// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Random test', () {
    test('random bytes length = 0', () {
      expect(randomBytes(0), []);
    });
    test('random bytes length = 1', () {
      expect(randomBytes(1).length, 1);
    });
    test('random bytes length = 100', () {
      expect(randomBytes(100).length, 100);
    });

    test('random buffer length = 0', () {
      expect(randomBuffer(0), []);
    });
    test('random buffer length = 1', () {
      expect(randomBuffer(1).lengthInBytes, 1);
    });
    test('random buffer length = 100', () {
      expect(randomBuffer(100).lengthInBytes, 100);
    });

    test('random buffer length = 100', () {
      var list = Uint32List(5);
      expect(list, equals([0, 0, 0, 0, 0]));
      fillRandom(list.buffer);
      expect(list, isNot(equals([0, 0, 0, 0, 0])));
    });
  });
}
