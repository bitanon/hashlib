// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash32.dart';

const int _mask32 = 0xFFFFFFFF;

/// This abstract class contains general implementation for 32-bit based SHA2
/// hash functions, i.e. [SHA224] and [SHA256].
///
/// The implementation is derived from [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://datatracker.ietf.org/doc/html/rfc6234
/// For an instance, use [SHA224] or [SHA256].
abstract class SHA2of32bit extends Hash32bit {
  final _chunk = Uint32List(64); /* Extended message block */

  /// For internal use only.
  SHA2of32bit({
    required List<int> seed,
    required int hashLengthInBits,
  }) : super(
          seed: seed,
          endian: Endian.big,
          blockLengthInBits: 512,
          hashLengthInBits: hashLengthInBits,
        );

  /// Rotates x right by n bits.
  int _rotr(int x, int n) =>
      ((x & _mask32) >>> n) | ((x << (32 - n)) & _mask32);

  int _bsig0(int x) => (_rotr(x, 2) ^ _rotr(x, 13) ^ _rotr(x, 22));

  int _bsig1(int x) => (_rotr(x, 6) ^ _rotr(x, 11) ^ _rotr(x, 25));

  int _ssig0(int x) => (_rotr(x, 7) ^ _rotr(x, 18) ^ (x >>> 3));

  int _ssig1(int x) => (_rotr(x, 17) ^ _rotr(x, 19) ^ (x >>> 10));

  @override
  void $process(final Uint32List state, final ByteData buffer) {
    final w = _chunk;
    for (int i = 0, j = 0; j < blockLength; i++, j += 4) {
      _chunk[i] = buffer.getUint32(j, endian);
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

    int a = state[0];
    int b = state[1];
    int c = state[2];
    int d = state[3];
    int e = state[4];
    int f = state[5];
    int g = state[6];
    int h = state[7];

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

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += e;
    state[5] += f;
    state[6] += g;
    state[7] += h;
  }

  @override
  void $finalize(final Uint32List state, final ByteData buffer, int pos) {
    // Adding a single 1 bit padding
    buffer.setUint8(pos++, 0x80);

    // If buffer length > 56 bytes, skip this block
    if (pos > 56) {
      while (pos < 64) {
        buffer.setUint8(pos++, 0);
      }
      $process(state, buffer);
      pos = 0;
    }

    // Padding with 0s until buffer length is 56 bytes
    while (pos < 56) {
      buffer.setUint8(pos++, 0);
    }

    // Append original message length in bits to message
    buffer.setUint64(pos, messageLengthInBits, endian);
    $process(state, buffer);
  }
}
