// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const _mask32 = 0xFFFFFFFF;

/// 64 constants [Formula: floor(2^32 * abs(sin(i + 1)))]
const _k = <int>[
  0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee, //
  0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
  0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
  0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
  0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
  0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
  0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
  0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
  0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
  0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
  0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
  0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
  0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
  0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
  0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
  0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391
];

/// Shift constants
const _rc = <int>[
  07, 12, 17, 22, 07, 12, 17, 22, 07, 12, 17, 22, 07, 12, 17, 22, //
  05, 09, 14, 20, 05, 09, 14, 20, 05, 09, 14, 20, 05, 09, 14, 20, //
  04, 11, 16, 23, 04, 11, 16, 23, 04, 11, 16, 23, 04, 11, 16, 23, //
  06, 10, 15, 21, 06, 10, 15, 21, 06, 10, 15, 21, 06, 10, 15, 21,
];

/// This implementation is derived from the RSA Data Security, Inc.
/// [MD5 Message-Digest Algorithm][rfc1321].
///
/// [rfc1321]: https://www.rfc-editor.org/rfc/rfc1321
class MD5Hash extends BlockHashBase {
  final Uint32List state;
  final Uint32List chunk;

  MD5Hash()
      : chunk = Uint32List(16),
        state = Uint32List.fromList([
          0x67452301, // a
          0xEFCDAB89, // b
          0x98BADCFE, // c
          0x10325476, // d
        ]),
        super(
          hashLength: 128 >>> 3,
          blockLength: 512 >>> 3,
        );

  @override
  void $update(List<int> block, [int offset = 0]) {
    int a, b, c, d, e, f, g, h, t;

    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];

    // Convert the block to chunk
    for (int i = 0, j = offset; i < 16; i++, j += 4) {
      chunk[i] = ((block[j + 3] & 0xFF) << 24) |
          ((block[j + 2] & 0xFF) << 16) |
          ((block[j + 1] & 0xFF) << 8) |
          (block[j] & 0xFF);
    }

    for (int i = 0; i < 16; i++) {
      e = (b & c) | ((~b & _mask32) & d);
      t = d;
      d = c;
      c = b;
      g = (a + e + _k[i] + chunk[i]) & _mask32;
      h = _rc[i];
      b += ((g << h) & _mask32) | (g >>> (32 - h));
      a = t;
    }

    for (int i = 16; i < 32; i++) {
      e = (d & b) | ((~d & _mask32) & c);
      f = ((5 * i) + 1) & 15;
      t = d;
      d = c;
      c = b;
      g = (a + e + _k[i] + chunk[f]) & _mask32;
      h = _rc[i];
      b += ((g << h) & _mask32) | (g >>> (32 - h));
      a = t;
    }

    for (int i = 32; i < 48; i++) {
      e = b ^ c ^ d;
      f = ((3 * i) + 5) & 15;
      t = d;
      d = c;
      c = b;
      g = (a + e + _k[i] + chunk[f]) & _mask32;
      h = _rc[i];
      b += ((g << h) & _mask32) | (g >>> (32 - h));
      a = t;
    }

    for (int i = 48; i < 64; i++) {
      e = c ^ (b | (~d & _mask32));
      f = (7 * i) & 15;
      t = d;
      d = c;
      c = b;
      g = (a + e + _k[i] + chunk[f]) & _mask32;
      h = _rc[i];
      b += ((g << h) & _mask32) | (g >>> (32 - h));
      a = t;
    }

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
  }

  @override
  Uint8List $finalize(Uint8List block, int length) {
    // Adding the signature byte
    block[length++] = 0x80;

    // If no more space left in buffer for the message length
    if (length > 56) {
      for (; length < 64; length++) {
        block[length] = 0;
      }
      $update(block);
      length = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; length < 56; length++) {
      block[length] = 0;
    }

    // Append original message length in bits to message
    int n = messageLengthInBits;
    block[56] = n;
    block[57] = n >>> 8;
    block[58] = n >>> 16;
    block[59] = n >>> 24;
    block[60] = n >>> 32;
    block[61] = n >>> 40;
    block[62] = n >>> 48;
    block[63] = n >>> 56;

    // Update with the final block
    $update(block);

    // Convert the state to 8-bit byte array
    return Uint8List.fromList(state.buffer.asUint8List());
  }
}
