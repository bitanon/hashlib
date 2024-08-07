// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/keccak/keccak.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// Keccak-384 is a member of Keccak family hash functions that generates
/// a 384-bit hash.
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
const BlockHashBase keccak384 = _Keccak384();

class _Keccak384 extends BlockHashBase {
  const _Keccak384();

  @override
  final String name = 'Keccak-384';

  @override
  Keccak384Hash createSink() => Keccak384Hash();
}

/// Generates a Keccak-384 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String keccak384sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return keccak384.string(input, encoding).hex(uppercase);
}
