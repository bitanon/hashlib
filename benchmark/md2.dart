// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart' as hashlib;

import '_base.dart';

Random random = Random();

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.md2.convert(input).bytes;
  }
}

void main() {
  print('--------- MD2 ----------');
  final conditions = [
    [5 << 20, 10],
    [1 << 10, 5000],
    [10, 100000],
  ];
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    print('---- size: ${formatSize(size)} | iterations: $iter ----');
    HashlibBenchmark(size, iter).measureRate();
    print('');
  }
}
