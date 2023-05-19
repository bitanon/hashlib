// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart' show fromHex, toHex, randomBytes;
import 'package:test/test.dart';

void main() {
  group('Test base16', () {
    group("encoding", () {
      test('[] => ""', () {
        expect(toHex([]), "");
      });
      test('[5] => "05"', () {
        expect(toHex([5]), "05");
      });
      test('[12] => "0c"', () {
        expect(toHex([12]), "0c");
      });
      test('[16] => "10"', () {
        expect(toHex([16]), "10");
      });
      test('random', () {
        for (int i = 0; i < 100; ++i) {
          var b = randomBytes(i);
          var hex = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
          expect(toHex(b), hex, reason: 'length $i');
        }
      });
    });
    group('encoding buffer', () {
      var buf = [
        244, 11, 21, 63, 222, 56, 63, 111, 57, 64, 22, 56, 32, //
        55, 115, 178, 138, 230, 251
      ];
      var lowerHex = "f40b153fde383f6f39401638203773b28ae6fb";
      var upperHex = "F40B153FDE383F6F39401638203773B28AE6FB";
      test("lower", () {
        expect(toHex(buf), lowerHex);
      });
      test("upper", () {
        expect(toHex(buf, upper: true), upperHex);
      });
    });
    group("decoding", () {
      test('"" => []', () {
        expect(fromHex(""), []);
      });
      test('"5" => [5]', () {
        expect(fromHex("5"), [5]);
      });
      test('"c" => [12]', () {
        expect(fromHex("c"), [12]);
      });
      test('"0c" => [12]', () {
        expect(fromHex("0c"), [12]);
      });
      test('"00c" => [0, 12]', () {
        expect(fromHex("00c"), [0, 12]);
      });
      test('"000c" => [0, 12]', () {
        expect(fromHex("000c"), [0, 12]);
      });
      test('"0000c" => [0, 0, 12]', () {
        expect(fromHex("0000c"), [0, 0, 12]);
      });
      test('random', () {
        for (int i = 0; i < 100; ++i) {
          var b = randomBytes(i);
          var hex = b.map((x) => x.toRadixString(16).padLeft(2, '0')).join();
          expect(fromHex(hex), equals(b), reason: 'length $i');
        }
      });
    });
    group('decoding buffer', () {
      var buf = [
        244, 11, 21, 63, 222, 56, 63, 111, 57, 64, 22, 56, 32, //
        55, 115, 178, 138, 230, 251
      ];
      var lowerHex = "f40b153fde383f6f39401638203773b28ae6fb";
      var upperHex = "F40B153FDE383F6F39401638203773B28AE6FB";
      test("lower", () {
        expect(fromHex(lowerHex), equals(buf));
      });
      test("upper", () {
        expect(fromHex(upperHex), equals(buf));
      });
    });
    test('encoding <-> decoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = toHex(b);
        expect(fromHex(r), equals(b), reason: 'length $i');
      }
    });
    test('encoding <-> decoding uppercase', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = toHex(b, upper: true);
        expect(fromHex(r), equals(b), reason: 'length $i');
      }
    });
    group('decoding with invalid chars', () {
      test('"Error"', () {
        expect(() => fromHex("Error"), throwsFormatException);
      });
      test('"-10"', () {
        expect(() => fromHex("-10"), throwsFormatException);
      });
      test('"something"', () {
        expect(() => fromHex("something"), throwsFormatException);
      });
    });
  });
}
