// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/ripemd/ripemd320.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// RIPEMD-320 (RACE Integrity Primitives Evaluation Message Digest) is a
/// cryptographic hash function that produces a fixed-size, 320-bit hash value.
///
/// It shares some design principles with RIPEMD-160, but provides a higher
/// level of security having a larger output size and a more complex message
/// expansion function.
const BlockHashBase ripemd320 = _RIPEMD320();

class _RIPEMD320 extends BlockHashBase {
  const _RIPEMD320();

  @override
  final String name = 'RIPEMD-320';

  @override
  RIPEMD320Hash createSink() => RIPEMD320Hash();
}

/// Generates a RIPEMD-320 hash in hexadecimal
///
/// Parameters:
/// - [input] is the message string
/// - [encoding] specifies the character encoding. Default is [utf8].
/// - [uppercase] flag indicates whether the output should be in uppercase.
String ripemd320sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return ripemd320.string(input, encoding).hex(uppercase);
}
