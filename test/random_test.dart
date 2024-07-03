// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
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
    test("keccak random", () {
      runFunctionalText(HashlibRandom(RandomGenerator.keccak));
    });
    test("sha256 random", () {
      runFunctionalText(HashlibRandom(RandomGenerator.sha256));
    });
    test("sm3 random", () {
      runFunctionalText(HashlibRandom(RandomGenerator.sm3));
    });
    test("md5 random", () {
      runFunctionalText(HashlibRandom(RandomGenerator.md5));
    });
    test("xxh64 random", () {
      runFunctionalText(HashlibRandom(RandomGenerator.xxh64));
    }, tags: ['vm-only']);
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
  test('fill random', () {
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
    var rand = HashlibRandom(RandomGenerator.keccak, seed: 100);
    expect(rand.nextBetween(0, 0), 0);
    expect(rand.nextBetween(1, 1), 1);
    expect(rand.nextBetween(5, 10), lessThanOrEqualTo(10));
    expect(rand.nextBetween(10, 5), greaterThanOrEqualTo(5));
    expect(rand.nextBetween(-5, -2), lessThan(0));
    expect(rand.nextBetween(-5, -15), lessThan(0));
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

  group('keccak random', () {
    test('with seed', () {
      var rand = HashlibRandom(RandomGenerator.keccak, seed: 100);
      expect(rand.nextInt(), 4172722486);
    });
    test('default seed', () {
      var rand = HashlibRandom(RandomGenerator.keccak);
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
      expect(randomBytes(100, generator: RandomGenerator.keccak).length, 100);
    });
  });
}
