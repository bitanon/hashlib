// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:math';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('MD5 test', () {
    test('with empty string', () {
      expect(md5sum(""), equals("d41d8cd98f00b204e9800998ecf8427e"));
    });

    test('with single letter', () {
      expect(md5sum("a"), equals("0cc175b9c0f1b6a831c399e269772661"));
    });

    test('with few letters', () {
      expect(md5sum("abc"), equals("900150983cd24fb0d6963f7d28e17f72"));
    });

    test('"message digest"', () {
      final input = "message digest";
      final output = "f96b697d7cb7938d525a2f31aaf161d0";
      expect(md5sum(input), equals(output));
    });
    test('"abcdefghijklmnopqrstuvwxyz"', () {
      final input = "abcdefghijklmnopqrstuvwxyz";
      final output = "c3fcd3d76192e4007dfb496cca67e13b";
      expect(md5sum(input), equals(output));
    });
    test('with string A-Za-z0-9', () {
      final input =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      final output = "d174ab98d277d9f5a5611c2c9f419d9f";
      expect(md5sum(input), equals(output));
    });

    test('with a very long number string', () {
      final input =
          "12345678901234567890123456789012345678901234567890123456789012345678901234567890";
      final output = "57edf4a22be3c955ac49da2e2107b67a";
      expect(md5sum(input), equals(output));
    });
    test('"123"', () {
      final input = "123";
      final output = "202cb962ac59075b964b07152d234b70";
      expect(md5sum(input), equals(output));
    });
    test('"test"', () {
      final input = "test";
      final output = "098f6bcd4621d373cade4e832627b4f6";
      expect(md5sum(input), equals(output));
    });
    test('"message"', () {
      final input = 'message';
      final output = "78e731027d8fd50ed642340b7c9a63b3";
      expect(md5sum(input), equals(output));
    });
    test('"Hello World"', () {
      final input = "Hello World";
      final output = "b10a8db164e0754105b7a99be72e3fe5";
      expect(md5sum(input), equals(output));
    });
    test('List.filled(512, "a").join()', () {
      final input = List.filled(512, "a").join();
      final output = "56907396339ca2b099bd12245f936ddc";
      expect(md5sum(input), equals(output));
    });
    test('List.filled(128, "a").join()', () {
      final input = List.filled(128, "a").join();
      final output = "e510683b3f5ffe4093d021808bc6ff70";
      expect(md5sum(input), equals(output));
    });
    test('List.filled(513, "a").join()', () {
      final input = List.filled(513, "a").join();
      final output = "6649c3e827e44f7bf539768bddf76435";
      expect(md5sum(input), equals(output));
    });
    test('List.filled(511, "a").join()', () {
      final input = List.filled(511, "a").join();
      final output = "3ba3485f242a5859f4417ccf004cd74c";
      expect(md5sum(input), equals(output));
    });
    test('List.filled(1000000, "a").join()', () {
      final input = List.filled(1000000, "a").join();
      final output = "7707d6ae4e027c70eea2a935c2296f21";
      expect(md5sum(input), equals(output));
    }, skip: true);

    test('with stream', () async {
      final input = List.filled(511, "a").join();
      final stream = Stream.fromIterable(input.codeUnits);
      final output = "3ba3485f242a5859f4417ccf004cd74c";
      final actual = await md5.byteStream(stream);
      expect(actual.hex(), output);
    });

    test('sink test', () {
      final input = List.filled(511, "a".codeUnitAt(0));
      final output = "3ba3485f242a5859f4417ccf004cd74c";
      final sink = md5.createSink();
      expect(sink.closed, isFalse);
      for (int i = 0; i < input.length; i += 48) {
        sink.add(input.skip(i).take(48).toList());
      }
      expect(sink.digest().hex(), equals(output));
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
      sink.reset();
      sink.add(input);
      sink.close();
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
    });
  });
}
