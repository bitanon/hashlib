// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// This implementation is derived from the RFC document
/// [HMAC: Keyed-Hashing for Message Authentication][rfc2104].
///
/// [rfc2104]: https://www.ietf.org/rfc/rfc2104.html
class HMACSink<T extends BlockHashBase> extends MACSinkBase {
  final BlockHashSink _sink;

  @override
  late final int hashLength = _sink.hashLength;

  late final innerKey = Uint8List(_sink.blockLength);
  late final outerKey = Uint8List(_sink.blockLength);

  HMACSink(
    T algo,
    List<int> keyBytes,
  ) : _sink = algo.createSink() {
    var key = keyBytes is Uint8List ? keyBytes : Uint8List.fromList(keyBytes);

    // Keys longer than blockLength are shortened by hashing them
    if (key.length > _sink.blockLength) {
      _sink.reset();
      _sink.add(key);
      key = _sink.$finalize();
    }

    // Calculated padded keys for inner and outer sinks
    int i = 0;
    for (; i < key.length; i++) {
      innerKey[i] = key[i] ^ 0x36;
      outerKey[i] = key[i] ^ 0x5c;
    }
    for (; i < _sink.blockLength; i++) {
      innerKey[i] = 0x36;
      outerKey[i] = 0x5c;
    }

    _sink.reset();
    _sink.add(innerKey);
  }

  @override
  void reset() {
    _sink.reset();
    _sink.add(innerKey);
    super.reset();
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    _sink.$process(chunk, start, end);
  }

  @override
  Uint8List $finalize() {
    var hash = _sink.$finalize();
    _sink.reset();
    _sink.add(outerKey);
    _sink.add(hash);
    return _sink.$finalize();
  }
}
