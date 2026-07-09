// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:pointycastle/export.dart' show Pbkdf2Parameters;
import 'package:pointycastle/pointycastle.dart' as pc;

import '_base.dart';

class HashlibBenchmark extends SyncBenchmark {
  final PBKDF2Security security;

  HashlibBenchmark(this.security) : super('hashlib', 0);

  @override
  dynamic run() {
    final salt = Uint8List.fromList("some salt".codeUnits);
    final pass = Uint8List.fromList("some password".codeUnits);
    return PBKDF2
        .fromSecurity(security, salt: salt, keyLength: 64)
        .convert(pass);
  }
}

class PointyCastleBenchmark extends SyncBenchmark {
  final PBKDF2Security security;

  PointyCastleBenchmark(this.security) : super('hashlib', 0);

  @override
  dynamic run() {
    final salt = Uint8List.fromList("some salt".codeUnits);
    final pass = Uint8List.fromList("some password".codeUnits);
    var pbkdf2 = pc.KeyDerivator('SHA-256/HMAC/PBKDF2');
    pbkdf2.init(Pbkdf2Parameters(salt, security.c, 64));
    var out = Uint8List(64);
    pbkdf2.deriveKey(pass, 0, out, 0);
    return out;
  }
}

void main() {
  Measurement m;
  print('--------- Hashlib/PBKDF2 ----------');
  m = HashlibBenchmark(PBKDF2Security.test).measure();
  print('hashlib/pbkdf2[test]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(PBKDF2Security.little).measure();
  print('hashlib/pbkdf2[little]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(PBKDF2Security.moderate).measure();
  print('hashlib/pbkdf2[moderate]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(PBKDF2Security.good).measure();
  print('hashlib/pbkdf2[good]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(PBKDF2Security.strong).measure();
  print('hashlib/pbkdf2[strong]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(PBKDF2Security.owasp).measure();
  print('hashlib/pbkdf2[owasp1]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(PBKDF2Security.owasp2).measure();
  print('hashlib/pbkdf2[owasp2]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(PBKDF2Security.owasp3).measure();
  print('hashlib/pbkdf2[owasp3]: ${m.runtimeMillis} ms');
  print('');
  print('--------- PointyCastle/PBKDF2 ----------');
  m = PointyCastleBenchmark(PBKDF2Security.test).measure();
  print('pc/pbkdf2[test]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(PBKDF2Security.little).measure();
  print('pc/pbkdf2[little]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(PBKDF2Security.moderate).measure();
  print('pc/pbkdf2[moderate]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(PBKDF2Security.good).measure();
  print('pc/pbkdf2[good]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(PBKDF2Security.strong).measure();
  print('pc/pbkdf2[strong]: ${m.runtimeMillis} ms');
  print('');
}
