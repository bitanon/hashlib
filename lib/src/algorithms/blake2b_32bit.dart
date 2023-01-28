// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

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

const int _mask32 = 0xFFFFFFFF;

const int _r1 = 32;
const int _r2 = 24;
const int _r3 = 16;
const int _r4 = 63;

const _seed = [
  0xF3BCC908, 0x6A09E667, //
  0x84CAA73B, 0xBB67AE85,
  0xFE94F82B, 0x3C6EF372,
  0x5F1D36F1, 0xA54FF53A,
  0xADE682D1, 0x510E527F,
  0x2B3E6C1F, 0x9B05688C,
  0xFB41BD6B, 0x1F83D9AB,
  0x137E2179, 0x5BE0CD19,
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

final _sigma2 = _sigma.map((e) => e.map((e) => e << 1).toList()).toList();

const int _w0 = 0;
const int _w1 = _w0 + 2;
const int _w2 = _w1 + 2;
const int _w3 = _w2 + 2;
const int _w4 = _w3 + 2;
const int _w5 = _w4 + 2;
const int _w6 = _w5 + 2;
const int _w7 = _w6 + 2;
const int _w8 = _w7 + 2;
const int _w9 = _w8 + 2;
const int _w10 = _w9 + 2;
const int _w11 = _w10 + 2;
const int _w12 = _w11 + 2;
const int _w13 = _w12 + 2;
const int _w14 = _w13 + 2;
const int _w15 = _w14 + 2;

/// The implementation is derived from [RFC-7693][rfc] document for
/// "The BLAKE2 Cryptographic Hash and Message Authentication Code (MAC)".
///
/// For reference, the official [blake2][blake2] implementation was followed.
///
/// Note that blake2b uses 64-bit operations.
///
/// [rfc]: https://www.ietf.org/rfc/rfc7693.html
/// [blake2]: https://github.com/BLAKE2/BLAKE2/blob/master/ref/blake2b-ref.c
class Blake2bHash extends BlockHashSink with MACSinkBase {
  final Uint32List _var = Uint32List(_w15 + 2);
  final Uint32List state = Uint32List.fromList(_seed);
  final Uint32List _initialState = Uint32List(_seed.length);

  @override
  final int hashLength;

  /// For internal use only.
  Blake2bHash(
    int digestSize, {
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  })  : hashLength = digestSize,
        super(1024 >>> 3) {
    if (digestSize < 1 || digestSize > 64) {
      throw ArgumentError('The digest size must be between 1 and 64');
    }

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
      for (int i = 0, p = 0; i < 4; i++, p += 8) {
        state[8] ^= (salt[i] & 0xFF) << p;
      }
      for (int i = 4, p = 0; i < 8; i++, p += 8) {
        state[9] ^= (salt[i] & 0xFF) << p;
      }
      for (int i = 8, p = 0; i < 12; i++, p += 8) {
        state[10] ^= (salt[i] & 0xFF) << p;
      }
      for (int i = 12, p = 0; i < 16; i++, p += 8) {
        state[11] ^= (salt[i] & 0xFF) << p;
      }
    }

    if (personalization != null && personalization.isNotEmpty) {
      if (personalization.length != 16) {
        throw ArgumentError('The valid length of personalization is 16 bytes');
      }
      for (int i = 0, p = 0; i < 4; i++, p += 8) {
        state[12] ^= (personalization[i] & 0xFF) << p;
      }
      for (int i = 4, p = 0; i < 8; i++, p += 8) {
        state[13] ^= (personalization[i] & 0xFF) << p;
      }
      for (int i = 8, p = 0; i < 12; i++, p += 8) {
        state[14] ^= (personalization[i] & 0xFF) << p;
      }
      for (int i = 12, p = 0; i < 16; i++, p += 8) {
        state[15] ^= (personalization[i] & 0xFF) << p;
      }
    }

    _initialState.setAll(0, state);
  }

  @override
  void reset() {
    super.reset();
    state.setAll(0, _initialState);
  }

  @override
  void init(List<int> key) {
    if (key.length > 64) {
      throw ArgumentError('The key should not be greater than 64 bytes');
    }
    reset();
    // The first block is the key padded with zeroes
    buffer.setAll(0, key);
    pos = blockLength;
    messageLength += blockLength;
    // Parameter block
    state[0] ^= 0x01010000 ^ hashLength ^ (key.length << 8);
    // Save state
    _initialState.setAll(0, state);
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

  /// `v[k] = (v[i] << (64 - n)) | (v[i] >>> n)`
  static void _rotr(int n, List<int> v, int i, int k) {
    var a = v[i + 1];
    var b = v[i];
    if (n == 32) {
      v[k + 1] = b;
      v[k] = a;
    } else if (n < 32) {
      v[k + 1] = (b << (32 - n)) | (a >>> n);
      v[k] = (a << (32 - n)) | (b >>> n);
    } else {
      v[k + 1] = (a << (64 - n)) | (b >>> (n - 32));
      v[k] = (b << (64 - n)) | (a >>> (n - 32));
    }
  }

  /// `v[k] = v[i] ^ v[j]`
  static void _xor(List<int> v, int i, int j, int k) {
    v[k] = v[i] ^ v[j];
    v[k + 1] = v[i + 1] ^ v[j + 1];
  }

  /// `v[k] = v[i] + v[j]`
  static void _add2(List<int> v, int i, int j, int k) {
    var t = v[i] + v[j];
    v[k] = t;
    v[k + 1] = (v[i + 1] + v[j + 1]) + (v[k] < t ? 1 : 0);
  }

  /// `v[k] = v[i] + v[j] + n[x]`
  static void _add3(List<int> v, int i, int j, List<int> n, int x, int k) {
    var t = v[i] + v[j];
    v[k] = t;
    v[k + 1] = v[i + 1] + v[j + 1] + (v[k] < t ? 1 : 0);
    t = v[k] + n[x];
    v[k] += n[x];
    v[k + 1] += n[x + 1] + (v[k] < t ? 1 : 0);
  }

  // The G function for mixing
  static void _mix(
    List<int> v,
    int a,
    int b,
    int c,
    int d,
    List<int> m,
    int x,
    int y,
  ) {
    // v[a] = (v[a] + v[b] + x);
    _add3(v, a, b, m, x, a);
    // v[d] = _rotr(v[d] ^ v[a], _r1);
    _xor(v, d, a, d);
    _rotr(_r1, v, d, d);
    // v[c] = (v[c] + v[d]);
    _add2(v, c, d, c);
    // v[b] = _rotr(v[b] ^ v[c], _r2);
    _xor(v, b, c, b);
    _rotr(_r2, v, b, b);
    // v[a] = (v[a] + v[b] + y);
    _add3(v, a, b, m, y, a);
    // v[d] = _rotr(v[d] ^ v[a], _r3);
    _xor(v, d, a, d);
    _rotr(_r3, v, d, d);
    // v[c] = (v[c] + v[d]);
    _add2(v, c, d, c);
    // v[b] = _rotr(v[b] ^ v[c], _r4);
    _xor(v, b, c, b);
    _rotr(_r4, v, b, b);
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    // Copy state and seed
    for (int i = 0; i < 16; ++i) {
      _var[i] = state[i];
      _var[_w8 + i] = _seed[i];
    }

    _var[_w12] ^= messageLength & _mask32;
    _var[_w12 + 1] ^= (messageLength >>> 32) & _mask32;

    if (last) {
      _var[_w14] ^= _mask32;
      _var[_w14 + 1] ^= _mask32;
    }

    // Cryptographic mixing
    for (int i = 0; i < 12; i++) {
      var s = _sigma2[i];
      _mix(_var, _w0, _w4, _w8, _w12, sbuffer, s[0], s[1]);
      _mix(_var, _w1, _w5, _w9, _w13, sbuffer, s[2], s[3]);
      _mix(_var, _w2, _w6, _w10, _w14, sbuffer, s[4], s[5]);
      _mix(_var, _w3, _w7, _w11, _w15, sbuffer, s[6], s[7]);
      _mix(_var, _w0, _w5, _w10, _w15, sbuffer, s[8], s[9]);
      _mix(_var, _w1, _w6, _w11, _w12, sbuffer, s[10], s[11]);
      _mix(_var, _w2, _w7, _w8, _w13, sbuffer, s[12], s[13]);
      _mix(_var, _w3, _w4, _w9, _w14, sbuffer, s[14], s[15]);
    }

    // Build new state
    for (int i = 0; i < 16; ++i) {
      state[i] ^= _var[i] ^ _var[_w8 + i];
    }
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
