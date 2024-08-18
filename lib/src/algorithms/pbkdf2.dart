// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/kdf_base.dart';
import 'package:hashlib/src/core/mac_base.dart';

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
  /// The underlying Pseudo Random Function (PRF)
  final MACSinkBase sink;

  /// The byte array containing salt
  final List<int> salt;

  /// The number of iterations
  final int iterations;

  @override
  final int derivedKeyLength;

  const PBKDF2._({
    required this.sink,
    required this.salt,
    required this.iterations,
    required this.derivedKeyLength,
  });

  /// Create a [PBKDF2] instance with a MAC instance.
  factory PBKDF2(
    MACHashBase mac,
    List<int> salt,
    int iterations, [
    int? keyLength,
  ]) {
    // validate parameters
    if (iterations < 1) {
      throw StateError('The iterations must be at least 1');
    }
    if (iterations > 0xFFFFFFFF) {
      throw StateError('The iterations must be less than 2^32');
    }
    if (keyLength != null && keyLength < 1) {
      throw StateError('The keyLength must be at least 1');
    }

    // create instance
    final sink = mac.createSink();
    return PBKDF2._(
      sink: sink,
      salt: salt,
      iterations: iterations,
      derivedKeyLength: keyLength ?? sink.hashLength,
    );
  }

  /// Generate a derived key using the [sink] function.
  ///
  /// This function will throw an [StateError] if the [sink] is not initialized
  /// and the [password] is not provided.
  @override
  HashDigest convert([List<int>? password]) {
    int i, j, k, t;
    Uint8List hash, block;
    var result = Uint8List(derivedKeyLength);

    // Initialize the MAC with provided password
    if (password != null) {
      sink.init(password);
    }

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
