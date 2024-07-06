// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2/sha2.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// SHA-512/256 is a variation of SHA-512 which uses 512-bit internal state to
/// generate a message digest of 256-bit long truncating the last bits.
const BlockHashBase sha512t256 = _SHA512t256();

class _SHA512t256 extends BlockHashBase {
  const _SHA512t256();

  @override
  final String name = 'SHA-512/256';

  @override
  SHA512t256Hash createSink() => SHA512t256Hash();
}

/// SHA-512/224 is a variation of SHA-512 which uses 512-bit internal state to
/// generate a message digest of 224-bit long truncating the last bits.
const BlockHashBase sha512t224 = _SHA512t224();

class _SHA512t224 extends BlockHashBase {
  const _SHA512t224();

  @override
  final String name = 'SHA-512/224';

  @override
  SHA512t224Hash createSink() => SHA512t224Hash();
}

/// Generates a SHA-512/256 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines whether the hexadecimal output should be in uppercase
String sha512t256sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512t256.string(input, encoding).hex(uppercase);
}

/// Generates a SHA-512/224 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha512t224sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512t224.string(input, encoding).hex(uppercase);
}
