// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// This implementation is derived from the RFC document
/// [HMAC: Keyed-Hashing for Message Authentication][rfc2104].
///
/// [rfc2104]: https://www.ietf.org/rfc/rfc2104.html
class HMACSink extends HashDigestSink with MACSinkBase {
  final BlockHashSink sink;
  final Uint8List innerKey;
  final Uint8List outerKey;

  /// The internal block length of the algorithm in bytes
  final int blockLength;

  /// The message length in bytes
  final int messageLength;

  bool _initialized = false;

  HMACSink(this.sink)
      : blockLength = sink.blockLength,
        messageLength = sink.messageLength,
        innerKey = Uint8List(sink.blockLength),
        outerKey = Uint8List(sink.blockLength);

  @override
  bool get initialized => _initialized;

  @override
  int get hashLength => sink.hashLength;

  @override
  void init(List<int> key) {
    // Keys longer than blockLength are shortened by hashing them
    if (key.length > blockLength) {
      sink.reset();
      sink.add(key);
      key = sink.$finalize();
    }

    // Calculated padded keys for inner and outer sinks
    int i = 0;
    for (; i < key.length; i++) {
      innerKey[i] = key[i] ^ 0x36;
      outerKey[i] = key[i] ^ 0x5c;
    }
    for (; i < blockLength; i++) {
      innerKey[i] = 0x36;
      outerKey[i] = 0x5c;
    }

    sink.reset();
    sink.add(innerKey);
    _initialized = true;
  }

  @override
  void reset() {
    if (!_initialized) {
      throw StateError('The instance is not yet initialized with a key');
    }
    sink.reset();
    sink.add(innerKey);
    super.reset();
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    if (!_initialized) {
      throw StateError('The instance is not yet initialized with a key');
    }
    sink.$process(chunk, start, end);
  }

  @override
  Uint8List $finalize() {
    if (!_initialized) {
      throw StateError('The instance is not yet initialized with a key');
    }
    var hash = sink.$finalize();
    sink.reset();
    sink.add(outerKey);
    sink.add(hash);
    return sink.$finalize();
  }
}
