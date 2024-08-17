// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

class XXHash64Sink extends BlockHashSink {
  @override
  final int hashLength = 8;

  XXHash64Sink(int seed) : super(32) {
    seed;
    throw UnimplementedError('XXHash64 is not supported in Node platform');
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    throw UnimplementedError('XXHash64 is not supported in Node platform');
  }

  @override
  Uint8List $finalize() {
    throw UnimplementedError('XXHash64 is not supported in Node platform');
  }
}
