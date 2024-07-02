// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hashlib_random.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/random.dart';

class HashlibSalt extends HashDigest {
  const HashlibSalt._(Uint8List bytes) : super(bytes);

  factory HashlibSalt(int size, [HashlibRandom? generator]) {
    generator ??= HashlibRandom();
    var bytes = Uint8List(size);
    generator.fill(bytes.buffer);
    return HashlibSalt._(bytes);
  }

  /// Generate a salt from the system random generator
  factory HashlibSalt.system(int size, [int? seed]) => HashlibSalt(
        size,
        HashlibRandom(
          seed: seed,
          generator: RandomGenerator.system,
        ),
      );

  /// Generate a salt from the keccak random generator
  factory HashlibSalt.keccak(int size, [int? seed]) => HashlibSalt(
        size,
        HashlibRandom(
          seed: seed,
          generator: RandomGenerator.keccak,
        ),
      );
}
