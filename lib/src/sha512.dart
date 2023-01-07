// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_64.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// SHA-512 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001. SHA-512 uses
/// 64-bit operations to generate a 512-bit long hash digest. Internally, it
/// does the same types of operations as of SHA-256.
///
/// **WARNING**: Not supported in JavaScript VM
const HashBase sha512 = _SHA512();

class _SHA512 extends HashBase {
  const _SHA512();

  @override
  SHA512Sink create() => SHA512Sink();
}

/// Generates a SHA-512 checksum
String sha512sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512.string(input, encoding).hex(uppercase);
}
