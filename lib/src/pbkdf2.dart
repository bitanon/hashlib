// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/pbkdf2/pbkdf2.dart';
import 'package:hashlib/src/algorithms/pbkdf2/security.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/mac_base.dart';
import 'package:hashlib/src/hmac.dart';
import 'package:hashlib/src/sha256.dart';

export 'algorithms/pbkdf2/pbkdf2.dart' show PBKDF2;
export 'algorithms/pbkdf2/security.dart' show PBKDF2Security;

/// Extension to the HashBase to get an [PBKDF2] instance
extension PBKDF2onMACHashBase on MACHash {
  /// Generate a secret using [PBKDF2] hash algorithm.
  @pragma('vm:prefer-inline')
  PBKDF2 pbkdf2(
    List<int> salt, {
    PBKDF2Security security = PBKDF2Security.good,
    int? iterations,
    int? keyLength,
  }) =>
      PBKDF2.fromSecurity(
        security,
        mac: this,
        salt: salt,
        keyLength: keyLength,
        iterations: iterations,
      );
}

/// Extension on [BlockHashBase] to get an [PBKDF2] instance
extension PBKDF2onBlockHashBase on BlockHashBase {
  /// Generate a secret using [PBKDF2] hash algorithm.
  @pragma('vm:prefer-inline')
  PBKDF2 pbkdf2(
    List<int> salt, {
    PBKDF2Security security = PBKDF2Security.good,
    int? iterations,
    int? keyLength,
  }) =>
      PBKDF2.fromSecurity(
        security,
        mac: HMAC(this),
        salt: salt,
        keyLength: keyLength,
        iterations: iterations,
      );
}

/// This is an implementation of Password Based Key Derivation Algorithm,
/// PBKDF2 derived from [RFC-8081][rfc], which internally uses [sha256] hash
/// function for key derivation.
///
/// Parameters:
/// - [password] is the raw password to be encoded.
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [iterations] is the number of iterations. Default: 50000
/// - [keyLength] is the length of the generated key. Default: 32
///
/// The strength of the generated key depends on the number of [iterations].
/// The idea is to prevent a brute force attack on the original password by
/// making the key derivation time long.
///
/// [rfc]: https://www.rfc-editor.org/rfc/rfc8018.html#section-5.2
@pragma('vm:prefer-inline')
HashDigest pbkdf2(
  List<int> password,
  List<int> salt, [
  int? iterations,
  int? keyLength,
]) =>
    hmac_sha256
        .pbkdf2(
          salt,
          keyLength: keyLength,
          iterations: iterations,
        )
        .convert(password);
