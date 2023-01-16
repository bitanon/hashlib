// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

/*
              | BLAKE2b          |
--------------+------------------+
 Bits in word | w = 64           |
 Rounds in F  | r = 12           |
 Block bytes  | bb = 128         |
 Hash bytes   | 1 <= nn <= 64    |
 Key bytes    | 0 <= kk <= 64    |
 Input bytes  | 0 <= ll < 2**128 |
--------------+------------------+
 G Rotation   | (R1, R2, R3, R4) |
  constants = | (32, 24, 16, 63) |
--------------+------------------+
*/

const int _r1 = 32;
const int _r2 = 24;
const int _r3 = 16;
const int _r4 = 63;

const _seed = [
  0x6A09E667F3BCC908,
  0xBB67AE8584CAA73B,
  0x3C6EF372FE94F82B,
  0xA54FF53A5F1D36F1,
  0x510E527FADE682D1,
  0x9B05688C2B3E6C1F,
  0x1F83D9ABFB41BD6B,
  0x5BE0CD19137E2179,
];

const _sigma = [
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], // round 0
  [14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3], // round 1
  [11, 8, 12, 0, 5, 2, 15, 13, 10, 14, 3, 6, 7, 1, 9, 4], // round 2
  [7, 9, 3, 1, 13, 12, 11, 14, 2, 6, 5, 10, 4, 0, 15, 8], // round 3
  [9, 0, 5, 7, 2, 4, 10, 15, 14, 1, 11, 12, 6, 8, 3, 13], // round 4
  [2, 12, 6, 10, 0, 11, 8, 3, 4, 13, 7, 5, 15, 14, 1, 9], // round 5
  [12, 5, 1, 15, 14, 13, 4, 10, 0, 7, 6, 3, 9, 2, 8, 11], // round 6
  [13, 11, 7, 14, 12, 1, 3, 9, 5, 0, 15, 4, 8, 6, 2, 10], // round 7
  [6, 15, 14, 9, 11, 3, 0, 8, 12, 2, 13, 7, 1, 4, 10, 5], // round 8
  [10, 2, 8, 4, 7, 6, 1, 5, 15, 11, 9, 14, 3, 12, 13, 0], // round 9
  [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15], // round 10
  [14, 10, 4, 8, 9, 15, 13, 6, 1, 12, 0, 2, 11, 7, 5, 3], // round 11
];

/// The implementation is derived from [RFC-7693][rfc] document for
/// "The BLAKE2 Cryptographic Hash and Message Authentication Code (MAC)".
///
/// For reference, the official [blake2][blake2] implementation was followed.
///
/// Note that blake2b uses 64-bit operations.
///
/// [rfc]: https://www.rfc-editor.org/rfc/rfc7693
/// [blake2]: https://github.com/BLAKE2/BLAKE2/blob/master/ref/blake2b-ref.c
class Blake2bHash extends BlockHash {
  final Uint64List state;
  late final Uint64List qbuffer;
  late final List<int> _initialState;

  @override
  final int hashLength;

  /// For internal use only.
  Blake2bHash({
    int digestSize = 64,
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  })  : hashLength = digestSize,
        state = Uint64List.fromList(_seed),
        super(1024 >>> 3) {
    if (digestSize < 1 || digestSize > 64) {
      throw ArgumentError('The digest size must be between 1 and 64');
    }

    qbuffer = buffer.buffer.asUint64List();

    // Parameter block
    state[0] ^= 0x01010000 ^ hashLength;

    if (key != null && key.isNotEmpty) {
      if (key.length > 64) {
        throw ArgumentError('The key should not be greater than 64 bytes');
      }
      // Add key length to parameter
      state[0] ^= key.length << 8;
      // If the key is present, the first block is the key padded with zeroes
      buffer.setAll(0, key);
      pos = blockLength;
      messageLength += blockLength;
    }

    if (salt != null && salt.isNotEmpty) {
      if (salt.length != 16) {
        throw ArgumentError('The valid length of salt is 16 bytes');
      }
      for (int i = 0, p = 0; i < 8; i++, p += 8) {
        state[4] ^= (salt[i] & 0xFF) << p;
      }
      for (int i = 8, p = 0; i < 16; i++, p += 8) {
        state[5] ^= (salt[i] & 0xFF) << p;
      }
    }

    if (personalization != null && personalization.isNotEmpty) {
      if (personalization.length != 16) {
        throw ArgumentError('The valid length of personalization is 16 bytes');
      }
      for (int i = 0, p = 0; i < 8; i++, p += 8) {
        state[6] ^= (personalization[i] & 0xFF) << p;
      }
      for (int i = 8, p = 0; i < 16; i++, p += 8) {
        state[7] ^= (personalization[i] & 0xFF) << p;
      }
    }

    _initialState = state.toList(growable: false);
  }

  @override
  void reset() {
    super.reset();
    state.setAll(0, _initialState);
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (; start < end; start++, pos++, messageLength++) {
      if (pos == blockLength) {
        $update();
        pos = 0;
      }
      buffer[pos] = chunk[start];
    }
  }

  /// Rotates x right by n bits.
  static int _rotr(int x, int n) => (x >>> n) ^ (x << (64 - n));

  // static void _G(Uint64List v, int a, int b, int c, int d, int x, int y) {
  //   v[a] = (v[a] + v[b] + x);
  //   v[d] = _rotr(v[d] ^ v[a], _r1);
  //   v[c] = (v[c] + v[d]);
  //   v[b] = _rotr(v[b] ^ v[c], _r2);
  //   v[a] = (v[a] + v[b] + y);
  //   v[d] = _rotr(v[d] ^ v[a], _r3);
  //   v[c] = (v[c] + v[d]);
  //   v[b] = _rotr(v[b] ^ v[c], _r4);
  // }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    var m = qbuffer;
    int w0, w1, w2, w3, w4, w5, w6, w7;
    int w8, w9, w10, w11, w12, w13, w14, w15;

    // first half from state
    w0 = state[0];
    w1 = state[1];
    w2 = state[2];
    w3 = state[3];
    w4 = state[4];
    w5 = state[5];
    w6 = state[6];
    w7 = state[7];

    // second half from IV
    w8 = _seed[0];
    w9 = _seed[1];
    w10 = _seed[2];
    w11 = _seed[3];
    w12 = _seed[4] ^ messageLength;
    w13 = _seed[5];
    w14 = _seed[6];
    w15 = _seed[7];

    if (last) {
      w14 = ~w14; // invert bits
    }

    // Cryptographic mixing
    for (int i = 0; i < 12; i++) {
      var s = _sigma[i];

      // _G(v, 0, 4, 8, 12, m[s[0]], m[s[1]]);
      w0 += w4 + m[s[0]];
      w12 = _rotr(w12 ^ w0, _r1);
      w8 += w12;
      w4 = _rotr(w4 ^ w8, _r2);
      w0 += w4 + m[s[1]];
      w12 = _rotr(w12 ^ w0, _r3);
      w8 += w12;
      w4 = _rotr(w4 ^ w8, _r4);

      // _G(v, 1, 5, 9, 13, m[s[2]], m[s[3]]);
      w1 += w5 + m[s[2]];
      w13 = _rotr(w13 ^ w1, _r1);
      w9 += w13;
      w5 = _rotr(w5 ^ w9, _r2);
      w1 += w5 + m[s[3]];
      w13 = _rotr(w13 ^ w1, _r3);
      w9 += w13;
      w5 = _rotr(w5 ^ w9, _r4);

      // _G(v, 2, 6, 10, 14, m[s[4]], m[s[5]]);
      w2 += w6 + m[s[4]];
      w14 = _rotr(w14 ^ w2, _r1);
      w10 += w14;
      w6 = _rotr(w6 ^ w10, _r2);
      w2 += w6 + m[s[5]];
      w14 = _rotr(w14 ^ w2, _r3);
      w10 += w14;
      w6 = _rotr(w6 ^ w10, _r4);

      // _G(v, 3, 7, 11, 15, m[s[6]], m[s[7]]);
      w3 += w7 + m[s[6]];
      w15 = _rotr(w15 ^ w3, _r1);
      w11 += w15;
      w7 = _rotr(w7 ^ w11, _r2);
      w3 += w7 + m[s[7]];
      w15 = _rotr(w15 ^ w3, _r3);
      w11 += w15;
      w7 = _rotr(w7 ^ w11, _r4);

      // _G(v, 0, 5, 10, 15, m[s[8]], m[s[9]]);
      w0 += w5 + m[s[8]];
      w15 = _rotr(w15 ^ w0, _r1);
      w10 += w15;
      w5 = _rotr(w5 ^ w10, _r2);
      w0 += w5 + m[s[9]];
      w15 = _rotr(w15 ^ w0, _r3);
      w10 += w15;
      w5 = _rotr(w5 ^ w10, _r4);

      // _G(v, 1, 6, 11, 12, m[s[10]], m[s[11]]);
      w1 += w6 + m[s[10]];
      w12 = _rotr(w12 ^ w1, _r1);
      w11 += w12;
      w6 = _rotr(w6 ^ w11, _r2);
      w1 += w6 + m[s[11]];
      w12 = _rotr(w12 ^ w1, _r3);
      w11 += w12;
      w6 = _rotr(w6 ^ w11, _r4);

      // _G(v, 2, 7, 8, 13, m[s[12]], m[s[13]]);
      w2 += w7 + m[s[12]];
      w13 = _rotr(w13 ^ w2, _r1);
      w8 += w13;
      w7 = _rotr(w7 ^ w8, _r2);
      w2 += w7 + m[s[13]];
      w13 = _rotr(w13 ^ w2, _r3);
      w8 += w13;
      w7 = _rotr(w7 ^ w8, _r4);

      // _G(v, 3, 4, 9, 14, m[s[14]], m[s[15]]);
      w3 += w4 + m[s[14]];
      w14 = _rotr(w14 ^ w3, _r1);
      w9 += w14;
      w4 = _rotr(w4 ^ w9, _r2);
      w3 += w4 + m[s[15]];
      w14 = _rotr(w14 ^ w3, _r3);
      w9 += w14;
      w4 = _rotr(w4 ^ w9, _r4);
    }

    // XOR the two halves for new state
    state[0] ^= w0 ^ w8;
    state[1] ^= w1 ^ w9;
    state[2] ^= w2 ^ w10;
    state[3] ^= w3 ^ w11;
    state[4] ^= w4 ^ w12;
    state[5] ^= w5 ^ w13;
    state[6] ^= w6 ^ w14;
    state[7] ^= w7 ^ w15;
  }

  @override
  Uint8List $finalize([Uint8List? block, int? length]) {
    // Fill remaining buffer to put the message length at the end
    for (; pos < blockLength; pos++) {
      buffer[pos] = 0;
    }

    // Update with the final block
    $update(buffer, 0, true);

    // Convert the state to 8-bit byte array
    return state.buffer.asUint8List().sublist(0, hashLength);
  }
}
