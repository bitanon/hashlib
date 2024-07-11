// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/ripemd/ripemd128.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// RIPEMD-128 (RACE Integrity Primitives Evaluation Message Digest) is a
/// cryptographic hash function that produces a fixed-size, 128-bit hash value.
///
/// While it provides reasonable level of security, it is less commonly used
/// than RIPEMD-160, the more secure algorithm in the same family.
const BlockHashBase ripemd128 = _RIPEMD128();

class _RIPEMD128 extends BlockHashBase {
  const _RIPEMD128();

  @override
  final String name = 'RIPEMD-128';

  @override
  RIPEMD128Hash createSink() => RIPEMD128Hash();
}

/// Generates a RIPEMD-128 hash in hexadecimal
///
/// Parameters:
/// - [input] is the message string
/// - [encoding] specifies the character encoding. Default is [utf8].
/// - [uppercase] flag indicates whether the output should be in uppercase.
String ripemd128sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return ripemd128.string(input, encoding).hex(uppercase);
}
