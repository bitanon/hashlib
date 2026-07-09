// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart' as hashlib;

import '_base.dart';

class HashlibBenchmark extends SyncBenchmark {
  final List<int> input;
  HashlibBenchmark(int size)
      : input = List.filled(size, 0x3f),
        super('hashlib', size);

  @override
  dynamic run() {
    return hashlib.blake2s256.convert(input).bytes;
  }
}

void main() async {
  print('--------- BLAKE-2s ----------');
  for (int size in [5 << 20, 1 << 10, 10]) {
    print('---- message: ${formatSize(size)} ----');
    await HashlibBenchmark(size).measureRate();
    print('');
  }
}
