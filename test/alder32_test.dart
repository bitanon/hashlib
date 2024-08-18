// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Alder-32 test', () {
    test("name", () {
      expect(alder32.name, 'ALDER-32');
    });
    test('alder32code with empty string', () {
      expect(alder32code(""), 1);
    });
    test('alder32code with a string', () {
      expect(alder32code("Wikipedia"), 300286872);
    });
  });
}
