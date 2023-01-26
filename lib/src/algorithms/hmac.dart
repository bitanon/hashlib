// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// This implementation is derived from the RFC document
/// [HMAC: Keyed-Hashing for Message Authentication][rfc2104].
///
/// [rfc2104]: https://www.ietf.org/rfc/rfc2104.html
class HMACSink implements HashDigestSink {
  final BlockHashSink sink;
  final Uint8List outerKey;
  bool _closed = false;
  HashDigest? _digest;

  HMACSink._(this.sink, this.outerKey);

  factory HMACSink(HashBase algo, List<int> key) {
    var sink = algo.createSink();
    if (sink is! BlockHashSink) {
      throw StateError('Only Block Hashes are supported for MAC generation');
    }

    int i;
    var paddedKey = Uint8List(sink.blockLength);

    // Keys longer than blockLength are shortened by hashing them
    if (key.length > sink.blockLength) {
      sink.add(key);
      key = sink.digest().bytes;
      sink.reset();
    }

    // Calculated padded key for inner sink
    for (i = 0; i < key.length; i++) {
      paddedKey[i] = key[i] ^ 0x36;
    }
    for (; i < paddedKey.length; i++) {
      paddedKey[i] = 0x36;
    }
    sink.add(paddedKey);

    // Calculated padded key for outer sink
    for (i = 0; i < key.length; i++) {
      paddedKey[i] = key[i] ^ 0x5c;
    }
    for (; i < paddedKey.length; i++) {
      paddedKey[i] = 0x5c;
    }

    return HMACSink._(sink, paddedKey);
  }

  @override
  bool get closed => _closed;

  @override
  int get hashLength => sink.hashLength;

  @override
  void add(List<int> data, [int start = 0, int? end]) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }
    sink.add(data, start, end);
  }

  @override
  HashDigest digest() {
    if (_closed) {
      return _digest!;
    }
    _closed = true;
    var hash = sink.digest().bytes;
    sink.reset();
    sink.add(outerKey);
    sink.add(hash);
    return _digest = sink.digest();
  }
}
