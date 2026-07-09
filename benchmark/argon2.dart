// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:argon2/argon2.dart' as argon2;
import 'package:hashlib/hashlib.dart';

import '_base.dart';

class HashlibArgon2iBenchmark extends SyncBenchmark {
  final Argon2Security security;

  HashlibArgon2iBenchmark(this.security) : super('hashlib', 0);

  @override
  dynamic run() {
    return Argon2(
      hashLength: 24,
      iterations: security.t,
      memorySizeKB: security.m,
      parallelism: security.p,
      salt: 'some salt'.codeUnits,
      type: Argon2Type.argon2i,
    ).convert('password'.codeUnits);
  }
}

class HashlibArgon2dBenchmark extends SyncBenchmark {
  final Argon2Security security;

  HashlibArgon2dBenchmark(this.security) : super('hashlib', 0);

  @override
  dynamic run() {
    return Argon2(
      hashLength: 24,
      iterations: security.t,
      memorySizeKB: security.m,
      parallelism: security.p,
      salt: 'some salt'.codeUnits,
      type: Argon2Type.argon2d,
    ).convert('password'.codeUnits);
  }
}

class HashlibArgon2idBenchmark extends SyncBenchmark {
  final Argon2Security security;

  HashlibArgon2idBenchmark(this.security) : super('hashlib', 0);

  @override
  dynamic run() {
    return Argon2(
      hashLength: 24,
      iterations: security.t,
      memorySizeKB: security.m,
      parallelism: security.p,
      salt: 'some salt'.codeUnits,
      type: Argon2Type.argon2id,
    ).convert('password'.codeUnits);
  }
}

class Argon2Argon2idBenchmark extends SyncBenchmark {
  final Argon2Security security;

  Argon2Argon2idBenchmark(this.security) : super('argon2', 0);

  @override
  dynamic run() {
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
    return res;
  }
}

void main() {
  Measurement m;
  print('--------- Argon2id ----------');
  m = HashlibArgon2idBenchmark(Argon2Security.test).measure();
  print('hashlib/argon2id[test]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.little).measure();
  print('hashlib/argon2id[little]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.moderate).measure();
  print('hashlib/argon2id[moderate]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.good).measure();
  print('hashlib/argon2id[good]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.strong).measure();
  print('hashlib/argon2id[strong]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.owasp).measure();
  print('hashlib/argon2id[owasp1]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.owasp2).measure();
  print('hashlib/argon2id[owasp2]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.owasp3).measure();
  print('hashlib/argon2id[owasp3]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.owasp4).measure();
  print('hashlib/argon2id[owasp4]: ${m.runtimeMillis} ms');
  m = HashlibArgon2idBenchmark(Argon2Security.owasp5).measure();
  print('hashlib/argon2id[owasp5]: ${m.runtimeMillis} ms');
  print('');

  print('--------- Argon2i ----------');
  m = HashlibArgon2iBenchmark(Argon2Security.test).measure();
  print('hashlib/argon2i[test]: ${m.runtimeMillis} ms');
  m = HashlibArgon2iBenchmark(Argon2Security.little).measure();
  print('hashlib/argon2i[little]: ${m.runtimeMillis} ms');
  m = HashlibArgon2iBenchmark(Argon2Security.moderate).measure();
  print('hashlib/argon2i[moderate]: ${m.runtimeMillis} ms');
  m = HashlibArgon2iBenchmark(Argon2Security.good).measure();
  print('hashlib/argon2i[good]: ${m.runtimeMillis} ms');
  m = HashlibArgon2iBenchmark(Argon2Security.strong).measure();
  print('hashlib/argon2i[strong]: ${m.runtimeMillis} ms');
  print('');

  print('--------- Argon2d ----------');
  m = HashlibArgon2dBenchmark(Argon2Security.test).measure();
  print('hashlib/argon2d[test]: ${m.runtimeMillis} ms');
  m = HashlibArgon2dBenchmark(Argon2Security.little).measure();
  print('hashlib/argon2d[little]: ${m.runtimeMillis} ms');
  m = HashlibArgon2dBenchmark(Argon2Security.moderate).measure();
  print('hashlib/argon2d[moderate]: ${m.runtimeMillis} ms');
  m = HashlibArgon2dBenchmark(Argon2Security.good).measure();
  print('hashlib/argon2d[good]: ${m.runtimeMillis} ms');
  m = HashlibArgon2dBenchmark(Argon2Security.strong).measure();
  print('hashlib/argon2d[strong]: ${m.runtimeMillis} ms');
  print('');

  print('--------- Other argon2 argon2id ----------');
  m = Argon2Argon2idBenchmark(Argon2Security.test).measure();
  print('argon2/argon2id[test]: ${m.runtimeMillis} ms');
  m = Argon2Argon2idBenchmark(Argon2Security.little).measure();
  print('argon2/argon2id[little]: ${m.runtimeMillis} ms');
  m = Argon2Argon2idBenchmark(Argon2Security.moderate).measure();
  print('argon2/argon2id[moderate]: ${m.runtimeMillis} ms');
  m = Argon2Argon2idBenchmark(Argon2Security.good).measure();
  print('argon2/argon2id[good]: ${m.runtimeMillis} ms');
  m = Argon2Argon2idBenchmark(Argon2Security.strong).measure();
  print('argon2/argon2id[strong]: ${m.runtimeMillis} ms');
  print('');
}
