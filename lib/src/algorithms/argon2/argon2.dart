// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show min;

import 'package:hashlib/src/core/kdf_base.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';

import 'argon2_64bit.dart' if (dart.library.js) 'argon2_32bit.dart';
import 'common.dart';

export 'common.dart';

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
class Argon2 extends KeyDerivatorBase {
  final Argon2Context _ctx;

  /// Argon2 Hash Type
  Argon2Type get type => _ctx.type;

  /// The current version is 0x13 (decimal: 19)
  Argon2Version get version => _ctx.version;

  /// Degree of parallelism (i.e. number of threads)
  int get parallelism => _ctx.lanes;

  /// Desired number of returned bytes
  int get hashLength => _ctx.hashLength;

  /// Amount of memory (in kibibytes) to use
  int get memorySizeKB => _ctx.memorySizeKB;

  /// Number of iterations to perform
  int get iterations => _ctx.passes;

  /// Salt (16 bytes recommended for password hashing)
  List<int> get salt => _ctx.salt;

  /// Optional key
  List<int>? get key => _ctx.key;

  /// Optional arbitrary additional data
  List<int>? get personalization => _ctx.personalization;

  @override
  int get derivedKeyLength => hashLength;

  /// Generate a derived key from a [password] using Argon2 algorithm
  @override
  Argon2HashDigest convert(List<int> password) {
    final result = Argon2Internal(_ctx).convert(password);
    return Argon2HashDigest(_ctx, result);
  }

  /// Generate an Argon2 encoded string from a [password]
  String encode(List<int> password) => convert(password).encoded();

  const Argon2._(this._ctx);

  factory Argon2({
    Argon2Type type = Argon2Type.argon2id,
    Argon2Version version = Argon2Version.v13,
    required int parallelism,
    required int hashLength,
    required int memorySizeKB,
    required int iterations,
    required List<int> salt,
    List<int>? key,
    List<int>? personalization,
  }) {
    var ctx = Argon2Context(
      salt: salt,
      version: version,
      type: type,
      hashLength: hashLength,
      iterations: iterations,
      parallelism: parallelism,
      memorySizeKB: memorySizeKB,
      key: key,
      personalization: personalization,
    );
    return Argon2._(ctx);
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
      hashLength: (data[5].length * 6) >>> 3,
      key: key,
      personalization: personalization,
    );
  }
}

/// This contains some recommended values of memory, iteration and parallelism
/// values for [Argon2] algorithm.
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

  /// Find the Argon2 parameters that can be used to encode password in
  /// [desiredRuntime] time on the current device.
  ///
  /// This function may take up to `50 * desiredRuntime` time to compute.
  static Future<Argon2Security> optimize(
    Duration desiredRuntime, {
    int strictness = 10,
    int saltLength = 16,
    int hashLength = 32,
    int maxMemoryAsPowerOf2 = 22,
    Argon2Type type = Argon2Type.argon2i,
    Argon2Version version = Argon2Version.v13,
    bool verbose = false,
  }) async {
    if (strictness < 1) {
      throw ArgumentError('Strictness value must be at least 1');
    }
    if (maxMemoryAsPowerOf2 < 3) {
      throw ArgumentError('Max memory as power of 2 must be at least 3');
    }

    var watch = Stopwatch()..start();
    var salt = List.filled(saltLength, 1);
    var password = List.filled(saltLength << 2, 2);
    int target = desiredRuntime.inMicroseconds;

    // maximize memory
    int pow = 3, memory, lanes = 1, passes = 1;
    for (; pow <= maxMemoryAsPowerOf2; pow++) {
      memory = 1 << pow;
      lanes = min(16, memory >>> 3);
      var samples = List.generate(10, (_) {
        var f = Argon2(
          salt: salt,
          hashLength: hashLength,
          type: type,
          version: version,
          iterations: passes,
          parallelism: lanes,
          memorySizeKB: memory,
        );
        watch.reset();
        f.convert(password);
        return watch.elapsedMicroseconds;
      });
      int best = samples.fold(samples.first, min);
      if (verbose) {
        int delta = target - best;
        print("[Argon2Security] t=$passes,p=$lanes,m=$memory ~ $delta us");
      }
      if ((strictness * target / best).round() < strictness) {
        if (pow > 12) {
          pow -= 2;
        } else {
          pow--;
        }
        break;
      }
    }

    // found the maximum memory
    memory = 1 << pow;

    // now maximize the passes
    for (passes++;; passes++) {
      var samples = List.generate(10, (_) {
        var f = Argon2(
          salt: salt,
          hashLength: hashLength,
          type: type,
          version: version,
          iterations: passes,
          parallelism: lanes,
          memorySizeKB: memory,
        );
        watch.reset();
        f.convert(password);
        return watch.elapsedMicroseconds;
      });
      int best = samples.fold(samples.first, min);
      if (verbose) {
        int delta = target - best;
        print("[Argon2Security] t=$passes,p=$lanes,m=$memory ~ $delta us");
      }
      if ((strictness * target / best).round() < strictness) {
        passes--;
        break;
      }
    }
    if (passes == 1 && pow > 10) {
      pow++;
      memory = 1 << pow;
    }

    if (verbose) {
      print('[Argon2Security] ------------');
      print('[Argon2Security] t: $passes');
      print('[Argon2Security] p: $lanes');
      print('[Argon2Security] m: $memory (2^$pow)');
    }

    return Argon2Security('optimized', m: memory, t: passes, p: lanes);
  }
}
