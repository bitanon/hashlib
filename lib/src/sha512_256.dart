// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-512/256 is a variation of SHA-512 which uses 512-bit internal state to
/// generate a message digest of 256-bit long truncating the last bits.
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
