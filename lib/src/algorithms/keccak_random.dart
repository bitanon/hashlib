// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'keccak.dart';

/// A pseudo random number generator using Keccak construction.
///
/// **NOTE: This is a proof of concept feature. Use it at your own risk.**
class KeccakRandom implements Random {
  final Iterator<int> _generator;

  static get _defaultSeed =>
      (DateTime.now().microsecond << 10) ^ DateTime.now().millisecond;

  KeccakRandom([int? seed])
      : _generator = KeccakHash.generate(
          seed ?? _defaultSeed,
        ).iterator;

  /// Generates a 8-bit bit random number
  @pragma('vm:prefer-inline')
  int nextByte() {
    _generator.moveNext();
    return _generator.current;
  }

  /// Generates a 16-bit bit random  number
  @pragma('vm:prefer-inline')
  int nextWord() {
    return nextByte() ^ (nextByte() << 8);
  }

  /// Generates a 32-bit bit random number
  @pragma('vm:prefer-inline')
  int nextDWord() {
    return nextByte() ^
        (nextByte() << 8) ^
        (nextByte() << 16) ^
        (nextByte() << 24);
  }

  @override
  @pragma('vm:prefer-inline')
  bool nextBool() {
    return nextByte() & 0x55 == 0;
  }

  @override
  @pragma('vm:prefer-inline')
  double nextDouble() {
    return nextDWord() / 0xFFFFFFFF;
  }

  @override
  @pragma('vm:prefer-inline')
  int nextInt(int max) {
    int num = nextByte();
    if (max > 0x100) {
      num ^= nextByte() << 8;
    }
    if (max > 0x10000) {
      num ^= nextByte() << 16;
    }
    if (max > 0x1000000) {
      num ^= nextByte() << 24;
    }
    return num % max;
  }
}
