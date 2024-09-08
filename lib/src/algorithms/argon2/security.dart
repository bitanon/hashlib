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

  /// The type of the algorithm
  final Argon2Type type;

  /// The version of the algorithm
  final Argon2Version version;

  const Argon2Security(
    this.name, {
    required this.m,
    required this.p,
    required this.t,
    this.type = Argon2Type.argon2id,
    this.version = Argon2Version.v13,
  });

  /// Provides a very low security. Use it for test purposes.
  ///
  /// It uses 32KB of memory, 2 lanes, and 2 iterations.
  ///
  /// **WARNING: Not recommended for general use.**
  static const test = Argon2Security('test', m: 1 << 5, p: 4, t: 3);

  /// Provides low security but faster. Suitable for low-end devices.
  ///
  /// It uses 1MB of memory, 8 lanes, and 2 iterations.
  static const little = Argon2Security('little', m: 1 << 10, p: 8, t: 2);

  /// Provides moderate security. Suitable for modern mobile devices.
  ///
  /// It uses 8MB of memory, 4 lanes, and 3 iterations.
  /// This is 10x slower than the [little] one.
  static const moderate = Argon2Security('moderate', m: 1 << 13, p: 4, t: 2);

  /// Provides good security. Second recommended option by [RFC-9106][rfc].
  ///
  /// It uses 64MB of memory, 4 lanes, and 3 iterations.
  /// This is 10x slower than the [moderate] one.
  ///
  /// [rfc]: https://www.ietf.org/rfc/rfc9106.html
  static const good = Argon2Security('good', m: 1 << 16, p: 4, t: 3);

  /// Provides strong security. First recommended option by [RFC-9106][rfc].
  ///
  /// It uses 2GB of memory, 4 lanes, and 1 iteration.
  /// This is 10x slower than the [good] one.
  ///
  /// [rfc]: https://www.ietf.org/rfc/rfc9106.html
  static const strong = Argon2Security('strong', m: 1 << 21, p: 4, t: 1);

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// It uses 46MB of memory, 1 lane, and 1 iteration.
  ///
  /// **Do not use with Argon2i.**
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp = Argon2Security('owasp1', m: 47104, t: 1, p: 1);

  /// Second recommendation from [OWASP][link].
  ///
  /// It uses 19MB of memory, 1 lane, and 2 iterations.
  ///
  /// **Do not use with Argon2i.**
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp2 = Argon2Security('owasp2', m: 19456, t: 2, p: 1);

  /// Third recommendation from [OWASP][link].
  ///
  /// It uses 12MB of memory, 1 lane, and 3 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp3 = Argon2Security('owasp3', m: 12288, t: 3, p: 1);

  /// Fourth recommendation from [OWASP][link].
  ///
  /// It uses 9MB of memory, 1 lane, and 4 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp4 = Argon2Security('owasp4', m: 9216, t: 4, p: 1);

  /// Second recommendation from [OWASP][link].
  ///
  /// It uses 7MB of memory, 1 lane, and 5 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp5 = Argon2Security('owasp5', m: 7168, t: 5, p: 1);
}
