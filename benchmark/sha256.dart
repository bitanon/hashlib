// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import '_utils.dart';

Random random = Random();

class HashlibSha256Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  HashlibSha256Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Hashlib] SHA256');

  @override
  void run() {
    hashlib.sha256buffer(input);
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

class CryptoSha256Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  CryptoSha256Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Crypto] SHA256');

  @override
  void run() {
    crypto.sha256.convert(input).bytes;
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

void main() {
  print('--------- SHA256 ----------');
  showDiff([
    HashlibSha256Benchmark(17, 1000),
    CryptoSha256Benchmark(17, 1000),
  ]);
  print('');
  showDiff([
    HashlibSha256Benchmark(1777, 50),
    CryptoSha256Benchmark(1777, 50),
  ]);
  print('');
  showDiff([
    HashlibSha256Benchmark(111000, 1),
    CryptoSha256Benchmark(111000, 1),
  ]);
  print('');
}
