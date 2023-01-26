// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:argon2/argon2.dart' as argon2;
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:hashlib/hashlib.dart';

Random random = Random();

class HashlibArgon2iBenchmark extends BenchmarkBase {
  final Argon2Security security;

  HashlibArgon2iBenchmark(this.security) : super('hashlib');

  @override
  void run() {
    Argon2(
      hashLength: 24,
      iterations: security.t,
      memorySizeKB: security.m,
      parallelism: security.p,
      salt: 'some salt'.codeUnits,
      type: Argon2Type.argon2i,
    ).convert('password'.codeUnits);
  }
}

class HashlibArgon2dBenchmark extends BenchmarkBase {
  final Argon2Security security;

  HashlibArgon2dBenchmark(this.security) : super('hashlib');

  @override
  void run() {
    Argon2(
      hashLength: 24,
      iterations: security.t,
      memorySizeKB: security.m,
      parallelism: security.p,
      salt: 'some salt'.codeUnits,
      type: Argon2Type.argon2d,
    ).convert('password'.codeUnits);
  }
}

class HashlibArgon2idBenchmark extends BenchmarkBase {
  final Argon2Security security;

  HashlibArgon2idBenchmark(this.security) : super('hashlib');

  @override
  void run() {
    Argon2(
      hashLength: 24,
      iterations: security.t,
      memorySizeKB: security.m,
      parallelism: security.p,
      salt: 'some salt'.codeUnits,
      type: Argon2Type.argon2id,
    ).convert('password'.codeUnits);
  }
}

class Argon2Argon2idBenchmark extends BenchmarkBase {
  final Argon2Security security;

  Argon2Argon2idBenchmark(this.security) : super('argon2');

  @override
  void run() {
    var password = 'password'.toBytesLatin1();
    var salt = 'some salt'.toBytesLatin1();
    var parameters = argon2.Argon2Parameters(
      argon2.Argon2Parameters.ARGON2_id,
      salt,
      version: argon2.Argon2Parameters.ARGON2_VERSION_13,
      iterations: security.t,
      memory: security.m,
      lanes: security.p,
    );
    var instance = argon2.Argon2BytesGenerator();
    instance.init(parameters);
    var res = Uint8List(24);
    instance.generateBytes(password, res, 0, res.length);
  }
}

void main() {
  final watch = Stopwatch()..start();
  print('--------- Argon2i ----------');
  watch.reset();
  HashlibArgon2iBenchmark(Argon2Security.test).run();
  print('hashlib/argon2i[test]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2iBenchmark(Argon2Security.little).run();
  print('hashlib/argon2i[little]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2iBenchmark(Argon2Security.moderate).run();
  print('hashlib/argon2i[moderate]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2iBenchmark(Argon2Security.good).run();
  print('hashlib/argon2i[good]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2iBenchmark(Argon2Security.strong).run();
  print('hashlib/argon2i[strong]: ${watch.elapsedMicroseconds / 1000} ms');
  print('');

  print('--------- Argon2d ----------');
  watch.reset();
  HashlibArgon2dBenchmark(Argon2Security.test).run();
  print('hashlib/argon2d[test]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2dBenchmark(Argon2Security.little).run();
  print('hashlib/argon2d[little]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2dBenchmark(Argon2Security.moderate).run();
  print('hashlib/argon2d[moderate]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2dBenchmark(Argon2Security.good).run();
  print('hashlib/argon2d[good]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2dBenchmark(Argon2Security.strong).run();
  print('hashlib/argon2d[strong]: ${watch.elapsedMicroseconds / 1000} ms');
  print('');

  print('--------- Argon2id ----------');
  watch.reset();
  HashlibArgon2idBenchmark(Argon2Security.test).run();
  print('hashlib/argon2id[test]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2idBenchmark(Argon2Security.little).run();
  print('hashlib/argon2id[little]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2idBenchmark(Argon2Security.moderate).run();
  print('hashlib/argon2id[moderate]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2idBenchmark(Argon2Security.good).run();
  print('hashlib/argon2id[good]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  HashlibArgon2idBenchmark(Argon2Security.strong).run();
  print('hashlib/argon2id[strong]: ${watch.elapsedMicroseconds / 1000} ms');
  print('');

  print('--------- Other argon2 argon2id ----------');
  watch.reset();
  Argon2Argon2idBenchmark(Argon2Security.test).run();
  print('argon2/argon2id[test]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2Argon2idBenchmark(Argon2Security.little).run();
  print('argon2/argon2id[little]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2Argon2idBenchmark(Argon2Security.moderate).run();
  print('argon2/argon2id[moderate]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2Argon2idBenchmark(Argon2Security.good).run();
  print('argon2/argon2id[good]: ${watch.elapsedMicroseconds / 1000} ms');
  watch.reset();
  Argon2Argon2idBenchmark(Argon2Security.strong).run();
  print('argon2/argon2id[strong]: ${watch.elapsedMicroseconds / 1000} ms');
  print('');
}
