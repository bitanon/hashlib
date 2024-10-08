// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask32 = 0xFFFFFFFF;

const _iv = <int>[
  0x67452301, // a
  0xEFCDAB89, // b
  0x98BADCFE, // c
  0x10325476, // d
  0xC3D2E1F0, // e
];

/// This implementation is derived from The Internet Society
/// [US Secure Hash Algorithm 1 (SHA1)][rfc3174].
///
/// [rfc3174]: https://www.ietf.org/rfc/rfc3174.html
class SHA1Hash extends BlockHashSink {
  final Uint32List state;
  final Uint32List chunk;

  @override
  final int hashLength;

  SHA1Hash()
      : chunk = Uint32List(80),
        hashLength = 160 >>> 3,
        state = Uint32List.fromList(_iv),
        super(512 >>> 3);

  @override
  void reset() {
    state.setAll(0, _iv);
    super.reset();
  }

  @override
  void $update(List<int> block, [int offset = 0, bool last = false]) {
    var w = chunk;

    int a, b, c, d, e;
    int t, x, ch, i, j;
    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];
    e = state[4];

    // Convert the block to chunk
    i = 0;
    j = offset;
    for (; i < 16; i++, j += 4) {
      w[i] = ((block[j] & 0xFF) << 24) |
          ((block[j + 1] & 0xFF) << 16) |
          ((block[j + 2] & 0xFF) << 8) |
          (block[j + 3] & 0xFF);
    }

    // Extend the first 16 words into the remaining 64 words
    for (i = 16; i < 80; i++) {
      x = w[i - 3] ^ w[i - 8] ^ w[i - 14] ^ w[i - 16];
      w[i] = (x << 1) | ((x & _mask32) >>> 31);
    }

    for (i = 0; i < 20; i++) {
      ch = (b & c) | ((~b) & d);
      t = ((a << 5) & _mask32) | (a >>> 27);
      x = t + ch + e + w[i] + 0x5A827999;
      e = d;
      d = c;
      c = ((b << 30) & _mask32) | (b >>> 2);
      b = a;
      a = x & _mask32;
    }

    for (; i < 40; i++) {
      ch = (b ^ c ^ d);
      t = ((a << 5) & _mask32) | (a >>> 27);
      x = t + ch + e + w[i] + 0x6ED9EBA1;
      e = d;
      d = c;
      c = ((b << 30) & _mask32) | (b >>> 2);
      b = a;
      a = x & _mask32;
    }

    for (; i < 60; i++) {
      ch = ((b & c) | (b & d) | (c & d));
      t = ((a << 5) & _mask32) | (a >>> 27);
      x = t + ch + e + w[i] + 0x8F1BBCDC;
      e = d;
      d = c;
      c = ((b << 30) & _mask32) | (b >>> 2);
      b = a;
      a = x & _mask32;
    }

    for (; i < 80; i++) {
      ch = (b ^ c ^ d);
      t = ((a << 5) & _mask32) | (a >>> 27);
      x = t + ch + e + w[i] + 0xCA62C1D6;
      e = d;
      d = c;
      c = ((b << 30) & _mask32) | (b >>> 2);
      b = a;
      a = x & _mask32;
    }

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += e;
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
      $update(buffer);
      pos = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; pos < 56; pos++) {
      buffer[pos] = 0;
    }

    // Append original message length in bits to message
    int n = messageLengthInBits;
    buffer[56] = n >>> 56;
    buffer[57] = n >>> 48;
    buffer[58] = n >>> 40;
    buffer[59] = n >>> 32;
    buffer[60] = n >>> 24;
    buffer[61] = n >>> 16;
    buffer[62] = n >>> 8;
    buffer[63] = n;

    // Update with the final block
    $update(buffer);

    // Convert the state to 8-bit byte array
    var bytes = Uint8List(hashLength);
    for (int j = 0, i = 0; j < hashLength; i++, j += 4) {
      bytes[j] = state[i] >>> 24;
      bytes[j + 1] = state[i] >>> 16;
      bytes[j + 2] = state[i] >>> 8;
      bytes[j + 3] = state[i];
    }
    return bytes;
  }
}
