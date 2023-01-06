// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/hash_sink.dart';

const _mask32 = 0xFFFFFFFF;

// Shift amounts for round 1.
const int _s11 = 07;
const int _s12 = 12;
const int _s13 = 17;
const int _s14 = 22;

// Shift amounts for round 2.
const int _s21 = 05;
const int _s22 = 09;
const int _s23 = 14;
const int _s24 = 20;

// Shift amounts for round 3.
const int _s31 = 04;
const int _s32 = 11;
const int _s33 = 16;
const int _s34 = 23;

// Shift amounts for round 4.
const int _s41 = 06;
const int _s42 = 10;
const int _s43 = 15;
const int _s44 = 21;

/// This implementation is derived from the RSA Data Security, Inc.
/// [MD5 Message-Digest Algorithm][rfc1321].
///
/// [rfc1321]: https://datatracker.ietf.org/doc/html/rfc1321
class MD5Sink extends HashSink {
  MD5Sink([Sink<HashDigest>? sink])
      : super(
          sink: sink,
          endian: Endian.little,
          hashLengthInBits: 128,
          blockLengthInBits: 512,
          seed: [
            0x67452301, // a
            0xefcdab89, // b
            0x98badcfe, // c
            0x10325476, // d
          ],
        );

  /// Rotates x left by n bits.
  int _rotl(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  /// Basic MD5 function for round 1.
  int _tF(int x, int y, int z) => (x & y) | (~x & z);

  /// Basic MD5 function for round 2.
  int _tG(int x, int y, int z) => (x & z) | (y & ~z);

  /// Basic MD5 function for round 3.
  int _tH(int x, int y, int z) => x ^ y ^ z;

  /// Basic MD5 function for round 4.
  int _tI(int x, int y, int z) => y ^ (x | (~z & _mask32));

  /// MD5 Transformation for round 1.
  int _tFF(int a, int b, int c, int d, int x, int s, int ac) =>
      (b + _rotl(a + _tF(b, c, d) + x + ac, s)) & _mask32;

  /// MD5 Transformation for round 2.
  int _tGG(int a, int b, int c, int d, int x, int s, int ac) =>
      (b + _rotl(a + _tG(b, c, d) + x + ac, s)) & _mask32;

  /// MD5 Transformation for round 3.
  int _tHH(int a, int b, int c, int d, int x, int s, int ac) =>
      (b + _rotl(a + _tH(b, c, d) + x + ac, s)) & _mask32;

  /// MD5 Transformation for round 4.
  int _rII(int a, int b, int c, int d, int x, int s, int ac) =>
      (b + _rotl(a + _tI(b, c, d) + x + ac, s)) & _mask32;

  @override
  void update(final Uint32List block) {
    var x = block;
    var a = state[0];
    var b = state[1];
    var c = state[2];
    var d = state[3];

    // Formula for the last param: floor(2^32 * abs(sin(i + 1)))

    /* Round 1 */
    a = _tFF(a, b, c, d, x[0], _s11, 0xd76aa478); /* 1 */
    d = _tFF(d, a, b, c, x[1], _s12, 0xe8c7b756); /* 2 */
    c = _tFF(c, d, a, b, x[2], _s13, 0x242070db); /* 3 */
    b = _tFF(b, c, d, a, x[3], _s14, 0xc1bdceee); /* 4 */
    a = _tFF(a, b, c, d, x[4], _s11, 0xf57c0faf); /* 5 */
    d = _tFF(d, a, b, c, x[5], _s12, 0x4787c62a); /* 6 */
    c = _tFF(c, d, a, b, x[6], _s13, 0xa8304613); /* 7 */
    b = _tFF(b, c, d, a, x[7], _s14, 0xfd469501); /* 8 */
    a = _tFF(a, b, c, d, x[8], _s11, 0x698098d8); /* 9 */
    d = _tFF(d, a, b, c, x[9], _s12, 0x8b44f7af); /* 10 */
    c = _tFF(c, d, a, b, x[10], _s13, 0xffff5bb1); /* 11 */
    b = _tFF(b, c, d, a, x[11], _s14, 0x895cd7be); /* 12 */
    a = _tFF(a, b, c, d, x[12], _s11, 0x6b901122); /* 13 */
    d = _tFF(d, a, b, c, x[13], _s12, 0xfd987193); /* 14 */
    c = _tFF(c, d, a, b, x[14], _s13, 0xa679438e); /* 15 */
    b = _tFF(b, c, d, a, x[15], _s14, 0x49b40821); /* 16 */

    /* Round 2 */
    a = _tGG(a, b, c, d, x[1], _s21, 0xf61e2562); /* 17 */
    d = _tGG(d, a, b, c, x[6], _s22, 0xc040b340); /* 18 */
    c = _tGG(c, d, a, b, x[11], _s23, 0x265e5a51); /* 19 */
    b = _tGG(b, c, d, a, x[0], _s24, 0xe9b6c7aa); /* 20 */
    a = _tGG(a, b, c, d, x[5], _s21, 0xd62f105d); /* 21 */
    d = _tGG(d, a, b, c, x[10], _s22, 0x2441453); /* 22 */
    c = _tGG(c, d, a, b, x[15], _s23, 0xd8a1e681); /* 23 */
    b = _tGG(b, c, d, a, x[4], _s24, 0xe7d3fbc8); /* 24 */
    a = _tGG(a, b, c, d, x[9], _s21, 0x21e1cde6); /* 25 */
    d = _tGG(d, a, b, c, x[14], _s22, 0xc33707d6); /* 26 */
    c = _tGG(c, d, a, b, x[3], _s23, 0xf4d50d87); /* 27 */
    b = _tGG(b, c, d, a, x[8], _s24, 0x455a14ed); /* 28 */
    a = _tGG(a, b, c, d, x[13], _s21, 0xa9e3e905); /* 29 */
    d = _tGG(d, a, b, c, x[2], _s22, 0xfcefa3f8); /* 30 */
    c = _tGG(c, d, a, b, x[7], _s23, 0x676f02d9); /* 31 */
    b = _tGG(b, c, d, a, x[12], _s24, 0x8d2a4c8a); /* 32 */

    /* Round 3 */
    a = _tHH(a, b, c, d, x[5], _s31, 0xfffa3942); /* 33 */
    d = _tHH(d, a, b, c, x[8], _s32, 0x8771f681); /* 34 */
    c = _tHH(c, d, a, b, x[11], _s33, 0x6d9d6122); /* 35 */
    b = _tHH(b, c, d, a, x[14], _s34, 0xfde5380c); /* 36 */
    a = _tHH(a, b, c, d, x[1], _s31, 0xa4beea44); /* 37 */
    d = _tHH(d, a, b, c, x[4], _s32, 0x4bdecfa9); /* 38 */
    c = _tHH(c, d, a, b, x[7], _s33, 0xf6bb4b60); /* 39 */
    b = _tHH(b, c, d, a, x[10], _s34, 0xbebfbc70); /* 40 */
    a = _tHH(a, b, c, d, x[13], _s31, 0x289b7ec6); /* 41 */
    d = _tHH(d, a, b, c, x[0], _s32, 0xeaa127fa); /* 42 */
    c = _tHH(c, d, a, b, x[3], _s33, 0xd4ef3085); /* 43 */
    b = _tHH(b, c, d, a, x[6], _s34, 0x4881d05); /* 44 */
    a = _tHH(a, b, c, d, x[9], _s31, 0xd9d4d039); /* 45 */
    d = _tHH(d, a, b, c, x[12], _s32, 0xe6db99e5); /* 46 */
    c = _tHH(c, d, a, b, x[15], _s33, 0x1fa27cf8); /* 47 */
    b = _tHH(b, c, d, a, x[2], _s34, 0xc4ac5665); /* 48 */

    /* Round 4 */
    a = _rII(a, b, c, d, x[0], _s41, 0xf4292244); /* 49 */
    d = _rII(d, a, b, c, x[7], _s42, 0x432aff97); /* 50 */
    c = _rII(c, d, a, b, x[14], _s43, 0xab9423a7); /* 51 */
    b = _rII(b, c, d, a, x[5], _s44, 0xfc93a039); /* 52 */
    a = _rII(a, b, c, d, x[12], _s41, 0x655b59c3); /* 53 */
    d = _rII(d, a, b, c, x[3], _s42, 0x8f0ccc92); /* 54 */
    c = _rII(c, d, a, b, x[10], _s43, 0xffeff47d); /* 55 */
    b = _rII(b, c, d, a, x[1], _s44, 0x85845dd1); /* 56 */
    a = _rII(a, b, c, d, x[8], _s41, 0x6fa87e4f); /* 57 */
    d = _rII(d, a, b, c, x[15], _s42, 0xfe2ce6e0); /* 58 */
    c = _rII(c, d, a, b, x[6], _s43, 0xa3014314); /* 59 */
    b = _rII(b, c, d, a, x[13], _s44, 0x4e0811a1); /* 60 */
    a = _rII(a, b, c, d, x[4], _s41, 0xf7537e82); /* 61 */
    d = _rII(d, a, b, c, x[11], _s42, 0xbd3af235); /* 62 */
    c = _rII(c, d, a, b, x[2], _s43, 0x2ad7d2bb); /* 63 */
    b = _rII(b, c, d, a, x[9], _s44, 0xeb86d391); /* 64 */

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
  }
}
