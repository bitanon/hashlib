// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:math';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

final tests = {
  "": "31d6cfe0d16ae931b73c59d7e0c089c0",
  "a": "bde52cb31de33e46245e05fbdbd6fb24",
  "abc": "a448017aaf21d8525fc10ae87aa6729d",
  "message digest": "d9130a8164549fe818874806e1c7014b",
  "abcdefghijklmnopqrstuvwxyz": "d79e1c308aa5bbcdeea8ed63df412da9",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789":
      "043f8582f241db351ce627e153e7f0e4",
  "12345678901234567890123456789012345678901234567890123456789012345678901234567890":
      "e33b4ddc9c38f2199c3e7b164fcc0536",
  "123": "c58cda49f00748a3bc0fcfa511d516cb",
  "test": "db346d691d7acc4dc2625db19f9e3f52",
  'message': "ffa70bbb57bda34ec842cac3d9a099aa",
  "Hello World": "77a781b995cf1cfaf39d9e2f5910c2cf",
  List.filled(512, "a").join(): "71ad0ebe8db92f0deca36c233e1ac4cb",
  List.filled(128, "a").join(): "cb4a20a561558e29460190c91dced59f",
  List.filled(513, "a").join(): "e5f5b4253616aeb972b6f823a2519911",
  List.filled(511, "a").join(): "1c2912a2a50886af88bbf6b374593d6c",
  List.filled(1000000, "a").join(): "bbce80cc6bb65e5c6745e30d4eeca9a4",
};

void main() {
  group('MD4 test', () {
    test('with empty string', () {
      expect(md4sum(""), tests[""]);
    });

    test('with single letter', () {
      expect("a".md4digest().hex(), tests["a"]);
    });

    test('with few letters', () {
      expect(md4sum("abc"), tests["abc"]);
    });

    test('with longest string', () {
      var last = tests.entries.last;
      expect(md4sum(last.key), last.value);
    });

    test('with special case', () {
      var key =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      expect(md4sum(key), tests[key]);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(md4sum(key), value);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(md4sum(key), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map((s) => s.codeUnits);
        final result = await md4.consume(stream);
        expect(result.hex(), entry.value);
      }
    });
  });
}
