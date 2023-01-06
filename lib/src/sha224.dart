// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha2_32.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// SHA-224 is a part of SHA-2 algorithm family designed by the United States
/// National Security Agency (NSA) and first published in 2001. SHA-224 and
/// SHA-256 essentially does the same calculations, except this one omits the
/// last 32-bits of SHA-256 to generate a 224-bit long hash digest.
const HashBase sha224 = _SHA224();

/// Generates a 224-bit SHA-224 hash digest from the input.
HashDigest sha224buffer(final List<int> input) {
  return sha224.convert(input);
}

/// Generates a 224-bit SHA-224 hash from string
HashDigest sha224sum(final String input, [Encoding? encoding]) {
  return sha224buffer(toBytes(input, encoding));
}

/// Generates a 224-bit SHA-224 hash from stream
Future<HashDigest> sha224stream(final Stream<List<int>> stream) async {
  var sha224 = SHA224Sink();
  await stream.forEach(sha224.add);
  sha224.close();
  return sha224.digest;
}

class _SHA224 extends HashBase {
  const _SHA224();

  @override
  ByteConversionSink startChunkedConversion(Sink<HashDigest> sink) =>
      ByteConversionSink.from(SHA224Sink(sink));
}
