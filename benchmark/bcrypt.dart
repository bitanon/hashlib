// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';

import '_base.dart';

Random random = Random();

class HashlibBenchmark extends KDFBenchmarkBase {
  final salt = randomBytes(16);
  final BcryptSecurity security;
  final password = 'long password'.codeUnits;

  HashlibBenchmark(this.security) : super('hashlib');

  @override
  void run() {
    bcryptDigest(password, salt: salt, security: security);
  }
}

void main() {
  double runtime;
  print('--------- Hashlib/BCRYPT ----------');
  runtime = HashlibBenchmark(BcryptSecurity.test).measure();
  print('hashlib/bcrypt[test]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(BcryptSecurity.little).measure();
  print('hashlib/bcrypt[little]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(BcryptSecurity.moderate).measure();
  print('hashlib/bcrypt[moderate]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(BcryptSecurity.good).measure();
  print('hashlib/bcrypt[good]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(BcryptSecurity.strong).measure();
  print('hashlib/bcrypt[strong]: ${runtime / 1000} ms');
  runtime = HashlibBenchmark(BcryptSecurity.owasp).measure();
  print('hashlib/bcrypt[owasp]: ${runtime / 1000} ms');
  print('');
}
