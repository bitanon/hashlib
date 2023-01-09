// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha512.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-512/256 is the truncated version of SHA-512. This algorithm generates
/// a 256-bit hash omitting the last 256-bit from 512-bit SHA-512.
const HashBase sha512t256 = _SHA512t256();

class _SHA512t256 extends HashBase {
  const _SHA512t256();

  @override
  SHA512t256Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      SHA512t256Hash();
}

/// Generates a SHA-512/256 checksum
String sha512sum256(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512t256.string(input, encoding).hex(uppercase);
}
