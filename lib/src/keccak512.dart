// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/keccak.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// Keccak-512 is a member of Keccak family hash functions that generates
/// a 512-bit hash.
///
/// _Note that the only difference between Keccak-512 and standard SHA3-512
/// is the choice of padding, everything else are the same._
///
/// Keccak is a secure and versatile hash function family that uses a simple
/// [sponge construction][sponge] and Keccak-f cryptographic permutation.
/// After its selection as the winner of the SHA-3 competition, Keccak has
/// been standardized in NIST standards [FIPS 202][fips202]
///
/// _Note that the standard implementation of Keccak-512 is available as
/// SHA3-512. This one follows the original design. However, the only
/// difference between them is the choice of the final padding._
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
///
/// **WARNING**: Not supported in Web
const HashBase keccak512 = _Keccak512();

class _Keccak512 extends HashBase {
  const _Keccak512();

  @override
  Keccak512Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      Keccak512Hash();
}

/// Generates a SHA3-512 checksum
String keccak512sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return keccak512.string(input, encoding).hex(uppercase);
}
