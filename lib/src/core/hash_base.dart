// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/hash_digest_sink.dart';

abstract class HashBase extends Converter<List<int>, HashDigest> {
  const HashBase();

  @override
  HashDigest convert(final List<int> input) {
    var sink = HashDigestSink();
    var buffer = startChunkedConversion(sink);
    buffer.add(input);
    buffer.close();
    return sink.value;
  }

  @override
  ByteConversionSink startChunkedConversion(Sink<HashDigest> sink);
}
