// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import 'base.dart';

Random random = Random();

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('Hashlib', size, iter);

  @override
  void run() {
    hashlib.sha512256.convert(input).bytes;
  }
}

class CryptoBenchmark extends Benchmark {
  CryptoBenchmark(int size, int iter) : super('Crypto', size, iter);

  @override
  void run() {
    crypto.sha512256.convert(input).bytes;
  }
}

void main() {
  print('--------- SHA-512 ----------');
  HashlibBenchmark(17, 1000).showDiff([
    CryptoBenchmark(17, 1000),
  ]);
  print('');
  HashlibBenchmark(1777, 50).showDiff([
    CryptoBenchmark(1777, 50),
  ]);
  print('');
  HashlibBenchmark(111000, 1).showDiff([
    CryptoBenchmark(111000, 1),
  ]);
  print('');
}
