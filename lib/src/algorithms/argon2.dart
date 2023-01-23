// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

import 'argon2_64bit.dart' if (dart.library.js) 'argon2_32bit.dart';

const int _minParallelism = 1;
const int _maxParallelism = 0xFFFFFF;
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
///   hashType: Argon2Type.argon2id,
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
class Argon2 {
  /// Argon2 Hash Type
  final Argon2Type hashType;

  /// The current version is 0x13 (decimal: 19)
  final Argon2Version version;

  /// Degree of parallelism (i.e. number of threads)
  final int parallelism;

  /// Desired number of returned bytes
  final int hashLength;

  /// Amount of memory (in kibibytes) to use
  final int memorySizeKB;

  /// Number of iterations to perform
  final int iterations;

  /// Salt (16 bytes recommended for password hashing)
  List<int> salt;

  /// Optional key
  List<int>? key;

  /// Optional arbitrary additional data
  List<int>? personalization;

  //     slice 0      slice 1      slice 2      slice 3
  //   ____/\____   ____/\____   ____/\____   ____/\____
  //  /          \ /          \ /          \ /          \
  // +------------+------------+------------+------------+
  // | segment 0  | segment 1  | segment 2  | segment 3  | -> lane 0
  // +------------+------------+------------+-----------+
  // | segment 4  | segment 5  | segment 6  | segment 7  | -> lane 1
  // +------------+------------+------------+------------+
  // | segment 8  | segment 9  | segment 10 | segment 11 | -> lane 2
  // +------------+------------+------------+------------+
  // |           ...          ...          ...           | ...
  // +------------+------------+------------+------------+
  // |            |            |            |            | -> lane p - 1
  // +------------+------------+------------+------------+

  /// Number of slices per column
  final int slices = 4;
  final int midSlice = 2;

  /// Number of passes (= iterations)
  late final passes = iterations;

  /// Number of lanes (= parallelism)
  late final lanes = parallelism;

  /// Number of segments per lane
  late final segments = memorySizeKB ~/ (slices * parallelism);

  /// Total number of columns per lane
  late final columns = slices * segments;

  /// Total number of memory blocks (1024 bytes each)
  late final blocks = lanes * slices * segments;

  /// The Argon2 instance for encoding or verifying password hash
  late final Argon2Hash instance;

  Argon2({
    required this.salt,
    this.version = Argon2Version.v13,
    this.hashType = Argon2Type.argon2id,
    required this.hashLength,
    required this.iterations,
    required this.parallelism,
    required this.memorySizeKB,
    this.key,
    this.personalization,
  }) {
    _validate();
    instance = Argon2Hash(this);
  }

  factory Argon2.fromEncoded(String encodedHash) {
    var data = encodedHash.split('\$');
    if (data.length < 6) {
      throw ArgumentError('Invalid Argon2 encoded hash');
    }

    Argon2Type type = Argon2Type.values.firstWhere((e) => e.name == data[1]);

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
      hashType: type,
      version: version,
      iterations: t,
      parallelism: p,
      memorySizeKB: m,
      salt: fromBase64(data[4]),
      hashLength: (data[5].length * 6) ~/ 8,
    );
  }

  /// Generates password hash using Argon2 algorithm
  Argon2HashDigest convert(List<int> password) => instance.convert(password);

  /// Generate Argon2 encoded string for a password
  String encode(List<int> password) => instance.convert(password).encoded();

  /// Checks validity of the parameters of this context
  void _validate() {
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

/// Use the Argon2Context to obtain an instance of this type.
abstract class Argon2HashBase {
  final Argon2 ctx;
  const Argon2HashBase(this.ctx);

  /// Encodes a password using Argon2 algorithm
  Argon2HashDigest convert(List<int> password);
}

class Argon2HashDigest extends HashDigest {
  final Argon2 ctx;
  Argon2HashDigest(this.ctx, Uint8List bytes) : super(bytes);

  @override
  String toString() => encoded();

  /// Gets the encoded Argon2 string
  String encoded() {
    return "\$${ctx.hashType.name}"
        "\$v=${ctx.version.value}"
        "\$m=${ctx.memorySizeKB}"
        ",t=${ctx.iterations}"
        ",p=${ctx.parallelism}"
        "\$${toBase64(ctx.salt)}"
        "\$${toBase64(bytes)}";
  }
}

class Argon2Security {
  final String name;

  /// The amount of memory to use in KB. The more the better, but slower.
  final int m;

  /// Number of threads or lanes to use. The more the better, but slower.
  final int p;

  /// Number of iterations. The more the better, but slower.
  final int t;

  const Argon2Security(
    this.name, {
    required this.m,
    required this.p,
    required this.t,
  });

  /// Provides a very low security. Use it for test purposes.
  ///
  /// It uses 32KB of RAM, 4 lanes, and 3 iterations.
  ///
  /// **WARNING: Not recommended for general use.**
  static const test = Argon2Security('test', m: 32, p: 4, t: 3);

  /// Provides low security but faster. Suitable for low-end devices.
  ///
  /// It uses 1MB of RAM, 4 lanes, and 2 iterations.
  static const small = Argon2Security('small', m: (1 << 10), p: 4, t: 2);

  /// Provides moderate security. Suitable for modern mobile devices.
  ///
  /// It uses 8MB of RAM, 4 lanes, and 2 iterations.
  /// This is 10x slower than the [small] one.
  static const moderate = Argon2Security('moderate', m: 1 << 13, p: 4, t: 2);

  /// Provides good security. Second recommended option by [RFC-9106][rfc].
  ///
  /// It uses 64MB of RAM, 4 lanes, and 3 iterations.
  /// This is 10x slower than the [moderate] one.
  ///
  /// [rfc]: https://rfc-editor.org/rfc/rfc9106.html
  static const good = Argon2Security('good', m: 1 << 16, p: 4, t: 3);

  /// Provides strong security. First recommended option by [RFC-9106][rfc].
  ///
  /// It uses 2GB of RAM, 4 threads, and 1 iteration.
  /// This is 10x slower than the [good] one.
  ///
  /// [rfc]: https://rfc-editor.org/rfc/rfc9106.html
  static const strong = Argon2Security('strong', m: 1 << 21, p: 4, t: 1);
}
