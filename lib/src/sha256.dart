// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_32.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// SHA-224 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001. SHA-256 uses
/// 32-bit operations on a 512-bit size block to generate a 256-bit long
/// hash digest. So far it is considered a secure hash algorithm.
const HashBase sha256 = _SHA256();

/// Generates a 256-bit SHA-256 hash digest from the input.
HashDigest sha256buffer(final List<int> input) {
  return sha256.convert(input);
}

/// Generates a 256-bit SHA-256 hash digest from string
HashDigest sha256sum(final String input, [Encoding? encoding]) {
  return sha256buffer(toBytes(input, encoding));
}

/// Generates a 256-bit SHA-256 hash digest from stream
Future<HashDigest> sha256stream(final Stream<List<int>> stream) async {
  var sha256 = SHA256Sink();
  await stream.forEach(sha256.add);
  sha256.close();
  return sha256.digest;
}

class _SHA256 extends HashBase {
  const _SHA256();

  @override
  ByteConversionSink startChunkedConversion(Sink<HashDigest> sink) =>
      ByteConversionSink.from(SHA256Sink(sink));
}
