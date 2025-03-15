// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

/// Stub for 32-bit machines.
class XXH3Sink128bit extends BlockHashSink {
  @override
  final int hashLength = 16;

  factory XXH3Sink128bit.withSeed(int seed) {
    seed;
    throw UnimplementedError('XXH3-128 is not supported in Node platform');
  }

  factory XXH3Sink128bit.withSecret([List<int>? secret]) {
    secret;
    throw UnimplementedError('XXH3-128 is not supported in Node platform');
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    throw UnimplementedError('XXH3-128 is not supported in Node platform');
  }

  @override
  Uint8List $finalize() {
    throw UnimplementedError('XXH3-128 is not supported in Node platform');
  }
}
