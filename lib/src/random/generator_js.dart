// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show Random;
import 'dart:js_interop';

const int _mask32 = 0xFFFFFFFF;

@JS()
@staticInterop
class Crypto {}

extension on Crypto {
  external int randomInt(final int max);
}

@JS()
external Crypto require(final String id);

class NodeRandom implements Random {
  @override
  bool nextBool() => nextInt(2) == 1;

  @override
  double nextDouble() {
    final int a = nextInt(1 << 26); // 26 bits
    final int b = nextInt(1 << 27); // 27 bits
    return ((a << 27) + b) / (1 << 53); // 26 + 27 = 53 bits (JS limit)
  }

  @override
  int nextInt(final int max) {
    if (max < 1 || max > _mask32 + 1) {
      throw RangeError.range(
          max, 1, _mask32 + 1, 'max', 'max must be <= (1 << 32)');
    }
    return require('crypto').randomInt(max);
  }
}

/// Returns a secure random generator in JS runtime
Random secureRandom() {
  try {
    return Random.secure();
  } catch (e) {
    // For Node.js with dart2js compiler, the following error is expected.
    if (e.runtimeType.toString() == 'UnknownJsTypeError') {
      // This error is internal to 'dart:_js_helper'.
      return NodeRandom();
    }
    rethrow;
  }
}

/// Generates a random seed
int $generateSeed() => secureRandom().nextInt(_mask32);
