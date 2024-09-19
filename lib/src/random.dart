// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'random/generators.dart';
import 'random/random.dart';

export 'random/generators.dart' show RNG;
export 'random/random.dart' show HashlibRandom;

/// Generate a list of random 8-bit numbers of size [length]
@pragma('vm:prefer-inline')
Uint8List randomBytes(
  int length, {
  RNG generator = RNG.secure,
}) =>
    HashlibRandom(generator).nextBytes(length);

/// Generate a list of random 32-bit numbers of size [length]
@pragma('vm:prefer-inline')
Uint32List randomNumbers(
  int length, {
  RNG generator = RNG.secure,
}) =>
    HashlibRandom(generator).nextNumbers(length);

/// Fills the [buffer] with random numbers.
///
/// Both the [start] and [length] are in bytes.
@pragma('vm:prefer-inline')
void fillRandom(
  ByteBuffer buffer, {
  int start = 0,
  int? length,
  RNG generator = RNG.secure,
}) =>
    HashlibRandom(generator).fill(buffer, start, length);

/// Fills the [list] with random 32-bit numbers.
///
/// Both the [start] and [length] are in bytes.
void fillNumbers(
  List<int> list, {
  int start = 0,
  int? length,
  RNG generator = RNG.secure,
}) {
  int n = length ?? list.length;
  if (n == 0) return;
  var rand = HashlibRandom(generator);
  for (; n > 0 && start < list.length; ++start, --n) {
    list[start] = rand.nextInt();
  }
}

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
  RNG generator = RNG.secure,
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
