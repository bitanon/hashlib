// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/md5.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// MD5 can be used as a checksum to verify data integrity against unintentional
/// corruption. Although it was widely used as a cryptographic has function
/// once, it has been found to suffer from extensive vulnerabilities.
///
/// **WARNING**: Do not use it for cryptographic purposes.
const HashBase md5 = _MD5();

/// Generates a 128-bit MD5 hash digest from a byte array
HashDigest md5buffer(final List<int> input) {
  return md5.convert(input);
}

/// Generates a 128-bit MD5 hash from string
HashDigest md5sum(final String input, [Encoding? encoding]) {
  return md5buffer(toBytes(input, encoding));
}

/// Generates a 128-bit MD5 hash from stream
Future<HashDigest> md5stream(final Stream<List<int>> stream) async {
  var md5 = MD5Sink();
  await stream.forEach(md5.add);
  md5.close();
  return md5.digest;
}

class _MD5 extends HashBase {
  const _MD5();

  @override
  Sink<List<int>> startChunkedConversion(Sink<HashDigest> sink) =>
      MD5Sink(sink);
}
