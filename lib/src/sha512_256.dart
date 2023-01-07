// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_64.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// SHA-512/256 is the truncated version of SHA-512. This algorithm generates
/// a 256-bit hash omitting the last 256-bit from 512-bit SHA-512.
///
/// **WARNING**: Not supported in JavaScript VM
const HashBase sha512256 = _SHA512t256();

class _SHA512t256 extends HashBase {
  const _SHA512t256();

  @override
  SHA512t256Sink create() => SHA512t256Sink();
}

/// Generates a SHA-512/256 checksum
String sha512sum256(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512256.string(input, encoding).hex(uppercase);
}
