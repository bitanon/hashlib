// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hash/hash.dart' as hash;
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import 'base.dart';

Random random = Random();

final key = List.generate(64, (i) => random.nextInt(256));

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.HMAC(hashlib.md5, key).convert(input).bytes;
  }
}

class CryptoBenchmark extends Benchmark {
  CryptoBenchmark(int size, int iter) : super('crypto', size, iter);

  @override
  void run() {
    crypto.Hmac(crypto.md5, key).convert(input).bytes;
  }
}

class HashBenchmark extends Benchmark {
  HashBenchmark(int size, int iter) : super('hash', size, iter);

  @override
  void run() {
    hash.Hmac(hash.MD5(), key).update(input).digest();
  }
}

void main() {
  print('------- HMAC(MD5) --------');
  final conditions = [
    [10, 100000],
    [1000, 5000],
    [500000, 10],
  ];
  for (var condition in conditions) {
    int size = condition[0];
    int iter = condition[1];
    HashlibBenchmark(size, iter).showDiff([
      CryptoBenchmark(size, iter),
      HashBenchmark(size, iter),
    ]);
    print('');
  }
}
