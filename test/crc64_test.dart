// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

/// CRC-64 code for "123456789"
var known = {
  CRC64Params.iso: '46a5a9388a5beffe',
  CRC64Params.ecma: '6c40df5f0b497347',
  CRC64Params.goIso: 'b90956c775a41001',
  CRC64Params.ms: '75d4b74f024eceea',
  CRC64Params.we: '62ec59e3f1a4f00a',
  CRC64Params.jones: 'caa717168609f281',
  CRC64Params.goEcma: '995dc9bbdf1939fa',
  CRC64Params.xz: '995dc9bbdf1939fa',
  CRC64Params.redis: 'e9c6d914c4b8d9ca',
  CRC64Params.nvme: 'ae8b14860a799888',
};

void main() {
  group('CRC-64 test', () {
    test("name", () {
      expect(crc64.name, 'CRC-64/ISO-HDLC');
    });
    test("name for defined polynomial", () {
      expect(CRC64(CRC64Params.ecma).name, 'CRC-64/ECMA-182');
    });
    test("name for custom polynomial", () {
      expect(CRC64(CRC64Params(0x1919)).name, 'CRC-64/1919');
    });

    test('code with an empty string', () {
      expect(crc64code(""), 0);
    });
    test('with a string', () {
      expect(crc64.string("Wikipedia").hex(), "352d6c9d31566506");
    });
    test('code with a string', () {
      expect(crc64code("Wikipedia"), (0x352d6c9d << 32) | 0x31566506);
    }, tags: ['vm-only']);
    test('hex output', () {
      expect(crc64sum("Wikipedia"), "352d6c9d31566506");
    });

    test('createSink produces same result for same input', () {
      final sink1 = crc64.createSink();
      sink1.add(utf8.encode("TestString"));
      final result1 = sink1.digest().hex();

      final sink2 = crc64.createSink();
      sink2.add(utf8.encode("TestString"));
      final result2 = sink2.digest().hex();

      expect(result1, equals(result2));
    });

    test('sink test', () {
      final sink = crc64.createSink();
      expect(sink.closed, isFalse);
      sink.add([10, 20]);
      expect(sink.closed, isFalse);
      sink.close();
      expect(sink.closed, isTrue);
      expect(() => sink.add([10]), throwsStateError);
      sink.reset();
      expect(sink.closed, isFalse);
      sink.add([10, 20, 30]);
      expect(sink.digest().length, 8);
      expect(sink.closed, isTrue);
    });

    test('CRC64Params.hex', () {
      var params = CRC64Params.hex(
        poly: '42F0E1EBA9EA3693',
        seed: 'FFFFFFFFFFFFFFFF',
        xorOut: 'FFFFFFFFFFFFFFFF',
      );
      expect(params.high, 0x42F0E1EB);
      expect(params.low, 0xA9EA3693);
      expect(params.seedHigh, 0xFFFFFFFF);
      expect(params.seedLow, 0xFFFFFFFF);
      expect(params.xorOutHigh, 0xFFFFFFFF);
      expect(params.xorOutLow, 0xFFFFFFFF);
    });

    for (var e in known.entries) {
      test('check "${e.key.name}"', () {
        expect(crc64sum("123456789", params: e.key), e.value);
      });
    }
  });
}
