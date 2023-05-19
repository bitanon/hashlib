// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart' show fromBinary, toBinary, randomBytes;
import 'package:test/test.dart';

void main() {
  group('Test binary', () {
    group("encoding", () {
      test('[] => ""', () {
        expect(toBinary([]), "");
      });
      test('[1] => "00000001"', () {
        expect(toBinary([1]), "00000001");
      });
      test('[7] => "00000111"', () {
        expect(toBinary([7]), "00000111");
      });
      test('[10] => "00001010"', () {
        expect(toBinary([10]), "00001010");
      });
      test('[0,10] => "00001010"', () {
        expect(toBinary([0, 10]), "0000000000001010");
      });
      test('random', () {
        for (int i = 0; i < 100; ++i) {
          var b = randomBytes(i);
          var r = b.map((x) => x.toRadixString(2).padLeft(8, '0')).join();
          expect(toBinary(b), equals(r), reason: 'length $i');
        }
      });
    });
    group("decoding", () {
      test('"" => []', () {
        expect(fromBinary(""), []);
      });
      test('"1010" => [10]', () {
        expect(fromBinary("1010"), [10]);
      });
      test('"01010" => [10]', () {
        expect(fromBinary("01010"), [10]);
      });
      test('"0001010" => [10]', () {
        expect(fromBinary("0001010"), [10]);
      });
      test('"00001010" => [10]', () {
        expect(fromBinary("00001010"), [10]);
      });
      test('"000001010" => [10]', () {
        expect(fromBinary("000001010"), [0, 10]);
      });
      test('"0000000001010" => [10]', () {
        expect(fromBinary("0000000001010"), [0, 10]);
      });
      test('random', () {
        for (int i = 0; i < 100; ++i) {
          var b = randomBytes(i);
          var r = b.map((x) => x.toRadixString(2).padLeft(8, '0')).join();
          expect(fromBinary(r), equals(b), reason: 'length $i');
        }
      });
    });
    test('encoding <-> decoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = toBinary(b);
        expect(fromBinary(r), equals(b), reason: 'length $i');
      }
    });
    group('decoding with invalid chars', () {
      test('"0158"', () {
        expect(() => fromBinary("0158"), throwsFormatException);
      });
      test('"-10"', () {
        expect(() => fromBinary("-10"), throwsFormatException);
      });
      test('"01a1"', () {
        expect(() => fromBinary("01a1"), throwsFormatException);
      });
    });
  });
}
