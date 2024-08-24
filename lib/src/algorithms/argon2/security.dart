// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'argon2.dart';

/// This contains some recommended values of memory, iteration and parallelism
/// values for [Argon2] algorithm.
///
/// It is best to try out different combinations of these values to achieve the
/// desired runtime on a target machine.
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
