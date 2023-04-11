// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Test toHex()', () {
    test('an empty array', () {
      expect(toHex([]), "");
    });
    test('with single number 5', () {
      expect(toHex([5]), "05");
    });
    test('with single number 12', () {
      expect(toHex([12]), "0c");
    });
  });
}
