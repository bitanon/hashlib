// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';

import '_base.dart';

class HashlibBenchmark extends SyncBenchmark {
  final salt = randomBytes(16);
  final BcryptSecurity security;
  final password = 'long password'.codeUnits;

  HashlibBenchmark(this.security) : super('hashlib', 0);

  @override
  dynamic run() {
    return bcryptDigest(password, salt: salt, security: security);
  }
}

void main() {
  Measurement m;
  print('--------- Hashlib/BCRYPT ----------');
  m = HashlibBenchmark(BcryptSecurity.test).measure();
  print('hashlib/bcrypt[test]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(BcryptSecurity.little).measure();
  print('hashlib/bcrypt[little]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(BcryptSecurity.moderate).measure();
  print('hashlib/bcrypt[moderate]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(BcryptSecurity.good).measure();
  print('hashlib/bcrypt[good]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(BcryptSecurity.strong).measure();
  print('hashlib/bcrypt[strong]: ${m.runtimeMillis} ms');
  m = HashlibBenchmark(BcryptSecurity.owasp).measure();
  print('hashlib/bcrypt[owasp]: ${m.runtimeMillis} ms');
  print('');
}
