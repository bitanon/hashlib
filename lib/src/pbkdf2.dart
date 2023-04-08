// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/algorithms/hmac.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/mac_base.dart';

export 'package:hashlib/src/algorithms/pbkdf2.dart' show PBKDF2;

/// This is an implementation of Password Based Key Derivation Algorithm,
/// PBKDF2 derived from [RFC-8081][rfc], which internally uses [sha256] hash
/// function for key derivation.
///
/// Parameters:
/// - [password] is the raw password to be encoded.
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [iterations] is the number of iterations.
/// - [keyLength] is the number of output bytes.
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
  int iterations = 1000,
  int? keyLength,
]) =>
    PBKDF2(
      HMACSink(sha256.createSink()),
      salt,
      iterations,
      keyLength,
    ).convert(password);

/// Extension on [BlockHashBase] to get an [PBKDF2] instance
extension PBKDF2onBlockHashBase on BlockHashBase {
  /// Generate a secret using [PBKDF2] hash algorithm.
  @pragma('vm:prefer-inline')
  HashDigest pbkdf2(
    List<int> password,
    List<int> salt, [
    int iterations = 1000,
    int? keyLength,
  ]) =>
      PBKDF2(
        HMACSink(createSink()),
        salt,
        iterations,
        keyLength,
      ).convert(password);
}

/// Extension to the HashBase to get an [PBKDF2] instance
extension PBKDF2onHMAC on MACHashBase {
  /// Generate a secret using [PBKDF2] hash algorithm.
  @pragma('vm:prefer-inline')
  HashDigest pbkdf2(
    List<int> salt, [
    int iterations = 1000,
    int? keyLength,
  ]) =>
      PBKDF2
          .mac(
            this,
            salt,
            iterations,
            keyLength,
          )
          .convert();
}
