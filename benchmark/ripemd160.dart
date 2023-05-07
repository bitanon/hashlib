// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hash/hash.dart' as hash;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:pointycastle/digests/ripemd160.dart' as pc;

import 'base.dart';

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.ripemd160.convert(input).bytes;
  }
}

class HashBenchmark extends Benchmark {
  HashBenchmark(int size, int iter) : super('hash', size, iter);

  @override
  void run() {
    hash.RIPEMD160().update(input).digest();
  }
}

class PointyCastleBenchmark extends Benchmark {
  Uint8List _input = Uint8List(0);
  PointyCastleBenchmark(int size, int iter) : super('PointyCastle', size, iter);

  @override
  void setup() {
    super.setup();
    _input = Uint8List.fromList(input);
  }

  @override
  void run() {
    final d = pc.RIPEMD160Digest();
    d.process(_input);
  }
}

void main() {
  print('--------- RIPEMD-160 ----------');
  final conditions = [
    [10, 100000],
    [1000, 5000],
    [500000, 10],
  ];
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    print('---- size=$size | iterations: $iter ----');
    HashlibBenchmark(size, iter).showDiff([
      HashBenchmark(size, iter),
      PointyCastleBenchmark(size, iter),
    ]);
    print('');
  }
}
