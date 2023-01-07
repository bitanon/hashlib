// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_64.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// SHA-512 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001. SHA-512 uses
/// 64-bit operations to generate a 512-bit long hash digest. Internally, it
/// does the same types of operations as of SHA-256.
///
/// **WARNING**: Not safe with JavaScript VM
const HashBase sha512 = _SHA512();

/// Generates a 512-bit SHA-512 hash digest from a byte array
HashDigest sha512buffer(final List<int> input) {
  return sha512.convert(input);
}

/// Generates a 512-bit SHA-512 hash digest from a string
HashDigest sha512sum(final String input, [Encoding? encoding]) {
  return sha512buffer(toBytes(input, encoding));
}

/// Generates a 512-bit SHA-512 hash digest from a stream
Future<HashDigest> sha512stream(final Stream<List<int>> stream) async {
  var sha512 = SHA512Sink();
  await stream.forEach(sha512.add);
  sha512.close();
  return sha512.digest;
}

class _SHA512 extends HashBase {
  const _SHA512();

  @override
  Sink<List<int>> startChunkedConversion(Sink<HashDigest> sink) =>
      SHA512Sink(sink);
}
