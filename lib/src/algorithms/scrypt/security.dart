// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

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

  @override
  String toString() => "ScryptSecurity($name):{N=$N,r=$r,p=$p}";

  /// Provides a very low security. Use it only for test purposes.
  ///
  /// It uses 16 lanes, 2 blocks per lane and 1 iteration.
  ///
  /// **WARNING: Not recommended for general use.**
  static const test = ScryptSecurity('test', N: 1 << 4, r: 2, p: 1);

  /// Provides low security. Can be used on low-end devices.
  ///
  /// It uses 256 lanes, 4 blocks per lane and 2 iterations.
  ///
  /// **WARNING: Not recommended for general use.**
  static const little = ScryptSecurity('little', N: 1 << 8, r: 4, p: 2);

  /// Provides moderate security.
  ///
  /// It uses 1,024 lanes, 8 blocks per lane and 2 iterations.
  static const moderate = ScryptSecurity('moderate', N: 1 << 10, r: 8, p: 2);

  /// Provides good security. The default parameters from [RFC-7914][rfc]
  ///
  /// It uses 16,384 lanes, 8 blocks per lane and 1 iteration.
  ///
  /// [rfc]: https://www.ietf.org/rfc/rfc7914.html
  static const good = ScryptSecurity('good', N: 1 << 14, r: 8, p: 1);

  /// Provides strong security.
  ///
  /// It uses 65,536 lanes, 16 blocks per lane and 2 iterations.
  static const strong = ScryptSecurity('strong', N: 1 << 16, r: 16, p: 2);
}
