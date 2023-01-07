// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/hash_sink.dart';

const int _mask32 = 0xFFFFFFFF;

/// This implementation is derived from The Internet Society
/// [US Secure Hash Algorithm 1 (SHA1)][rfc3174].
///
/// [rfc3174]: https://datatracker.ietf.org/doc/html/rfc3174
class SHA1Sink extends HashSink {
  SHA1Sink([Sink<HashDigest>? sink])
      : super(
          sink: sink,
          hashLengthInBits: 160,
          blockLengthInBits: 512,
          extendedChunkLength: 80,
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
  void update(Uint32List block) {
    var w = block;
    var a = state[0];
    var b = state[1];
    var c = state[2];
    var d = state[3];
    var e = state[4];

    // Extend the first 16 words into the remaining 64 words
    for (int t = 16; t < 80; t++) {
      w[t] = _rotl(w[t - 3] ^ w[t - 8] ^ w[t - 14] ^ w[t - 16], 1);
    }

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
}
