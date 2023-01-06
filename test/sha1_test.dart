import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

final tests = {
  "": "da39a3ee5e6b4b0d3255bfef95601890afd80709",
  "a": "86f7e437faa5a7fce15d1ddcb9eaeaea377667b8",
  "abc": "a9993e364706816aba3e25717850c26c9cd0d89d",
  "123": "40bd001563085fc35165329ea1ff5c5ecbdbbeef",
  "test": "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",
  'message': "6f9b9af3cd6e8b8a73c2cdced37fe9f59226e27d",
  "Hello World": "0a4d55a8d778e5022fab701977c5d840bbc486d0",
  "The quick brown fox jumps over the lazy dog":
      "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12",
  "The quick brown fox jumps over the lazy cog":
      "de9f2c7fd25e1b3afad3e85a0bd17d9b100db4b3",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "84983e441c3bd26ebaae4aa1f95129e5e54670f1",
  List.filled(1000000, "a").join(): "34aa973cd4c4daa4f61eeb2bdbad27316534016f",
  List.filled(10,
          "0123456701234567012345670123456701234567012345670123456701234567")
      .join(): "dea356a2cddd90c7a7ecedc5ebb563934f460452",
};

void main() {
  group('SHA1 tests', () {
    test('with empty string', () {
      expect(hashlib.sha1sum("").hex(), tests[""]);
    });

    test('with single letter', () {
      expect(hashlib.sha1sum("a").hex(), tests["a"]);
    });

    test('with few letters', () {
      expect(hashlib.sha1sum("abc").hex(), tests["abc"]);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(hashlib.sha1sum(key).hex(), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map(toBytes);
        final result = await hashlib.sha1stream(stream);
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
          toHex(hashlib.sha1.convert(data).bytes),
          toHex(crypto.sha1.convert(data).bytes),
          reason: String.fromCharCodes(data),
        );
      }
    });
  });
}
