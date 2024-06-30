// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'bcrypt.dart';

/// This contains some recommended parameters for [Bcrypt] algorithm.
class BcryptSecurity {
  final String name;

  /// The number of rounds in terms of power of 2.
  final int nb;

  const BcryptSecurity(
    this.name, {
    required this.nb,
  });

  @override
  String toString() => "BCryptSecurity($name):nb=$nb";

  /// Provides a very low security. Use it for test purposes.
  ///
  /// It uses 2^1 = 2 round for encryption.
  ///
  /// **WARNING: Not recommended for general use.**
  static const test = BcryptSecurity('test', nb: 1);

  /// Provides low security but faster. Suitable for low-end devices.
  ///
  /// It uses 2^5 = 32 rounds for encryption.
  static const little = BcryptSecurity('little', nb: 5);

  /// Provides moderate security. Suitable for modern mobile devices.
  ///
  /// It uses 2^8 = 256 rounds for encryption.
  static const moderate = BcryptSecurity('moderate', nb: 8);

  /// Provides good security.
  ///
  /// It uses 2^12 = 4096 rounds for encryption.
  static const good = BcryptSecurity('good', nb: 12);

  /// Provides strong security.
  ///
  /// It uses 2^15 = 32768 rounds for encryption.
  static const strong = BcryptSecurity('strong', nb: 15);
}
