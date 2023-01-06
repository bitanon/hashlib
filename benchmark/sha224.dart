// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import '_utils.dart';

Random random = Random();

class HashlibSha224Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  HashlibSha224Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Hashlib] SHA224');

  @override
  void run() {
    hashlib.sha224buffer(input);
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

class CryptoSha224Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  CryptoSha224Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Crypto] SHA224');

  @override
  void run() {
    crypto.sha224.convert(input).bytes;
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

void main() {
  print('--------- SHA224 ----------');
  showDiff([
    HashlibSha224Benchmark(17, 1000),
    CryptoSha224Benchmark(17, 1000),
  ]);
  print('');
  showDiff([
    HashlibSha224Benchmark(1777, 50),
    CryptoSha224Benchmark(1777, 50),
  ]);
  print('');
  showDiff([
    HashlibSha224Benchmark(111000, 1),
    CryptoSha224Benchmark(111000, 1),
  ]);
  print('');
}
