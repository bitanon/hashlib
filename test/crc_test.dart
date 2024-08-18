// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('CRC test', () {
    test("name", () {
      expect(crc16.name, 'CRC-16');
      expect(crc32.name, 'CRC-32');
      expect(crc64.name, 'CRC-64');
    });

    test('CRC-16 code with an empty string', () {
      expect(crc16code(""), 0);
    });
    test('CRC-16 with a string', () {
      expect(crc16.string("Wikipedia").hex(), "ee3e");
    });
    test('CRC-16 code with a string', () {
      expect(crc16code("Wikipedia"), 0xee3e);
    });

    test('CRC-32 code with an empty string', () {
      expect(crc32code(""), 0);
    });
    test('CRC-32 with a string', () {
      expect(crc32.string("Wikipedia").hex(), "adaac02e");
    });
    test('CRC-32 code with a string', () {
      expect(crc32code("Wikipedia"), 0xadaac02e);
    });

    test('CRC-64 code with an empty string', () {
      expect(crc64code(""), 0);
    });
    test('CRC-64 with a string', () {
      expect(crc64.string("Wikipedia").hex(), "352d6c9d31566506");
    });
    test('CRC-64 code with a string', () {
      expect(crc64code("Wikipedia"), (0x352d6c9d << 32) | 0x31566506);
    }, tags: ['vm-only']);
    test('CRC-64 hex output', () {
      expect(crc64sum("Wikipedia"), "352d6c9d31566506");
    });
  });
}
