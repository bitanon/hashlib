// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/hash_sink.dart';

const int _mask32 = 0xFFFFFFFF;

class SHA224Sink extends _SHA2of32bit {
  SHA224Sink([Sink<HashDigest>? sink])
      : super(
          sink: sink,
          hashLengthInBits: 224,
          seed: [
            0xc1059ed8, // a
            0x367cd507, // b
            0x3070dd17, // c
            0xf70e5939, // d
            0xffc00b31, // e
            0x68581511, // f
            0x64f98fa7, // g
            0xbefa4fa4, // h
          ],
        );
}

class SHA256Sink extends _SHA2of32bit {
  SHA256Sink([Sink<HashDigest>? sink])
      : super(
          sink: sink,
          hashLengthInBits: 256,
          seed: [
            0x6a09e667, // a
            0xbb67ae85, // b
            0x3c6ef372, // c
            0xa54ff53a, // d
            0x510e527f, // e
            0x9b05688c, // f
            0x1f83d9ab, // g
            0x5be0cd19, // h
          ],
        );
}

// Initialize array of round constants
const List<int> K = [
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

/// The implementation is derived from the US Secure Hash Algorithms document
/// of [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://datatracker.ietf.org/doc/html/rfc6234
abstract class _SHA2of32bit extends HashSink {
  /// For internal use only.
  _SHA2of32bit({
    Sink<HashDigest>? sink,
    required List<int> seed,
    required int hashLengthInBits,
  }) : super(
          sink: sink,
          seed: seed,
          endian: Endian.big,
          blockLengthInBits: 512,
          extendedChunkLength: 64,
          hashLengthInBits: hashLengthInBits,
        );

  /// Rotates x right by n bits.
  int _rotr(int x, int n) =>
      ((x & _mask32) >>> n) | ((x << (32 - n)) & _mask32);

  int _ch(int x, int y, int z) => (x & y) ^ ((~x & _mask32) & z);

  int _maj(int x, int y, int z) => (x & y) ^ (x & z) ^ (y & z);

  int _bsig0(int x) => (_rotr(x, 2) ^ _rotr(x, 13) ^ _rotr(x, 22));

  int _bsig1(int x) => (_rotr(x, 6) ^ _rotr(x, 11) ^ _rotr(x, 25));

  int _ssig0(int x) => (_rotr(x, 7) ^ _rotr(x, 18) ^ (x >>> 3));

  int _ssig1(int x) => (_rotr(x, 17) ^ _rotr(x, 19) ^ (x >>> 10));

  @override
  void update(final Uint32List block) {
    var w = block;
    var a = state[0];
    var b = state[1];
    var c = state[2];
    var d = state[3];
    var e = state[4];
    var f = state[5];
    var g = state[6];
    var h = state[7];

    // Extend the first 16 words into the remaining 48 words
    for (var i = 16; i < 64; i++) {
      w[i] = _ssig1(w[i - 2]) + w[i - 7] + _ssig0(w[i - 15]) + w[i - 16];
    }

    for (var i = 0; i < 64; ++i) {
      var t1 = h + _bsig1(e) + _ch(e, f, g) + K[i] + w[i];
      var t2 = _bsig0(a) + _maj(a, b, c);

      h = g;
      g = f;
      f = e;
      e = (d + t1) & _mask32;
      d = c;
      c = b;
      b = a;
      a = (t1 + t2) & _mask32;
    }

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += e;
    state[5] += f;
    state[6] += g;
    state[7] += h;
  }
}
