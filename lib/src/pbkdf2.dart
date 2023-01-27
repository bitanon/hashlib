// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/algorithms/hmac.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';

export 'package:hashlib/src/algorithms/pbkdf2.dart' show PBKDF2;

/// Extension on [BlockHashBase] to get an [PBKDF2] instance
extension PBKDF2onBlockHashBase on BlockHashBase {
  /// Get an [PBKDF2] instance that uses this hash function for key derivation.
  HashDigest pbkdf2({
    required List<int> password,
    required List<int> salt,
    required int iterations,
    int? keyLength,
  }) {
    return PBKDF2(
      HMACSink(createSink()),
      salt: salt,
      keyLength: keyLength,
      iterations: iterations,
    ).convert(password);
  }
}

/// Extension to the HashBase to get an [PBKDF2] instance
extension PBKDF2onHMAC on HMAC {
  /// Get an [PBKDF2] instance that uses this hash function for key derivation.
  HashDigest pbkdf2({
    required List<int> salt,
    required int iterations,
    int? keyLength,
  }) {
    return PBKDF2(
      createSink(),
      salt: salt,
      keyLength: keyLength,
      iterations: iterations,
    ).convert();
  }
}
