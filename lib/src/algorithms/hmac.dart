// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// This implementation is derived from the RFC document
/// [HMAC: Keyed-Hashing for Message Authentication][rfc2104].
///
/// [rfc2104]: https://www.rfc-editor.org/rfc/rfc2104
class HMACSink implements HashDigestSink {
  final BlockHash outer;
  final BlockHash inner;

  factory HMACSink(HashBase algo, List<int> key) {
    var outer = algo.createSink();
    var inner = algo.createSink();
    if (outer is! BlockHash || inner is! BlockHash) {
      throw StateError('Only block hashes are supported for HMAC');
    }

    var paddedKey = Uint8List(outer.blockLength);

    // Keys longer than blockLength are shortened by hashing them
    if (key.length > outer.blockLength) {
      key = algo.convert(key).bytes;
    }

    // Calculated padded key for outer sink
    for (var i = 0; i < key.length; i++) {
      paddedKey[i] = key[i] ^ 0x5c;
    }
    for (var i = key.length; i < paddedKey.length; i++) {
      paddedKey[i] = 0x5c;
    }
    outer.add(paddedKey);

    // Calculated padded key for inner sink
    for (var i = 0; i < key.length; i++) {
      paddedKey[i] = key[i] ^ 0x36;
    }
    for (var i = key.length; i < paddedKey.length; i++) {
      paddedKey[i] = 0x36;
    }
    inner.add(paddedKey);

    return HMACSink._(
      outer: outer,
      inner: inner,
    );
  }

  HMACSink._({
    required this.outer,
    required this.inner,
  });

  @override
  bool get closed => outer.closed;

  @override
  int get hashLength => outer.hashLength;

  @override
  void add(List<int> data, [int start = 0, int? end]) {
    inner.add(data, start, end);
  }

  @override
  HashDigest digest() {
    if (!outer.closed) {
      outer.add(inner.digest().bytes);
    }
    return outer.digest();
  }
}
