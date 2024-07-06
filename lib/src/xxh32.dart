// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/xxh32/xxh32.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// An instance of [XXHash32] with seed = 0
const XXHash32 xxh32 = XXHash32(0);

/// XXHash32 is a fast and efficient non-cryptographic hash function for
/// 32-bit platforms. It is designed for producing a quick and reliable hash
/// value for a given data, which can be used for many applications, such as
/// checksum, data validation, etc. In addition, it has a good distribution of
/// hash values, which helps to reduce [collisions][wiki].
///
/// This implementation was derived from https://github.com/Cyan4973/xxHash
///
/// [wiki]: https://github.com/Cyan4973/xxHash/wiki/Collision-ratio-comparison
///
/// **WARNING: It should not be used for cryptographic purposes.**
class XXHash32 extends BlockHashBase {
  final int seed;

  /// Creates a new instance of [XXHash32].
  ///
  /// Parameters:
  /// - [seed] is an optional 32-bit integer. Default: 0
  const XXHash32([this.seed = 0]);

  @override
  final String name = 'XXH32';

  @override
  XXHash32Sink createSink() => XXHash32Sink(seed);

  /// Get and instance of [XXHash32] with an specific seed
  XXHash32 withSeed(int seed) => XXHash32(seed);
}

/// Gets the 32-bit xxHash value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int xxh32code(String input, [Encoding? encoding]) {
  return xxh32.string(input, encoding).number();
}
