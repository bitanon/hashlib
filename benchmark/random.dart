// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';

import 'base.dart';

class HashlibBenchmark extends Benchmark {
  final random = KeccakRandom();
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextBool();
    }
  }
}

class RandomBenchmark extends Benchmark {
  final random = Random(56468882);
  RandomBenchmark(int size, int iter) : super('Random', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextBool();
    }
  }
}

class SecureRandomBenchmark extends Benchmark {
  final random = Random.secure();
  SecureRandomBenchmark(int size, int iter)
      : super('Random.secure', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextBool();
    }
  }
}

void main() {
  print('--------- Random ----------');
  final conditions = [
    [5 << 20, 10],
    [1 << 10, 5000],
    [10, 100000],
  ];
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    print('---- size: ${formatSize(size)} | iterations: $iter ----');
    HashlibBenchmark(size, iter).showDiff([
      RandomBenchmark(size, iter),
      SecureRandomBenchmark(size, iter),
    ]);
    print('');
  }
}
