// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/ripemd160.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// RIPEMD-160 (RACE Integrity Primitives Evaluation Message Digest) is a
/// cryptographic hash function that produces a fixed-size, 160-bit hash value.
/// It is used to verify the integrity and authenticity of messages and is
/// resistant to various types of attacks, including collisions and preimage
/// attacks. It is commonly used in security protocols and applications.
const BlockHashBase ripemd160 = _RIPEMD160();

class _RIPEMD160 extends BlockHashBase {
  const _RIPEMD160();

  @override
  final String name = 'RIPEMD-160';

  @override
  RIPEMD160Hash createSink() => RIPEMD160Hash();
}

/// Generates a RIPEMD-160 hash in hexadecimal
///
/// Parameters:
/// - [input] is the message string
/// - [encoding] specifies the character encoding. Default is [utf8].
/// - [uppercase] flag indicates whether the output should be in uppercase.
///
/// Example:
/// ```dart
/// final input = 'Hello, world!';
/// final hash = ripemd160sum(input);
/// print(hash); // 58262d1fbdbe4530d8865d3518c6d6e41002610f
/// ```
String ripemd160sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return ripemd160.string(input, encoding).hex(uppercase);
}
