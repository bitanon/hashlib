// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/argon2.dart';

export 'package:hashlib/src/algorithms/argon2.dart'
    show Argon2, Argon2Type, Argon2Version, Argon2Security;

const _defaultHashLength = 24;
const _defaultSecurity = Argon2Security.moderate;

/// Verify if Argon2 encoded string matches for a raw password
bool argon2Verify(String encoded, List<int> password) {
  return Argon2.fromEncoded(encoded).encode(password) == encoded;
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
  Argon2Security security = _defaultSecurity,
  int hashLength = _defaultHashLength,
  List<int>? key,
  List<int>? personalization,
}) {
  return Argon2(
    salt: salt,
    hashType: Argon2Type.argon2d,
    hashLength: hashLength,
    iterations: security.t,
    parallelism: security.p,
    memorySizeKB: security.m,
    key: key,
    personalization: personalization,
  ).convert(password);
}

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
  Argon2Security security = _defaultSecurity,
  int hashLength = _defaultHashLength,
  List<int>? key,
  List<int>? personalization,
}) {
  return Argon2(
    salt: salt,
    hashType: Argon2Type.argon2i,
    hashLength: hashLength,
    iterations: security.t,
    parallelism: security.p,
    memorySizeKB: security.m,
    key: key,
    personalization: personalization,
  ).convert(password);
}

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
  Argon2Security security = _defaultSecurity,
  int hashLength = _defaultHashLength,
  List<int>? key,
  List<int>? personalization,
}) {
  return Argon2(
    salt: salt,
    hashType: Argon2Type.argon2id,
    hashLength: hashLength,
    iterations: security.t,
    parallelism: security.p,
    memorySizeKB: security.m,
    key: key,
    personalization: personalization,
  ).convert(password);
}
