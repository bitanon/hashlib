// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/xxhash64.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// An instance of [XXHash64] with seed = 0
const XXHash64 xxh64 = XXHash64(0);

/// This is an implementation of 64-bit Hash algorithm from xxHash family that
/// is derived from https://github.com/Cyan4973/xxHash
///
/// It has been tested with [Austin Appleby's excellent SMHasher][smhasher]
/// test suite, and passes all tests, ensuring reasonable quality levels.
/// A more details collision-ratio comparison can be found in [the wiki][wiki].
///
/// [smhasher]: https://github.com/aappleby/smhasher
/// [wiki]: https://github.com/Cyan4973/xxHash/wiki/Collision-ratio-comparison
class XXHash64 extends BlockHashBase {
  final int seed;

  const XXHash64([this.seed = 0]);

  @override
  BlockHashSink createSink() => XXHash64Sink(seed);

  /// Get and instance of [XXHash64] with an specific seed
  XXHash64 withSeed(int seed) => XXHash64(seed);
}

/// Gets the xxHash-64 remainder value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int xxh64code(String input, [Encoding? encoding]) {
  return xxh64.string(input, encoding).remainder();
}

/// Extension to [String] to generate [xxh64] code
extension XXHash64StringExtension on String {
  /// Gets the xxHash-64 remainder value of a String
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  int xxh64code([Encoding? encoding]) {
    return xxh64.string(this, encoding).remainder();
  }
}
