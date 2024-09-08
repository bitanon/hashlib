// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

class TestKDF extends KeyDerivatorBase {
  @override
  String get name => 'TestKDF';

  @override
  final int derivedKeyLength = 3;

  @override
  HashDigest convert(List<int> password) {
    password = List.filled(derivedKeyLength, password.length);
    return HashDigest(Uint8List.fromList(password));
  }
}

void main() {
  group('KeyDerivatorBase', () {
    test('TestKDF is defined properly', () {
      final algo = TestKDF();
      expect(algo.name, 'TestKDF');
      expect(algo.derivedKeyLength, 3);
      expect(algo.convert([1, 2]).bytes, equals([2, 2, 2]));
    });

    test('hex method works correctly', () {
      expect(TestKDF().hex([]), equals('000000'));
      expect(TestKDF().hex([1, 2, 3, 4, 5]), equals('050505'));
    });

    test('string method works correctly', () {
      expect(TestKDF().string('').bytes, equals([0, 0, 0]));
      expect(TestKDF().string('abcd').bytes, equals([4, 4, 4]));
    });

    test('string method works correctly with encoding', () {
      expect(TestKDF().string('', utf8).bytes, equals([0, 0, 0]));
      expect(TestKDF().string('abcd', utf8).bytes, equals([4, 4, 4]));
    });

    test('verify method works correctly', () {
      expect(TestKDF().verify([2, 2, 2], [8, 4]), isTrue);
    });
  });
}
