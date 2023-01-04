// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/src/core/hash_algo.dart';
import 'package:hashlib/src/core/utils.dart';

/// Generates a 160-bit SHA1 hash digest from the input.
Uint8List sha1buffer(final Iterable<int> input) {
  final sha1 = SHA1();
  sha1.update(input);
  return sha1.digest();
}

/// Generates a 160-bit SHA1 hash digest from stream
Future<Uint8List> sha1stream(final Stream<List<int>> inputStream) async {
  final sha1 = SHA1();
  await inputStream.forEach((x) {
    sha1.update(x);
  });
  return sha1.digest();
}

/// Generates a 160-bit SHA1 hash as hexadecimal digest from bytes
String sha1sum(final Iterable<int> input) {
  return toHexString(sha1buffer(input));
}

/// Generates a 160-bit SHA1 hash as hexadecimal digest from string
String sha1(final String input, [Encoding encoding = utf8]) {
  return sha1sum(toBytes(input, encoding));
}

const int _mask32 = 0xFFFFFFFF;

/// This implementation is derived from The Internet Society
/// [US Secure Hash Algorithm 1 (SHA1)][rfc3174].
///
/// [rfc3174]: https://datatracker.ietf.org/doc/html/rfc3174
///
/// **Warning**: SHA1 has extensive vulnerabilities. It can be safely used
/// for checksum, but do not use it for cryptographic purposes.
class SHA1 extends HashAlgo {
  @override
  final int hashSize = 160;

  final _state = Uint32List(5); /* state (ABCD) */
  final _digest = Uint8List(20); /* the final digest */
  final _buffer = Uint8List(64); /* 512-bit chunk in bytes */
  final _chunk = Uint32List(80); /* Extended words */
  int _countLow = 0, _countHigh = 0; /* number of bits mod 2^64 */
  bool _closed = false; /* whether the digest is ready */
  int _pos = 0; /* latest buffer position */

  /// Initializes a new instance of SHA1 message-digest.
  /// An instance can be re-used after calling the [clear] function.
  SHA1() {
    clear();
  }

  @override
  void clear() {
    // Reset count
    _countLow = 0;
    _countHigh = 0;
    // Initialize variables
    _state[0] = 0x67452301; // a
    _state[1] = 0xEFCDAB89; // b
    _state[2] = 0x98BADCFE; // c
    _state[3] = 0x10325476; // d
    _state[4] = 0xC3D2E1F0; // e
    // Reset state
    _pos = 0;
    _closed = false;
  }

  @override
  void update(final Iterable<int> input) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }

    // Transform as many times as possible.
    int n = 0;
    for (int x in input) {
      n++;
      _buffer[_pos++] = x;
      if (_pos == 64) {
        _update();
        _pos = 0;
      }
    }

    // Update number of bits
    int m = _countLow + (n << 3);
    _countHigh = (_countHigh + (m >> 32) + (n >> 29)) & _mask32;
    _countLow = m & _mask32;
  }

  @override
  Uint8List digest() {
    // The final message digest is available in [_digest]
    if (_closed) {
      return _digest;
    }
    _closed = true;

    // Adding a single 1 bit padding
    _buffer[_pos++] = 0x80;

    // If buffer length > 56 bytes, skip this block
    if (_pos >= 56) {
      while (_pos < 64) {
        _buffer[_pos++] = 0;
      }
      _update();
      _pos = 0;
    }

    // Padding with 0s until buffer length is 56 bytes
    while (_pos < 56) {
      _buffer[_pos++] = 0;
    }

    // Append original message length in bits to message
    for (int source in [_countHigh, _countLow]) {
      _buffer[_pos++] = (source >> 24) & 0xff;
      _buffer[_pos++] = (source >> 16) & 0xff;
      _buffer[_pos++] = (source >> 8) & 0xff;
      _buffer[_pos++] = (source & 0xff);
    }
    _update();
    _pos = 0;

    for (int i = 0, j = 0; j < 20; i++, j += 4) {
      _digest[j] = (_state[i] >> 24) & 0xff;
      _digest[j + 1] = (_state[i] >> 16) & 0xff;
      _digest[j + 2] = (_state[i] >> 8) & 0xff;
      _digest[j + 3] = (_state[i] & 0xff);
    }
    return _digest;
  }

  /// Rotates x left n bits.
  int _shift(int n, int x) =>
      ((x << n) & _mask32) | ((x & _mask32) >> (32 - n));

  /// MD5 block update operation. Continues an MD5 message-digest operation,
  /// processing another message block, and updating the context.
  ///
  /// It uses the [_chunk] as the message block.
  void _update() {
    // convert 8-bit _buffer to 16-bit _chunk
    final w = _chunk;
    for (int t = 0, j = 0; t < 16; t++, j += 4) {
      _chunk[t] = (_buffer[j] << 24) |
          (_buffer[j + 1] << 16) |
          (_buffer[j + 2] << 8) |
          (_buffer[j + 3]);
    }
    const int k0 = 0x5A827999;
    const int k1 = 0x6ED9EBA1;
    const int k2 = 0x8F1BBCDC;
    const int k3 = 0xCA62C1D6;

    int a = _state[0];
    int b = _state[1];
    int c = _state[2];
    int d = _state[3];
    int e = _state[4];

    int x, t = 0;
    for (t = 16; t < 80; t++) {
      w[t] = _shift(1, w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16]);
    }

    for (t = 0; t < 20; t++) {
      x = _shift(5, a) + ((b & c) | ((~b) & d)) + e + w[t] + k0;
      e = d;
      d = c;
      c = _shift(30, b);
      b = a;
      a = x & _mask32;
    }

    for (; t < 40; t++) {
      x = _shift(5, a) + (b ^ c ^ d) + e + w[t] + k1;
      e = d;
      d = c;
      c = _shift(30, b);
      b = a;
      a = x & _mask32;
    }

    for (; t < 60; t++) {
      x = _shift(5, a) + ((b & c) | (b & d) | (c & d)) + e + w[t] + k2;
      e = d;
      d = c;
      c = _shift(30, b);
      b = a;
      a = x & _mask32;
    }

    for (; t < 80; t++) {
      x = _shift(5, a) + (b ^ c ^ d) + e + w[t] + k3;
      e = d;
      d = c;
      c = _shift(30, b);
      b = a;
      a = x & _mask32;
    }

    _state[0] += a;
    _state[1] += b;
    _state[2] += c;
    _state[3] += d;
    _state[4] += e;
  }
}
