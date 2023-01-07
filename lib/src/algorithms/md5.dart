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
            0xEFCDAB89, // b
            0x98BADCFE, // c
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
  void update(Uint32List block) {
    var x = block;
    var a = state[0];
    var b = state[1];
    var c = state[2];
    var d = state[3];

    // Formula for the last param: floor(2^32 * abs(sin(i + 1)))

    /* Round 1 */
    a = _tFF(a, b, c, d, x[0], _s11, 0xD76AA478); /* 1 */
    d = _tFF(d, a, b, c, x[1], _s12, 0xE8C7B756); /* 2 */
    c = _tFF(c, d, a, b, x[2], _s13, 0x242070DB); /* 3 */
    b = _tFF(b, c, d, a, x[3], _s14, 0xC1BDCEEE); /* 4 */
    a = _tFF(a, b, c, d, x[4], _s11, 0xF57C0FAF); /* 5 */
    d = _tFF(d, a, b, c, x[5], _s12, 0x4787C62A); /* 6 */
    c = _tFF(c, d, a, b, x[6], _s13, 0xA8304613); /* 7 */
    b = _tFF(b, c, d, a, x[7], _s14, 0xFD469501); /* 8 */
    a = _tFF(a, b, c, d, x[8], _s11, 0x698098D8); /* 9 */
    d = _tFF(d, a, b, c, x[9], _s12, 0x8B44F7AF); /* 10 */
    c = _tFF(c, d, a, b, x[10], _s13, 0xFFFF5BB1); /* 11 */
    b = _tFF(b, c, d, a, x[11], _s14, 0x895CD7BE); /* 12 */
    a = _tFF(a, b, c, d, x[12], _s11, 0x6B901122); /* 13 */
    d = _tFF(d, a, b, c, x[13], _s12, 0xFD987193); /* 14 */
    c = _tFF(c, d, a, b, x[14], _s13, 0xA679438E); /* 15 */
    b = _tFF(b, c, d, a, x[15], _s14, 0x49B40821); /* 16 */

    /* Round 2 */
    a = _tGG(a, b, c, d, x[1], _s21, 0xF61E2562); /* 17 */
    d = _tGG(d, a, b, c, x[6], _s22, 0xC040B340); /* 18 */
    c = _tGG(c, d, a, b, x[11], _s23, 0x265E5A51); /* 19 */
    b = _tGG(b, c, d, a, x[0], _s24, 0xE9B6C7AA); /* 20 */
    a = _tGG(a, b, c, d, x[5], _s21, 0xD62F105D); /* 21 */
    d = _tGG(d, a, b, c, x[10], _s22, 0x2441453); /* 22 */
    c = _tGG(c, d, a, b, x[15], _s23, 0xD8A1E681); /* 23 */
    b = _tGG(b, c, d, a, x[4], _s24, 0xE7D3FBC8); /* 24 */
    a = _tGG(a, b, c, d, x[9], _s21, 0x21E1CDE6); /* 25 */
    d = _tGG(d, a, b, c, x[14], _s22, 0xC33707D6); /* 26 */
    c = _tGG(c, d, a, b, x[3], _s23, 0xF4D50D87); /* 27 */
    b = _tGG(b, c, d, a, x[8], _s24, 0x455A14ED); /* 28 */
    a = _tGG(a, b, c, d, x[13], _s21, 0xA9E3E905); /* 29 */
    d = _tGG(d, a, b, c, x[2], _s22, 0xFCEFA3F8); /* 30 */
    c = _tGG(c, d, a, b, x[7], _s23, 0x676F02D9); /* 31 */
    b = _tGG(b, c, d, a, x[12], _s24, 0x8D2A4C8A); /* 32 */

    /* Round 3 */
    a = _tHH(a, b, c, d, x[5], _s31, 0xFFFA3942); /* 33 */
    d = _tHH(d, a, b, c, x[8], _s32, 0x8771F681); /* 34 */
    c = _tHH(c, d, a, b, x[11], _s33, 0x6D9D6122); /* 35 */
    b = _tHH(b, c, d, a, x[14], _s34, 0xFDE5380C); /* 36 */
    a = _tHH(a, b, c, d, x[1], _s31, 0xA4BEEA44); /* 37 */
    d = _tHH(d, a, b, c, x[4], _s32, 0x4BDECFA9); /* 38 */
    c = _tHH(c, d, a, b, x[7], _s33, 0xF6BB4B60); /* 39 */
    b = _tHH(b, c, d, a, x[10], _s34, 0xBEBFBC70); /* 40 */
    a = _tHH(a, b, c, d, x[13], _s31, 0x289B7EC6); /* 41 */
    d = _tHH(d, a, b, c, x[0], _s32, 0xEAA127FA); /* 42 */
    c = _tHH(c, d, a, b, x[3], _s33, 0xD4EF3085); /* 43 */
    b = _tHH(b, c, d, a, x[6], _s34, 0x4881D05); /* 44 */
    a = _tHH(a, b, c, d, x[9], _s31, 0xD9D4D039); /* 45 */
    d = _tHH(d, a, b, c, x[12], _s32, 0xE6DB99E5); /* 46 */
    c = _tHH(c, d, a, b, x[15], _s33, 0x1FA27CF8); /* 47 */
    b = _tHH(b, c, d, a, x[2], _s34, 0xC4AC5665); /* 48 */

    /* Round 4 */
    a = _rII(a, b, c, d, x[0], _s41, 0xF4292244); /* 49 */
    d = _rII(d, a, b, c, x[7], _s42, 0x432AFF97); /* 50 */
    c = _rII(c, d, a, b, x[14], _s43, 0xAB9423A7); /* 51 */
    b = _rII(b, c, d, a, x[5], _s44, 0xFC93A039); /* 52 */
    a = _rII(a, b, c, d, x[12], _s41, 0x655B59C3); /* 53 */
    d = _rII(d, a, b, c, x[3], _s42, 0x8F0CCC92); /* 54 */
    c = _rII(c, d, a, b, x[10], _s43, 0xFFEFF47D); /* 55 */
    b = _rII(b, c, d, a, x[1], _s44, 0x85845DD1); /* 56 */
    a = _rII(a, b, c, d, x[8], _s41, 0x6FA87E4F); /* 57 */
    d = _rII(d, a, b, c, x[15], _s42, 0xFE2CE6E0); /* 58 */
    c = _rII(c, d, a, b, x[6], _s43, 0xA3014314); /* 59 */
    b = _rII(b, c, d, a, x[13], _s44, 0x4E0811A1); /* 60 */
    a = _rII(a, b, c, d, x[4], _s41, 0xF7537E82); /* 61 */
    d = _rII(d, a, b, c, x[11], _s42, 0xBD3AF235); /* 62 */
    c = _rII(c, d, a, b, x[2], _s43, 0x2AD7D2BB); /* 63 */
    b = _rII(b, c, d, a, x[9], _s44, 0xEB86D391); /* 64 */

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
  }
}
