// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/xxh3_64.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// An instance of [XXH3] with seed = 0
const XXH3 xxh3 = XXH3(seed: 0);

/// This is an implementation of 64-bit XXH3 hash algorithm of xxHash family
/// derived from https://github.com/Cyan4973/xxHash
///
/// XXH3 is a new high-performance variant XXHash algorithm that is designed to
/// be fast, with a low memory footprint, and to produce high-quality hash
/// values with good distribution and [low collision rates][wiki].
///
/// One of the main improvements in XXH3 compared to XXHash is its use of a
/// new mixing function that provides better mixing of the input data and
/// results in improved distribution of the resulting hash values.
///
/// [wiki]: https://github.com/Cyan4973/xxHash/wiki/Collision-ratio-comparison
///
/// **WARNING: It should not be used for cryptographic purposes.**
class XXH3 extends BlockHashBase {
  final int seed;
  final List<int>? secret;

  const XXH3({this.seed = 0, this.secret});

  /// Get and instance of [xxh3] with an specific seed
  factory XXH3.withSeed(int seed) => XXH3(seed: seed);

  /// Get and instance of [xxh3] with a secret
  factory XXH3.withSecret(List<int> secret) => XXH3(secret: secret);

  @override
  BlockHashSink createSink() => XX3Hash64bSink.withSeed(seed);
}

/// Gets the 64-bit XXH3 value of a String.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int xxh3code(String input, [Encoding? encoding]) {
  return xxh3.string(input, encoding).remainder();
}

/// Extension to [String] to generate [xxh3] code
extension XXH3StringExtension on String {
  /// Gets the 64-bit XXH3 value of a String.
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  int xxh3code([Encoding? encoding]) {
    return xxh3.string(this, encoding).remainder();
  }
}
