// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

/// CRC-32 code for "123456789"
var known = {
  CRC32Params.ieee: 0xCBF43926,
  CRC32Params.bzip2: 0xFC891918,
  CRC32Params.cksum: 0x765E7680,
  CRC32Params.jamcrc: 0x340BC6D9,
  CRC32Params.mpeg2: 0x0376E6E7,
  CRC32Params.aixm: 0x3010BF7F,
  CRC32Params.autosar: 0x1697D06A,
  CRC32Params.base91D: 0x87315576,
  CRC32Params.cdRomEdc: 0x6EC2EDC4,
  CRC32Params.castagnoli: 0xE3069283,
  CRC32Params.koopman: 0xD2C22F51,
  CRC32Params.xfer: 0xBD0BE338,
};

void main() {
  group('CRC-32 test', () {
    test("name", () {
      expect(crc32.name, 'CRC-32/IEEE');
    });
    test("name for defined polynomial", () {
      expect(CRC32(CRC32Params.aixm).name, 'CRC-32/AIXM');
    });
    test("name for custom polynomial", () {
      expect(CRC32(CRC32Params(0x1919)).name, 'CRC-32/1919');
    });
    test('code with an empty string', () {
      expect(crc32code(""), 0);
    });
    test('with a string', () {
      expect(crc32.string("Wikipedia").hex(), "adaac02e");
    });
    test('code with a string', () {
      expect(crc32.code("Wikipedia", utf8), 0xadaac02e);
    });

    test('createSink produces same result for same input', () {
      final sink1 = crc32.createSink();
      sink1.add(utf8.encode("TestString"));
      final result1 = sink1.digest().hex();

      final sink2 = crc32.createSink();
      sink2.add(utf8.encode("TestString"));
      final result2 = sink2.digest().hex();

      expect(result1, equals(result2));
    });

    test('sink test', () {
      final sink = crc32.createSink();
      expect(sink.closed, isFalse);
      sink.add([10, 20]);
      expect(sink.closed, isFalse);
      sink.close();
      expect(sink.closed, isTrue);
      expect(() => sink.add([10]), throwsStateError);
      sink.reset();
      expect(sink.closed, isFalse);
      sink.add([10, 20, 30]);
      expect(sink.digest().length, 4);
      expect(sink.closed, isTrue);
    });

    for (var e in known.entries) {
      test('check "${e.key.name}"', () {
        expect(crc32code("123456789", polynomial: e.key), e.value);
      });
    }
  });
}
