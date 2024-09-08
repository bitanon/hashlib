// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import '_base.dart';

Random random = Random();

final key = List.generate(128, (i) => random.nextInt(256));

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.HMAC(hashlib.sha256).by(key).convert(input).bytes;
  }
}

class CryptoBenchmark extends Benchmark {
  CryptoBenchmark(int size, int iter) : super('crypto', size, iter);

  @override
  void run() {
    crypto.Hmac(crypto.sha256, key).convert(input).bytes;
  }
}

void main() {
  print('------- HMAC(SHA-256) --------');
  final conditions = [
    [5 << 20, 10],
    [1 << 10, 5000],
    [10, 100000],
  ];
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    print('---- size: ${formatSize(size)} | iterations: $iter ----');
    HashlibBenchmark(size, iter).measureDiff([
      CryptoBenchmark(size, iter),
    ]);
    print('');
  }
}
