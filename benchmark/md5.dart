// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import '_utils.dart';

Random random = Random();

class HashlibMd5Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  HashlibMd5Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Hashlib] MD5');

  @override
  void setup() {}

  @override
  void run() {
    hashlib.md5buffer(input);
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

class CryptoMd5Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  CryptoMd5Benchmark(this.size, this.iter)
      : input = List<int>.generate(size, (i) => random.nextInt(256)),
        super('[Crypto] MD5');

  @override
  void setup() {}

  @override
  void run() {
    crypto.md5.convert(input).bytes;
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }
}

void main() {
  print('--------- MD5 ----------');
  showDiff([
    HashlibMd5Benchmark(17, 1000),
    CryptoMd5Benchmark(17, 1000),
  ]);
  print('');
  showDiff([
    HashlibMd5Benchmark(1777, 50),
    CryptoMd5Benchmark(1777, 50),
  ]);
  print('');
  showDiff([
    HashlibMd5Benchmark(111000, 1),
    CryptoMd5Benchmark(111000, 1),
  ]);
  print('');
}
