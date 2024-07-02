// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/src/algorithms/keccak.dart';

const int _maxLong = 1 << 32;

enum RandomGenerator {
  keccak,
  system,
}

extension RandomGeneratorIterable on RandomGenerator {
  Iterable<int> build([int? seed]) {
    switch (this) {
      case RandomGenerator.keccak:
        return _RandomGenerators.$keccakGenerateor(seed);
      case RandomGenerator.system:
      default:
        return _RandomGenerators.$systemGenerator(seed);
    }
  }
}

abstract class _RandomGenerators {
  /// Generate a seed based on current time
  static int $generateSeed() =>
      (DateTime.now().microsecond << 10) ^ DateTime.now().millisecond;

  /// Returns secure [Random], or a seeded Random on failure.
  static Random $systemRandom([int? seed]) {
    try {
      return Random.secure();
    } catch (err) {
      return Random(seed ?? $generateSeed());
    }
  }

  /// Returns a iterable of 32-bit integers backed by system's [Random].
  static Iterable<int> $systemGenerator([int? seed]) sync* {
    Random random = $systemRandom(seed);
    while (true) {
      yield random.nextInt(_maxLong);
    }
  }

  /// Returns a iterable of 32-bit integers generated from the [KeccakHash].
  static Iterable<int> $keccakGenerateor([int? seed]) sync* {
    seed ??= $generateSeed();
    var sink = KeccakHash(stateSize: 64, paddingByte: 0);
    sink.sbuffer.fillRange(0, sink.sbuffer.length, seed);
    while (true) {
      sink.$update();
      for (var x in sink.sbuffer) {
        yield x;
      }
    }
  }
}
