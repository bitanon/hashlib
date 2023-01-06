// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import '_utils.dart';

Random random = Random();

class HashlibSha1Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  HashlibSha1Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Hashlib] SHA1');

  @override
  void run() {
    hashlib.sha1buffer(input);
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

class CryptoSha1Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  CryptoSha1Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Crypto] SHA1');

  @override
  void run() {
    crypto.sha1.convert(input).bytes;
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

void main() {
  print('--------- SHA1 ----------');
  showDiff([
    HashlibSha1Benchmark(17, 1000),
    CryptoSha1Benchmark(17, 1000),
  ]);
  print('');
  showDiff([
    HashlibSha1Benchmark(1777, 50),
    CryptoSha1Benchmark(1777, 50),
  ]);
  print('');
  showDiff([
    HashlibSha1Benchmark(111000, 1),
    CryptoSha1Benchmark(111000, 1),
  ]);
  print('');
}
