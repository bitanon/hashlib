// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hash/hash.dart' as hash;
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:pointycastle/digests/sha224.dart' as pc;

import 'base.dart';

Random random = Random();

class HashlibBenchmark extends Benchmark {
  HashlibBenchmark(int size, int iter) : super('hashlib', size, iter);

  @override
  void run() {
    hashlib.sha224.convert(input).bytes;
  }
}

class CryptoBenchmark extends Benchmark {
  CryptoBenchmark(int size, int iter) : super('crypto', size, iter);

  @override
  void run() {
    crypto.sha224.convert(input).bytes;
  }
}

class HashBenchmark extends Benchmark {
  HashBenchmark(int size, int iter) : super('hash', size, iter);

  @override
  void run() {
    hash.SHA224().update(input).digest();
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
    final d = pc.SHA224Digest();
    d.process(_input);
  }
}

void main() {
  print('--------- SHA-224 ----------');
  HashlibBenchmark(17, 1000).showDiff([
    CryptoBenchmark(17, 1000),
    HashBenchmark(17, 1000),
    PointyCastleBenchmark(17, 1000),
  ]);
  print('');
  HashlibBenchmark(7000, 100).showDiff([
    CryptoBenchmark(7000, 100),
    HashBenchmark(7000, 100),
    PointyCastleBenchmark(7000, 100),
  ]);
  print('');
  HashlibBenchmark(777000, 1).showDiff([
    CryptoBenchmark(777000, 1),
    HashBenchmark(777000, 1),
    PointyCastleBenchmark(777000, 1),
  ]);
  print('');
}
