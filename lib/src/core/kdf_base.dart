// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/core/hash_digest.dart';

abstract class KeyDerivatorBase {
  const KeyDerivatorBase();

  /// The name of this algorithm
  String get name;

  /// The length of derived key in bytes
  int get derivedKeyLength;

  /// Generate a derived key from a [password]
  HashDigest convert(List<int> password);

  /// Returns the derived key in hexadecimal.
  @pragma('vm:prefer-inline')
  String hex(List<int> password) => convert(password).hex();

  /// Process the [password] string and returns derived key as [HashDigest].
  ///
  /// If [encoding] is not specified, the [String.codeUnits] are used.
  @pragma('vm:prefer-inline')
  HashDigest string(String password, [Encoding? encoding]) => convert(
        encoding != null ? encoding.encode(password) : password.codeUnits,
      );

  /// Verify if the [derivedKey] was derived from the original [password]
  /// using the current parameters.
  bool verify(List<int> derivedKey, List<int> password) {
    if (derivedKey.length != derivedKeyLength) {
      return false;
    }
    var other = convert(password).bytes;
    for (int i = 0; i < other.length; ++i) {
      if (derivedKey[i] != other[i]) {
        return false;
      }
    }
    return true;
  }
}
