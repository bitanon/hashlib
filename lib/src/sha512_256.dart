// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_64.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// SHA-512/256 is the truncated version of SHA-512. This algorithm generates
/// a 256-bit hash omitting the last 256-bit from 512-bit SHA-512.
///
/// **WARNING**: Not safe with JavaScript VM
const HashBase sha512256 = _SHA512256();

/// Generates a 256-bit SHA-512 hash digest from a byte array
HashDigest sha512256buffer(final List<int> input) {
  return sha512256.convert(input);
}

/// Generates a 256-bit SHA-512 hash digest from a string
HashDigest sha512256sum(final String input, [Encoding? encoding]) {
  return sha512256buffer(toBytes(input, encoding));
}

/// Generates a 256-bit SHA-512 hash digest from a stream
Future<HashDigest> sha512256stream(final Stream<List<int>> stream) async {
  var sha512256 = SHA512256Sink();
  await stream.forEach(sha512256.add);
  sha512256.close();
  return sha512256.digest;
}

class _SHA512256 extends HashBase {
  const _SHA512256();

  @override
  Sink<List<int>> startChunkedConversion(Sink<HashDigest> sink) =>
      SHA512256Sink(sink);
}
