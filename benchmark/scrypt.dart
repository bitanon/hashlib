// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:hashlib/hashlib.dart';

Random random = Random();

class ScryptBenchmarkBase extends BenchmarkBase {
  final ScryptSecurity security;

  ScryptBenchmarkBase(String name, this.security) : super(name);

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
  HashlibBenchmark(ScryptSecurity security) : super('hashlib', security);

  @override
  void run() {
    scrypt(
      'long password'.codeUnits,
      'secret salt'.codeUnits,
      security: security,
      dklen: 64,
    );
  }
}

void main() {
  double runtime;
  print('--------- Hashlib/SCRYPT ----------');
  runtime = HashlibBenchmark(ScryptSecurity.test).measure();
  print('hashlib/scrypt[test]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.little).measure();
  print('hashlib/scrypt[little]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.moderate).measure();
  print('hashlib/scrypt[moderate]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.good).measure();
  print('hashlib/scrypt[good]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.strong).measure();
  print('hashlib/scrypt[strong]: ${runtime / 1000} ms');
  print('');
}
