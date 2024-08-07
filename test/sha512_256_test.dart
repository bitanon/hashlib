// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

final tests = {
  "": "c672b8d1ef56ed28ab87c3622c5114069bdd3ad7b8f9737498d0c01ecef0967a",
  "a": "455e518824bc0601f9fb858ff5c37d417d67c2f8e0df2babe4808858aea830f8",
  "abc": "53048e2681941ef99b2e29b76b4c7dabe4c2d0c634fc6d46e0e2f13107e7af23",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "bde8e1f9f19bb9fd3406c90ec6bc47bd36d8ada9f11880dbc8a22a7078b6a461",
  "The quick brown fox jumps over the lazy dog":
      "dd9d67b371519c339ed8dbd25af90e976a1eeefd4ad3d889005e532fc5bef04d",
  "The quick brown fox jumps over the lazy cog":
      "cc8d255a7f2f38fd50388fd1f65ea7910835c5c1e73da46fba01ea50d5dd76fb",
  List.filled(512, "a").join():
      "092b65b92e80ccf4c66683684fb02da4567160534abede190e9b2edef6156839",
  List.filled(128, "a").join():
      "b88f97e274f9c1d49f181c8cbd01a9c74930ad055a46ac4499a1d601f1c80bf2",
  List.filled(513, "a").join():
      "a59cf33e5ad3e70d4962adbb833d021eafa48f85dd9788f84fca4cf762c5f1c7",
  List.filled(511, "a").join():
      "7e627ccc0719192627fcf9f3987d3da9a61f261a09580371e1ea4622b8ccfcc8",
  List.filled(1000000, "a").join():
      "9a59a052930187a97038cae692f30708aa6491923ef5194394dc68d56c74fb21",
  List.filled(112, "a").join():
      "9216b5303edb66504570bee90e48ea5beaa5e9fe9f760bbd3e0460559fc005f6",
};

void main() {
  group('SHA512256 test', () {
    test('with empty string', () {
      expect(sha512t256sum(""), tests[""]);
    });

    test('with single letter', () {
      expect(sha512t256sum("a"), tests["a"]);
    });

    test('with few letters', () {
      expect(sha512t256sum("abc"), tests["abc"]);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(sha512t256sum(key), value);
    });

    test('known cases', () {
      tests.forEach((key, value) {
        // print(toHex(crypto.sha512256.convert(toBytes(key)).bytes));
        expect(sha512t256sum(key), value);
      });
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(sha512t256sum(key), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map((s) => s.codeUnits);
        final result = await sha512t256.bind(stream).first;
        expect(result.hex(), entry.value);
      }
    });
  });
}
