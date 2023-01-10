// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-512/256 is a variation of SHA-512 which uses 512-bit internal state to
/// generate a message digest of 256-bit long truncating the last bits.
const HashBase sha512t256 = _SHA512t256();

class _SHA512t256 extends HashBase {
  const _SHA512t256();

  @override
  SHA512t256Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      SHA512t256Hash();
}

/// SHA-512/224 is a variation of SHA-512 which uses 512-bit internal state to
/// generate a message digest of 224-bit long truncating the last bits.
const HashBase sha512t224 = _SHA512t224();

class _SHA512t224 extends HashBase {
  const _SHA512t224();

  @override
  SHA512t224Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      SHA512t224Hash();
}

/// Generates a SHA-512/256 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines whether the hexadecimal output should be in uppercase
String sha512t256sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512t256.string(input, encoding).hex(uppercase);
}

/// Generates a SHA-512/224 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha512t224sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512t224.string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [sha512t224] and [sha512t256] hash
extension Sha512tStringExtension on String {
  /// Generates a SHA-512/224 digest of this string
  ///
  /// Parameters:
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  HashDigest sha512t224digest([Encoding? encoding]) {
    return sha512t224.string(this, encoding);
  }

  /// Generates a SHA-512/256 digest of this string
  ///
  /// Parameters:
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  HashDigest sha512t256digest([Encoding? encoding]) {
    return sha512t256.string(this, encoding);
  }
}
