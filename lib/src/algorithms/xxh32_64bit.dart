// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask32 = 0xFFFFFFFF;

/// This implementation is derived from
/// https://github.com/easyaspi314/xxhash-clean/blob/master/xxhash32-ref.c
class XXHash32Sink extends BlockHashSink {
  final int seed;

  @override
  final int hashLength = 4;

  static const int prime32_1 = 0x9E3779B1;
  static const int prime32_2 = 0x85EBCA77;
  static const int prime32_3 = 0xC2B2AE3D;
  static const int prime32_4 = 0x27D4EB2F;
  static const int prime32_5 = 0x165667B1;

  int _acc1 = 0;
  int _acc2 = 0;
  int _acc3 = 0;
  int _acc4 = 0;

  XXHash32Sink(this.seed) : super(16) {
    reset();
  }

  @override
  void reset() {
    super.reset();
    _acc1 = (seed & _mask32) + prime32_1 + prime32_2;
    _acc2 = (seed & _mask32) + prime32_2;
    _acc3 = (seed & _mask32) + 0;
    _acc4 = (seed & _mask32) - prime32_1;
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
    _acc1 = (_acc1 + sbuffer[0] * prime32_2) & _mask32;
    _acc1 = (_acc1 << 13) | (_acc1 >>> 19);
    _acc1 = (_acc1 * prime32_1) & _mask32;

    _acc2 = (_acc2 + sbuffer[1] * prime32_2) & _mask32;
    _acc2 = (_acc2 << 13) | (_acc2 >>> 19);
    _acc2 = (_acc2 * prime32_1) & _mask32;

    _acc3 = (_acc3 + sbuffer[2] * prime32_2) & _mask32;
    _acc3 = (_acc3 << 13) | (_acc3 >>> 19);
    _acc3 = (_acc3 * prime32_1) & _mask32;

    _acc4 = (_acc4 + sbuffer[3] * prime32_2) & _mask32;
    _acc4 = (_acc4 << 13) | (_acc4 >>> 19);
    _acc4 = (_acc4 * prime32_1) & _mask32;
  }

  @override
  Uint8List $finalize() {
    int i, t;
    int _hash;

    if (messageLength < 16) {
      _hash = (seed & _mask32) + prime32_5;
    } else {
      _hash = (_acc1 << 1) | (_acc1 >>> 31);
      _hash += (_acc2 << 7) | (_acc2 >>> 25);
      _hash += (_acc3 << 12) | (_acc3 >>> 20);
      _hash += (_acc4 << 18) | (_acc4 >>> 14);
    }

    _hash = (_hash + messageLength) & _mask32;

    // process the remaining data
    for (i = t = 0; t + 4 <= pos; ++i, t += 4) {
      _hash = (_hash + sbuffer[i] * prime32_3) & _mask32;
      _hash = (_hash << 17) | (_hash >>> 15);
      _hash = (_hash * prime32_4) & _mask32;
    }
    for (; t < pos; t++) {
      _hash = (_hash + buffer[t] * prime32_5) & _mask32;
      _hash = (_hash << 11) | (_hash >>> 21);
      _hash = (_hash * prime32_1) & _mask32;
    }

    // avalanche
    _hash ^= _hash >>> 15;
    _hash = (_hash * prime32_2) & _mask32;
    _hash ^= _hash >>> 13;
    _hash = (_hash * prime32_3) & _mask32;
    _hash ^= _hash >>> 16;

    return Uint8List.fromList([
      _hash >>> 24,
      _hash >>> 16,
      _hash >>> 8,
      _hash,
    ]);
  }
}
