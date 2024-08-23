// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask32 = 0xFFFFFFFF;

const _iv = <int>[
  0x7380166f,
  0x4914b2b9,
  0x172442d7,
  0xda8a0600,
  0xa96f30bc,
  0x163138aa,
  0xe38dee4d,
  0xb0fb0e4e,
];

/// This implementation is derived from the draft of
/// [The SM3 Cryptographic Hash Function][rfc].
///
/// [rfc]: https://datatracker.ietf.org/doc/draft-sca-cfrg-sm3/
class SM3Hash extends BlockHashSink {
  final Uint32List state;

  @override
  final int hashLength;

  SM3Hash()
      : state = Uint32List.fromList(_iv),
        hashLength = 256 >>> 3,
        super(
          512 >>> 3,
          bufferLength: 68 << 2,
        );

  @override
  void reset() {
    state.setAll(0, _iv);
    super.reset();
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    messageLength += end - start;
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        $update();
        pos = 0;
      }
      buffer[pos] = chunk[start];
    }
    if (pos == blockLength) {
      $update(buffer);
      pos = 0;
    }
  }

  @pragma('vm:prefer-inline')
  static int _rotl32(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  @pragma('vm:prefer-inline')
  static int _swap32(int x) =>
      ((x << 24) & 0xff000000) |
      ((x << 8) & 0x00ff0000) |
      ((x >>> 8) & 0x0000ff00) |
      ((x >>> 24) & 0x000000ff);

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int a, b, c, d, e, f, g, h;
    int i, t, ss1, ss2, tt1, tt2;
    var x = sbuffer;
    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];
    e = state[4];
    f = state[5];
    g = state[6];
    h = state[7];

    // Message Expansion
    for (i = 0; i < 16; i++) {
      x[i] = _swap32(x[i]);
    }
    for (i = 16; i < 68; i++) {
      t = x[i - 16] ^ x[i - 9] ^ _rotl32(x[i - 3], 15);
      t ^= _rotl32(t, 15) ^ _rotl32(t, 23);
      t ^= _rotl32(x[i - 13], 7) ^ x[i - 6];
      x[i] = t;
    }

    // Compression Function
    for (i = 0; i < 16; i++) {
      t = _rotl32(a, 12) + e + _rotl32(0x79cc4519, i);
      ss1 = _rotl32(t, 7);
      ss2 = ss1 ^ _rotl32(a, 12);
      t = a ^ b ^ c;
      tt1 = (t + d + ss2 + (x[i] ^ x[i + 4])) & _mask32;
      t = e ^ f ^ g;
      tt2 = (t + h + ss1 + x[i]) & _mask32;
      d = c;
      c = _rotl32(b, 9);
      b = a;
      a = tt1;
      h = g;
      g = _rotl32(f, 19);
      f = e;
      e = tt2 ^ _rotl32(tt2, 9) ^ _rotl32(tt2, 17);
    }
    for (i = 16; i < 64; i++) {
      t = _rotl32(a, 12) + e + _rotl32(0x7a879d8a, i & 31);
      ss1 = _rotl32(t, 7);
      ss2 = ss1 ^ _rotl32(a, 12);
      t = (a & b) | (b & c) | (c & a);
      tt1 = (t + d + ss2 + (x[i] ^ x[i + 4])) & _mask32;
      t = (e & f) | (g & (~e));
      tt2 = (t + h + ss1 + x[i]) & _mask32;
      d = c;
      c = _rotl32(b, 9);
      b = a;
      a = tt1;
      h = g;
      g = _rotl32(f, 19);
      f = e;
      e = tt2 ^ _rotl32(tt2, 9) ^ _rotl32(tt2, 17);
    }

    state[0] ^= a;
    state[1] ^= b;
    state[2] ^= c;
    state[3] ^= d;
    state[4] ^= e;
    state[5] ^= f;
    state[6] ^= g;
    state[7] ^= h;
  }

  @override
  Uint8List $finalize() {
    // Adding the signature byte
    buffer[pos++] = 0x80;

    // If no more space left in buffer for the message length
    if (pos > 56) {
      for (; pos < 64; pos++) {
        buffer[pos] = 0;
      }
      $update();
      pos = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; pos < 56; pos++) {
      buffer[pos] = 0;
    }

    // Append original message length in bits to message
    bdata.setUint32(56, messageLengthInBits >>> 32, Endian.big);
    bdata.setUint32(60, messageLengthInBits, Endian.big);

    // Update with the final block
    $update();

    // Convert the state to 8-bit byte array
    var output = Uint32List(hashLength >>> 2);
    for (int i = 0; i < output.length; i++) {
      output[i] = _swap32(state[i]);
    }
    return Uint8List.view(output.buffer);
  }
}
