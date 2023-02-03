// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask16 = 0xFFFF;
const int _mask32 = 0xFFFFFFFF;

/// 0b10011110001101110111100110110001 = 0x9E3779B1
const int prime32_1 = 0x9E3779B1;

/// 0b10000101111010111100101001110111 = 0x85EBCA77
const int prime32_2 = 0x85EBCA77;

/// 0b11000010101100101010111000111101 = 0xC2B2AE3D
const int prime32_3 = 0xC2B2AE3D;

/// 0b00100111110101001110101100101111 = 0x27D4EB2F
const int prime32_4 = 0x27D4EB2F;

/// 0b00010110010101100110011110110001 = 0x165667B1
const int prime32_5 = 0x165667B1;

class XXHash32Sink extends BlockHashSink {
  final int seed;
  int _acc1 = 0;
  int _acc2 = 0;
  int _acc3 = 0;
  int _acc4 = 0;

  @override
  final int hashLength = 4;

  XXHash32Sink(this.seed) : super(16) {
    reset();
  }

  @override
  void reset() {
    super.reset();
    _acc1 = seed + prime32_1 + prime32_2;
    _acc2 = seed + prime32_2;
    _acc3 = seed + 0;
    _acc4 = seed - prime32_1;
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
  }

  /// Returns ([a] * [b]) & [mask32]
  static int cross32(int a, int b) {
    int ah = (a >>> 16) & _mask16;
    int al = a & _mask16;
    int bh = (b >>> 16) & _mask16;
    int bl = b & _mask16;
    a = (ah * bl + al * bh) & _mask32;
    b = (al * bl) & _mask32;
    return ((a << 16) + b) & _mask32;
  }

  /// Rotates 32-bit number [x] by [n] bits
  static int rotl32(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    _acc1 += cross32(sbuffer[0], prime32_2);
    _acc1 = rotl32(_acc1, 13);
    _acc1 = cross32(_acc1, prime32_1);

    _acc2 += cross32(sbuffer[1], prime32_2);
    _acc2 = rotl32(_acc2, 13);
    _acc2 = cross32(_acc2, prime32_1);

    _acc3 += cross32(sbuffer[2], prime32_2);
    _acc3 = rotl32(_acc3, 13);
    _acc3 = cross32(_acc3, prime32_1);

    _acc4 += cross32(sbuffer[3], prime32_2);
    _acc4 = rotl32(_acc4, 13);
    _acc4 = cross32(_acc4, prime32_1);
  }

  @override
  Uint8List $finalize() {
    int i, t;
    int _hash;

    if (messageLength < 16) {
      _hash = seed + prime32_5;
    } else {
      _hash = rotl32(_acc1, 1);
      _hash += rotl32(_acc2, 7);
      _hash += rotl32(_acc3, 12);
      _hash += rotl32(_acc4, 18);
    }

    _hash += messageLength & _mask32;

    // process the remaining data
    for (i = t = 0; t + 4 <= pos; ++i, t += 4) {
      _hash += cross32(sbuffer[i], prime32_3);
      _hash = rotl32(_hash, 17);
      _hash = cross32(_hash, prime32_4);
    }
    for (; t < pos; t++) {
      _hash += cross32(buffer[t], prime32_5);
      _hash = rotl32(_hash, 11);
      _hash = cross32(_hash, prime32_1);
    }

    // avalanche
    _hash &= _mask32;
    _hash ^= _hash >>> 15;
    _hash = cross32(_hash, prime32_2);
    _hash ^= _hash >>> 13;
    _hash = cross32(_hash, prime32_3);
    _hash ^= _hash >>> 16;

    return Uint8List.fromList([
      _hash >>> 24,
      _hash >>> 16,
      _hash >>> 8,
      _hash,
    ]);
  }
}