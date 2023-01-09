import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

final tests = {
  "": "6ed0dd02806fa89e25de060c19d3ac86cabb87d6a0ddd05c333b84f4",
  "a": "d5cdb9ccc769a5121d4175f2bfdd13d6310e0d3d361ea75d82108327",
  "abc": "4634270f707b6a54daae7530460842e20e37ed265ceee9a43e8924aa",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "e5302d6d54bb242275d1e7622d68df6eb02dedd13f564c13dbda2174",
  "The quick brown fox jumps over the lazy dog":
      "944cd2847fb54558d4775db0485a50003111c8e5daa63fe722c6aa37",
  "The quick brown fox jumps over the lazy cog":
      "2b9d6565a7e40f780ba8ab7c8dcf41e3ed3b77997f4c55aa987eede5",
  List.filled(512, "a").join():
      "057bab73fa47ac3e597a34d02c1e285e2d5d8a2e90c9079f549b4af6",
  List.filled(128, "a").join():
      "261b94bcba554264b3b738e9e09e7dc68ac8e0b4c8517fe9bb7c3617",
  List.filled(513, "a").join():
      "502ec9656e1e0b96f9a2699c04cec265edc690b729c45037c6b37a00",
  List.filled(511, "a").join():
      "bd0452a57045c857de05b1c1d94fb49624b00ceaf0ec4c0d4d656a89",
  List.filled(1000000, "a").join():
      "37ab331d76f0d36de422bd0edeb22a28accd487b7a8453ae965dd287",
  List.filled(112, "a").join():
      "79b41fef2a0439d2705724a67615f7bcbcd2bf5664a7774b80818eb6",
};

void main() {
  group('SHA512224 test', () {
    test('with empty string', () {
      expect(hashlib.sha512sum224(""), tests[""]);
    });

    test('with single letter', () {
      expect(hashlib.sha512sum224("a"), tests["a"]);
    });

    test('with few letters', () {
      expect(hashlib.sha512sum224("abc"), tests["abc"]);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(hashlib.sha512sum224(key), value);
    });

    test('known cases', () {
      tests.forEach((key, value) {
        // print(toHex(crypto.sha512224.convert(toBytes(key)).bytes));
        expect(hashlib.sha512sum224(key), value);
      });
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(hashlib.sha512sum224(key), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map(toBytes);
        final result = await hashlib.sha512t224.stream(stream);
        expect(result.hex(), entry.value);
      }
    });

    test('to compare against known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(hashlib.sha512t224.convert(data).bytes),
          toHex(crypto.sha512224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(hashlib.sha512t224.convert(data).bytes),
          toHex(crypto.sha512224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });
}
