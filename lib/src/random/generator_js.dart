// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show Random;
import 'dart:js_interop';

const int _mask32 = 0xFFFFFFFF;

@JS()
external JSObject require(String id);

@JS()
@staticInterop
class Buffer {}

extension BufferExt on Buffer {
  external int readUInt32LE(int offset);
}

@JS()
@staticInterop
class Crypto {}

extension CryptoExt on Crypto {
  external Buffer randomBytes(int size);
}

class NodeRandom implements Random {
  final Crypto _crypto = require('crypto') as Crypto;

  @override
  bool nextBool() => nextInt(2) == 1;

  @override
  double nextDouble() {
    final int a = nextInt(1 << 26); // 26 bits
    final int b = nextInt(1 << 27); // 27 bits
    return ((a << 27) + b) / (1 << 53); // 26 + 27 = 53 bits (JS limit)
  }

  @override
  int nextInt(int max) {
    // Generate 32-bit unsigned random values and use rejection sampling
    // to avoid modulo bias.
    const int maxUint = _mask32 + 1; // (1 << 32)
    if (max < 1 || max > maxUint) {
      throw RangeError.range(
          max, 1, maxUint, 'max', 'max must be <= (1 << 32)');
    }

    final int rejectionLimit = maxUint - (maxUint % max);

    int v = rejectionLimit;
    while (v >= rejectionLimit) {
      v = _crypto.randomBytes(4).readUInt32LE(0);
    }
    return v % max;
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
