// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/src/algorithms/argon2.dart';

export 'package:hashlib/src/algorithms/argon2.dart'
    show Argon2, Argon2Type, Argon2Version, argon2verify;

const _defaultHashLength = 24;
const _defaultSecurity = Argon2Security.moderate;

/// Encode a password using default Argon2d algorithm
///
/// Parameters:
/// - [password] is the raw password to be encoded
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [security] is the parameter choice for the algorithm.
/// - [hashLength] is the number of output bytes
/// - [key] is an optional key bytes to use
/// - [personalization] is optional additional data bytes
Argon2HashDigest argon2d(
  List<int> password,
  List<int> salt, {
  Argon2Security security = _defaultSecurity,
  int hashLength = _defaultHashLength,
  List<int>? key,
  List<int>? personalization,
}) {
  return Argon2(
    salt: salt,
    type: Argon2Type.argon2d,
    hashLength: hashLength,
    iterations: security.t,
    parallelism: security.p,
    memorySizeKB: security.m,
    key: key,
    personalization: personalization,
  ).convert(password);
}

/// Encode a password using default Argon2i algorithm
///
/// Parameters:
/// - [password] is the raw password to be encoded
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [security] is the parameter choice for the algorithm.
/// - [hashLength] is the number of output bytes
/// - [key] is an optional key bytes to use
/// - [personalization] is optional additional data bytes
///
///
Argon2HashDigest argon2i(
  List<int> password,
  List<int> salt, {
  Argon2Security security = _defaultSecurity,
  int hashLength = _defaultHashLength,
  List<int>? key,
  List<int>? personalization,
}) {
  return Argon2(
    salt: salt,
    type: Argon2Type.argon2i,
    hashLength: hashLength,
    iterations: security.t,
    parallelism: security.p,
    memorySizeKB: security.m,
    key: key,
    personalization: personalization,
  ).convert(password);
}

/// Encode a password using default Argon2id algorithm
///
/// Parameters:
/// - [password] is the raw password to be encoded
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [security] is the parameter choice for the algorithm.
/// - [hashLength] is the number of output bytes
/// - [key] is an optional key bytes to use
/// - [personalization] is optional additional data bytes
Argon2HashDigest argon2id(
  List<int> password,
  List<int> salt, {
  Argon2Security security = _defaultSecurity,
  int hashLength = _defaultHashLength,
  List<int>? key,
  List<int>? personalization,
}) {
  return Argon2(
    salt: salt,
    type: Argon2Type.argon2id,
    hashLength: hashLength,
    iterations: security.t,
    parallelism: security.p,
    memorySizeKB: security.m,
    key: key,
    personalization: personalization,
  ).convert(password);
}

/// This contains some recommended values of memory, iteration and parallelism
/// values for Argon2 algorithm.
///
/// It is best to try out different combinations of these values to achieve the
/// desired runtime on a target machine. You can use the [optimize] method for
/// tuning out the parameters.
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

  @override
  String toString() => "Argon2Security($name):{m=$m,p=$p,t=$t}";

  /// Provides a very low security. Use it for test purposes.
  ///
  /// It uses 32KB of RAM, 2 lanes, and 2 iterations.
  ///
  /// **WARNING: Not recommended for general use.**
  static const test = Argon2Security('test', m: 1 << 5, p: 4, t: 3);

  /// Provides low security but faster. Suitable for low-end devices.
  ///
  /// It uses 1MB of RAM, 8 lanes, and 2 iterations.
  static const little = Argon2Security('little', m: 1 << 10, p: 8, t: 2);

  /// Provides moderate security. Suitable for modern mobile devices.
  ///
  /// It uses 8MB of RAM, 4 lanes, and 3 iterations.
  /// This is 10x slower than the [little] one.
  static const moderate = Argon2Security('moderate', m: 1 << 13, p: 4, t: 2);

  /// Provides good security. Second recommended option by [RFC-9106][rfc].
  ///
  /// It uses 64MB of RAM, 4 lanes, and 3 iterations.
  /// This is 10x slower than the [moderate] one.
  ///
  /// [rfc]: https://www.ietf.org/rfc/rfc9106.html
  static const good = Argon2Security('good', m: 1 << 16, p: 4, t: 3);

  /// Provides strong security. First recommended option by [RFC-9106][rfc].
  ///
  /// It uses 2GB of RAM, 4 threads, and 1 iteration.
  /// This is 10x slower than the [good] one.
  ///
  /// [rfc]: https://www.ietf.org/rfc/rfc9106.html
  static const strong = Argon2Security('strong', m: 1 << 21, p: 4, t: 1);

  /// Get Argon2 parameters optimized for security on the current device. This
  /// function may take `50 * desiredRuntime` amount of time to compute.
  ///
  /// Here is the method used to compute these parameters:
  ///
  /// - Pick a [desiredRuntime] for optimization. Recommended is at least 1s.
  ///   Higher runtime means more safety against a brute-force attack.
  /// - More memory means more security. Give [m] a fixed value.
  /// - For parallelism [p], use any value between 8 to 1024. It does not affect
  ///   the runtime that much.
  /// - Now check how many passes [t] can be done within the [desiredRuntime].
  static Future<Argon2Security> optimize(
    Duration desiredRuntime, {
    int strictness = 100,
    int saltLength = 16,
    int hashLength = 32,
    int maxMemoryAsPowerOf2 = 22,
    Argon2Type type = Argon2Type.argon2i,
    Argon2Version version = Argon2Version.v13,
  }) async {
    if (strictness < 1) {
      throw ArgumentError('Strictness value must be at least 1');
    }
    if (maxMemoryAsPowerOf2 < 3) {
      throw ArgumentError('Max memory as power of 2 must be at least 3');
    }

    var salt = List.filled(saltLength, 1);
    var password = List.filled(4 * saltLength, 2);
    int target = desiredRuntime.inMicroseconds;

    // maximize memory
    int pow = 3, lanes = 1;
    for (; pow <= maxMemoryAsPowerOf2; pow++) {
      lanes = min(16, 1 << (pow - 3));
      var samples = await Future.wait(
        List.generate(10, (_) async {
          var watch = Stopwatch();
          var f = Argon2(
            salt: salt,
            hashLength: hashLength,
            type: type,
            version: version,
            iterations: 1,
            memorySizeKB: 1 << pow,
            parallelism: lanes,
          );
          watch.start();
          f.convert(password);
          return watch.elapsedMicroseconds;
        }),
      );
      int best = samples.fold(samples.first, min);
      int factor = (strictness * target / best).round();
      print("2^$pow ~ $best us | diff: ${target - best} us");
      if (factor < strictness) {
        pow--;
        break;
      }
    }

    // found the maximum memory
    int memory = 1 << pow;

    // now maximize the passes
    int passes = 2;
    for (;; passes++) {
      var samples = await Future.wait(
        List.generate(10, (_) async {
          var watch = Stopwatch();
          var f = Argon2(
            salt: salt,
            hashLength: hashLength,
            type: type,
            version: version,
            iterations: passes,
            parallelism: lanes,
            memorySizeKB: memory,
          );
          watch.start();
          f.convert(password);
          return watch.elapsedMicroseconds;
        }),
      );
      int best = samples.fold(samples.first, min);
      int factor = (strictness * target / best).round();
      print("$passes ~ $best us | diff: ${target - best} us");
      if (factor < strictness) {
        passes--;
        break;
      }
    }

    return Argon2Security('optimized', m: memory, t: passes, p: lanes);
  }
}
