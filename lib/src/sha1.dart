// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha1.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-1 produces a message digest based on principle similar to MD5, except
/// it can generate a 160-bit hash. Since 2005, SHA-1 has not been considered
/// secure and NIST formally deprecated it in 2001. It is no longer allowed
/// in digital signatures, however it is safe to use it as a checksum to verify
/// data integrity.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const HashBase sha1 = _SHA1();

class _SHA1 extends HashBase {
  const _SHA1();

  @override
  SHA1Hash createSink() => SHA1Hash();
}

/// Generates a SHA-1 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha1sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha1.string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [sha1] hash
extension Sha1StringExtension on String {
  /// Generates a SHA-1 digest of this string
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  HashDigest sha1digest([Encoding? encoding]) {
    return sha1.string(this, encoding);
  }
}
