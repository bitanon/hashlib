// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:pointycastle/key_derivators/scrypt.dart' as pc;
import 'package:pointycastle/export.dart' show ScryptParameters;

import '_base.dart';

class HashlibBenchmark extends SyncBenchmark {
  final ScryptSecurity security;

  HashlibBenchmark(this.security) : super('hashlib', 0);

  @override
  dynamic run() {
    final salt = Uint8List.fromList('secret salt'.codeUnits);
    final pass = Uint8List.fromList('long password'.codeUnits);
    return Scrypt.fromSecurity(
      security,
      salt: salt,
      derivedKeyLength: 64,
    ).convert(pass);
  }
}

class PointyCastleBenchmark extends SyncBenchmark {
  final ScryptSecurity security;

  PointyCastleBenchmark(this.security) : super('PointyCastle', 0);

  @override
  dynamic run() {
    final salt = Uint8List.fromList('secret salt'.codeUnits);
    final pass = Uint8List.fromList('long password'.codeUnits);
    final scrypt = pc.Scrypt();
    scrypt.init(ScryptParameters(security.N, security.r, security.p, 64, salt));
    final out = Uint8List(64);
    scrypt.deriveKey(pass, 0, out, 0);
    return out;
  }
}

void main() {
  Measurement m;
  print('--------- Hashlib/SCRYPT ----------');
  m = HashlibBenchmark(ScryptSecurity.test).measure();
  print('hashlib/scrypt[test]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.little).measure();
  print('hashlib/scrypt[little]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.moderate).measure();
  print('hashlib/scrypt[moderate]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.good).measure();
  print('hashlib/scrypt[good]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.strong).measure();
  print('hashlib/scrypt[strong]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.owasp).measure();
  print('hashlib/scrypt[owasp1]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.owasp2).measure();
  print('hashlib/scrypt[owasp2]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.owasp3).measure();
  print('hashlib/scrypt[owasp3]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.owasp4).measure();
  print('hashlib/scrypt[owasp4]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(ScryptSecurity.owasp5).measure();
  print('hashlib/scrypt[owasp5]: ${m.runtimeMillis} ms');
  print('');
  print('--------- PointyCastle/SCRYPT ----------');
  m = PointyCastleBenchmark(ScryptSecurity.test).measure();
  print('pc/scrypt[test]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(ScryptSecurity.little).measure();
  print('pc/scrypt[little]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(ScryptSecurity.moderate).measure();
  print('pc/scrypt[moderate]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(ScryptSecurity.good).measure();
  print('pc/scrypt[good]: ${m.runtimeMillis} ms');
  m = PointyCastleBenchmark(ScryptSecurity.strong).measure();
  print('pc/scrypt[strong]: ${m.runtimeMillis} ms');
  print('');
}
