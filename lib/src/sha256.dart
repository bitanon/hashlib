// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_32.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// SHA-256 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001.
///
/// SHA-256 uses 32-bit operations to generate a 256-bit long hash digest.
const HashBase sha256 = _SHA256();

class _SHA256 extends HashBase {
  const _SHA256();

  @override
  SHA256Sink create() => SHA256Sink();
}

/// Generates a SHA-256 checksum
String sha256sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha256.string(input, encoding).hex(uppercase);
}
