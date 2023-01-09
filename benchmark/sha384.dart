// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hash/hash.dart' as hash;
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import 'base.dart';

Random random = Random();

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.sha384.convert(input).bytes;
  }
}

class CryptoBenchmark extends Benchmark {
  CryptoBenchmark(int size, int iter) : super('crypto', size, iter);

  @override
  void run() {
    crypto.sha384.convert(input).bytes;
  }
}

class HashBenchmark extends Benchmark {
  HashBenchmark(int size, int iter) : super('hash', size, iter);

  @override
  void run() {
    hash.SHA384().update(input).digest();
  }
}

void main() {
  print('--------- SHA-384 ----------');
  HashlibBenchmark(17, 1000).showDiff([
    CryptoBenchmark(17, 1000),
    HashBenchmark(17, 1000),
  ]);
  print('');
  HashlibBenchmark(7000, 100).showDiff([
    CryptoBenchmark(7000, 100),
    HashBenchmark(7000, 100),
  ]);
  print('');
  HashlibBenchmark(777000, 1).showDiff([
    CryptoBenchmark(777000, 1),
    HashBenchmark(777000, 1),
  ]);
  print('');
}
