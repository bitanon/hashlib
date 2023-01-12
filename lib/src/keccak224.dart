// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/keccak.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// Keccak-224 is a member of Keccak family hash functions that generates
/// a 224-bit hash.
///
/// Keccak is a secure and versatile hash function family that uses a simple
/// [sponge construction][sponge] and Keccak-f cryptographic permutation.
/// After its selection as the winner of the SHA-3 competition, Keccak has
/// been standardized in NIST standards [FIPS 202][fips202]
///
/// _Note that the standard implementation of Keccak-224 is available as
/// SHA3-224. This one follows the original design. However, the only
/// difference between them is the choice of the final padding._
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
const HashBase keccak224 = _Keccak224();

class _Keccak224 extends HashBase {
  const _Keccak224();

  @override
  Keccak224Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      Keccak224Hash();
}

/// Generates a Keccak-224 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String keccak224sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return keccak224.string(input, encoding).hex(uppercase);
}
