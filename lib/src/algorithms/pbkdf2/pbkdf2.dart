// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/kdf_base.dart';
import 'package:hashlib/src/core/mac_base.dart';
import 'package:hashlib/src/random.dart';

import 'security.dart';

int _defaultKeyLength = 24;
int _defaultSaltLength = 16;

/// This is an implementation of Password Based Key Derivation Algorithm,
/// PBKDF2 derived from [RFC-8081][rfc], which internally uses a MAC based
/// Pseudo Random Function (PRF) for key derivation.
///
/// PBKDF2 is part of Public-Key Cryptography Standards (PKCS) series published
/// by the RSA Laboratories, specifically PKCS #5 v2.0. It supersedes PBKDF1,
/// which could only produce derived keys up to 160 bits long.
///
/// The strength of the generated password using PBKDF2 depends on the number
/// of iterations. The idea is to prevent a brute force attack on the original
/// password by making the key derivation time long. This implementation can be
/// used for both to [convert] a passphrase and [verify] it with a derived key.
///
/// [rfc]: https://www.rfc-editor.org/rfc/rfc8018.html#section-5.2
class PBKDF2 extends KeyDerivatorBase {
  @override
  String get name => '${algo.name}/PBKDF2';

  /// The underlying algorithm used as Pseudo Random Function (PRF)
  final MACHash algo;

  /// The byte array containing salt
  final List<int> salt;

  /// The number of iterations
  final int iterations;

  @override
  final int derivedKeyLength;

  const PBKDF2._({
    required this.algo,
    required this.salt,
    required this.iterations,
    required this.derivedKeyLength,
  });

  /// Create a [PBKDF2] instance with a MAC instance.
  factory PBKDF2(
    MACHash mac,
    int iterations, {
    List<int>? salt,
    int? keyLength,
  }) {
    keyLength ??= _defaultKeyLength;
    salt ??= randomBytes(_defaultSaltLength);

    // validate parameters
    if (iterations < 1) {
      throw StateError('The iterations must be at least 1');
    }
    if (iterations > 0x7FFFFFFF) {
      throw StateError('The iterations must be less than 2^31');
    }
    if (keyLength < 1) {
      throw StateError('The keyLength must be at least 1');
    }

    // create instance
    return PBKDF2._(
      algo: mac,
      salt: salt,
      iterations: iterations,
      derivedKeyLength: keyLength,
    );
  }

  /// Create a [PBKDF2] instance from [PBKDF2Security].
  factory PBKDF2.fromSecurity(
    PBKDF2Security security, {
    List<int>? salt,
    MACHash? mac,
    int? iterations,
    int? keyLength,
  }) =>
      PBKDF2(
        mac ?? security.mac,
        iterations ?? security.c,
        keyLength: keyLength ?? security.dklen,
        salt: salt,
      );

  @override
  HashDigest convert(List<int> password) {
    int i, j, k, t;
    Uint8List hash, block;
    var result = Uint8List(derivedKeyLength);

    // Initialize the MAC with provided password
    var sink = algo.by(password).createSink();

    k = 0;
    for (i = 1; k < derivedKeyLength; i++) {
      // Generate the first HMAC: U_1
      sink.reset();
      sink.add(salt);
      sink.add([i >>> 24, i >>> 16, i >>> 8, i]);
      hash = sink.digest().bytes;

      // For storing the combined XORs
      block = hash;

      // Subsequence HMAC generation: U_2 .. U_c
      for (t = 1; t < iterations; ++t) {
        sink.reset();
        sink.add(hash);
        hash = sink.digest().bytes;

        for (j = 0; j < hash.length; ++j) {
          block[j] ^= hash[j];
        }
      }

      // Append the hash to the result
      for (j = 0; j < hash.length && k < derivedKeyLength; ++j, ++k) {
        result[k] = block[j];
      }
    }

    return HashDigest(result);
  }
}
