// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show Random;

const int _mask32 = 0xFFFFFFFF;

final secure = Random.secure();

@pragma('vm:prefer-inline')
Random secureRandom() => secure;

@pragma('vm:prefer-inline')
int $generateSeed() =>
    (DateTime.now().microsecondsSinceEpoch & _mask32) ^ secure.nextInt(_mask32);
