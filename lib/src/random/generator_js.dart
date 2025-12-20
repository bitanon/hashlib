// Copyright (c) 2025, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show Random;

import 'generator_js_legacy.dart'
    if (dart.library.js_interop) 'generator_js_interop.dart';

const int _mask32 = 0xFFFFFFFF;

/// For Node.js environment + dart2js compiler
class NodeRandom extends CryptoRandom implements Random {
  @override
  int nextInt(final int max) {
    if (max < 1 || max > _mask32 + 1) {
      throw RangeError.range(
          max, 1, _mask32 + 1, 'max', 'max must be <= (1 << 32)');
    }
    return cryptoRandomInt(max);
  }

  @override
  double nextDouble() {
    final int first26Bits = nextInt(1 << 26);
    final int next27Bits = nextInt(1 << 27);
    final int random53Bits = (first26Bits << 27) + next27Bits; // JS int limit
    return random53Bits / (1 << 53);
  }

  @override
  bool nextBool() => nextInt(2) == 1;
}

/// Returns a secure random generator in JS runtime
Random secureRandom() => NodeRandom();

/// Generates a random seed
int $generateSeed() => secureRandom().nextInt(_mask32);
