// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/ripemd256.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// RIPEMD-256 (RACE Integrity Primitives Evaluation Message Digest) is a
/// cryptographic hash function that produces a fixed-size, 256-bit hash value.
///
/// It shares some design principles with RIPEMD-128, but provides a higher
/// level of security. It is also less commonly used than RIPEMD-160.
const BlockHashBase ripemd256 = _RIPEMD256();

class _RIPEMD256 extends BlockHashBase {
  const _RIPEMD256();

  @override
  final String name = 'RIPEMD-256';

  @override
  RIPEMD256Hash createSink() => RIPEMD256Hash();
}

/// Generates a RIPEMD-256 hash in hexadecimal
///
/// Parameters:
/// - [input] is the message string
/// - [encoding] specifies the character encoding. Default is [utf8].
/// - [uppercase] flag indicates whether the output should be in uppercase.
String ripemd256sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return ripemd256.string(input, encoding).hex(uppercase);
}
