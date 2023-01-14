// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/md5.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// MD5 can be used as a checksum to verify data integrity against unintentional
/// corruption. Although it was widely used as a cryptographic has function
/// once, it has been found to suffer from extensive vulnerabilities.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const HashBase md5 = _MD5();

class _MD5 extends HashBase {
  const _MD5();

  @override
  MD5Hash createSink() => MD5Hash();
}

/// Generates a MD5 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String md5sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return md5.string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [md5] hash
extension Md5StringExtension on String {
  /// Generates a MD5 digest of this string
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  HashDigest md5digest([Encoding? encoding]) {
    return md5.string(this, encoding);
  }
}
