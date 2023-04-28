// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('CRC test', () {
    test('CRC-16 with empty string', () {
      expect(crc16code(""), 0);
    });
    test('CRC-16 with a string', () {
      expect(crc16.string("Wikipedia").hex(), "ee3e");
    });

    test('CRC-32 with empty string', () {
      expect(crc32code(""), 0);
    });
    test('CRC-32 with a string', () {
      expect(crc32.string("Wikipedia").hex(), "adaac02e");
    });

    test('CRC-64 with empty string', () {
      expect(crc64code(""), 0);
    });
    test('CRC-64 with a string', () {
      expect(crc64.string("Wikipedia").hex(), "352d6c9d31566506");
    });
  });
}
