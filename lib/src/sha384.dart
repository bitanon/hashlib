// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha512.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-384 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001.
///
/// SHA-384 and SHA-512 internally does the same calculations, except this one
/// omits the last 128-bits of SHA-512 to generate a 384-bit long hash digest.
const HashBase sha384 = _SHA384();

class _SHA384 extends HashBase {
  const _SHA384();

  @override
  SHA384Hash startChunkedConversion([Sink<HashDigest>? sink]) => SHA384Hash();
}

/// Generates a SHA-384 checksum
String sha384sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha384.string(input, encoding).hex(uppercase);
}
