// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-224 is a member of SHA-2 family which uses 256-bit internal state to
/// generate a message digest of 224-bit long.
///
/// SHA-2 is a family of algorithms designed by the United States National
/// Security Agency (NSA), first published in 2001 and later standardized in
/// [FIPS 180-4][fips180].
///
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
const HashBase sha224 = _SHA224();

class _SHA224 extends HashBase {
  const _SHA224();

  @override
  SHA224Hash startChunkedConversion([Sink<HashDigest>? sink]) => SHA224Hash();
}

/// Generates a SHA-224 checksum
String sha224sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha224.string(input, encoding).hex(uppercase);
}
