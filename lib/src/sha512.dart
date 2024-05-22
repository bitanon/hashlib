// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-512 is a member of SHA-2 family which uses 512-bit internal state to
/// generate a message digest of 512-bit long.
///
/// SHA-2 is a family of algorithms designed by the United States National
/// Security Agency (NSA), first published in 2001 and later standardized in
/// [FIPS 180-4][fips180].
///
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
const BlockHashBase sha512 = _SHA512();

class _SHA512 extends BlockHashBase {
  const _SHA512();

  @override
  final String name = 'SHA-512';

  @override
  SHA512Hash createSink() => SHA512Hash();
}

/// Generates a SHA-512 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha512sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512.string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [sha512] hash
extension Sha512StringExtension on String {
  /// Generates a SHA-512 digest of this string
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  @Deprecated('Use the public method instead.')
  HashDigest sha512digest([Encoding? encoding]) {
    return sha512.string(this, encoding);
  }
}
