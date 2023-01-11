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
class HMACSink extends HashDigestSink {
  final BlockHashBase outerSink;
  final BlockHashBase innerSink;

  factory HMACSink(HashBase algo, List<int> key) {
    var outer = algo.startChunkedConversion();
    var inner = algo.startChunkedConversion();
    if (outer is! BlockHashBase || inner is! BlockHashBase) {
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
    outer.addSlice(paddedKey, 0, outer.blockLength);

    // Calculated padded key for inner sink
    for (var i = 0; i < key.length; i++) {
      paddedKey[i] = key[i] ^ 0x36;
    }
    for (var i = key.length; i < paddedKey.length; i++) {
      paddedKey[i] = 0x36;
    }
    inner.addSlice(paddedKey, 0, outer.blockLength);

    return HMACSink._(
      outerSink: outer,
      innerSink: inner,
    );
  }

  HMACSink._({
    required this.outerSink,
    required this.innerSink,
  }) : super(hashLength: outerSink.hashLength);

  @override
  bool get closed => outerSink.closed;

  @override
  void addSlice(List<int> chunk, int start, int end, [bool isLast = false]) {
    innerSink.addSlice(chunk, start, end, isLast);
  }

  @override
  HashDigest digest() {
    if (outerSink.closed) {
      return outerSink.digest();
    }
    outerSink.addSlice(
      innerSink.digest().bytes,
      0,
      innerSink.hashLength,
      true,
    );
    return outerSink.digest();
  }
}
