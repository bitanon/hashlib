// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/mac_base.dart';
import 'package:hashlib/src/hmac.dart';
import 'package:hashlib/src/md5.dart';
import 'package:hashlib/src/sha1.dart';
import 'package:hashlib/src/sha256.dart';
import 'package:hashlib/src/sha3_256.dart';
import 'package:hashlib/src/sha512.dart';

import 'pbkdf2.dart';

/// This contains some recommended parameters for [PBKDF2] algorithm.
class PBKDF2Security {
  final String name;

  /// The number of iterations
  final int c;

  /// The length of the derived key
  final int dklen;

  /// The underlying algorithm
  final MACHash mac;

  const PBKDF2Security(
    this.name, {
    required this.c,
    required this.mac,
    required this.dklen,
  });

  /// Provides a very low security. Use it only for test purposes.
  ///
  /// It uses MD5/HMAC algorithm with a cost of 10.
  ///
  /// **WARNING: Not recommended for general use.**
  static const test = PBKDF2Security('test', mac: HMAC(md5), c: 10, dklen: 16);

  /// Provides low security. Can be used on low-end devices.
  ///
  /// It uses SHA3-256/HMAC algorithm with 100 iterations.
  ///
  /// **WARNING: Not recommended for general use.**
  static const little =
      PBKDF2Security('little', mac: HMAC(sha3_256), c: 100, dklen: 32);

  /// Provides moderate security.
  ///
  /// It uses SHA-256/HMAC algorithm with 3,000 iterations.
  static const moderate =
      PBKDF2Security('moderate', mac: hmac_sha256, c: 3000, dklen: 32);

  /// Provides good security.
  ///
  /// It uses SHA-256/HMAC algorithm with 50,000 iterations.
  static const good =
      PBKDF2Security('good', mac: hmac_sha256, c: 50000, dklen: 64);

  /// Provides strong security. It uses similar parameters as [owasp2].
  ///
  /// It uses SHA-256/HMAC algorithm with 600,000 iterations.
  static const strong =
      PBKDF2Security('strong', mac: HMAC(sha256), c: 600000, dklen: 64);

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// It uses SHA1/HMAC algorithm with 1,300,000 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp =
      PBKDF2Security('owasp1', mac: HMAC(sha1), c: 1300000, dklen: 32);

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// It uses SHA-256/HMAC algorithm with 600,000 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp2 =
      PBKDF2Security('owasp2', mac: HMAC(sha256), c: 600000, dklen: 64);

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// It uses SHA-512/HMAC algorithm with 210,000 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp3 =
      PBKDF2Security('owasp3', mac: HMAC(sha512), c: 210000, dklen: 64);
}
