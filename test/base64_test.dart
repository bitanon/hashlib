// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Test base64', () {
    test('encoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b).replaceAll('=', '');
        expect(toBase64(b), r);
      }
    });
    test('decoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b).replaceAll('=', '');
        expect(fromBase64(r), equals(b));
      }
    });
    test('encoding with padding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b);
        expect(toBase64(b, padding: true), r);
      }
    });
    test('decoding with padding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var r = base64Encode(b);
        expect(fromBase64(r), equals(b));
      }
    });
  });
}
