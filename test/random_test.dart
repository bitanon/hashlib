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

    test('fill random', () {
      var list = Uint32List(5);
      expect(list, equals([0, 0, 0, 0, 0]));
      int sum = 0;
      for (int i = 0; i < 100; ++i) {
        fillRandom(list.buffer, 5, 9);
        var bytes = list.buffer.asUint8List();
        sum += bytes.skip(5).take(9).any((n) => n > 0) ? 1 : 0;
        expect(bytes.take(5).toList(), equals([0, 0, 0, 0, 0]));
        expect(bytes.skip(5 + 9).toList(), equals([0, 0, 0, 0, 0, 0]));
      }
      expect(sum, greaterThan(0));
    });
  });
}
