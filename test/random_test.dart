// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/algorithms/random_generators.dart';
import 'package:hashlib/src/hashlib_base.dart';
import 'package:test/test.dart';

const int _maxInt = 0xFFFFFFFF;

Iterable<int> testGenerator() sync* {
  while (true) {
    yield _maxInt;
  }
}

var testRandom = HashlibRandom.generator(testGenerator().iterator);

void runFunctionalText(HashlibRandom rand) {
  rand.nextInt();
  rand.nextBetween(30, 50);
  rand.nextBool();
  rand.nextByte();
  rand.nextBytes(10);
  rand.nextDouble();
  rand.nextInt();
  rand.nextNumbers(10);
  rand.nextString(10);
  rand.nextWord();
}

void main() {
  group('functional tests', () {
    test("system random", () {
      runFunctionalText(HashlibRandom(RandomGenerator.system));
    });
    group("keccak random", () {
      test('functions', () {
        runFunctionalText(HashlibRandom(RandomGenerator.keccak));
      });
      test('with seed', () {
        var rand = HashlibRandom(RandomGenerator.keccak, seed: 100);
        expect(rand.nextInt(), 3662713900);
      });
    });
    group("sha256 random", () {
      test("functions", () {
        runFunctionalText(HashlibRandom(RandomGenerator.sha256));
      });
      test('with seed', () {
        var rand = HashlibRandom(RandomGenerator.sha256, seed: 100);
        expect(rand.nextInt(), 3449288731);
      });
    });
    group("sm3 random", () {
      test("functions", () {
        runFunctionalText(HashlibRandom(RandomGenerator.sm3));
      });
      test('with seed', () {
        var rand = HashlibRandom(RandomGenerator.sm3, seed: 100);
        expect(rand.nextInt(), 894660838);
      });
    });
    group("md5 random", () {
      test("functions", () {
        runFunctionalText(HashlibRandom(RandomGenerator.md5));
      });
      test('with seed', () {
        var rand = HashlibRandom(RandomGenerator.md5, seed: 100);
        expect(rand.nextInt(), 2852136378);
      });
    });
    test("xxh64 random", () {
      runFunctionalText(HashlibRandom(RandomGenerator.xxh64));
    }, tags: ['vm-only']);
  });

  test('seed generator uniqueness', () {
    int n = 10000;
    var m = <int>{};
    for (int i = 0; i < n; ++i) {
      m.add(RandomGenerators.$generateSeed());
    }
    expect(m.length, n);
  });

  test('random bytes length = 0', () {
    expect(randomBytes(0), []);
  });
  test('random bytes length = 1', () {
    expect(randomBytes(1).length, 1);
  });
  test('random bytes length = 100', () {
    expect(randomBytes(100).length, 100);
  });

  test('random numbers length = 0', () {
    expect(randomNumbers(0), []);
  });
  test('random numbers length = 1', () {
    expect(randomNumbers(1).length, 1);
  });
  test('random numbers length = 100', () {
    expect(randomNumbers(100).length, 100);
  });
  test('random numbers value', () {
    randomNumbers(10).firstWhere((e) => e >= 256);
  });

  test('fill random bytes', () {
    var data = Uint8List(10);
    fillRandom(data.buffer);
    data.firstWhere((e) => e != 0);
  });

  test('fill random numbers', () {
    var data = Uint32List(10);
    fillNumbers(data);
    data.firstWhere((e) => e >= 256);
  });

  test('fill test random', () {
    int i, c;
    for (c = 0; c <= 100; ++c) {
      for (i = 0; i + c <= 100; ++i) {
        var data = Uint8List(100);
        testRandom.fill(data.buffer, i, c);
        int s = data.fold<int>(0, (p, e) => p + (e > 0 ? 1 : 0));
        expect(s, c, reason: 'fill($i, $c) : $data');
      }
    }
  });

  test('next between', () {
    var rand = HashlibRandom.secure();
    expect(rand.nextBetween(0, 0), 0);
    expect(rand.nextBetween(1, 1), 1);
    expect(rand.nextBetween(5, 10), lessThanOrEqualTo(10));
    expect(rand.nextBetween(10, 5), greaterThanOrEqualTo(5));
    expect(rand.nextBetween(-5, -2), lessThan(0));
    expect(rand.nextBetween(-5, -15), lessThan(0));
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

  test('random string throws StateError on empty whitelist', () {
    expect(
        () => randomString(
              50,
              whitelist: [],
            ),
        throwsStateError);
    expect(
        () => randomString(
              50,
              whitelist: [1, 2, 3],
              blacklist: [1, 2, 3],
            ),
        throwsStateError);
    expect(
        () => randomString(
              50,
              numeric: true,
              blacklist: '0123456789'.codeUnits,
            ),
        throwsStateError);
  });
}
