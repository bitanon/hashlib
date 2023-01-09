// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/keccak.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// Keccak-256 is a member of Keccak family hash functions that generates
/// a 256-bit hash.
///
/// Keccak is a secure and versatile hash function family that uses a simple
/// [sponge construction][sponge] and Keccak-f cryptographic permutation.
/// After its selection as the winner of the SHA-3 competition, Keccak has
/// been standardized in NIST standards [FIPS 202][fips202]
///
/// _Note that the standard implementation of Keccak-256 is available as
/// SHA3-256. This one follows the original design. However, the only
/// difference between them is the choice of the final padding._
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
///
/// **WARNING**: Not supported in Web
const HashBase keccak256 = _Keccak256();

class _Keccak256 extends HashBase {
  const _Keccak256();

  @override
  Keccak256Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      Keccak256Hash();
}

/// Generates a Keccak-256 checksum
String keccak256sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return keccak256.string(input, encoding).hex(uppercase);
}
