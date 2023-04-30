// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/argon2.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/kdf_base.dart';
import 'package:hashlib/src/core/utils.dart';

import 'argon2_64bit.dart' if (dart.library.js) 'argon2_32bit.dart';

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
/// Argon2 is a key derivation algorithm that was selected as the winner of the
/// 2015 [Password Hashing Contest][phc], and the best password hashing / key
/// derivation algorithm known to date.
///
/// Example of password hashing using Argon2:
///
/// ```dart
/// final argon2 = Argon2(
///   version: Argon2Version.v13,
///   type: Argon2Type.argon2id,
///   hashLength: 32,
///   iterations: 2,
///   parallelism: 8,
///   memorySizeKB: 1 << 18,
///   salt: "some salt".codeUnits,
/// );
///
/// final digest = argon2.encode('password'.codeUnits);
/// ```
///
/// [phc]: https://www.password-hashing.net/
/// [wiki]: https://en.wikipedia.org/wiki/Argon2
abstract class Argon2 extends KeyDerivatorBase {
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
  List<int> salt;

  /// Optional key
  List<int>? key;

  /// Optional arbitrary additional data
  List<int>? personalization;

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

  @override
  int get derivedKeyLength => hashLength;

  Argon2.internal({
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
  }) : midSlice = slices ~/ 2 {
    if (hashLength < _minDigestSize) {
      throw ArgumentError('The tag length must be at least $_minDigestSize');
    }
    if (hashLength > _maxDigestSize) {
      throw ArgumentError('The tag length must be at most $_maxDigestSize');
    }
    if (lanes < _minParallelism) {
      throw ArgumentError('The parallelism must be at least $_minParallelism');
    }
    if (lanes > _maxParallelism) {
      throw ArgumentError('The parallelism must be at most $_maxParallelism');
    }
    if (passes < _minIterations) {
      throw ArgumentError('The iterations must be at least $_minIterations');
    }
    if (passes > _maxIterations) {
      throw ArgumentError('The iterations must be at most $_maxIterations');
    }
    if (memorySizeKB < 8 * lanes) {
      throw ArgumentError('The memory size must be at least 8 * parallelism');
    }
    if (memorySizeKB > _maxMemory) {
      throw ArgumentError('The memorySizeKB must be at most $_maxMemory');
    }
    if (salt.length < _minSaltSize) {
      throw ArgumentError('The salt must be at least $_minSaltSize bytes long');
    }
    if (salt.length > _maxSaltSize) {
      throw ArgumentError('The salt must be at most $_maxSaltSize bytes long');
    }
    if (key != null && key!.isNotEmpty) {
      if (key!.length < _minKeySize) {
        throw ArgumentError('The key must be at least $_minKeySize bytes long');
      }
      if (key!.length > _maxKeySize) {
        throw ArgumentError('The key must be at most $_maxKeySize bytes long');
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

  factory Argon2({
    required List<int> salt,
    required int hashLength,
    required int iterations,
    required int parallelism,
    required int memorySizeKB,
    List<int>? key,
    List<int>? personalization,
    Argon2Version version = Argon2Version.v13,
    Argon2Type type = Argon2Type.argon2id,
  }) {
    int segments = memorySizeKB ~/ (_slices * parallelism);
    int columns = _slices * segments;
    int blocks = parallelism * _slices * segments;
    return Argon2Internal(
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

  /// Creates an [Argon2] instance from [Argon2Security] parameter.
  factory Argon2.fromSecurity(
    Argon2Security security, {
    required List<int> salt,
    int hashLength = 32,
    List<int>? key,
    List<int>? personalization,
    Argon2Version version = Argon2Version.v13,
    Argon2Type type = Argon2Type.argon2id,
  }) {
    return Argon2(
      salt: salt,
      version: version,
      type: type,
      hashLength: hashLength,
      iterations: security.t,
      parallelism: security.p,
      memorySizeKB: security.m,
      key: key,
      personalization: personalization,
    );
  }

  /// Creates an [Argon2] instance from an [encoded].
  ///
  /// The encoded hash may look like this:
  /// `$argon2i$v=19$m=16,t=2,p=1$c29tZSBzYWx0$u1eU6mZFG4/OOoTdAtM5SQ`
  factory Argon2.fromEncoded(
    String encoded, {
    List<int>? key,
    List<int>? personalization,
  }) {
    var data = encoded.split('\$');
    if (data.length < 6) {
      throw ArgumentError('Invalid Argon2 encoded hash');
    }

    Argon2Type type =
        Argon2Type.values.firstWhere((e) => "$e".split('.').last == data[1]);

    Argon2Version version =
        Argon2Version.values.firstWhere((e) => 'v=${e.value}' == data[2]);

    var params = data[3].split(',');
    int? m, t, p;
    for (var param in params) {
      var pair = param.split('=');
      var key = pair[0];
      var value = pair[1];
      if (key == 'm') {
        m = int.parse(value);
      } else if (key == 't') {
        t = int.parse(value);
      } else if (key == 'p') {
        p = int.parse(value);
      } else {
        throw ArgumentError('Invalid parameter: $key');
      }
    }
    if (m == null) {
      throw ArgumentError('Missing parameter: m');
    }
    if (t == null) {
      throw ArgumentError('Missing parameter: t');
    }
    if (p == null) {
      throw ArgumentError('Missing parameter: p');
    }

    return Argon2(
      type: type,
      version: version,
      iterations: t,
      parallelism: p,
      memorySizeKB: m,
      salt: fromBase64(data[4]),
      hashLength: (data[5].length * 6) ~/ 8,
      key: key,
      personalization: personalization,
    );
  }

  /// Generate a derived key from a [password] using Argon2 algorithm
  @override
  Argon2HashDigest convert(List<int> password);

  /// Generate an Argon2 encoded string from a [password]
  String encode(List<int> password) => convert(password).encoded();
}

/// Verifies if the original [password] was derived from the [encoded]
/// Argon2 hash.
///
/// The encoded hash may look like this:
/// `$argon2i$v=19$m=16,t=2,p=1$c29tZSBzYWx0$u1eU6mZFG4/OOoTdAtM5SQ`
bool argon2verify(String encoded, List<int> password) {
  var instance = Argon2.fromEncoded(encoded);
  var key = fromBase64(encoded.split('\$').last);
  return instance.verify(key, password);
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
  final Argon2 ctx;
  Argon2HashDigest(this.ctx, Uint8List bytes) : super(bytes);

  @override
  String toString() => encoded();

  /// Gets the encoded Argon2 string
  String encoded() {
    return "\$${ctx.type.toString().split('.').last}"
        "\$v=${ctx.version.value}"
        "\$m=${ctx.memorySizeKB}"
        ",t=${ctx.passes}"
        ",p=${ctx.lanes}"
        "\$${toBase64(ctx.salt)}"
        "\$${toBase64(bytes)}";
  }
}
