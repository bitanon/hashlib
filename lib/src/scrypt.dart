// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/scrypt.dart';
import 'package:hashlib/src/core/hash_digest.dart';

export 'package:hashlib/src/algorithms/scrypt.dart' show Scrypt;

/// Generate a secure password using the [scrypt][rfc] algorithm.
///
/// The scrypt algorithm is a modern password-based key derivation function
/// that is designed to be highly secure against brute-force attacks. It uses
/// a large amount of memory and is highly customizable, allowing the user to
/// tune the parameters according to their specific needs.
///
/// Parameters:
/// - [password] : The passphrase string to hash.
/// - [salt] : An uniquely and randomly generated string.
/// - [r] : The size of a single block in bytes.
/// - [N] : The CPU/Memory cost parameter as a power of 2. 1 < [N] < 2^32
/// - [p] : The parallelization paramete. [p] <= (2^32 - 1) / (128 * [r])
/// - [dklen] : The intended output length in bytes. [dklen] <= 2^32 - 1
/// - [security] : The default parameter source for [N], [r], [p] if they are
///   not provided (default is [ScryptSecurity.good]).
///
/// The parameters N, r, and p should be tuned according to the amount of
/// memory and computing power available, as well as the desired level of
/// parallelism. At the current time, the values of r=8 and p=1 appear to
/// yield good results, but as technology advances, it is likely that the
/// optimum values for both r and p will increase.
///
/// [rfc]: https://www.rfc-editor.org/rfc/rfc7914.html
@pragma('vm:prefer-inline')
HashDigest scrypt(
  List<int> password,
  List<int> salt, {
  int? N,
  int? r,
  int? p,
  int dklen = 64,
  ScryptSecurity security = ScryptSecurity.good,
}) =>
    Scrypt(
      salt: salt,
      cost: N ?? security.N,
      blockSize: r ?? security.r,
      parallelism: p ?? security.p,
      derivedKeyLength: dklen,
    ).convert(password);

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
  /// It uses 1024 lanes, 8 blocks per lane and 2 iterations.
  static const moderate = ScryptSecurity('moderate', N: 1 << 10, r: 8, p: 2);

  /// Provides good security. The default parameters from [RFC-7914][rfc]
  ///
  /// It uses 16384 lanes, 8 blocks per lane and 1 iteration.
  ///
  /// [rfc]: https://www.ietf.org/rfc/rfc7914.html
  static const good = ScryptSecurity('good', N: 1 << 14, r: 8, p: 1);

  /// Provides strong security.
  ///
  /// It uses 65536 lanes, 16 blocks per lane and 2 iterations.
  static const strong = ScryptSecurity('strong', N: 1 << 16, r: 16, p: 2);
}
