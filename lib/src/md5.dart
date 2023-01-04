// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/src/core/hash_algo.dart';
import 'package:hashlib/src/core/utils.dart';

/// Generates a 128-bit MD5 hash value from the input.
Uint8List md5hash(final Iterable<int> input) {
  final md5 = MD5();
  md5.update(input);
  return md5.digest();
}

/// Generates a 128-bit MD5 hash value as hexadecimal from bytes
String md5sum(final Iterable<int> input) {
  return toHexString(md5hash(input));
}

/// Generates a 128-bit MD5 hash value as hexadecimal from string
String md5(final String input, [Encoding encoding = utf8]) {
  return md5sum(toBytes(input, encoding));
}

/// Generates a 128-bit MD5 hash value as hexadecimal from string
Future<Uint8List> md5stream(final Stream<int> inputStream) async {
  final md5 = MD5();
  await inputStream.forEach((x) {
    md5.update([x]);
  });
  return md5.digest();
}

/// This implementation is derived from the RSA Data Security, Inc.
/// [MD5 Message-Digest Algorithm][RFC].
///
/// [RFC]: https://tools.ietf.org/html/rfc1321
///
/// **Warning**: MD5 has extensive vulnerabilities. It can be safely used
/// for checksum, but do not use it for cryptographic purposes.
class MD5 extends HashAlgo {
  final _state = Uint32List(4); /* state (ABCD) */
  final _count = Uint32List(2); /* number of bits mod 2^64 (lsb first) */
  final _chunk = Uint32List(16); /* 512-bit chunk */
  final _buffer = Uint8List(64); /* input buffer */
  final _digest = Uint8List(16); /* the final digest */
  bool _closed = false; /* whether the digest is ready */
  int _pos = 0; /* latest buffer position */

  /// Initializes a new instance of MD5 message-digest.
  /// An instance can be re-used after calling the [clear] function.
  MD5() {
    // Initialize variables
    _state[0] = 0x67452301; // a
    _state[1] = 0xefcdab89; // b
    _state[2] = 0x98badcfe; // c
    _state[3] = 0x10325476; // d
  }

  @override
  void clear() {
    _pos = 0;
    _count[0] = 0;
    _count[1] = 0;
    _state[0] = 0x67452301;
    _state[1] = 0xefcdab89;
    _state[2] = 0x98badcfe;
    _state[3] = 0x10325476;
    _closed = false;
  }

  @override
  void update(final Iterable<int> input) {
    if (_closed) {
      throw StateError('The MD5 message-digest is already closed');
    }

    // Transform as many times as possible.
    int n = 0;
    for (int x in input) {
      n++;
      _buffer[_pos++] = x;
      if (_pos == 64) {
        _decode();
        _update();
      }
    }

    // Update number of bits
    int m = _count[0] + (n << 3);
    _count[1] += (m >> 32);
    _count[1] += n >> 29;
    _count[0] = m;
  }

  @override
  Uint8List digest() {
    // The final message digest is available in [_digest]
    if (_closed) {
      return _digest;
    }
    _closed = true;
    if (_pos < 64) {
      // Adding a single 1 bit
      _buffer[_pos++] = 0x80;

      // If buffer length > 56 bytes, skip this block
      if (_pos > 56) {
        while (_pos < 64) {
          _buffer[_pos++] = 0;
        }
        _decode();
        _update();
      }

      // Padding with 0s until buffer length is 56 bytes
      while (_pos < 56) {
        _buffer[_pos++] = 0;
      }

      // Append original message length in bits mod 2^64 to message
      for (int i = 0; i < _count.length; ++i) {
        _buffer[_pos++] = _count[i] & 0xff;
        _buffer[_pos++] = (_count[i] >> 8) & 0xff;
        _buffer[_pos++] = (_count[i] >> 16) & 0xff;
        _buffer[_pos++] = (_count[i] >> 24) & 0xff;
      }

      _decode();
      _update();
    }
    _encode();
    return _digest;
  }

  /// Converts 8-bit [_buffer] array to 32-bit [_chunk] array
  void _decode() {
    _pos = 0;
    for (int i = 0, j = 0; j < 64; i++, j += 4) {
      _chunk[i] = (_buffer[j]) |
          (_buffer[j + 1] << 8) |
          (_buffer[j + 2] << 16) |
          (_buffer[j + 3] << 24);
    }
  }

  /// Converts 32-bit [_state] array to 8-bit [_digest] array
  void _encode() {
    for (int i = 0, j = 0; j < 16; i++, j += 4) {
      _digest[j] = (_state[i] & 0xff);
      _digest[j + 1] = (_state[i] >> 8) & 0xff;
      _digest[j + 2] = (_state[i] >> 16) & 0xff;
      _digest[j + 3] = (_state[i] >> 24) & 0xff;
    }
  }

  /// Basic MD5 function for round 1.
  int _f(int x, int y, int z) =>
      (_state[x] & _state[y]) | (~_state[x] & _state[z]);

  /// Basic MD5 function for round 2.
  int _g(int x, int y, int z) =>
      (_state[x] & _state[z]) | (_state[y] & ~_state[z]);

  /// Basic MD5 function for round 3.
  int _h(int x, int y, int z) => _state[x] ^ _state[y] ^ _state[z];

  /// Basic MD5 function for round 4.
  int _i(int x, int y, int z) =>
      _state[y] ^ (_state[x] | (~_state[z] & 0xffffffff));

  /// Rotates x left n bits.
  int _rotl(int x, int n) => ((x << n) & 0xffffffff) | (x >> (32 - n));

  /// Transformation for rounds 1.
  void _ff(int a, int b, int c, int d, int x, int s, int ac) {
    _state[a] += _f(b, c, d);
    _state[a] += x;
    _state[a] += ac;
    _state[a] = _rotl(_state[a], s);
    _state[a] += _state[b];
  }

  /// Transformation for rounds 2.
  void _gg(int a, int b, int c, int d, int x, int s, int ac) {
    _state[a] += _g(b, c, d);
    _state[a] += x;
    _state[a] += ac;
    _state[a] = _rotl(_state[a], s);
    _state[a] += _state[b];
  }

  /// Transformation for rounds 3.
  void _hh(int a, int b, int c, int d, int x, int s, int ac) {
    _state[a] += _h(b, c, d);
    _state[a] += x;
    _state[a] += ac;
    _state[a] = _rotl(_state[a], s);
    _state[a] += _state[b];
  }

  /// Transformation for rounds 4.
  void _ii(int a, int b, int c, int d, int x, int s, int ac) {
    _state[a] += _i(b, c, d);
    _state[a] += x;
    _state[a] += ac;
    _state[a] = _rotl(_state[a], s);
    _state[a] += _state[b];
  }

  /// MD5 block update operation. Continues an MD5 message-digest operation,
  /// processing another message block, and updating the context.
  ///
  /// It uses the [_chunk] as the message block.
  void _update() {
    final x = _chunk;
    const int a = 0;
    const int b = 1;
    const int c = 2;
    const int d = 3;
    int pa = _state[0];
    int pb = _state[1];
    int pc = _state[2];
    int pd = _state[3];

    // Shift amounts per round
    const int s11 = 07;
    const int s12 = 12;
    const int s13 = 17;
    const int s14 = 22;
    const int s21 = 05;
    const int s22 = 09;
    const int s23 = 14;
    const int s24 = 20;
    const int s31 = 04;
    const int s32 = 11;
    const int s33 = 16;
    const int s34 = 23;
    const int s41 = 06;
    const int s42 = 10;
    const int s43 = 15;
    const int s44 = 21;

    // Formula for the last param: floor(2^32 * abs(sin(i + 1)))
    /* Round 1 */
    _ff(a, b, c, d, x[0], s11, 0xd76aa478); /* 1 */
    _ff(d, a, b, c, x[1], s12, 0xe8c7b756); /* 2 */
    _ff(c, d, a, b, x[2], s13, 0x242070db); /* 3 */
    _ff(b, c, d, a, x[3], s14, 0xc1bdceee); /* 4 */
    _ff(a, b, c, d, x[4], s11, 0xf57c0faf); /* 5 */
    _ff(d, a, b, c, x[5], s12, 0x4787c62a); /* 6 */
    _ff(c, d, a, b, x[6], s13, 0xa8304613); /* 7 */
    _ff(b, c, d, a, x[7], s14, 0xfd469501); /* 8 */
    _ff(a, b, c, d, x[8], s11, 0x698098d8); /* 9 */
    _ff(d, a, b, c, x[9], s12, 0x8b44f7af); /* 10 */
    _ff(c, d, a, b, x[10], s13, 0xffff5bb1); /* 11 */
    _ff(b, c, d, a, x[11], s14, 0x895cd7be); /* 12 */
    _ff(a, b, c, d, x[12], s11, 0x6b901122); /* 13 */
    _ff(d, a, b, c, x[13], s12, 0xfd987193); /* 14 */
    _ff(c, d, a, b, x[14], s13, 0xa679438e); /* 15 */
    _ff(b, c, d, a, x[15], s14, 0x49b40821); /* 16 */

    /* Round 2 */
    _gg(a, b, c, d, x[1], s21, 0xf61e2562); /* 17 */
    _gg(d, a, b, c, x[6], s22, 0xc040b340); /* 18 */
    _gg(c, d, a, b, x[11], s23, 0x265e5a51); /* 19 */
    _gg(b, c, d, a, x[0], s24, 0xe9b6c7aa); /* 20 */
    _gg(a, b, c, d, x[5], s21, 0xd62f105d); /* 21 */
    _gg(d, a, b, c, x[10], s22, 0x2441453); /* 22 */
    _gg(c, d, a, b, x[15], s23, 0xd8a1e681); /* 23 */
    _gg(b, c, d, a, x[4], s24, 0xe7d3fbc8); /* 24 */
    _gg(a, b, c, d, x[9], s21, 0x21e1cde6); /* 25 */
    _gg(d, a, b, c, x[14], s22, 0xc33707d6); /* 26 */
    _gg(c, d, a, b, x[3], s23, 0xf4d50d87); /* 27 */
    _gg(b, c, d, a, x[8], s24, 0x455a14ed); /* 28 */
    _gg(a, b, c, d, x[13], s21, 0xa9e3e905); /* 29 */
    _gg(d, a, b, c, x[2], s22, 0xfcefa3f8); /* 30 */
    _gg(c, d, a, b, x[7], s23, 0x676f02d9); /* 31 */
    _gg(b, c, d, a, x[12], s24, 0x8d2a4c8a); /* 32 */

    /* Round 3 */
    _hh(a, b, c, d, x[5], s31, 0xfffa3942); /* 33 */
    _hh(d, a, b, c, x[8], s32, 0x8771f681); /* 34 */
    _hh(c, d, a, b, x[11], s33, 0x6d9d6122); /* 35 */
    _hh(b, c, d, a, x[14], s34, 0xfde5380c); /* 36 */
    _hh(a, b, c, d, x[1], s31, 0xa4beea44); /* 37 */
    _hh(d, a, b, c, x[4], s32, 0x4bdecfa9); /* 38 */
    _hh(c, d, a, b, x[7], s33, 0xf6bb4b60); /* 39 */
    _hh(b, c, d, a, x[10], s34, 0xbebfbc70); /* 40 */
    _hh(a, b, c, d, x[13], s31, 0x289b7ec6); /* 41 */
    _hh(d, a, b, c, x[0], s32, 0xeaa127fa); /* 42 */
    _hh(c, d, a, b, x[3], s33, 0xd4ef3085); /* 43 */
    _hh(b, c, d, a, x[6], s34, 0x4881d05); /* 44 */
    _hh(a, b, c, d, x[9], s31, 0xd9d4d039); /* 45 */
    _hh(d, a, b, c, x[12], s32, 0xe6db99e5); /* 46 */
    _hh(c, d, a, b, x[15], s33, 0x1fa27cf8); /* 47 */
    _hh(b, c, d, a, x[2], s34, 0xc4ac5665); /* 48 */

    /* Round 4 */
    _ii(a, b, c, d, x[0], s41, 0xf4292244); /* 49 */
    _ii(d, a, b, c, x[7], s42, 0x432aff97); /* 50 */
    _ii(c, d, a, b, x[14], s43, 0xab9423a7); /* 51 */
    _ii(b, c, d, a, x[5], s44, 0xfc93a039); /* 52 */
    _ii(a, b, c, d, x[12], s41, 0x655b59c3); /* 53 */
    _ii(d, a, b, c, x[3], s42, 0x8f0ccc92); /* 54 */
    _ii(c, d, a, b, x[10], s43, 0xffeff47d); /* 55 */
    _ii(b, c, d, a, x[1], s44, 0x85845dd1); /* 56 */
    _ii(a, b, c, d, x[8], s41, 0x6fa87e4f); /* 57 */
    _ii(d, a, b, c, x[15], s42, 0xfe2ce6e0); /* 58 */
    _ii(c, d, a, b, x[6], s43, 0xa3014314); /* 59 */
    _ii(b, c, d, a, x[13], s44, 0x4e0811a1); /* 60 */
    _ii(a, b, c, d, x[4], s41, 0xf7537e82); /* 61 */
    _ii(d, a, b, c, x[11], s42, 0xbd3af235); /* 62 */
    _ii(c, d, a, b, x[2], s43, 0x2ad7d2bb); /* 63 */
    _ii(b, c, d, a, x[9], s44, 0xeb86d391); /* 64 */

    _state[0] += pa;
    _state[1] += pb;
    _state[2] += pc;
    _state[3] += pd;
  }
}
