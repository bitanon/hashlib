// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:argon2/argon2.dart' as argon2;
import 'package:hashlib/hashlib.dart';

import 'base.dart';

Random random = Random();

class HashlibArgon2iBenchmark extends KDFBenchmarkBase {
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

class HashlibArgon2dBenchmark extends KDFBenchmarkBase {
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

class HashlibArgon2idBenchmark extends KDFBenchmarkBase {
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

class Argon2Argon2idBenchmark extends KDFBenchmarkBase {
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
  double runtime;
  print('--------- Argon2i ----------');
  runtime = HashlibArgon2iBenchmark(Argon2Security.test).measure();
  print('hashlib/argon2i[test]: ${runtime / 1000} ms');
  runtime = HashlibArgon2iBenchmark(Argon2Security.little).measure();
  print('hashlib/argon2i[little]: ${runtime / 1000} ms');
  runtime = HashlibArgon2iBenchmark(Argon2Security.moderate).measure();
  print('hashlib/argon2i[moderate]: ${runtime / 1000} ms');
  runtime = HashlibArgon2iBenchmark(Argon2Security.good).measure();
  print('hashlib/argon2i[good]: ${runtime / 1000} ms');
  runtime = HashlibArgon2iBenchmark(Argon2Security.strong).measure();
  print('hashlib/argon2i[strong]: ${runtime / 1000} ms');
  print('');

  print('--------- Argon2d ----------');
  runtime = HashlibArgon2dBenchmark(Argon2Security.test).measure();
  print('hashlib/argon2d[test]: ${runtime / 1000} ms');
  runtime = HashlibArgon2dBenchmark(Argon2Security.little).measure();
  print('hashlib/argon2d[little]: ${runtime / 1000} ms');
  runtime = HashlibArgon2dBenchmark(Argon2Security.moderate).measure();
  print('hashlib/argon2d[moderate]: ${runtime / 1000} ms');
  runtime = HashlibArgon2dBenchmark(Argon2Security.good).measure();
  print('hashlib/argon2d[good]: ${runtime / 1000} ms');
  runtime = HashlibArgon2dBenchmark(Argon2Security.strong).measure();
  print('hashlib/argon2d[strong]: ${runtime / 1000} ms');
  print('');

  print('--------- Argon2id ----------');
  runtime = HashlibArgon2idBenchmark(Argon2Security.test).measure();
  print('hashlib/argon2id[test]: ${runtime / 1000} ms');
  runtime = HashlibArgon2idBenchmark(Argon2Security.little).measure();
  print('hashlib/argon2id[little]: ${runtime / 1000} ms');
  runtime = HashlibArgon2idBenchmark(Argon2Security.moderate).measure();
  print('hashlib/argon2id[moderate]: ${runtime / 1000} ms');
  runtime = HashlibArgon2idBenchmark(Argon2Security.good).measure();
  print('hashlib/argon2id[good]: ${runtime / 1000} ms');
  runtime = HashlibArgon2idBenchmark(Argon2Security.strong).measure();
  print('hashlib/argon2id[strong]: ${runtime / 1000} ms');
  print('');

  print('--------- Other argon2 argon2id ----------');
  runtime = Argon2Argon2idBenchmark(Argon2Security.test).measure();
  print('argon2/argon2id[test]: ${runtime / 1000} ms');
  runtime = Argon2Argon2idBenchmark(Argon2Security.little).measure();
  print('argon2/argon2id[little]: ${runtime / 1000} ms');
  runtime = Argon2Argon2idBenchmark(Argon2Security.moderate).measure();
  print('argon2/argon2id[moderate]: ${runtime / 1000} ms');
  runtime = Argon2Argon2idBenchmark(Argon2Security.good).measure();
  print('argon2/argon2id[good]: ${runtime / 1000} ms');
  runtime = Argon2Argon2idBenchmark(Argon2Security.strong).measure();
  print('argon2/argon2id[strong]: ${runtime / 1000} ms');
  print('');
}
