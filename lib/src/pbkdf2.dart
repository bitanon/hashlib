// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/block_hash.dart';

export 'package:hashlib/src/algorithms/pbkdf2.dart' show PBKDF2;

/// Extension to the HashBase to get an [PBKDF2] instance
extension HashBaseToPBKDF2 on BlockHashBase {
  /// Get an [PBKDF2] instance that uses this hash function for key derivation.
  PBKDF2 pbkdf2({
    required List<int> salt,
    required int iterations,
    int? keyLength,
  }) {
    return PBKDF2(
      this,
      salt: salt,
      keyLength: keyLength,
      iterations: iterations,
    );
  }
}
