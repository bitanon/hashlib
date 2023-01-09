// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart' as hashlib;

import 'base.dart';

Random random = Random();

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.sha256.convert(input).bytes;
  }
}

void main() {
  print('--------- SHA3-256 ----------');
  HashlibBenchmark(17, 1000).showDiff([]);
  print('');
  HashlibBenchmark(1777, 50).showDiff([]);
  print('');
  HashlibBenchmark(111000, 1).showDiff([]);
  print('');
}
