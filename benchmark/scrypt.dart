// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:hashlib/hashlib.dart';

Random random = Random();

class ScryptBenchmarkBase extends BenchmarkBase {
  final int n;
  final int r;
  final int p;

  ScryptBenchmarkBase(String name, this.n, this.r, this.p) : super(name);

  @override
  double measure() {
    final watch = Stopwatch()..start();
    run();
    watch.reset();
    run();
    run();
    run();
    return (watch.elapsedMicroseconds / 3).floorToDouble();
  }
}

class HashlibBenchmark extends ScryptBenchmarkBase {
  HashlibBenchmark(int n, int r, int p) : super('hashlib', n, r, p);

  @override
  void run() {
    Scrypt(
      salt: 'secret salt'.codeUnits,
      cost: n,
      blockSize: r,
      parallelism: p,
      derivedKeyLength: 64,
    ).convert('long password'.codeUnits);
  }
}

void main() {
  double runtime;
  print('--------- Hashlib/SCRYPT ----------');
  runtime = HashlibBenchmark(1 << 4, 16, 4).measure();
  print('hashlib/scrypt[n=1<<4,r=16,p=4]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(1 << 8, 16, 4).measure();
  print('hashlib/scrypt[n=1<<8,r=16,p=4]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(1 << 12, 16, 4).measure();
  print('hashlib/scrypt[n=1<<12,r=16,p=4]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(1 << 15, 16, 4).measure();
  print('hashlib/scrypt[n=1<<15,r=16,p=4]: ${runtime / 1000} ms');
  print('');
}
