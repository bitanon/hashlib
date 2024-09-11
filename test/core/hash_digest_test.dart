// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('HashDigest', () {
    late Uint8List bytes;
    late HashDigest digest;

    setUp(() {
      bytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      digest = HashDigest(bytes);
    });

    test('toString returns correct hex representation', () {
      expect(digest.toString(), equals('0102030405060708'));
    });

    test('binary returns correct binary representation', () {
      final matcher = equals(
        '00000001000000100000001100000100'
        '00000101000001100000011100001000',
      );
      expect(digest.binary(), matcher);
      expect(digest.binary(), matcher);
    });

    test('octal returns correct octal representation', () {
      expect(digest.octal(), equals('0004020060200501403410'));
    });

    test('hex returns correct hexadecimal representation', () {
      expect(digest.hex(), equals('0102030405060708'));
      var digest2 = HashDigest(Uint8List.fromList([9, 10, 11, 12]));
      expect(digest2.hex(), equals('090a0b0c'));
      expect(digest2.hex(true), equals('090A0B0C'));
    });

    test('base32 returns correct Base-32 representation', () {
      expect(digest.base32(), equals('AEBAGBAFAYDQQ==='));
      expect(digest.base32(upper: false), equals('aebagbafaydqq==='));
      expect(digest.base32(padding: false), equals('AEBAGBAFAYDQQ'));
    });

    test('base64 returns correct Base-64 representation', () {
      expect(digest.base64(), equals('AQIDBAUGBwg='));
      expect(digest.base64(padding: false),
          equals('AQIDBAUGBwg')); // Without padding
      expect(digest.base64(urlSafe: true),
          equals('AQIDBAUGBwg=')); // URL-safe base64
    });

    test('bigInt returns correct BigInt representation', () {
      expect(digest.bigInt(),
          equals(BigInt.parse('0807060504030201', radix: 16))); // Little-endian
      expect(digest.bigInt(endian: Endian.big),
          equals(BigInt.parse('0102030405060708', radix: 16))); // Big-endian
    });

    test('number returns correct integer representation', () {
      expect(digest.number(8), equals(8));
      expect(digest.number(16), equals(0x0708));
      expect(digest.number(16, Endian.little), equals(0x0201));
      expect(digest.number(32), equals(0x05060708));
      expect(digest.number(32, Endian.little), equals(0x04030201));
    });

    test('number does not accept invalid bit length', () {
      expect(() => digest.number(-8), throwsArgumentError);
      expect(() => digest.number(0), throwsArgumentError);
      expect(() => digest.number(4), throwsArgumentError);
      expect(() => digest.number(7), throwsArgumentError);
      expect(() => digest.number(9), throwsArgumentError);
      expect(() => digest.number(26), throwsArgumentError);
      expect(() => digest.number(63), throwsArgumentError);
      expect(() => digest.number(65), throwsArgumentError);
      expect(() => digest.number(96), throwsArgumentError);
      expect(() => digest.number(128), throwsArgumentError);
    });

    test('ascii returns correct ASCII representation', () {
      final asciiBytes = Uint8List.fromList('ABCDEFGH'.codeUnits);
      final asciiDigest = HashDigest(asciiBytes);
      expect(asciiDigest.ascii(), equals('ABCDEFGH'));
    });

    test('utf8 returns correct UTF-8 representation', () {
      final utf8Bytes = Uint8List.fromList(utf8.encode('Hello, World!'));
      final utf8Digest = HashDigest(utf8Bytes);
      expect(utf8Digest.utf8(), equals('Hello, World!'));
    });

    test('to(encoding) returns correct encoded string', () {
      final utf16Bytes = Uint8List.fromList(ascii.encode('Hello, World!'));
      final utf16Digest = HashDigest(utf16Bytes);
      expect(utf16Digest.to(ascii), equals('Hello, World!'));
    });

    test('hashCode returns correct hash code', () {
      expect(digest.hashCode, equals(bytes.hashCode));
    });

    test('equality check compares correctly', () {
      expect(digest == digest, isTrue);
      expect(digest == HashDigest(bytes), isTrue);
      expect(digest == HashDigest(Uint8List.fromList([...bytes])), isFalse);
    });

    test('isEqual returns true for equal digests', () {
      final otherDigest =
          HashDigest(Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]));
      expect(digest.isEqual(otherDigest), isTrue);
    });

    test('isEqual returns true for equal byte arrays', () {
      final byteArray = [1, 2, 3, 4, 5, 6, 7, 8];
      expect(digest.isEqual(byteArray), isTrue);
    });

    test('isEqual returns true for equal byte iterables', () {
      final byteIterables = {1, 2, 3, 4, 5, 6, 7, 8};
      expect(digest.isEqual(byteIterables), isTrue);
    });

    test('isEqual returns true for equal ByteBuffer', () {
      final buffer = bytes.buffer;
      expect(digest.isEqual(buffer), isTrue);
    });

    test('isEqual returns true for equal hexadecimal string', () {
      final hexString = '0102030405060708';
      expect(digest.isEqual(hexString), isTrue);
    });

    test('isEqual returns false for unequal digests', () {
      final otherDigest =
          HashDigest(Uint8List.fromList([8, 7, 6, 5, 4, 3, 2, 1]));
      expect(digest.isEqual(otherDigest), isFalse);
    });

    test('isEqual returns true with other buffer type', () {
      final data = Uint32List.fromList([0x04030201, 0x08070605]);
      expect(digest.isEqual(data), isTrue);
    });

    test('isEqual returns false for unequal byte arrays', () {
      final byteArray = [8, 7, 6, 5, 4, 3, 2, 1];
      expect(digest.isEqual(byteArray), isFalse);
    });

    test('isEqual returns false for different length', () {
      final otherDigest = HashDigest(Uint8List.fromList([1, 2, 3]));
      expect(digest.isEqual(otherDigest), isFalse);
    });

    test('isEqual returns false for unsupported types', () {
      expect(digest.isEqual(12345), isFalse);
      expect(digest.isEqual(null), isFalse);
    });
  });
}
