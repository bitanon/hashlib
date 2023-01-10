// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:sha3/sha3.dart' as sha3;

import 'base.dart';

Random random = Random();

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.sha512.convert(input).bytes;
  }
}

class Sha3Benchmark extends Benchmark {
  Sha3Benchmark(int size, int iter) : super('sha3', size, iter);

  @override
  void run() {
    sha3.SHA3(512, sha3.SHA3_PADDING, 512)
      ..update(input)
      ..digest();
  }
}

void main() {
  print('--------- SHA3-512 ----------');
  HashlibBenchmark(17, 1000).showDiff([
    Sha3Benchmark(17, 1000),
  ]);
  print('');
  HashlibBenchmark(1777, 50).showDiff([
    Sha3Benchmark(1777, 50),
  ]);
  print('');
  HashlibBenchmark(111000, 1).showDiff([
    Sha3Benchmark(111000, 1),
  ]);
  print('');
}
