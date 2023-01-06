// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:hashlib/src/core/hash_digest.dart';

/// A sink used to get a digest value out of `Hash.startChunkedConversion`.
class HashDigestSink extends Sink<HashDigest> {
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
