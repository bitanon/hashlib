// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// This implementation is derived from the RFC document
/// [HMAC: Keyed-Hashing for Message Authentication][rfc2104].
///
/// [rfc2104]: https://www.ietf.org/rfc/rfc2104.html
class HMACSink extends HashDigestSink with MACSinkBase {
  final BlockHashSink sink;
  final Uint8List innerKey;
  final Uint8List outerKey;

  HashDigest? _digest;
  bool _closed = false;
  bool _initialized = false;

  HMACSink(this.sink)
      : innerKey = Uint8List(sink.blockLength),
        outerKey = Uint8List(sink.blockLength);

  @override
  void init(List<int> key) {
    // Keys longer than blockLength are shortened by hashing them
    if (key.length > sink.blockLength) {
      sink.reset();
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

    sink.reset();
    sink.add(innerKey);
    _initialized = true;
  }

  @override
  bool get closed => _closed;

  @override
  int get hashLength => sink.hashLength;

  /// The internal block length of the algorithm in bytes
  int get blockLength => sink.blockLength;

  /// The message length in bytes
  int get messageLength => sink.messageLength;

  @override
  void reset() {
    if (!_initialized) {
      throw StateError('The MAC instance is not initialized');
    }
    _closed = false;
    _digest = null;
    sink.reset();
    sink.add(innerKey);
  }

  @override
  void add(List<int> data, [int start = 0, int? end]) {
    if (!_initialized) {
      throw StateError('The MAC instance is not initialized');
    }
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }
    sink.add(data, start, end);
  }

  @override
  HashDigest digest() {
    if (!_initialized) {
      throw StateError('The MAC instance is not initialized');
    }
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
