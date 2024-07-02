// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/algorithms/random_generators.dart';
export 'package:hashlib/src/algorithms/random_generators.dart'
    show RandomGenerator;

/// Provides a generator for secure random values
class HashlibRandom {
  final Iterator<int> _generator;

  /// Create a instance with custom generator
  const HashlibRandom.generator(this._generator);

  /// Creates an instance based on [generator] with optional [seed] value.
  factory HashlibRandom({
    int? seed,
    RandomGenerator generator = RandomGenerator.system,
  }) =>
      HashlibRandom.generator(generator.build(seed).iterator);

  /// Creates an instance based on [RandomGenerator.system].
  factory HashlibRandom.system([int? seed]) => HashlibRandom(
        seed: seed,
        generator: RandomGenerator.system,
      );

  /// Creates an instance based on [RandomGenerator.keccak].
  factory HashlibRandom.keccak([int? seed]) => HashlibRandom(
        seed: seed,
        generator: RandomGenerator.keccak,
      );

  /// Generates a 32-bit bit random  number
  @pragma('vm:prefer-inline')
  int nextInt() {
    _generator.moveNext();
    return _generator.current;
  }

  /// Generates a 8-bit bit random number
  @pragma('vm:prefer-inline')
  int nextByte() => nextInt() & 0xFF;

  /// Generates a 16-bit bit random  number
  @pragma('vm:prefer-inline')
  int nextWord() => nextInt() & 0xFFFF;

  /// Generates a boolean value
  @pragma('vm:prefer-inline')
  bool nextBool() => nextByte() & 0x55 == 0;

  /// Generates a double number
  @pragma('vm:prefer-inline')
  double nextDouble() => nextInt() / 0xFFFFFFFF;

  /// Generates a 32-bit bit random number between [low] and [high], inclusive.
  @pragma('vm:prefer-inline')
  int nextBetween(int low, int high) => (nextInt() % (high - low)) + low;

  /// Fill the buffer with random values.
  ///
  /// Paramters:
  /// - [offsetInBytes] the start offset in bytes for the fill operation.
  /// - [lengthInBytes] the total bytes to fill. If `null`, fills to the end.
  void fill(ByteBuffer buffer, [int offsetInBytes = 0, int? lengthInBytes]) {
    int i, n;
    i = offsetInBytes;
    n = lengthInBytes ?? buffer.lengthInBytes;
    if (n <= 0) return;
    var list8 = Uint8List.view(buffer);
    for (; n > 0 && i < list8.length && i & 3 != 0; i++, n--) {
      list8[i] = nextByte();
    }
    if (n <= 0) return;
    var list32 = Uint32List.view(buffer);
    for (i >>>= 2; n >= 4 && i < list32.length; i++, n -= 4) {
      list32[i] = nextInt();
    }
    if (n <= 0) return;
    for (i <<= 2; n > 0 && i < list8.length; i++, n--) {
      list8[i] = nextByte();
    }
  }

  /// Generate a list of random 8-bit bytes of size [length]
  @pragma('vm:prefer-inline')
  Uint8List nextBytes(int length) {
    var data = Uint8List(length);
    fill(data.buffer);
    return data;
  }

  /// Generate a list of random 32-bit numbers of size [length]
  @pragma('vm:prefer-inline')
  Uint32List nextNumbers(int length) {
    var data = Uint32List(length);
    fill(data.buffer);
    return data;
  }
}
