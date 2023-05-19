// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart' show fromBase64, toBase64, randomBytes;
import 'package:test/test.dart';

void main() {
  group('Test base64', () {
    test('encoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b).replaceAll('=', '');
        expect(toBase64(b), r, reason: 'length $i');
      }
    });
    test('decoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b).replaceAll('=', '');
        expect(fromBase64(r), equals(b), reason: 'length $i');
      }
    });
    test('encoding with padding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b);
        expect(toBase64(b, padding: true), r, reason: 'length $i');
      }
    });
    test('decoding with padding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b);
        expect(fromBase64(r), equals(b), reason: 'length $i');
      }
    });
    test('encoding <-> decoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = toBase64(b);
        expect(fromBase64(r), equals(b), reason: 'length $i');
      }
    });
    test('encoding <-> decoding with padding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = toBase64(b, padding: true);
        expect(fromBase64(r), equals(b), reason: 'length $i');
      }
    });
    group('decoding with invalid chars', () {
      test('"Hashlib!"', () {
        expect(() => fromBase64("Hashlib!"), throwsFormatException);
      });
      test('"-10"', () {
        expect(() => fromBase64(" 10"), throwsFormatException);
      });
      test('"s_mething"', () {
        expect(() => fromBase64("s_mething"), throwsFormatException);
      });
    });
    // group('decoding with invalid length', () {
    //   test('"H"', () {
    //     expect(() => fromBase64("H"), throwsFormatException);
    //   });
    //   test('"Ha"', () {
    //     expect(() => fromBase64("Ha"), throwsFormatException);
    //   });
    //   test('"Has"', () {
    //     expect(() => fromBase64("Has"), throwsFormatException);
    //   });
    //   test('"Hashl"', () {
    //     expect(() => fromBase64("Hashl"), throwsFormatException);
    //   });
    //   test('"Hashli"', () {
    //     expect(() => fromBase64("Hashli"), throwsFormatException);
    //   });
    //   test('"Hashlib"', () {
    //     expect(() => fromBase64("Hashlib"), throwsFormatException);
    //   });
    // });
  });
}
