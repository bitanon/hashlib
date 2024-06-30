// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/scrypt/scrypt.dart';
import 'package:hashlib/src/algorithms/scrypt/security.dart';
import 'package:hashlib/src/core/hash_digest.dart';

export 'algorithms/scrypt/scrypt.dart' show Scrypt;
export 'algorithms/scrypt/security.dart' show ScryptSecurity;

/// Generate a secure password using the [scrypt][rfc] algorithm.
///
/// The scrypt algorithm is a modern password-based key derivation function
/// that is designed to be highly secure against brute-force attacks. It uses
/// a large amount of memory and is highly customizable, allowing the user to
/// tune the parameters according to their specific needs.
///
/// Parameters:
/// - [password] : The passphrase string to hash.
/// - [salt] : An uniquely and randomly generated string.
/// - [r] : The size of a single block in bytes.
/// - [N] : The CPU/Memory cost parameter as a power of 2. 1 < [N] < 2^32
/// - [p] : The parallelization paramete. [p] <= (2^32 - 1) / (128 * [r])
/// - [dklen] : The intended output length in bytes. [dklen] <= 2^32 - 1
/// - [security] : The default parameter source for [N], [r], [p] if they are
///   not provided (default is [ScryptSecurity.good]).
///
/// The parameters N, r, and p should be tuned according to the amount of
/// memory and computing power available, as well as the desired level of
/// parallelism. At the current time, the values of r=8 and p=1 appear to
/// yield good results, but as technology advances, it is likely that the
/// optimum values for both r and p will increase.
///
/// [rfc]: https://www.rfc-editor.org/rfc/rfc7914.html
@pragma('vm:prefer-inline')
HashDigest scrypt(
  List<int> password,
  List<int> salt, {
  int? N,
  int? r,
  int? p,
  int dklen = 64,
  ScryptSecurity security = ScryptSecurity.good,
}) =>
    Scrypt(
      salt: salt,
      cost: N ?? security.N,
      blockSize: r ?? security.r,
      parallelism: p ?? security.p,
      derivedKeyLength: dklen,
    ).convert(password);
