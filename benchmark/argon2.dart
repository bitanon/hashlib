// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:hashlib/hashlib.dart';

Random random = Random();

class Argon2iBenchmark extends BenchmarkBase {
  Argon2iBenchmark() : super('argon2i');

  @override
  void run() {
    final argon2 = Argon2Context(
      version: Argon2Version.v13,
      hashType: Argon2Type.argon2i,
      hashLength: 32,
      iterations: 8,
      parallelism: 4,
      memorySizeKB: 32768,
      salt: "some salt".codeUnits,
    ).toInstance();
    argon2.encode('password'.codeUnits);
  }
}

class Argon2dBenchmark extends BenchmarkBase {
  Argon2dBenchmark() : super('argon2d');

  @override
  void run() {
    final argon2 = Argon2Context(
      version: Argon2Version.v13,
      hashType: Argon2Type.argon2d,
      hashLength: 32,
      iterations: 8,
      parallelism: 4,
      memorySizeKB: 32768,
      salt: "some salt".codeUnits,
    ).toInstance();
    argon2.encode('password'.codeUnits);
  }
}

class Argon2idBenchmark extends BenchmarkBase {
  Argon2idBenchmark() : super('argon2id');

  @override
  void run() {
    final argon2 = Argon2Context(
      version: Argon2Version.v13,
      hashType: Argon2Type.argon2id,
      hashLength: 32,
      iterations: 8,
      parallelism: 4,
      memorySizeKB: 32768,
      salt: "some salt".codeUnits,
    ).toInstance();
    argon2.encode('password'.codeUnits);
  }
}

void main() {
  print('--------- Argon2i ----------');
  final watch = Stopwatch()..start();
  Argon2iBenchmark().run();
  print('argon2i: ${watch.elapsedMilliseconds} ms');

  print('--------- Argon2d ----------');
  watch.reset();
  Argon2dBenchmark().run();
  print('argon2d: ${watch.elapsedMilliseconds} ms');

  print('--------- Argon2id ----------');
  watch.reset();
  Argon2idBenchmark().run();
  print('argon2id: ${watch.elapsedMilliseconds} ms');
}
