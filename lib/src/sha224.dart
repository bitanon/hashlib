// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_32.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-224 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001.
///
/// SHA-224 and SHA-256 essentially does the same calculations, except this one
/// omits the last 32-bits of SHA-256 to generate a 224-bit long hash digest.
const HashBase sha224 = _SHA224();

class _SHA224 extends HashBase {
  const _SHA224();

  @override
  SHA224Hash startChunkedConversion([Sink<HashDigest>? sink]) => SHA224Hash();
}

/// Generates a SHA-224 checksum
String sha224sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha224.string(input, encoding).hex(uppercase);
}
