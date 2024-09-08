// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:pointycastle/key_derivators/scrypt.dart' as pc;
import 'package:pointycastle/export.dart' show ScryptParameters;

import '_base.dart';

Random random = Random();

class HashlibBenchmark extends KDFBenchmarkBase {
  final ScryptSecurity security;

  HashlibBenchmark(this.security) : super('hashlib');

  @override
  void run() {
    final salt = Uint8List.fromList('secret salt'.codeUnits);
    final pass = Uint8List.fromList('long password'.codeUnits);
    Scrypt.fromSecurity(
      security,
      salt: salt,
      derivedKeyLength: 64,
    ).convert(pass);
  }
}

class PointyCastleBenchmark extends KDFBenchmarkBase {
  final ScryptSecurity security;

  PointyCastleBenchmark(this.security) : super('PointyCastle');

  @override
  void run() {
    final salt = Uint8List.fromList('secret salt'.codeUnits);
    final pass = Uint8List.fromList('long password'.codeUnits);
    final scrypt = pc.Scrypt();
    scrypt.init(ScryptParameters(security.N, security.r, security.p, 64, salt));
    final out = Uint8List(64);
    scrypt.deriveKey(pass, 0, out, 0);
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
  runtime = HashlibBenchmark(ScryptSecurity.owasp).measure();
  print('hashlib/scrypt[owasp1]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.owasp2).measure();
  print('hashlib/scrypt[owasp2]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.owasp3).measure();
  print('hashlib/scrypt[owasp3]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.owasp4).measure();
  print('hashlib/scrypt[owasp4]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(ScryptSecurity.owasp5).measure();
  print('hashlib/scrypt[owasp5]: ${runtime / 1000} ms');
  print('');
  print('--------- PointyCastle/SCRYPT ----------');
  runtime = PointyCastleBenchmark(ScryptSecurity.test).measure();
  print('pc/scrypt[test]: ${runtime / 1000} ms');
  runtime = PointyCastleBenchmark(ScryptSecurity.little).measure();
  print('pc/scrypt[little]: ${runtime / 1000} ms');
  runtime = PointyCastleBenchmark(ScryptSecurity.moderate).measure();
  print('pc/scrypt[moderate]: ${runtime / 1000} ms');
  runtime = PointyCastleBenchmark(ScryptSecurity.good).measure();
  print('pc/scrypt[good]: ${runtime / 1000} ms');
  runtime = PointyCastleBenchmark(ScryptSecurity.strong).measure();
  print('pc/scrypt[strong]: ${runtime / 1000} ms');
  print('');
}
