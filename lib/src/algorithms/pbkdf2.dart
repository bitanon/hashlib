// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// This is an implementation of Password Based Key Derivation Algorithm,
/// PBKDF2 derived from [RFC-8081][rfc], and uses HMAC based Pseudo Random
/// Function internally for key derivation.
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
class PBKDF2 extends KeyDerivationFunction {
  /// The underlying hash function to used for MAC generation
  final BlockHashSink _sink;

  /// The byte array containing salt
  final List<int> salt;

  /// The number of iterations
  final int iterations;

  @override
  final int derivedKeyLength;

  const PBKDF2._(
    this._sink, {
    required this.salt,
    required this.iterations,
    required this.derivedKeyLength,
  });

  factory PBKDF2(
    HashBase algo, {
    int? keyLength,
    required List<int> salt,
    required int iterations,
  }) {
    var sink = algo.createSink();
    if (sink is! BlockHashSink) {
      throw StateError('Only Block Hashes are supported for MAC generation');
    }
    return PBKDF2._(
      sink,
      salt: salt,
      iterations: iterations,
      derivedKeyLength: keyLength ?? sink.hashLength,
    );
  }

  @override
  HashDigest convert(List<int> password) {
    int i, j, k, t;
    Uint8List hash, block;
    var result = Uint8List(derivedKeyLength);
    var outerKey = Uint8List(_sink.blockLength);
    var innerKey = Uint8List(_sink.blockLength);

    // Keys longer than blockLength are shortened by hashing them
    if (password.length > _sink.blockLength) {
      _sink.add(password);
      password = _sink.digest().bytes;
    }

    // Calculated padded key for outer and inner sink
    for (i = 0; i < password.length; i++) {
      outerKey[i] = password[i] ^ 0x5c;
      innerKey[i] = password[i] ^ 0x36;
    }
    for (; i < _sink.blockLength; i++) {
      outerKey[i] = 0x5c;
      innerKey[i] = 0x36;
    }

    k = 0;
    for (i = 1; k < derivedKeyLength; i++) {
      // Generate the first HMAC: U_1
      _sink.reset();
      _sink.add(innerKey);
      _sink.add(salt);
      _sink.add([i >>> 24, i >>> 16, i >>> 8, i]);
      hash = _sink.digest().bytes;

      _sink.reset();
      _sink.add(outerKey);
      _sink.add(hash);
      hash = _sink.digest().bytes;

      // For storing the combined XORs
      block = hash;

      // Subsequence HMAC generation: U_2 .. U_c
      for (t = 1; t < iterations; ++t) {
        _sink.reset();
        _sink.add(innerKey);
        _sink.add(hash);
        hash = _sink.digest().bytes;

        _sink.reset();
        _sink.add(outerKey);
        _sink.add(hash);
        hash = _sink.digest().bytes;

        for (j = 0; j < _sink.hashLength; ++j) {
          block[j] ^= hash[j];
        }
      }

      // Append the hash to the result
      for (j = 0; j < _sink.hashLength && k < derivedKeyLength; ++j, ++k) {
        result[k] = block[j];
      }
    }

    return HashDigest(result);
  }
}
