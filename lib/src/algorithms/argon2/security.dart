// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show min;

import 'argon2.dart';

/// This contains some recommended values of memory, iteration and parallelism
/// values for [Argon2] algorithm.
///
/// It is best to try out different combinations of these values to achieve the
/// desired runtime on a target machine. You can use the [tuneArgon2Security]
/// method for tuning out the best parameters.
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
}

/// Find the Argon2 parameters that can be used to encode password in
/// [desiredRuntime] time on the current device.
///
/// This function may take up to `50 * desiredRuntime` time to compute.
Future<Argon2Security> tuneArgon2Security(
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
