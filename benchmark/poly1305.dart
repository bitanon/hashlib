// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/macs/poly1305.dart' as pc;

import 'base.dart';

Random random = Random();

final key = List.generate(16, (i) => random.nextInt(256));
final secret = List.generate(16, (i) => random.nextInt(256));

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.poly1305(input, key, secret);
  }
}

class PointyCastleBenchmark extends Benchmark {
  Uint8List _key = Uint8List(32);
  Uint8List _input = Uint8List(0);
  PointyCastleBenchmark(int size, int iter) : super('PointyCastle', size, iter);

  @override
  void setup() {
    super.setup();
    _input = Uint8List.fromList(input);
    _key = Uint8List.fromList([...key, ...secret]);
  }

  @override
  void run() {
    final d = pc.Poly1305();
    d.init(KeyParameter(_key));
    d.process(_input);
  }
}

void main() {
  print('------- Poly1305 --------');
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
      PointyCastleBenchmark(size, iter),
    ]);
    print('');
  }
}
