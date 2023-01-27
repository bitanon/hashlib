// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_digest.dart';

abstract class KeyDerivatorBase {
  const KeyDerivatorBase();

  /// The length of derived key in bytes
  int get derivedKeyLength;

  /// Generate a derived key from a [password]
  HashDigest convert(List<int> password);

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
