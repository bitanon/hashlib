// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

class XXH3Sink64bit extends BlockHashSink {
  @override
  final int hashLength = 8;

  factory XXH3Sink64bit.withSeed(int seed) {
    throw UnimplementedError('XXH3 is not supported in Node platform');
  }

  factory XXH3Sink64bit.withSecret([List<int>? secret]) {
    throw UnimplementedError('XXH3 is not supported in Node platform');
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    throw UnimplementedError('XXH3 is not supported in Node platform');
  }

  @override
  Uint8List $finalize() {
    throw UnimplementedError('XXH3 is not supported in Node platform');
  }
}
