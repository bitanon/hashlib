import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

final tests = {
  "": "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f",
  "a": "abd37534c7d9a2efb9465de931cd7055ffdb8879563ae98078d6d6d5",
  "abc": "23097d223405d8228642a477bda255b32aadbce4bda0b3f7e36c9da7",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "75388b16512776cc5dba5da1fd890150b0c6455cb4f58b1952522525",
  "The quick brown fox jumps over the lazy dog":
      "730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525",
  "The quick brown fox jumps over the lazy cog":
      "fee755f44a55f20fb3362cdc3c493615b3cb574ed95ce610ee5b1e9b",
  List.filled(512, "a").join():
      "e926c6b764d4b216c99067c92f838ca1c5793c13c782d9ef7b668d71",
  List.filled(128, "a").join():
      "39873a2441c56608137850f4c54dde157710b9a2b83c8bdc756dd643",
  List.filled(513, "a").join():
      "e0afca6342847c80827fdc511f0004e53239d3c2f82f67ddd8185bef",
  List.filled(511, "a").join():
      "6eb1c24577241c0871ec3ab020786f59cecb2edb6acef2d483051d6a",
  List.filled(1000000, "a").join():
      "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67",
};

void main() {
  group('SHA-224 tests', () {
    test('with empty string', () {
      expect(hashlib.sha224sum("").hex(), tests[""]);
    });

    test('with single letter', () {
      expect(hashlib.sha224sum("a").hex(), tests["a"]);
    });

    test('with few letters', () {
      expect(hashlib.sha224sum("abc").hex(), tests["abc"]);
    });

    test('with block size', () {
      var key = tests.keys.firstWhere((x) => x.length == 512);
      var value = tests[key]!;
      expect(hashlib.sha224sum(key).hex(), value);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(hashlib.sha224sum(key).hex(), value);
      });
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(hashlib.sha224sum(key).hex(), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map(toBytes);
        final result = await hashlib.sha224stream(stream);
        expect(result.hex(), entry.value);
      }
    });

    test('to compare against known implementations', () {
      final random = Random.secure();
      for (int i = 0; i < 100; ++i) {
        final data = List.generate(
          random.nextInt(1000) + 10,
          (i) => random.nextInt(24) + 97,
        );
        expect(
          toHex(hashlib.sha224.convert(data).bytes),
          toHex(crypto.sha224.convert(data).bytes),
          reason: String.fromCharCodes(data),
        );
      }
    });
  });
}
