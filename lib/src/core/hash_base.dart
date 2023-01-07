// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/core/hash_digest.dart';

abstract class HashBase extends Converter<List<int>, HashDigest> {
  const HashBase();

  @override
  HashDigest convert(final List<int> input) {
    var sink = _HashDigestSink();
    var buffer = startChunkedConversion(sink);
    buffer.add(input);
    buffer.close();
    return sink.value;
  }
}

class _HashDigestSink extends Sink<HashDigest> {
  HashDigest? _value;

  HashDigest get value => _value!;

  bool get closed => _value != null;

  @override
  void add(HashDigest data) {
    if (_value != null) {
      throw StateError('The message-digest sink is already closed');
    }
    _value = data;
  }

  @override
  void close() {
    if (_value == null) {
      throw StateError('No message-digest was added');
    }
  }
}
