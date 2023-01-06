import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

final tests = {
  "": "d41d8cd98f00b204e9800998ecf8427e",
  "a": "0cc175b9c0f1b6a831c399e269772661",
  "abc": "900150983cd24fb0d6963f7d28e17f72",
  "message digest": "f96b697d7cb7938d525a2f31aaf161d0",
  "abcdefghijklmnopqrstuvwxyz": "c3fcd3d76192e4007dfb496cca67e13b",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789":
      "d174ab98d277d9f5a5611c2c9f419d9f",
  "12345678901234567890123456789012345678901234567890123456789012345678901234567890":
      "57edf4a22be3c955ac49da2e2107b67a",
  "123": "202cb962ac59075b964b07152d234b70",
  "test": "098f6bcd4621d373cade4e832627b4f6",
  'message': "78e731027d8fd50ed642340b7c9a63b3",
  "Hello World": "b10a8db164e0754105b7a99be72e3fe5",
  "fcnbqnfziebjnvbvqwwzzpdfafnvpyhkeemxxyijwuhkqyogkhdzovbvbbfguudzalavojxashfhzxrfmcjikzas":
      "6859ce201fd3ec059370d9eba4e86307",
  "fcnbqnfziebjnvbvqwwzzpdfafnvpyhkeemxxyijwuhkqyogkhdzovbvbbfguudzalavojxashfhzxrfmcjikz":
      "0e530931b1bb74c3df3a40a6854b6bf1",
  "fcnbqnfziebjnvbvqwwzzpdfafnvpyhkeemxxyijwuhkqyogkhdzovbvbbfguudzalavojxashfhzxrfmcjikzc":
      "e9227380933753a03dad1cb5d7be39bb",
  "simewkidgzgesatfyviqesladjafoclbwppqplhcwfqsbfnijiqsydxzpckbqxumulitsxzrpqhmdqhobhnhyoboijhcnulmxrhystmijucbnnnstecepnsynugxnqiqnssfbakzavpqxiyjkqjdcgvcrotocqsrlejuauleazpwnohknnuheooopltmjuqjcudewmtboqhlvgpawztiglmvxmolgzihczqcxfzebudlapnyeufbgijckqi":
      "9703e12025a2119b23a2b2da791ea44a",
};

void main() {
  group('MD5 tests', () {
    test('with empty string', () {
      expect(hashlib.md5sum("").hex(), tests[""]);
    });

    test('with single letter', () {
      expect(hashlib.md5sum("a").hex(), tests["a"]);
    });

    test('with few letters', () {
      expect(hashlib.md5sum("abc").hex(), tests["abc"]);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(hashlib.md5sum(key).hex(), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map(toBytes);
        final result = await hashlib.md5stream(stream);
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
          toHex(hashlib.md5.convert(data).bytes),
          toHex(crypto.md5.convert(data).bytes),
          reason: String.fromCharCodes(data),
        );
      }
    });
  });
}
