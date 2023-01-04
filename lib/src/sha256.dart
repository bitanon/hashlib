// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/src/core/hash_algo.dart';
import 'package:hashlib/src/core/utils.dart';

/// Generates a 256-bit SHA256 hash digest from the input.
Uint8List sha256buffer(final Iterable<int> input) {
  final sha256 = SHA256();
  sha256.update(input);
  return sha256.digest();
}

/// Generates a 256-bit SHA256 hash digest from stream
Future<Uint8List> sha256stream(final Stream<List<int>> inputStream) async {
  final sha256 = SHA256();
  await inputStream.forEach((x) {
    sha256.update(x);
  });
  return sha256.digest();
}

/// Generates a 256-bit SHA256 hash as hexadecimal digest from bytes
String sha256sum(final Iterable<int> input) {
  return toHexString(sha256buffer(input));
}

/// Generates a 256-bit SHA256 hash as hexadecimal digest from string
String sha256(final String input, [Encoding encoding = utf8]) {
  return sha256sum(toBytes(input, encoding));
}

const int _mask32 = 0xFFFFFFFF;

/// This implementation is derived from [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://datatracker.ietf.org/doc/html/rfc6234
///
/// **Warning**: SHA256 has extensive vulnerabilities. It can be safely used
/// for checksum, but do not use it for cryptographic purposes.
class SHA256 extends HashAlgo {
  @override
  final int hashLengthInBits = 256;

  final _state = Uint32List(8); /* the hash state */
  final _digest = Uint8List(32); /* the final digest */
  final _buffer = Uint8List(64); /* 512-bit chunk in bytes */
  final _chunk = Uint32List(64); /* Extended message block */
  int _countLow = 0, _countHigh = 0; /* number of bits mod 2^64 */
  bool _closed = false; /* whether the digest is ready */
  int _pos = 0; /* latest buffer position */

  /// Initializes a new instance of SHA256 message-digest.
  /// An instance can be re-used after calling the [clear] function.
  SHA256() {
    clear();
  }

  @override
  void clear() {
    // Reset count
    _countLow = 0;
    _countHigh = 0;
    // Initialize variables
    _state[0] = 0x6a09e667; // a
    _state[1] = 0xbb67ae85; // b
    _state[2] = 0x3c6ef372; // c
    _state[3] = 0xa54ff53a; // d
    _state[4] = 0x510e527f; // e
    _state[5] = 0x9b05688c; // f
    _state[6] = 0x1f83d9ab; // g
    _state[7] = 0x5be0cd19; // h
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

    for (int i = 0, j = 0; j < 32; i++, j += 4) {
      _digest[j] = (_state[i] >> 24) & 0xff;
      _digest[j + 1] = (_state[i] >> 16) & 0xff;
      _digest[j + 2] = (_state[i] >> 8) & 0xff;
      _digest[j + 3] = (_state[i] & 0xff);
    }
    return _digest;
  }

  /// Rotates x right by n bits.
  int _rotr(int x, int n) => ((x & _mask32) >> n) | ((x << (32 - n)) & _mask32);

  int _bsig0(int x) => (_rotr(x, 2) ^ _rotr(x, 13) ^ _rotr(x, 22));

  int _bsig1(int x) => (_rotr(x, 6) ^ _rotr(x, 11) ^ _rotr(x, 25));

  int _ssig0(int x) => (_rotr(x, 7) ^ _rotr(x, 18) ^ (x >> 3));

  int _ssig1(int x) => (_rotr(x, 17) ^ _rotr(x, 19) ^ (x >> 10));

  /// MD5 block update operation. Continues an MD5 message-digest operation,
  /// processing another message block, and updating the context.
  ///
  /// It uses the [_chunk] as the message block.
  void _update() {
    // Convert 8-bit _buffer to 16-bit _chunk
    final w = _chunk;
    for (int t = 0, j = 0; t < 16; t++, j += 4) {
      _chunk[t] = (_buffer[j] << 24) |
          (_buffer[j + 1] << 16) |
          (_buffer[j + 2] << 8) |
          (_buffer[j + 3]);
    }

    // Extend the first 16 words into the remaining 48 words
    for (int t = 16; t < 64; t++) {
      w[t] = _ssig1(w[t - 2]) + w[t - 7] + _ssig0(w[t - 15]) + w[t - 16];
    }

    // Initialize array of round constants
    const List<int> k = [
      0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, //
      0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
      0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
      0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
      0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
      0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
      0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
      0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
      0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
      0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
      0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
      0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
      0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
      0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
      0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
      0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
    ];

    int a = _state[0];
    int b = _state[1];
    int c = _state[2];
    int d = _state[3];
    int e = _state[4];
    int f = _state[5];
    int g = _state[6];
    int h = _state[7];

    int ch, maj, t1, t2;
    for (int i = 0; i < 64; ++i) {
      ch = (e & f) ^ ((~e) & g);
      maj = (a & b) ^ (a & c) ^ (b & c);
      t1 = (h + _bsig1(e) + ch + k[i] + w[i]) & _mask32;
      t2 = (_bsig0(a) + maj) & _mask32;

      h = g;
      g = f;
      f = e;
      e = (d + t1) & _mask32;
      d = c;
      c = b;
      b = a;
      a = (t1 + t2) & _mask32;
    }

    _state[0] += a;
    _state[1] += b;
    _state[2] += c;
    _state[3] += d;
    _state[4] += e;
    _state[5] += f;
    _state[6] += g;
    _state[7] += h;
  }
}
