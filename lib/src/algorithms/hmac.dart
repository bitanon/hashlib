// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// HMAC is a hash-based message authentication code that can be used to
/// simultaneously verify both the data integrity and authenticity of a message.
class HMAC extends MACHashBase {
  final BlockHashBase algo;
  late final Uint8List innerKey;
  late final Uint8List outerKey;

  @override
  final String name;

  @override
  List<int>? key;

  bool _initialized = false;

  HMAC(this.algo, [List<int>? key]) : name = 'HMAC/${algo.name}' {
    if (key != null) init(key);
  }

  @override
  void init(List<int> key) {
    this.key = key;
    final sink = algo.createSink();
    innerKey = Uint8List(sink.blockLength);
    outerKey = Uint8List(sink.blockLength);

    // Keys longer than blockLength are shortened by hashing them
    if (key.length > sink.blockLength) {
      sink.add(key);
      key = sink.digest().bytes;
    }

    // Calculated padded keys for inner and outer sinks
    int i = 0;
    for (; i < key.length; i++) {
      innerKey[i] = key[i] ^ 0x36;
      outerKey[i] = key[i] ^ 0x5c;
    }
    for (; i < sink.blockLength; i++) {
      innerKey[i] = 0x36;
      outerKey[i] = 0x5c;
    }

    _initialized = true;
  }

  @override
  MACSinkBase createSink() {
    if (!_initialized) {
      throw StateError('The MAC is not initialized with a key');
    }
    return _HMACSink(algo.createSink(), innerKey, outerKey);
  }
}

/// This implementation is derived from the RFC document
/// [HMAC: Keyed-Hashing for Message Authentication][rfc2104].
///
/// [rfc2104]: https://www.ietf.org/rfc/rfc2104.html
class _HMACSink implements MACSinkBase {
  final BlockHashSink sink;
  final Uint8List innerKey;
  final Uint8List outerKey;

  @override
  final int hashLength;

  _HMACSink(this.sink, this.innerKey, this.outerKey)
      : hashLength = sink.hashLength {
    reset();
  }

  @override
  void reset() {
    sink.reset();
    sink.add(innerKey);
  }

  @override
  void add(List<int> data, [int start = 0, int? end]) =>
      sink.add(data, start, end);

  @override
  bool get closed => sink.closed;

  @override
  void close() => digest();

  @override
  HashDigest digest() {
    final hash = sink.digest().bytes;
    sink.reset();
    sink.add(outerKey);
    sink.add(hash);
    return sink.digest();
  }
}
