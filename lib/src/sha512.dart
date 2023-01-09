// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHA-512 is a member of SHA-2 family which uses 512-bit internal state to
/// generate a message digest of 512-bit long.
///
/// SHA-2 is a family of algorithms designed by the United States National
/// Security Agency (NSA), first published in 2001 and later standardized in
/// [FIPS 180-4][fips180].
///
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
const HashBase sha512 = _SHA512();

class _SHA512 extends HashBase {
  const _SHA512();

  @override
  SHA512Hash startChunkedConversion([Sink<HashDigest>? sink]) => SHA512Hash();
}

/// Generates a SHA-512 checksum
String sha512sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha512.string(input, encoding).hex(uppercase);
}
