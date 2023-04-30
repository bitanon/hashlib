// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha3.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA3-384 is a member of SHA-3 family which uses 384-bit blocks to
/// generate a message digest of 384-bit long.
///
/// SHA-3 is a subset of Keccak cryptographic family, standardized by NIST
/// on 2015 to substitute SHA-2 if necessary. Since the algorithm uses the
/// [sponge construction][sponge], it can generate any arbitrary length of
/// message digest. This implementation generates a 384-bit output using
/// the [standard SHA-3 algorithm][fips202].
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
const BlockHashBase sha3_384 = _SHA3d384();

class _SHA3d384 extends BlockHashBase {
  const _SHA3d384();

  @override
  final String name = 'SHA3-384';

  @override
  SHA3d384Hash createSink() => SHA3d384Hash();
}

/// Generates a SHA3-384 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha3_384sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha3_384.string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [sha3_384] hash
extension Sha3d384StringExtension on String {
  /// Generates a SHA3-384 digest of this string
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  HashDigest sha3_384digest([Encoding? encoding]) {
    return sha3_384.string(this, encoding);
  }
}
