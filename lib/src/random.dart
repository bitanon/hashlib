// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hashlib_random.dart';

export 'package:hashlib/src/core/hashlib_random.dart';
export 'package:hashlib/src/core/hashlib_salt.dart';

/// Generate a list of random 8-bit numbers of size [length]
@pragma('vm:prefer-inline')
Uint8List randomBytes(
  int length, [
  RandomGenerator generator = RandomGenerator.system,
]) =>
    HashlibRandom(generator: generator).nextBytes(length);

/// Generate a list of random 32-bit numbers of size [length]
@pragma('vm:prefer-inline')
Uint32List randomNumbers(
  int length, [
  RandomGenerator generator = RandomGenerator.system,
]) =>
    HashlibRandom(generator: generator).nextNumbers(length);

/// Fill the [buffer] with random numbers.
///
/// Both the [start] and [length] are in bytes.
@pragma('vm:prefer-inline')
void fillRandom(
  ByteBuffer buffer, {
  int start = 0,
  int? length,
  RandomGenerator generator = RandomGenerator.system,
}) =>
    HashlibRandom(generator: generator).fill(buffer, start, length);
