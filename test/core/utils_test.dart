// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: deprecated_member_use_from_same_package

import 'package:test/test.dart';
import 'package:hashlib/src/core/utils.dart';

void main() {
  group('keepNumeric', () {
    test('should keep only numeric characters', () {
      expect(keepNumeric('abc123def456'), equals('123456'));
      expect(keepNumeric('No numbers here!'), equals(''));
      expect(keepNumeric('12345'), equals('12345'));
      expect(keepNumeric('0a1b2c3'), equals('0123'));
    });
  });

  group('keepAlpha', () {
    test('should keep only alphabetic characters', () {
      expect(keepAlpha('abc123def456'), equals('abcdef'));
      expect(keepAlpha('123456'), equals(''));
      expect(keepAlpha('Hello, World!'), equals('HelloWorld'));
      expect(keepAlpha('A1B2C3D4'), equals('ABCD'));
    });
  });

  group('keepAlphaNumeric', () {
    test('should keep only alphanumeric characters', () {
      expect(keepAlphaNumeric('abc123def456'), equals('abc123def456'));
      expect(keepAlphaNumeric('!@#\$%^&*()'), equals(''));
      expect(keepAlphaNumeric('A1B2C3D4'), equals('A1B2C3D4'));
      expect(keepAlphaNumeric('Hello, World! 2024'), equals('HelloWorld2024'));
    });
  });

  group('normalizeName', () {
    test('should normalize name to uppercase and keep alphanumeric characters',
        () {
      expect(normalizeName('abc123def456'), equals('ABC123DEF456'));
      expect(normalizeName('Hello, World! 2024'), equals('HELLOWORLD2024'));
      expect(normalizeName('lowercase'), equals('LOWERCASE'));
      expect(normalizeName('MixedCASE123'), equals('MIXEDCASE123'));
      expect(normalizeName('!@#\$%^&*()'), equals(''));
    });
  });
}
