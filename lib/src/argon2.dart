// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/argon2/argon2.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';

export 'package:hashlib/src/algorithms/argon2/argon2.dart';

const _defaultSecurity = Argon2Security.good;

/// Verifies if the original [password] was derived from the [encoded]
/// Argon2 hash.
///
/// The encoded hash may look like this:
/// `$argon2i$v=19$m=16,t=2,p=1$c29tZSBzYWx0$u1eU6mZFG4/OOoTdAtM5SQ`
bool argon2verify(String encoded, List<int> password) {
  var data = fromCrypt(encoded);
  var hash = data.hashBytes();
  if (hash == null) {
    throw ArgumentError('No password hash in the encoded string');
  }
  var instance = Argon2.fromEncoded(data);
  return instance.verify(hash, password);
}

/// Encode a password using default Argon2d algorithm
///
/// Parameters:
/// - [password] is the raw password to be encoded
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [security] is the parameter choice for the algorithm.
/// - [hashLength] is the number of output bytes
/// - [key] is an optional key bytes to use
/// - [personalization] is optional additional data bytes
Argon2HashDigest argon2d(
  List<int> password,
  List<int> salt, {
  int? hashLength,
  List<int>? key,
  List<int>? personalization,
  Argon2Security security = _defaultSecurity,
}) =>
    Argon2(
      salt: salt,
      type: Argon2Type.argon2d,
      hashLength: hashLength,
      iterations: security.t,
      parallelism: security.p,
      memorySizeKB: security.m,
      key: key,
      personalization: personalization,
    ).convert(password);

/// Encode a password using default Argon2i algorithm
///
/// Parameters:
/// - [password] is the raw password to be encoded
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [security] is the parameter choice for the algorithm.
/// - [hashLength] is the number of output bytes
/// - [key] is an optional key bytes to use
/// - [personalization] is optional additional data bytes
///
///
Argon2HashDigest argon2i(
  List<int> password,
  List<int> salt, {
  int? hashLength,
  List<int>? key,
  List<int>? personalization,
  Argon2Security security = _defaultSecurity,
}) =>
    Argon2(
      salt: salt,
      type: Argon2Type.argon2i,
      hashLength: hashLength,
      iterations: security.t,
      parallelism: security.p,
      memorySizeKB: security.m,
      key: key,
      personalization: personalization,
    ).convert(password);

/// Encode a password using default Argon2id algorithm
///
/// Parameters:
/// - [password] is the raw password to be encoded
/// - [salt] should be at least 8 bytes long. 16 bytes is recommended.
/// - [security] is the parameter choice for the algorithm.
/// - [hashLength] is the number of output bytes
/// - [key] is an optional key bytes to use
/// - [personalization] is optional additional data bytes
Argon2HashDigest argon2id(
  List<int> password,
  List<int> salt, {
  int? hashLength,
  List<int>? key,
  List<int>? personalization,
  Argon2Security security = _defaultSecurity,
}) =>
    Argon2(
      salt: salt,
      type: Argon2Type.argon2id,
      hashLength: hashLength,
      iterations: security.t,
      parallelism: security.p,
      memorySizeKB: security.m,
      key: key,
      personalization: personalization,
    ).convert(password);
