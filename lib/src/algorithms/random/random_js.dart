// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:js' show context;
import 'dart:math' show Random;

const int _mask32 = 0xFFFFFFFF;

int _seedCounter = context.hashCode;

@pragma('vm:prefer-inline')
Random secureRandom() => Random($generateSeed());

int $generateSeed() {
  int code = DateTime.now().microsecondsSinceEpoch;
  code -= _seedCounter++;
  if (code.bitLength & 1 == 1) {
    code *= ~code;
  }
  code ^= ~_seedCounter << 5;
  _seedCounter += code & 7;
  return code & _mask32;
}
