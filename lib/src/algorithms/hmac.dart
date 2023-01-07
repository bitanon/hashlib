// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/hash_sink.dart';

/// This implementation is derived from the RFC document
/// [HMAC: Keyed-Hashing for Message Authentication][rfc2104].
///
/// [rfc2104]: https://www.rfc-editor.org/rfc/rfc2104
class HMACSink implements HashDigestSink {
  final HashSink algo;
  final List<int> outerKey;
  final List<int> innerKey;
  HashDigest? _digest;

  HMACSink(this.algo, List<int> key)
      : outerKey = List.filled(algo.blockLength, 0x5c),
        innerKey = List.filled(algo.blockLength, 0x36) {
    // Keys longer than blockLength are shortened by hashing them
    if (key.length > algo.blockLength) {
      algo.reset();
      algo.add(key);
      key = algo.digest().bytes;
    }

    // Calculated padded keys
    for (var i = 0; i < key.length; i++) {
      outerKey[i] ^= key[i];
      innerKey[i] ^= key[i];
    }

    // Append inner padding before original message
    algo.reset();
    algo.add(innerKey);
  }

  @override
  void reset() {
    _digest = null;
    algo.reset();
    algo.add(innerKey);
  }

  @override
  void add(List<int> data) {
    algo.add(data);
  }

  @override
  HashDigest digest() {
    if (_digest != null) {
      return _digest!;
    }

    var innerHash = algo.digest().bytes;

    algo.reset();
    algo.add(outerKey);
    algo.add(innerHash);

    _digest = algo.digest();
    return _digest!;
  }
}
