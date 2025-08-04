// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

/// CRC-16 code for "123456789"
var known = {
  CRC16Params.ibm: 0xBB3D,
  CRC16Params.ccitt: 0x2189,
  CRC16Params.arinc: 0xEBA4,
  CRC16Params.cms: 0xAEE7,
  CRC16Params.dds110: 0x9ECF,
  CRC16Params.maximDow: 0x44C2,
  CRC16Params.modbus: 0x4B37,
  CRC16Params.umts: 0xFEE8,
  CRC16Params.usb: 0xB4C8,
  CRC16Params.genibus: 0xD64E,
  CRC16Params.gsm: 0xCE3C,
  CRC16Params.ibm3740: 0x29B1,
  CRC16Params.ccittFalse: 0x29B1,
  CRC16Params.ibmSdlc: 0x906E,
  CRC16Params.x25: 0x906E,
  CRC16Params.iso: 0xBF05,
  CRC16Params.mcrf4xx: 0x6F91,
  CRC16Params.riello: 0x63D0,
  CRC16Params.augCcitt: 0xE5CC,
  CRC16Params.spiFujitsu: 0xE5CC,
  CRC16Params.tms37157: 0x26B1,
  CRC16Params.xmodem: 0x31C3,
  CRC16Params.cdma2000: 0x4C06,
  CRC16Params.dectR: 0x007E,
  CRC16Params.dectX: 0x007F,
  CRC16Params.dnp: 0xEA82,
  CRC16Params.en13757: 0xC2B7,
  CRC16Params.lj1200: 0xBDF4,
  CRC16Params.nrsc5: 0xA066,
  CRC16Params.m17: 0x772B,
  CRC16Params.opensafetyA: 0x5D38,
  CRC16Params.opensafetyB: 0x20FE,
  CRC16Params.profibus: 0xA819,
  CRC16Params.t10Dif: 0xD0DB,
  CRC16Params.teledisk: 0x0FB3,
};

void main() {
  group('CRC test', () {
    test("name", () {
      expect(crc16.name, 'CRC-16/ARC');
    });
    test("name for defined polynomial", () {
      expect(CRC16(CRC16Params.arinc).name, 'CRC-16/ARINC');
    });
    test("name for custom polynomial", () {
      expect(CRC16(CRC16Params(0x1919)).name, 'CRC-16/1919');
    });

    test('code with an empty string', () {
      expect(crc16code(""), 0);
    });
    test('with a string', () {
      expect(crc16.string("Wikipedia").hex(), "ee3e");
    });
    test('code with a string', () {
      expect(crc16.code("Wikipedia", utf8), 0xee3e);
    });

    test('createSink produces same result for same input', () {
      final sink1 = crc16.createSink();
      sink1.add(utf8.encode("TestString"));
      final result1 = sink1.digest().hex();

      final sink2 = crc16.createSink();
      sink2.add(utf8.encode("TestString"));
      final result2 = sink2.digest().hex();

      expect(result1, equals(result2));
    });

    test('sink test', () {
      final sink = crc16.createSink();
      expect(sink.closed, isFalse);
      sink.add([10, 20]);
      expect(sink.closed, isFalse);
      sink.close();
      expect(sink.closed, isTrue);
      expect(() => sink.add([10]), throwsStateError);
      sink.reset();
      expect(sink.closed, isFalse);
      sink.add([10, 20, 30]);
      expect(sink.digest().length, 2);
      expect(sink.closed, isTrue);
    });

    for (var e in known.entries) {
      test('check "${e.key.name}"', () {
        expect(crc16code("123456789", polynomial: e.key), e.value);
      });
    }
  });
}
