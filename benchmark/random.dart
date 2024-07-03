// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';

import 'base.dart';

const int _maxInt = 0xFFFFFFFF;

class SystemRandomBenchmark extends Benchmark {
  final random = HashlibRandom(RandomGenerator.system);
  SystemRandomBenchmark(int size, int iter) : super('system', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt();
    }
  }
}

class SecureRandomBenchmark extends Benchmark {
  final random = HashlibRandom(RandomGenerator.secure);
  SecureRandomBenchmark(int size, int iter) : super('secure', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt();
    }
  }
}

class KeccakRandomBenchmark extends Benchmark {
  final random = HashlibRandom(RandomGenerator.keccak);
  KeccakRandomBenchmark(int size, int iter) : super('keccak', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt();
    }
  }
}

class SHA256RandomBenchmark extends Benchmark {
  final random = HashlibRandom(RandomGenerator.sha256);
  SHA256RandomBenchmark(int size, int iter) : super('sha256', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt();
    }
  }
}

class SM3RandomBenchmark extends Benchmark {
  final random = HashlibRandom(RandomGenerator.sm3);
  SM3RandomBenchmark(int size, int iter) : super('sm3', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt();
    }
  }
}

class XXH64RandomBenchmark extends Benchmark {
  final random = HashlibRandom(RandomGenerator.xxh64);
  XXH64RandomBenchmark(int size, int iter) : super('xxh64', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt();
    }
  }
}

class RandomBenchmark extends Benchmark {
  final random = Random(56468882);
  RandomBenchmark(int size, int iter) : super('Random', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt(_maxInt);
    }
  }
}

class SystemSecureRandomBenchmark extends Benchmark {
  final random = Random.secure();
  SystemSecureRandomBenchmark(int size, int iter)
      : super('Random.secure', size, iter);

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      random.nextInt(_maxInt);
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
    RandomBenchmark(size, iter).showDiff([
      SystemSecureRandomBenchmark(size, iter),
      SecureRandomBenchmark(size, iter),
      SystemRandomBenchmark(size, iter),
      KeccakRandomBenchmark(size, iter),
      SM3RandomBenchmark(size, iter),
      SHA256RandomBenchmark(size, iter),
      XXH64RandomBenchmark(size, iter),
    ]);
    print('');
  }
}
