// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/md4.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// MD4 can be used as a checksum to verify data integrity against unintentional
/// corruption. Although it was widely used as a cryptographic hash function
/// once, it has been found to suffer from extensive vulnerabilities.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const BlockHashBase md4 = _MD4();

class _MD4 extends BlockHashBase {
  const _MD4();

  @override
  final String name = 'MD4';

  @override
  MD4Hash createSink() => MD4Hash();
}

/// Generates a MD4 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String md4sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return md4.string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [md4] hash
extension Md4StringExtension on String {
  /// Generates a MD4 digest of this string
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  HashDigest md4digest([Encoding? encoding]) {
    return md4.string(this, encoding);
  }
}
