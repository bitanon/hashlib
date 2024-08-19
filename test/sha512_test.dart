// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

final tests = {
  "": "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce"
      "47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e",
  "a": "1f40fc92da241694750979ee6cf582f2d5d7d28e18335de05abc54d0560e0f53"
      "02860c652bf08d560252aa5e74210546f369fbbbce8c12cfc7957b2652fe9a75",
  "abc": "ddaf35a193617abacc417349ae20413112e6fa4e89a97ea20a9eeee64b55d39a"
      "2192992a274fc1a836ba3c23a3feebbd454d4423643ce80e2a9ac94fa54ca49f",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "204a8fc6dda82f0a0ced7beb8e08a41657c16ef468b228a8279be331a703c335"
          "96fd15c13b1b07f9aa1d3bea57789ca031ad85c7a71dd70354ec631238ca3445",
  "The quick brown fox jumps over the lazy dog":
      "07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb64"
          "2e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6",
  "The quick brown fox jumps over the lazy cog":
      "3eeee1d0e11733ef152a6c29503b3ae20c4f1f3cda4cb26f1bc1a41f91c7fe4a"
          "b3bd86494049e201c4bd5155f31ecb7a3c8606843c4cc8dfcab7da11c8ae5045",
  List.filled(512, "a").join():
      "0210d27bcbe05c2156627c5f136ade1338ab98e06a4591a00b0bcaa61662a593"
          "1d0b3bd41a67b5c140627923f5f6307669eb508d8db38b2a8cd41aebd783394b",
  List.filled(128, "a").join():
      "b73d1929aa615934e61a871596b3f3b33359f42b8175602e89f7e06e5f658a24"
          "3667807ed300314b95cacdd579f3e33abdfbe351909519a846d465c59582f321",
  List.filled(513, "a").join():
      "ebfd31a4fae71ce18d1df9c4c8cfa9803d8390fc3ef3c122c3ddf4015af96abd"
          "90ffc16f3f0ef66ffd28295603250407402e68a0cc0bcd5f38b9557717ea3d39",
  List.filled(511, "a").join():
      "fe32a1f497ce532d041889133436c7086ea40410af5728a6b958aa4a169de44e"
          "3884311461188be5f65e79b9a53d010d8347ac20118e4e05df787a17ba71204b",
  List.filled(1000000, "a").join():
      "e718483d0ce769644e2e42c7bc15b4638e1f98b13b2044285632a803afa973eb"
          "de0ff244877ea60a4cb0432ce577c31beb009c5c2c49aa2e4eadb217ad8cc09b",
  List.filled(112, "a").join():
      "c01d080efd492776a1c43bd23dd99d0a2e626d481e16782e75d54c2503b5dc32"
          "bd05f0f1ba33e568b88fd2d970929b719ecbb152f58f130a407c8830604b70ca",
};

void main() {
  group('SHA512 test', () {
    test('with empty string', () {
      expect(sha512sum(""), tests[""]);
    });

    test('with single letter', () {
      expect(sha512sum("a"), tests["a"]);
    });

    test('with few letters', () {
      expect(sha512sum("abc"), tests["abc"]);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(sha512sum(key), value);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(sha512sum(key), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map((s) => s.codeUnits);
        final result = await sha512.bind(stream).first;
        expect(result.hex(), entry.value);
      }
    });
  });
}
