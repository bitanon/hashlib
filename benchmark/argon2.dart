// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:hashlib/hashlib.dart';

Random random = Random();

class Argon2iBenchmark extends BenchmarkBase {
  final Argon2Security security;

  Argon2iBenchmark(this.security) : super('argon2i[${security.name}]');

  @override
  void run() {
    argon2i(
      'password'.codeUnits,
      'some salt'.codeUnits,
      security: security,
    );
  }
}

class Argon2dBenchmark extends BenchmarkBase {
  final Argon2Security security;

  Argon2dBenchmark(this.security) : super('argon2d[${security.name}]');

  @override
  void run() {
    argon2d(
      'password'.codeUnits,
      'some salt'.codeUnits,
      security: security,
    );
  }
}

class Argon2idBenchmark extends BenchmarkBase {
  final Argon2Security security;

  Argon2idBenchmark(this.security) : super('argon2id[${security.name}]');

  @override
  void run() {
    argon2id(
      'password'.codeUnits,
      'some salt'.codeUnits,
      security: security,
    );
  }
}

void main() {
  print('--------- Argon2i ----------');
  final watch = Stopwatch()..start();
  Argon2iBenchmark(Argon2Security.test).run();
  print('argon2i[test]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2iBenchmark(Argon2Security.small).run();
  print('argon2i[small]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2iBenchmark(Argon2Security.moderate).run();
  print('argon2i[moderate]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2iBenchmark(Argon2Security.good).run();
  print('argon2i[good]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2iBenchmark(Argon2Security.strong).run();
  print('argon2i[strong]: ${watch.elapsedMicroseconds / 1000} ms');
  print('');

  print('--------- Argon2d ----------');
  watch.reset();
  Argon2dBenchmark(Argon2Security.test).run();
  print('argon2d[test]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2dBenchmark(Argon2Security.small).run();
  print('argon2d[small]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2dBenchmark(Argon2Security.moderate).run();
  print('argon2d[moderate]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2dBenchmark(Argon2Security.good).run();
  print('argon2d[good]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2dBenchmark(Argon2Security.strong).run();
  print('argon2d[strong]: ${watch.elapsedMicroseconds / 1000} ms');
  print('');

  print('--------- Argon2id ----------');
  watch.reset();
  Argon2idBenchmark(Argon2Security.test).run();
  print('argon2id[test]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2idBenchmark(Argon2Security.small).run();
  print('argon2id[small]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2idBenchmark(Argon2Security.moderate).run();
  print('argon2id[moderate]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2idBenchmark(Argon2Security.good).run();
  print('argon2id[good]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2idBenchmark(Argon2Security.strong).run();
  print('argon2id[strong]: ${watch.elapsedMicroseconds / 1000} ms');
  print('');
}
