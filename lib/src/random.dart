// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hashlib_random.dart';

export 'package:hashlib/src/core/hashlib_random.dart';

/// Generate a list of random 8-bit numbers of size [length]
@pragma('vm:prefer-inline')
Uint8List randomBytes(
  int length, {
  RandomGenerator generator = RandomGenerator.system,
}) =>
    HashlibRandom(generator).nextBytes(length);

/// Generate a list of random 32-bit numbers of size [length]
@pragma('vm:prefer-inline')
Uint32List randomNumbers(
  int length, {
  RandomGenerator generator = RandomGenerator.system,
}) =>
    HashlibRandom(generator).nextNumbers(length);

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
    HashlibRandom(generator).fill(buffer, start, length);

/// Generate a list of random ASCII string of size [length].
///
/// Check the [HashlibRandom.nextString] documentation for more details.
@pragma('vm:prefer-inline')
String randomString(
  int length, {
  bool? lower,
  bool? upper,
  bool? numeric,
  bool? controls,
  bool? punctuations,
  List<int>? whitelist,
  List<int>? blacklist,
  RandomGenerator generator = RandomGenerator.system,
}) =>
    HashlibRandom(generator).nextString(
      length,
      lower: lower,
      upper: upper,
      numeric: numeric,
      controls: controls,
      punctuations: punctuations,
      whitelist: whitelist,
      blacklist: blacklist,
    );
