// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:math' show Random;

const int _mask32 = 0xFFFFFFFF;

int _seedCounter = Zone.current.hashCode;

final _secure = Random($generateSeed());

/// Returns a secure random generator in JS runtime
Random secureRandom() => _secure;

/// Generates a random seed in JS runtime
int $generateSeed() {
  int code = DateTime.now().millisecondsSinceEpoch;
  code -= _seedCounter++;
  if (code.bitLength & 1 == 1) {
    code *= ~code;
  }
  code ^= ~_seedCounter << 5;
  _seedCounter += code & 7;
  return code & _mask32;
}
