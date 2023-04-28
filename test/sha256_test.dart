// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

final tests = {
  "": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
  "a": "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb",
  "abc": "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789":
      "db4bfcbd4da0cd85a60c3c37d3fbd8805c77f15fc6b1fdfe614ee0a7c8fdb4c0",
  "12345678901234567890123456789012345678901234567890123456789012345678901234567890":
      "f371bc4a311f2b009eef952dd83ca80e2b60026c8e935592d0f9c308453c813e",
  "The quick brown fox jumps over the lazy dog":
      "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592",
  "The quick brown fox jumps over the lazy cog":
      "e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be",
  List.filled(512, "a").join():
      "471be6558b665e4f6dd49f1184814d1491b0315d466beea768c153cc5500c836",
  List.filled(128, "a").join():
      "6836cf13bac400e9105071cd6af47084dfacad4e5e302c94bfed24e013afb73e",
  List.filled(513, "a").join():
      "02425c0f5b0dabf3d2b9115f3f7723a02ad8bcfb1534a0d231614fd42b8188f6",
  List.filled(511, "a").join():
      "058fc5084b6355a06099bfef3de8e360344046dc5a47026de47470b9aabb5bfd",
  List.filled(1000000, "a").join():
      "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0",
};

void main() {
  group('SHA256 test', () {
    test('with empty string', () {
      expect(sha256sum(""), tests[""]);
    });

    test('with single letter', () {
      expect(sha256sum("a"), tests["a"]);
    });

    test('with few letters', () {
      expect(sha256sum("abc"), tests["abc"]);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(sha256sum(key), value);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(sha256sum(key), value);
      });
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(sha256sum(key), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map(toBytes);
        final result = await sha256.consume(stream);
        expect(result.hex(), entry.value);
      }
    });
  });
}
