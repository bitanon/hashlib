// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import 'base.dart';

Random random = Random();

final key = List.generate(128, (i) => random.nextInt(256));

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.HMAC(hashlib.sha256, key).convert(input).bytes;
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
  HashlibBenchmark(17, 1000).showDiff([
    CryptoBenchmark(17, 1000),
  ]);
  print('');
  HashlibBenchmark(7000, 100).showDiff([
    CryptoBenchmark(7000, 100),
  ]);
  print('');
  HashlibBenchmark(777000, 1).showDiff([
    CryptoBenchmark(777000, 1),
  ]);
  print('');
}
