// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/src/core/hash_algo.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// Generates a 160-bit SHA1 hash digest from the input.
HashDigest sha1buffer(final Iterable<int> input) {
  final sha1 = SHA1();
  sha1.update(input);
  return sha1.digest();
}

/// Generates a 160-bit SHA1 hash as hexadecimal digest from string
HashDigest sha1(final String input, [Encoding? encoding]) {
  return sha1buffer(toBytes(input, encoding));
}

/// Generates a 160-bit SHA1 hash digest from stream
Future<HashDigest> sha1stream(final Stream<List<int>> inputStream) async {
  final sha1 = SHA1();
  await inputStream.forEach(sha1.update);
  return sha1.digest();
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
  final _chunk = Uint32List(80); /* Extended message block */

  /// Initializes a new instance of SHA1 message-digest.
  SHA1()
      : super(
          hashSize: 160,
          blockSize: 512,
          endian: Endian.big,
          seed: [
            0x67452301, // a
            0xEFCDAB89, // b
            0x98BADCFE, // c
            0x10325476, // d
            0xC3D2E1F0, // e
          ],
        );

  /// Rotates x left by n bits.
  int _rotl(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  @override
  void $process(final Uint32List state, Uint8List buffer) {
    $decode(buffer, _chunk);
    final w = _chunk;

    // Extend the first 16 words into the remaining 64 words
    for (int t = 16; t < 80; t++) {
      w[t] = _rotl(w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16], 1);
    }

    int a = state[0];
    int b = state[1];
    int c = state[2];
    int d = state[3];
    int e = state[4];

    int t, x, ch;
    for (t = 0; t < 20; t++) {
      ch = ((b & c) | ((~b) & d));
      x = _rotl(a, 5) + ch + e + w[t] + 0x5A827999;
      e = d;
      d = c;
      c = _rotl(b, 30);
      b = a;
      a = x & _mask32;
    }

    for (; t < 40; t++) {
      ch = (b ^ c ^ d);
      x = _rotl(a, 5) + ch + e + w[t] + 0x6ED9EBA1;
      e = d;
      d = c;
      c = _rotl(b, 30);
      b = a;
      a = x & _mask32;
    }

    for (; t < 60; t++) {
      ch = ((b & c) | (b & d) | (c & d));
      x = _rotl(a, 5) + ch + e + w[t] + 0x8F1BBCDC;
      e = d;
      d = c;
      c = _rotl(b, 30);
      b = a;
      a = x & _mask32;
    }

    for (; t < 80; t++) {
      ch = (b ^ c ^ d);
      x = _rotl(a, 5) + ch + e + w[t] + 0xCA62C1D6;
      e = d;
      d = c;
      c = _rotl(b, 30);
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
  void $finalize(Uint32List state, Uint8List buffer, int pos) {
    // Adding a single 1 bit padding
    buffer[pos++] = 0x80;

    // If buffer length > 56 bytes, skip this block
    if (pos > 56) {
      while (pos < 64) {
        buffer[pos++] = 0;
      }
      $process(state, buffer);
      pos = 0;
    }

    // Padding with 0s until buffer length is 56 bytes
    while (pos < 56) {
      buffer[pos++] = 0;
    }

    // Append original message length in bits to message
    $encode64(Uint64List.fromList([messageLengthInBits]), buffer, pos);
    $process(state, buffer);
  }
}
