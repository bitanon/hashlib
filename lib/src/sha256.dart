// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2/sha2.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// SHA-256 is a member of SHA-2 family which uses 256-bit internal state to
/// generate a message digest of 256-bit long.
///
/// SHA-2 is a family of algorithms designed by the United States National
/// Security Agency (NSA), first published in 2001 and later standardized in
/// [FIPS 180-4][fips180].
///
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
const BlockHashBase sha256 = _SHA256();

class _SHA256 extends BlockHashBase {
  const _SHA256();

  @override
  final String name = 'SHA-256';

  @override
  SHA256Hash createSink() => SHA256Hash();
}

/// Generates a SHA-256 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha256sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha256.string(input, encoding).hex(uppercase);
}
