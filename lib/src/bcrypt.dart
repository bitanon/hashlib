// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/codecs.dart';
import 'package:hashlib/src/algorithms/bcrypt/bcrypt.dart';
import 'package:hashlib/src/algorithms/bcrypt/common.dart';
import 'package:hashlib/src/algorithms/bcrypt/security.dart';

export 'algorithms/bcrypt/bcrypt.dart' show Bcrypt;
export 'algorithms/bcrypt/common.dart'
    show BcryptContext, BcryptHashDigest, BcryptVersion;
export 'algorithms/bcrypt/security.dart' show BcryptSecurity;

/// Generate a secure password using the [Bcrypt] algorithm.
///
/// [Bcrypt][wiki] is a password hashing algorithm based on the Blowfish cipher.
/// It uses a unique salt and a configurable cost factor to prevent rainbow
/// table attacks and remain secure as hardware improves. Bcrypt's iterative
/// hashing and expensive key setup phase ensure resistance to brute-force
/// attacks.
///
/// Parameters:
/// - [password] : The password to hash. The algorithm uses first 72 bytes, and
///   the rest are ignored.
/// - [salt] : An randomly generated 16-byte string.
/// - [nb] : Number of rounds in terms of power of 2. 0 < [nb] < 31
/// - [version] : The [BcryptVersion] to use. Default [BcryptVersion.$2b]
/// - [security] : The default parameter source for [nb] if not provided
///   (default is [BcryptSecurity.good]).
///
/// [wiki]: https://en.wikipedia.org/wiki/Bcrypt
BcryptHashDigest bcryptDigest(
  List<int> password, {
  List<int>? salt,
  BcryptVersion version = BcryptVersion.$2b,
  BcryptSecurity security = BcryptSecurity.good,
  int? nb,
}) =>
    Bcrypt(
      version: version,
      salt: salt,
      cost: nb ?? security.nb,
    ).convert(password);

/// Generate the encoded salt to be used by the [Bcrypt] algorithm.
///
/// Parameters:
/// - [nb] : Number of rounds in terms of power of 2. 0 < [nb] < 31
/// - [version] : The [BcryptVersion] to use. Default [BcryptVersion.$2b]
/// - [security] : The default parameter source for [nb] if not provided
///   (default is [BcryptSecurity.good]).
String bcryptSalt({
  int? nb,
  BcryptVersion version = BcryptVersion.$2b,
  BcryptSecurity security = BcryptSecurity.good,
}) =>
    BcryptContext(
      version: version,
      cost: nb ?? security.nb,
    ).toEncoded();

/// Generates a secure password using the [Bcrypt] algorithm, and returns a
/// 60-byte encoded string containing the version, cost, salt, and password.
///
/// Parameters:
/// - [password] : The password to hash. The algorithm uses first 72 bytes, and
///   the rest are ignored.
/// - [salt] : Encoded salt, e.g.: `$2b$04$SQe9knOzepOVKoYXo9xTte`
///   If not provided, [bcryptSalt] is used to get a random one.
///
/// **Note**: Complete encoded string is also accepted, e.g.:
///   `$2b$04$SQe9knOzepOVKoYXo9xTteNYr6MBwVz4tpriJVe3PNgYufGIsgKcW`
String bcrypt(List<int> password, [String? salt]) =>
    Bcrypt.fromEncoded(fromCrypt(salt ?? bcryptSalt()))
        .convert(password)
        .encoded();

/// Verifies if the [plain] password was derived from the [encoded] hash.
///
/// The encoded hash may look like this:
/// `$2b$04$SQe9knOzepOVKoYXo9xTteNYr6MBwVz4tpriJVe3PNgYufGIsgKcW`
bool bcryptVerify(String encoded, List<int> plain) {
  var data = fromCrypt(encoded);
  var hash = data.hash!.substring(22);
  var hashBytes = fromBase64(hash, codec: Base64Codec.bcrypt);
  var instance = Bcrypt.fromEncoded(data);
  return instance.verify(hashBytes, plain);
}
