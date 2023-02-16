// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart' as hashlib;

import 'base.dart';

Random random = Random();

class XXH32Benchmark extends Benchmark {
  XXH32Benchmark(int size, int iter, [String name = 'XXH32'])
      : super(name, size, iter);

  @override
  void run() {
    hashlib.xxh32.convert(input).bytes;
  }
}

class XXH64Benchmark extends Benchmark {
  XXH64Benchmark(int size, int iter, [String name = 'XXH64'])
      : super(name, size, iter);

  @override
  void run() {
    hashlib.xxh64.convert(input).bytes;
  }
}

class XXH3Benchmark extends Benchmark {
  XXH3Benchmark(int size, int iter, [String name = 'XXH3'])
      : super(name, size, iter);

  @override
  void run() {
    hashlib.xxh3.convert(input).bytes;
  }
}

class XXH128Benchmark extends Benchmark {
  XXH128Benchmark(int size, int iter, [String name = 'XXH128'])
      : super(name, size, iter);

  @override
  void run() {
    hashlib.xxh128.convert(input).bytes;
  }
}

void main() {
  final conditions = [
    [1 << 9, 100000],
    [1 << 15, 1000],
    [1 << 23, 10],
  ];
  print('--------- XXH3 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH3Benchmark(size, iter).measureRate();
  }
  print('--------- XXH32 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH32Benchmark(size, iter).measureRate();
  }
  print('--------- XXH64 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH64Benchmark(size, iter).measureRate();
  }
  print('--------- XXH128 ----------');
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    XXH128Benchmark(size, iter).measureRate();
  }
}
