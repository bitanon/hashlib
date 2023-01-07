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
    hashlib.sha256.convert(input).bytes;
  }
}

class CryptoBenchmark extends Benchmark {
  CryptoBenchmark(int size, int iter) : super('crypto', size, iter);

  @override
  void run() {
    crypto.sha256.convert(input).bytes;
  }
}

class HashBenchmark extends Benchmark {
  HashBenchmark(int size, int iter) : super('hash', size, iter);

  @override
  void run() {
    hash.SHA256().update(input).digest();
  }
}

void main() {
  print('--------- SHA-256 ----------');
  HashlibBenchmark(17, 1000).showDiff([
    CryptoBenchmark(17, 1000),
    HashBenchmark(17, 1000),
  ]);
  print('');
  HashlibBenchmark(1777, 50).showDiff([
    CryptoBenchmark(1777, 50),
    HashBenchmark(1777, 50),
  ]);
  print('');
  HashlibBenchmark(111000, 1).showDiff([
    CryptoBenchmark(111000, 1),
    HashBenchmark(111000, 1),
  ]);
  print('');
}
