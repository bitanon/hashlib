// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:sha3/sha3.dart' as sha3;
import 'package:pointycastle/digests/sha3.dart' as pc;

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
    final d = pc.SHA3Digest(512);
    d.process(_input);
  }
}

void main() {
  print('--------- SHA3-512 ----------');
  final conditions = [
    [10, 100000],
    [1000, 5000],
    [500000, 10],
  ];
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    HashlibBenchmark(size, iter).showDiff([
      Sha3Benchmark(size, iter),
      PointyCastleBenchmark(size, iter),
    ]);
    print('');
  }
}
