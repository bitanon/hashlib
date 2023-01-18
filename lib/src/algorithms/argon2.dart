// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'argon2_64bit.dart';

const int _mask32 = 0xFFFFFFFF;

const int _minParallelism = 1;
const int _maxParallelism = _mask32 >>> 8;
const int _minDigestSize = 4;
const int _maxDigestSize = _mask32;
const int _minIterations = 1;
const int _maxIterations = _mask32;
const int _maxMemory = _mask32;
const int _minSalt = 8;

enum Argon2Type {
  argon2d,
  argon2i,
  argon2id,
}

enum Argon2Version {
  v10,
  v13,
}

class Argon2Context {
  /// Argon2 Hash Type
  final Argon2Type hashType;

  /// The current version is 0x13 (19 decimal)
  final Argon2Version version;

  /// Salt (16 bytes recommended for password hashing)
  final List<int> salt;

  /// Degree of parallelism (i.e. number of threads)
  final int parallelism;

  /// Desired number of returned bytes
  final int hashLength;

  /// Amount of memory (in kibibytes) to use
  final int memorySizeKB;

  /// Number of iterations to perform
  final int iterations;

  /// Optional key
  final List<int>? key;

  /// Optional arbitrary extra data
  final List<int>? personalization;

  const Argon2Context({
    this.version = Argon2Version.v13,
    required this.hashType,
    required this.salt,
    required this.hashLength,
    required this.iterations,
    required this.parallelism,
    required this.memorySizeKB,
    this.key,
    this.personalization,
  });

  /// Gets a Argon2 instance for encoding or verifying password hash
  Argon2 toInstance() => Argon2(this);

  /// Check validity of the parameters of this context
  void validate() {
    if (hashLength < _minDigestSize) {
      throw ArgumentError('The tag length must be at least $_minDigestSize');
    }
    if (hashLength > _maxDigestSize) {
      throw ArgumentError('The tag length must be at most $_maxDigestSize');
    }
    if (parallelism < _minParallelism) {
      throw ArgumentError('The parallelism must be at least $_minParallelism');
    }
    if (parallelism > _maxParallelism) {
      throw ArgumentError('The parallelism must be at most $_maxParallelism');
    }
    if (iterations < _minIterations) {
      throw ArgumentError('The iterations must be at least $_minIterations');
    }
    if (iterations > _maxIterations) {
      throw ArgumentError('The iterations must be at most $_maxIterations');
    }
    if (memorySizeKB < 8 * parallelism) {
      throw ArgumentError('The memory size must be at least 8 * parallelism');
    }
    if (memorySizeKB > _maxMemory) {
      throw ArgumentError('The memorySizeKB must be at most $_maxMemory');
    }
    if (salt.length < _minSalt) {
      throw ArgumentError('The salt must be at least $_minSalt bytes long');
    }
  }
}
