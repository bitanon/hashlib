// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/codecs_base.dart';
import 'package:test/test.dart';

void main() {
  group('Test base64', () {
    test('encoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var base64 = base64Encode(b).replaceAll('=', '');
        expect(toBase64(b), base64);
      }
    });
    test('decoding', () {
      for (int i = 0; i < 100; ++i) {
        var b = randomBytes(i);
        var base64 = base64Encode(b).replaceAll('=', '');
        expect(fromBase64(base64), orderedEquals(b));
      }
    });
  });
}
