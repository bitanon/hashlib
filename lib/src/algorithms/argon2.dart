// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'argon2_64bit.dart' if (dart.library.js) 'argon2_32bit.dart';

const int _minParallelism = 1;
const int _maxParallelism = 0xFFFFFF;
const int _minDigestSize = 4;
const int _maxDigestSize = 0xFFFFFFFF;
const int _minIterations = 1;
const int _maxIterations = 0xFFFFFFFF;
const int _maxMemory = 0xFFFFFFFF;
const int _minSalt = 8;
const int _maxSalt = 0xFFFFFFFF;
const int _minKey = 1;
const int _maxKey = 0xFFFFFFFF;
const int _minAD = 1;
const int _maxAD = 0xFFFFFFFF;

enum Argon2Type {
  argon2d,
  argon2i,
  argon2id,
}

/// The Argon2 version
enum Argon2Version {
  v10,
  v13,
}

/// Creates a context for [Argon2][wiki] password hashing.
///
/// Argon2 is a key derivation function that was selected as the winner of the
/// 2015 [Password Hashing Contest][phc], and the best password hashing / key
/// derivation algorithm known to date.
///
/// Example of password hashing using Argon2:
///
/// ```dart
/// final argon2 = Argon2Context(
///   version: Argon2Version.v13,
///   hashType: Argon2Type.argon2id,
///   hashLength: 32,
///   iterations: 8,
///   parallelism: 4,
///   memorySizeKB: 8192,
///   salt: "some salt".codeUnits,
/// ).toInstance();
///
/// final digest = argon2.encode('password'.codeUnits);
/// ```
///
/// [phc]: https://www.password-hashing.net/
/// [wiki]: https://en.wikipedia.org/wiki/Argon2
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

  /// Optional arbitrary additional data
  final List<int>? personalization;

  const Argon2Context({
    required this.salt,
    this.version = Argon2Version.v13,
    this.hashType = Argon2Type.argon2id,
    this.hashLength = 32,
    this.iterations = 8,
    this.parallelism = 4,
    this.memorySizeKB = 32768,
    this.key,
    this.personalization,
  });

  /// Gets a Argon2 instance for encoding or verifying password hash
  Argon2 toInstance() => Argon2(this);

  /// Checks validity of the parameters of this context
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
    if (salt.length > _maxSalt) {
      throw ArgumentError('The salt must be at most $_maxSalt bytes long');
    }
    if (key != null && key!.isNotEmpty) {
      if (key!.length < _minKey) {
        throw ArgumentError('The key must be at least $_minKey bytes long');
      }
      if (key!.length > _maxKey) {
        throw ArgumentError('The key must be at most $_maxKey bytes long');
      }
    }
    if (personalization != null && personalization!.isNotEmpty) {
      if (personalization!.length < _minAD) {
        throw ArgumentError('The extra data must be at least $_minAD bytes');
      }
      if (personalization!.length > _maxAD) {
        throw ArgumentError('The extra data must be at most $_maxAD');
      }
    }
  }
}
