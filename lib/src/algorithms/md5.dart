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
];

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
/// [rfc1321]: https://www.ietf.org/rfc/rfc1321.html
class MD5Hash extends BlockHashSink {
  final Uint32List state;

  @override
  final int hashLength;

  MD5Hash()
      : state = Uint32List.fromList(_iv),
        hashLength = 128 >>> 3,
        super(512 >>> 3);

  @override
  void reset() {
    super.reset();
    state.setAll(0, _iv);
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

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int a, b, c, d, e, f, g, h, t;
    var x = sbuffer;

    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];

    for (int i = 0; i < 16; i++) {
      e = (b & c) | ((~b & _mask32) & d);
      f = i;
      t = d;
      d = c;
      c = b;
      g = (a + e + _k[i] + x[f]) & _mask32;
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
      g = (a + e + _k[i] + x[f]) & _mask32;
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
      g = (a + e + _k[i] + x[f]) & _mask32;
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
      g = (a + e + _k[i] + x[f]) & _mask32;
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
  Uint8List $finalize([Uint8List? block, int? length]) {
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
    bdata.setUint32(56, messageLengthInBits, Endian.little);
    bdata.setUint32(60, messageLengthInBits >> 32, Endian.little);

    // Update with the final block
    $update();

    // Convert the state to 8-bit byte array
    return state.buffer.asUint8List().sublist(0, hashLength);
  }
}
