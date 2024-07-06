// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2/sha2.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// SHA-384 is a member of SHA-2 family which uses 512-bit internal state to
/// generate a message digest of 384-bit long.
///
/// SHA-2 is a family of algorithms designed by the United States National
/// Security Agency (NSA), first published in 2001 and later standardized in
/// [FIPS 180-4][fips180].
///
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
const BlockHashBase sha384 = _SHA384();

class _SHA384 extends BlockHashBase {
  const _SHA384();

  @override
  final String name = 'SHA-384';

  @override
  SHA384Hash createSink() => SHA384Hash();
}

/// Generates a SHA-384 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha384sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha384.string(input, encoding).hex(uppercase);
}
