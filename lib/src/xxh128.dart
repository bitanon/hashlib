// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/xxh3_128.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// An instance of [XXH128] with seed = 0
const XXH128 xxh128 = XXH128(seed: 0);

/// An instance of [XXH128] with seed = 0
const XXH128 xxh3_128 = xxh128;

/// This is an implementation of 128-bit XXH3 hash algorithm of xxHash family
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
class XXH128 extends BlockHashBase {
  final int seed;
  final List<int>? secret;

  /// Creates a new instance of [XXH128].
  ///
  /// Parameters:
  /// - [seed] is an optional 64-bit integer. Default: 0
  /// - [secret] is an array of bytes. The length should be at least 136.
  /// - If the [secret] is present, the [seed] is ignored.
  const XXH128({this.seed = 0, this.secret});

  @override
  final String name = 'XXH128';

  /// Get and instance of [xxh128] with an specific seed
  factory XXH128.withSeed(int seed) => XXH128(seed: seed);

  /// Get and instance of [xxh128] with a secret
  factory XXH128.withSecret(List<int> secret) => XXH128(secret: secret);

  @override
  XXH3Sink128bit createSink() => secret == null
      ? XXH3Sink128bit.withSeed(seed)
      : XXH3Sink128bit.withSecret(secret);
}

/// Gets the 128-bit XXH3 hash of a String in hexadecimal.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
String xxh128sum(String input, [Encoding? encoding]) {
  return xxh128.string(input, encoding).hex();
}

/// Extension to [String] to generate [xxh128] code
extension XXH128StringExtension on String {
  /// Gets the 128-bit XXH3 hash of a String in hexadecimal.
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  @Deprecated('Use the public method instead.')
  String xxh128sum([Encoding? encoding]) {
    return xxh128.string(this, encoding).hex();
  }
}
