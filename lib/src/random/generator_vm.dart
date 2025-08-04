// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show Random;

const int _mask32 = 0xFFFFFFFF;

/// Returns a secure random generator
@pragma('vm:prefer-inline')
Random secureRandom() => Random.secure();

/// Generates a random seed
@pragma('vm:prefer-inline')
int $generateSeed() =>
    (DateTime.now().microsecondsSinceEpoch & _mask32) ^
    Random.secure().nextInt(_mask32);
