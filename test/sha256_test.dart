import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

void main() {
  group('SHA256 tests', () {
    test('with some common cases', () {
      final data = {
        "": "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855",
        "a": "ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb",
        "abc":
            "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
      };
      data.forEach((key, value) {
        expect(hashlib.sha256(key).hex(), value);
      });
    });

    test('from RFC3174', () {
      final data = {
        "abc":
            "ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad",
        "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
            "248d6a61d20638b8e5c026930c3e6039a33ce45964ff2167f6ecedd419db06c1",
        List.filled(1000000, "a").join():
            "cdc76e5c9914fb9281a1c7e284d73e67f1809a48a497200e046d39ccc7112cd0",
        List.filled(10,
                    "0123456701234567012345670123456701234567012345670123456701234567")
                .join():
            "594847328451bdfa85056225462cc1d867d877fb388df0ce35f25ab5562bfbb5",
      };
      data.forEach((key, value) {
        expect(hashlib.sha256(key).hex(), value);
      });
    });

    test('from Wikipedia', () {
      final data = {
        "The quick brown fox jumps over the lazy dog":
            "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592",
        "The quick brown fox jumps over the lazy cog":
            "e4c4d8f3bf76b692de791a173e05321150f7a345b46484fe427f6acc7ecc81be",
      };
      data.forEach((key, value) {
        expect(hashlib.sha256(key).hex(), value);
      });
    });

    test('with many random numbers', () {
      final random = Random.secure();
      for (int i = 0; i < 100; ++i) {
        final data = List.generate(
          random.nextInt(1000),
          (i) => random.nextInt(24) + 97,
        );
        expect(
          hashlib.sha256buffer(data).hex(),
          toHex(crypto.sha256.convert(data).bytes),
          reason: "[${data.length}] ${String.fromCharCodes(data)}",
        );
      }
    });
  });
}
