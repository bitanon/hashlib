// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/md5.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// MD5 can be used as a checksum to verify data integrity against unintentional
/// corruption. Although it was widely used as a cryptographic has function
/// once, it has been found to suffer from extensive vulnerabilities.
///
/// **WARNING**: Do not use it for cryptographic purposes.
const HashBase md5 = _MD5();

class _MD5 extends HashBase {
  const _MD5();

  @override
  MD5Hash startChunkedConversion([Sink<HashDigest>? sink]) => MD5Hash();
}

/// Generates a MD-5 checksum
String md5sum(
  final String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return md5.string(input, encoding).hex(uppercase);
}
