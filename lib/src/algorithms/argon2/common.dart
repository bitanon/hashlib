// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/random.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';

const int _slices = 4;
const int _minParallelism = 1;
const int _maxParallelism = 0x7FFF;
const int _minDigestSize = 4;
const int _maxDigestSize = 0x3FFFFFF;
const int _minIterations = 1;
const int _maxIterations = 0x3FFFFFF;
const int _maxMemory = 0x3FFFFFF;
const int _minSaltSize = 8;
const int _maxSaltSize = 0x3FFFFFF;
const int _minKeySize = 1;
const int _maxKeySize = 0x3FFFFFF;
const int _minAD = 1;
const int _maxAD = 0x3FFFFFF;
const int _defaultHashLength = 32;

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

extension Argon2VersionValue on Argon2Version {
  /// The integer value for the version
  int get value {
    switch (this) {
      case Argon2Version.v10:
        return 0x10;
      case Argon2Version.v13:
        return 0x13;
      default:
        throw ArgumentError('Invalid version');
    }
  }
}

class Argon2HashDigest extends HashDigest {
  final Argon2Context ctx;

  const Argon2HashDigest(this.ctx, Uint8List bytes) : super(bytes);

  @override
  String toString() => encoded();

  /// Gets the PHC-compliant string for this [Argon2HashDigest]
  String encoded() => toCrypt(
        CryptDataBuilder(ctx.type.toString().split('.').last)
            .version('${ctx.version.value}')
            .param('m', ctx.memorySizeKB)
            .param('t', ctx.passes)
            .param('p', ctx.lanes)
            .saltBytes(ctx.salt)
            .hashBytes(bytes)
            .build(),
      );
}

/// The configuration used by the [Argon2] algorithm
class Argon2Context {
  /// Argon2 Hash Type
  final Argon2Type type;

  /// The current version is 0x13 (decimal: 19)
  final Argon2Version version;

  /// Degree of parallelism (i.e. number of threads)
  final int lanes;

  /// Desired number of returned bytes
  final int hashLength;

  /// Amount of memory (in kibibytes) to use
  final int memorySizeKB;

  /// Number of iterations to perform
  final int passes;

  /// Salt (16 bytes recommended for password hashing)
  final List<int> salt;

  /// Optional key
  final List<int>? key;

  /// Optional arbitrary additional data
  final List<int>? personalization;

  /// Number of slices per column
  final int slices;

  /// The start index of the second half of the slices
  final int midSlice;

  /// Number of segments per lane
  final int segments;

  /// Total number of columns per lane
  final int columns;

  /// Total number of memory blocks (1024 bytes each)
  final int blocks;

  const Argon2Context._({
    required this.salt,
    required this.version,
    required this.type,
    required this.hashLength,
    required this.passes,
    required this.lanes,
    required this.memorySizeKB,
    required this.slices,
    required this.segments,
    required this.columns,
    required this.blocks,
    required this.key,
    required this.personalization,
  }) : midSlice = slices ~/ 2;

  /// Creates a context for Argon2 password hashing
  ///
  /// Required Parameters:
  /// - [iterations] Number of iterations to perform.
  /// - [parallelism] Degree of parallelism (i.e. number of threads).
  /// - [memorySizeKB] Amount of memory (in kibibytes) to use.
  ///
  /// Optional Parameters:
  /// - [salt] Salt (16 bytes recommended for password hashing). If absent, a
  ///   64 bytes random salt is generated.
  /// - [hashLength] Desired number of returned bytes. Default: 32.
  /// - [key] Additional key.
  /// - [personalization] Arbitrary additional data.
  /// - [version] Algorithm version; Default: [Argon2Version.v13],
  /// - [type] Argon2 type; Default: [Argon2Type.argon2id].
  factory Argon2Context({
    required int iterations,
    required int parallelism,
    required int memorySizeKB,
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
    int? hashLength,
    Argon2Version version = Argon2Version.v13,
    Argon2Type type = Argon2Type.argon2id,
  }) {
    hashLength ??= _defaultHashLength;
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
    if (memorySizeKB < (parallelism << 3)) {
      throw ArgumentError('The memory size must be at least 8 * parallelism');
    }
    if (memorySizeKB > _maxMemory) {
      throw ArgumentError('The memorySizeKB must be at most $_maxMemory');
    }
    salt ??= randomBytes(64);
    if (salt.length < _minSaltSize) {
      throw ArgumentError('The salt must be at least $_minSaltSize bytes long');
    }
    if (salt.length > _maxSaltSize) {
      throw ArgumentError('The salt must be at most $_maxSaltSize bytes long');
    }
    if (key != null && key.isNotEmpty) {
      if (key.length < _minKeySize) {
        throw ArgumentError('The key must be at least $_minKeySize bytes long');
      }
      if (key.length > _maxKeySize) {
        throw ArgumentError('The key must be at most $_maxKeySize bytes long');
      }
    }
    if (personalization != null && personalization.isNotEmpty) {
      if (personalization.length < _minAD) {
        throw ArgumentError('The extra data must be at least $_minAD bytes');
      }
      if (personalization.length > _maxAD) {
        throw ArgumentError('The extra data must be at most $_maxAD');
      }
    }

    int segments = memorySizeKB ~/ (_slices * parallelism);
    int columns = _slices * segments;
    int blocks = parallelism * _slices * segments;

    return Argon2Context._(
      salt: salt,
      version: version,
      type: type,
      hashLength: hashLength,
      passes: iterations,
      slices: _slices,
      lanes: parallelism,
      memorySizeKB: memorySizeKB,
      columns: columns,
      segments: segments,
      blocks: blocks,
      key: key,
      personalization: personalization,
    );
  }
}
