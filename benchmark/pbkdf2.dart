// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:pointycastle/export.dart' show Pbkdf2Parameters;
import 'package:pointycastle/pointycastle.dart' as pc;

import 'base.dart';

Random random = Random();

final salt = Uint8List.fromList(List.generate(16, (i) => random.nextInt(256)));

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.sha256.pbkdf2(
      input,
      salt,
      iter,
      64,
    );
  }

  @override
  void exercise() {
    run();
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
    var out = Uint8List(64);
    var d = pc.KeyDerivator('SHA-256/HMAC/PBKDF2');
    d.init(Pbkdf2Parameters(salt, iter, 64));
    d.deriveKey(_input, 0, out, 0);
  }

  @override
  void exercise() {
    run();
  }
}

void main() {
  print('----- PBKDF2-HMAC(SHA256) -----');
  final conditions = [
    [32, 100000],
    [32, 1000],
    [32, 10],
  ];
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    print('---- size: ${formatSize(size)} | iterations: $iter ----');
    HashlibBenchmark(size, iter).showDiff([
      PointyCastleBenchmark(size, iter),
    ]);
    print('');
  }
}
