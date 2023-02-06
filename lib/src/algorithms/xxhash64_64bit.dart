// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

class XXHash64Sink extends BlockHashSink {
  final int seed;

  @override
  final int hashLength = 8;

  static const int prime64_1 = 0x9E3779B185EBCA87;
  static const int prime64_2 = 0xC2B2AE3D27D4EB4F;
  static const int prime64_3 = 0x165667B19E3779F9;
  static const int prime64_4 = 0x85EBCA77C2B2AE63;
  static const int prime64_5 = 0x27D4EB2F165667C5;

  int _acc1 = 0;
  int _acc2 = 0;
  int _acc3 = 0;
  int _acc4 = 0;

  late final Uint64List qbuffer = buffer.buffer.asUint64List();

  XXHash64Sink(this.seed) : super(32) {
    reset();
  }

  @override
  void reset() {
    super.reset();
    _acc1 = seed + prime64_1 + prime64_2;
    _acc2 = seed + prime64_2;
    _acc3 = seed + 0;
    _acc4 = seed - prime64_1;
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
    if (pos == blockLength) {
      $update();
      pos = 0;
    }
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    _acc1 += qbuffer[0] * prime64_2;
    _acc1 = (_acc1 << 31) | (_acc1 >>> 33);
    _acc1 *= prime64_1;

    _acc2 += qbuffer[1] * prime64_2;
    _acc2 = (_acc2 << 31) | (_acc2 >>> 33);
    _acc2 *= prime64_1;

    _acc3 += qbuffer[2] * prime64_2;
    _acc3 = (_acc3 << 31) | (_acc3 >>> 33);
    _acc3 *= prime64_1;

    _acc4 += qbuffer[3] * prime64_2;
    _acc4 = (_acc4 << 31) | (_acc4 >>> 33);
    _acc4 *= prime64_1;
  }

  @override
  Uint8List $finalize() {
    int i, t, p;
    int _hash;

    if (messageLength < 32) {
      _hash = seed + prime64_5;
    } else {
      // accumulate
      _hash = (_acc1 << 1) | (_acc1 >>> 63);
      _hash += (_acc2 << 7) | (_acc2 >>> 57);
      _hash += (_acc3 << 12) | (_acc3 >>> 52);
      _hash += (_acc4 << 18) | (_acc4 >>> 46);

      // merge round
      _acc1 *= prime64_2;
      _acc1 = (_acc1 << 31) | (_acc1 >>> 33);
      _acc1 *= prime64_1;
      _hash = (_hash ^ _acc1) * prime64_1 + prime64_4;

      _acc2 *= prime64_2;
      _acc2 = (_acc2 << 31) | (_acc2 >>> 33);
      _acc2 *= prime64_1;
      _hash = (_hash ^ _acc2) * prime64_1 + prime64_4;

      _acc3 *= prime64_2;
      _acc3 = (_acc3 << 31) | (_acc3 >>> 33);
      _acc3 *= prime64_1;
      _hash = (_hash ^ _acc3) * prime64_1 + prime64_4;

      _acc4 *= prime64_2;
      _acc4 = (_acc4 << 31) | (_acc4 >>> 33);
      _acc4 *= prime64_1;
      _hash = (_hash ^ _acc4) * prime64_1 + prime64_4;
    }

    _hash += messageLength;

    // process the remaining data
    for (i = t = 0; t + 8 <= pos; ++i, t += 8) {
      p = qbuffer[i] * prime64_2;
      p = (p << 31) | (p >>> 33);
      p *= prime64_1;
      _hash ^= p;
      _hash = (_hash << 27) | (_hash >>> 37);
      _hash = (_hash * prime64_1) + prime64_4;
    }
    for (i <<= 1; t + 4 <= pos; ++i, t += 4) {
      _hash ^= sbuffer[i] * prime64_1;
      _hash = (_hash << 23) | (_hash >>> 41);
      _hash = (_hash * prime64_2) + prime64_3;
    }
    for (; t < pos; t++) {
      _hash ^= buffer[t] * prime64_5;
      _hash = (_hash << 11) | (_hash >>> 53);
      _hash *= prime64_1;
    }

    // avalanche
    _hash ^= _hash >>> 33;
    _hash *= prime64_2;
    _hash ^= _hash >>> 29;
    _hash *= prime64_3;
    _hash ^= _hash >>> 32;

    return Uint8List.fromList([
      _hash >>> 56,
      _hash >>> 48,
      _hash >>> 40,
      _hash >>> 32,
      _hash >>> 24,
      _hash >>> 16,
      _hash >>> 8,
      _hash,
    ]);
  }
}
