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
  List.filled(1000000, "a").join():
      "20794655980c91d8bbb4c1ea97618a4bf03f42581948b2ee4ee7ad67",
  List.filled(10,
          "0123456701234567012345670123456701234567012345670123456701234567")
      .join(): "567f69f168cd7844e65259ce658fe7aadfa25216e68eca0eb7ab8262",
  "The quick brown fox jumps over the lazy dog":
      "730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525",
  "The quick brown fox jumps over the lazy cog":
      "fee755f44a55f20fb3362cdc3c493615b3cb574ed95ce610ee5b1e9b",
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
