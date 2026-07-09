// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart' as hashlib;

import '_base.dart';

class XXH32Benchmark extends SyncBenchmark {
  final List<int> input;
  XXH32Benchmark(int size, [String name = 'XXH32'])
      : input = List.filled(size, 0x3f),
        super(name, size);

  @override
  dynamic run() {
    return hashlib.xxh32.convert(input).bytes;
  }
}

class XXH64Benchmark extends SyncBenchmark {
  final List<int> input;
  XXH64Benchmark(int size, [String name = 'XXH64'])
      : input = List.filled(size, 0x3f),
        super(name, size);

  @override
  dynamic run() {
    return hashlib.xxh64.convert(input).bytes;
  }
}

class XXH3Benchmark extends SyncBenchmark {
  final List<int> input;
  XXH3Benchmark(int size, [String name = 'XXH3'])
      : input = List.filled(size, 0x3f),
        super(name, size);

  @override
  dynamic run() {
    return hashlib.xxh3.convert(input).bytes;
  }
}

class XXH128Benchmark extends SyncBenchmark {
  final List<int> input;
  XXH128Benchmark(int size, [String name = 'XXH128'])
      : input = List.filled(size, 0x3f),
        super(name, size);

  @override
  dynamic run() {
    return hashlib.xxh128.convert(input).bytes;
  }
}

void main() async {
  final sizes = [1 << 9, 1 << 15, 1 << 23];
  print('--------- XXH3 ----------');
  for (int size in sizes) {
    await XXH3Benchmark(size).measureRate();
  }
  print('--------- XXH32 ----------');
  for (int size in sizes) {
    await XXH32Benchmark(size).measureRate();
  }
  print('--------- XXH64 ----------');
  for (int size in sizes) {
    await XXH64Benchmark(size).measureRate();
  }
  print('--------- XXH128 ----------');
  for (int size in sizes) {
    await XXH128Benchmark(size).measureRate();
  }
}
