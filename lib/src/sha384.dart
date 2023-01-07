// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_64.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// SHA-384 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001.
///
/// SHA-384 and SHA-512 internally does the same calculations, except this one
/// omits the last 128-bits of SHA-512 to generate a 384-bit long hash digest.
///
/// **WARNING**: Not safe with JavaScript VM
const HashBase sha384 = _SHA384();

/// Generates a 384-bit SHA-384 hash digest from a byte array
HashDigest sha384buffer(final List<int> input) {
  return sha384.convert(input);
}

/// Generates a 384-bit SHA-384 hash digest from a string
HashDigest sha384sum(final String input, [Encoding? encoding]) {
  return sha384buffer(toBytes(input, encoding));
}

/// Generates a 384-bit SHA-384 hash digest from a stream
Future<HashDigest> sha384stream(final Stream<List<int>> stream) async {
  var sha384 = SHA384Sink();
  await stream.forEach(sha384.add);
  sha384.close();
  return sha384.digest;
}

class _SHA384 extends HashBase {
  const _SHA384();

  @override
  Sink<List<int>> startChunkedConversion(Sink<HashDigest> sink) =>
      SHA384Sink(sink);
}
