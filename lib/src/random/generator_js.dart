// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show Random;
import 'dart:js_interop';

const int _mask32 = 0xFFFFFFFF;

const bool isDart2JS = bool.fromEnvironment('dart.tool.dart2js');

@JS()
@staticInterop
class Process {}

@JS()
@staticInterop
class Versions {}

@JS('process')
external Process? get _process;

extension on Process {
  external Versions? get versions;
}

extension on Versions {
  external JSAny get node;
}

bool get isNodeDart2JS => _process?.versions?.node != null && isDart2JS;

@JS()
@staticInterop
class Crypto {}

extension on Crypto {
  external int randomInt(final int max);
}

@JS()
external Crypto require(final String id);

/// For Node.js environment + dart2js compiler
class NodeRandom implements Random {
  @override
  int nextInt(final int max) {
    if (max < 1 || max > _mask32 + 1) {
      throw RangeError.range(
          max, 1, _mask32 + 1, 'max', 'max must be <= (1 << 32)');
    }
    return require('crypto').randomInt(max);
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
Random secureRandom() => isNodeDart2JS ? NodeRandom() : Random.secure();

/// Generates a random seed
int $generateSeed() => secureRandom().nextInt(_mask32);
