// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/sha1.dart';
import 'package:hashlib/src/sha256.dart';
import 'package:hashlib/src/sha512.dart';

import 'pbkdf2.dart';

/// This contains some recommended parameters for [PBKDF2] algorithm.
class PBKDF2Security {
  final String name;

  /// The number of iterations
  final int c;

  /// The underlying algorithm
  final HashBase algo;

  const PBKDF2Security(
    this.name, {
    required this.c,
    required this.algo,
  });

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// PBKDF2-HMAC-SHA1 with 1,300,000 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp = PBKDF2Security('owasp1', algo: sha1, c: 1300000);

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// PBKDF2-HMAC-SHA256 with 1,300,000 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp2 = PBKDF2Security('owasp2', algo: sha256, c: 600000);

  /// Provides strong security recommended by [OWASP][link].
  ///
  /// PBKDF2-HMAC-SHA512 with 1,300,000 iterations.
  ///
  /// [link]: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
  static const owasp3 = PBKDF2Security('owasp3', algo: sha512, c: 210000);
}
