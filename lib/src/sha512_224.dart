// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_64.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// SHA-512/224 is the truncated version of SHA-512. This algorithm generates
/// a 224-bit hash omitting the last 288-bit from 512-bit SHA-512 function.
///
/// **WARNING**: Not safe with JavaScript VM
const HashBase sha512224 = _SHA512224();

/// Generates a 224-bit SHA-512 hash digest from a byte array
HashDigest sha512224buffer(final List<int> input) {
  return sha512224.convert(input);
}

/// Generates a 224-bit SHA-512 hash digest from a string
HashDigest sha512224sum(final String input, [Encoding? encoding]) {
  return sha512224buffer(toBytes(input, encoding));
}

/// Generates a 224-bit SHA-512 hash digest from a stream
Future<HashDigest> sha512224stream(final Stream<List<int>> stream) async {
  var sha512224 = SHA512224Sink();
  await stream.forEach(sha512224.add);
  sha512224.close();
  return sha512224.digest;
}

class _SHA512224 extends HashBase {
  const _SHA512224();

  @override
  Sink<List<int>> startChunkedConversion(Sink<HashDigest> sink) =>
      SHA512224Sink(sink);
}
