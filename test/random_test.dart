// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

const int _maxInt = 0xFFFFFFFF;

Iterable<int> testGenerator() sync* {
  while (true) {
    yield _maxInt;
  }
}

void main() {
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
    int i, c;
    var r = HashlibRandom.generator(testGenerator().iterator);
    for (c = 0; c <= 100; ++c) {
      for (i = 0; i + c <= 100; ++i) {
        var data = Uint8List(100);
        r.fill(data.buffer, i, c);
        int s = data.fold<int>(0, (p, e) => p + (e > 0 ? 1 : 0));
        expect(s, c, reason: 'fill($i, $c) : $data');
      }
    }
  });

  group('keccak random', () {
    test('without seed', () {
      var rand = HashlibRandom.keccak(0);
      expect(rand.nextInt(), 1088544231);
    });
    test('with seed', () {
      var rand = HashlibRandom.keccak(100);
      expect(rand.nextInt(), 826887880);
    });
    test('default seed', () {
      var rand = HashlibRandom.keccak();
      for (int i = 0; i < 100; ++i) {
        expect(rand.nextBetween(0, 1), lessThanOrEqualTo(1));
        expect(rand.nextBetween(0, 3), lessThanOrEqualTo(3));
        expect(rand.nextBetween(0, 10), lessThanOrEqualTo(10));
        expect(rand.nextBetween(0, 50), lessThanOrEqualTo(50));
        expect(rand.nextBetween(0, 500), lessThanOrEqualTo(500));
        expect(rand.nextBetween(0, 85701), lessThanOrEqualTo(85701));
        expect(rand.nextBetween(1, _maxInt), greaterThanOrEqualTo(1));
        expect(rand.nextBetween(3, _maxInt), greaterThanOrEqualTo(3));
        expect(rand.nextBetween(10, _maxInt), greaterThanOrEqualTo(10));
        expect(rand.nextBetween(50, _maxInt), greaterThanOrEqualTo(50));
        expect(rand.nextBetween(500, _maxInt), greaterThanOrEqualTo(500));
        expect(rand.nextBetween(85701, _maxInt), greaterThanOrEqualTo(85701));
      }
    });
    test('random bytes length = 100', () {
      expect(randomBytes(100, RandomGenerator.keccak).length, 100);
    });
  });
}
