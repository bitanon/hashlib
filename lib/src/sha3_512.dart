// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha3.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA3-512 is a member of SHA-3 family which uses 512-bit blocks to
/// generate a message digest of 512-bit long.
///
/// SHA-3 is a subset of Keccak cryptographic family, standardized by NIST
/// on 2015 to substitute SHA-2 if necessary. Since the algorithm uses the
/// [sponge construction][sponge], it can generate any arbitrary length of
/// message digest. This implementation generates a 512-bit output using
/// the [standard SHA-3 algorithm][fips202].
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
const BlockHashBase sha3_512 = _SHA3d512();

class _SHA3d512 extends BlockHashBase {
  const _SHA3d512();

  @override
  final String name = 'SHA3-512';

  @override
  SHA3d512Hash createSink() => SHA3d512Hash();
}

/// Generates a SHA3-512 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha3_512sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha3_512.string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [sha3_512] hash
extension Sha3d512StringExtension on String {
  /// Generates a SHA3-512 digest of this string
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  @Deprecated('Use the public method instead.')
  HashDigest sha3_512digest([Encoding? encoding]) {
    return sha3_512.string(this, encoding);
  }
}
