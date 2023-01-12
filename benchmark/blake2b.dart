// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:pointycastle/digests/blake2b.dart' as pc;

import 'base.dart';

Random random = Random();

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.blake2b512.convert(input).bytes;
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
    final d = pc.Blake2bDigest();
    d.process(_input);
  }
}

void main() {
  print('--------- BLAKE-2b ----------');
  HashlibBenchmark(17, 1000).showDiff([
    PointyCastleBenchmark(17, 1000),
  ]);
  print('');
  HashlibBenchmark(7000, 100).showDiff([
    PointyCastleBenchmark(7000, 100),
  ]);
  print('');
  HashlibBenchmark(777000, 1).showDiff([
    PointyCastleBenchmark(777000, 1),
  ]);
  print('');
}
