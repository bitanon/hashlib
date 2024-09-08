// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'scrypt.dart';

/// This contains some recommended values of memory, iteration and parallelism
/// values for [Scrypt] algorithm.
///
/// It is best to try out different combinations of these values to achieve the
/// desired runtime on a target machine.
class ScryptSecurity {
  final String name;

  /// The size of a single block in bytes
  final int r;

  /// The CPU/Memory cost parameter as a power of 2. 1 < [N] < 2^32
  final int N;

  /// The parallelization parameter. [p] <= (2^32 - 1) / (128 * [r])
  final int p;

  const ScryptSecurity(
    this.name, {
    required this.N,
    required this.r,
    required this.p,
  });

  /// Provides a very low security. Use it only for test purposes.
  ///
  /// It uses cost of 16, block size of 2 and parallelism of 1.
  ///
  /// **WARNING: Not recommended for general use.**
  static const test = ScryptSecurity('test', N: 1 << 4, r: 2, p: 1);

  /// Provides low security. Can be used on low-end devices.
  ///
  /// It uses cost of 256, block size of 4 and parallelism of 2.
  ///
  /// **WARNING: Not recommended for general use.**
  static const little = ScryptSecurity('little', N: 1 << 8, r: 4, p: 2);

  /// Provides moderate security.
  ///
  /// It uses cost of 2^10, block size of 8 and parallelism of 3.
  static const moderate = ScryptSecurity('moderate', N: 1 << 10, r: 8, p: 3);

  /// Provides good security. The default parameters from [RFC-7914][rfc]
  ///
  /// It uses cost of 2^14, block size of 8 and parallelism of 1.
  ///
  /// [rfc]: https://www.ietf.org/rfc/rfc7914.html
  static const good = ScryptSecurity('good', N: 1 << 14, r: 8, p: 1);

  /// Provides strong security.
  ///
  /// It uses cost of 2^18, block size of 16 and parallelism of 2.
  static const strong = ScryptSecurity('strong', N: 1 << 18, r: 8, p: 2);

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// It uses cost of 2^17, block size of 8 and parallelism of 1.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp = ScryptSecurity('owasp1', N: 1 << 17, r: 8, p: 1);

  /// The second recommendation by [OWASP][link].
  ///
  /// It uses cost of 2^16, block size of 8 and parallelism of 2.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp2 = ScryptSecurity('owasp2', N: 1 << 16, r: 8, p: 2);

  /// The third recommendation by [OWASP][link].
  ///
  /// It uses cost of 2^15, block size of 8 and parallelism of 3.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp3 = ScryptSecurity('owasp3', N: 1 << 15, r: 8, p: 3);

  /// The fourth recommendation by [OWASP][link].
  ///
  /// It uses cost of 2^14, block size of 8 and parallelism of 5.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp4 = ScryptSecurity('owasp4', N: 1 << 14, r: 8, p: 5);

  /// The fifth recommendation by [OWASP][link].
  ///
  /// It uses cost of 2^13, block size of 8 and parallelism of 10.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp5 = ScryptSecurity('owasp5', N: 1 << 13, r: 8, p: 10);
}
