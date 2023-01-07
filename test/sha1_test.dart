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
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789":
      "761c457bf73b14d27e9e9265c46f4b4dda11f940",
  "12345678901234567890123456789012345678901234567890123456789012345678901234567890":
      "50abf5706a150990a08b2c5ea40fa0e585554732",
  "The quick brown fox jumps over the lazy dog":
      "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12",
  "The quick brown fox jumps over the lazy cog":
      "de9f2c7fd25e1b3afad3e85a0bd17d9b100db4b3",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "84983e441c3bd26ebaae4aa1f95129e5e54670f1",
  List.filled(512, "a").join(): "164557facb73929875168c1e92caf09bb6064564",
  List.filled(128, "a").join(): "ad5b3fdbcb526778c2839d2f151ea753995e26a0",
  List.filled(513, "a").join(): "87ecd7233dbe9d7543a9a199fc671a90e469873d",
  List.filled(511, "a").join(): "b9370eafb7ac772c6c1dc6b88ac9ad466b880ea1",
  List.filled(1000000, "a").join(): "34aa973cd4c4daa4f61eeb2bdbad27316534016f",
};

void main() {
  group('SHA1 test', () {
    test('with empty string', () {
      expect(hashlib.sha1sum("").hex(), tests[""]);
    });

    test('with single letter', () {
      expect(hashlib.sha1sum("a").hex(), tests["a"]);
    });

    test('with few letters', () {
      expect(hashlib.sha1sum("abc").hex(), tests["abc"]);
    });

    test('with longest string', () {
      var last = tests.entries.last;
      expect(hashlib.sha1sum(last.key).hex(), last.value);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(hashlib.sha1sum(key).hex(), value);
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
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(hashlib.sha1.convert(data).bytes),
          toHex(crypto.sha1.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });
  });
}
