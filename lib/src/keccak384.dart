// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/keccak.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// Keccak-384 is a member of Keccak family hash functions that generates
/// a 384-bit hash.
///
/// _Note that the only difference between Keccak-384 and standard SHA3-384
/// is the choice of padding, everything else are the same._
///
/// Keccak is a secure and versatile hash function family that uses a simple
/// [sponge construction][sponge] and Keccak-f cryptographic permutation.
/// After its selection as the winner of the SHA-3 competition, Keccak has
/// been standardized in NIST standards [FIPS 202][fips202]
///
/// _Note that the standard implementation of Keccak-384 is available as
/// SHA3-384. This one follows the original design. However, the only
/// difference between them is the choice of the final padding._
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
///
/// **WARNING**: Not supported in Web
const HashBase keccak384 = _Keccak384();

class _Keccak384 extends HashBase {
  const _Keccak384();

  @override
  Keccak384Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      Keccak384Hash();
}

/// Generates a SHA3-384 checksum
String keccak384sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return keccak384.string(input, encoding).hex(uppercase);
}
