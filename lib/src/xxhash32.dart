// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/xxhash32.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// An instance of [XXHash32] with seed = 0
const XXHash32 xxh32 = XXHash32(0);

/// An instance of [XXHash32] with seed = [prime32_1]
const XXHash32 xxh32_1 = XXHash32(prime32_1);

/// An instance of [XXHash32] with seed = [prime32_2]
const XXHash32 xxh32_2 = XXHash32(prime32_2);

/// An instance of [XXHash32] with seed = [prime32_3]
const XXHash32 xxh32_3 = XXHash32(prime32_3);

/// An instance of [XXHash32] with seed = [prime32_4]
const XXHash32 xxh32_4 = XXHash32(prime32_4);

/// An instance of [XXHash32] with seed = [prime32_5]
const XXHash32 xxh32_5 = XXHash32(prime32_5);

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
