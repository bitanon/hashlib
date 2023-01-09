// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha512.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-512/224 is the truncated version of SHA-512. This algorithm generates
/// a 224-bit hash omitting the last 288-bit from 512-bit SHA-512 function.
const HashBase sha512t224 = _SHA512t224();

class _SHA512t224 extends HashBase {
  const _SHA512t224();

  @override
  SHA512t224Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      SHA512t224Hash();
}

/// Generates a SHA-512/224 checksum
String sha512sum224(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512t224.string(input, encoding).hex(uppercase);
}
