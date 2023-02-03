// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/xxhash32.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// An instance of [XXHash32] with seed = 0
const XXHash32 xxh32 = XXHash32(0);

/// This is an implementation of 32-bit Hash algorithm from xxHash family that
/// is derived from https://github.com/Cyan4973/xxHash
///
/// It has been tested with [Austin Appleby's excellent SMHasher][smhasher]
/// test suite, and passes all tests, ensuring reasonable quality levels.
/// A more details collision-ratio comparison can be found in [the wiki][wiki].
///
/// [smhasher]: https://github.com/aappleby/smhasher
/// [wiki]: https://github.com/Cyan4973/xxHash/wiki/Collision-ratio-comparison
class XXHash32 extends BlockHashBase {
  final int seed;

  const XXHash32([this.seed = 0]);

  @override
  BlockHashSink createSink() => XXHash32Sink(seed);

  /// Get and instance of [XXHash32] with an specific seed
  XXHash32 withSeed(int seed) => XXHash32(seed);
}

/// Gets the xxHash-32 remainder value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int xxh32code(String input, [Encoding? encoding]) {
  return xxh32.string(input, encoding).remainder();
}

/// Extension to [String] to generate [xxh32] code
extension XXHash32StringExtension on String {
  /// Gets the xxHash-32 remainder value of a String
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  int xxh32code([Encoding? encoding]) {
    return xxh32.string(this, encoding).remainder();
  }
}