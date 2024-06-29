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
        fillRandom(list.buffer, start: 5, length: 9);
        var bytes = Uint8List.view(list.buffer);
        sum += bytes.skip(5).take(9).any((n) => n > 0) ? 1 : 0;
        expect(bytes.take(5).toList(), equals([0, 0, 0, 0, 0]));
        expect(bytes.skip(5 + 9).toList(), equals([0, 0, 0, 0, 0, 0]));
      }
      expect(sum, greaterThan(0));
    });
    group('keccak random', () {
      test('without seed', () {
        var rand = KeccakRandom(0);
        expect(rand.nextDWord(), 1088544231);
      });
      test('with seed', () {
        var rand = KeccakRandom(100);
        expect(rand.nextDWord(), 826887880);
      });
      test('default seed', () {
        var rand = KeccakRandom();
        for (int i = 0; i < 100; ++i) {
          expect(rand.nextInt(1), lessThanOrEqualTo(1));
          expect(rand.nextInt(3), lessThanOrEqualTo(3));
          expect(rand.nextInt(10), lessThanOrEqualTo(10));
          expect(rand.nextInt(50), lessThanOrEqualTo(50));
          expect(rand.nextInt(500), lessThanOrEqualTo(500));
          expect(rand.nextInt(85701), lessThanOrEqualTo(85701));
        }
      });
      test('random bytes length = 100', () {
        expect(randomBytes(100, KeccakRandom()).length, 100);
      });
    });
  });
}
