// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/md5.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// MD5 can be used as a checksum to verify data integrity against unintentional
/// corruption. Although it was widely used as a cryptographic hash function
/// once, it has been found to suffer from extensive vulnerabilities.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const BlockHashBase md5 = _MD5();

class _MD5 extends BlockHashBase {
  const _MD5();

  @override
  final String name = 'MD5';

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
