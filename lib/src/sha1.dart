// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha1.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';

/// SHA-1 produces a message digest based on principle similar to MD5, except
/// it can generate a 160-bit hash. Since 2005, SHA-1 has not been considered
/// secure and NIST formally deprecated it in 2001. It is no longer allowed
/// in digital signatures, however it is safe to use it as a checksum to verify
/// data integrity.
///
/// **Warning**: Do not use it for cryptographic purposes.
const HashBase sha1 = _SHA1();

/// Generates a 160-bit SHA-1 hash digest from the input.
HashDigest sha1buffer(final List<int> input) {
  return sha1.convert(input);
}

/// Generates a 160-bit SHA-1 hash from string
HashDigest sha1sum(final String input, [Encoding? encoding]) {
  return sha1buffer(toBytes(input, encoding));
}

/// Generates a 160-bit SHA-1 hash from stream
Future<HashDigest> sha1stream(final Stream<List<int>> stream) async {
  var sha1 = SHA1Sink();
  await stream.forEach(sha1.add);
  sha1.close();
  return sha1.digest;
}

class _SHA1 extends HashBase {
  const _SHA1();

  @override
  ByteConversionSink startChunkedConversion(Sink<HashDigest> sink) =>
      ByteConversionSink.from(SHA1Sink(sink));
}
