// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';
import 'dart:async';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('SHAKE test', () {
    test("Shake128 name", () {
      expect(Shake128(8).name, 'SHAKE-128/64');
      expect(shake128.of(4).name, 'SHAKE-128/32');
      expect(shake128_128.name, 'SHAKE-128/128');
      expect(shake128_160.name, 'SHAKE-128/160');
      expect(shake128_224.name, 'SHAKE-128/224');
      expect(shake128_256.name, 'SHAKE-128/256');
      expect(shake128_384.name, 'SHAKE-128/384');
      expect(shake128_512.name, 'SHAKE-128/512');
    });

    test("Shake256 name", () {
      expect(Shake256(8).name, 'SHAKE-256/64');
      expect(shake256.of(4).name, 'SHAKE-256/32');
      expect(shake256_128.name, 'SHAKE-256/128');
      expect(shake256_160.name, 'SHAKE-256/160');
      expect(shake256_224.name, 'SHAKE-256/224');
      expect(shake256_256.name, 'SHAKE-256/256');
      expect(shake256_384.name, 'SHAKE-256/384');
      expect(shake256_512.name, 'SHAKE-256/512');
    });

    test('SHAKE-128 with empty message', () {
      expect(
        shake128.of(512).convert([]).hex().substring((512 - 32) * 2),
        "43e41b45a653f2a5c4492c1add544512dda2529833462b71a41a45be97290b6f",
      );
    });

    test('shake128sum', () {
      expect(
        shake128sum('a test message', 32),
        "763cd3748d2c24843f8f1c9b1ae78514f10e1e9a964e81e1295609fc81c936e0",
      );
    });

    test('shake128sum with encoding', () {
      expect(
        shake128sum('a test message', 32, utf8, true),
        "763CD3748D2C24843F8F1C9B1AE78514F10E1E9A964E81E1295609FC81C936E0",
      );
    });

    test('SHAKE-128 with some message', () {
      var inp = 'a test message'.codeUnits;
      expect(
        shake128.of(128).convert(inp).hex(),
        "763cd3748d2c24843f8f1c9b1ae78514f10e1e9a964e81e1295609fc81c936e0"
        "55b4b59405ad0509a27e80273f8219ee4fb25e77f3ca75994fbe1c0753014575"
        "6364ae785175d206393eb5808166fdee95f80256c0ec53ebd1ffba21f56f0603"
        "c01b0d0842977a4570612a5f184e39d60a59d605b281810a9fb2c387e5beacfe",
      );
    });

    test('SHAKE-128 with 1600-bit message', () async {
      final sc = StreamController<List<int>>();
      final digest = shake128.of(512).bind(sc.stream);
      final buf = List.filled(20, 0xA3);
      for (int i = 0; i < 200; i += 20) {
        sc.sink.add(buf);
      }
      sc.close();
      final out = await digest.first;
      expect(
        out.hex().substring((512 - 32) * 2),
        "44c9fb359fd56ac0a9a75a743cff6862f17d7259ab075216c0699511643b6439",
      );
    });

    test('shake256sum', () {
      expect(
        shake256sum('a test message', 32),
        "06cd8095b01a33a20e67c1c265af4079a8b861687d6e87e447861c4221dbe83d",
      );
    });

    test('shake256sum with encoding', () {
      expect(
        shake256sum('a test message', 32, utf8, true),
        "06CD8095B01A33A20E67C1C265AF4079A8B861687D6E87E447861C4221DBE83D",
      );
    });

    test('SHAKE-256 with some message', () {
      var inp = 'a test message'.codeUnits;
      expect(
        shake256.of(128).convert(inp).hex(),
        "06cd8095b01a33a20e67c1c265af4079a8b861687d6e87e447861c4221dbe83d"
        "e9c36540e3e4b9b7f75f84e1d8fc57451d2fca0b052691d4cb448e0fe2132419"
        "3feb52911aeedb57093d07b3ba128508271de6554cc651415e5af3f1b4d09d53"
        "7e87b0b7685031e09a848d60ff6a86c5f9f5a5b5a3070ce677b949264f6b4046",
      );
    });

    test('SHAKE-256 with empty message', () {
      expect(
        shake256.of(512).convert([]).hex().substring((512 - 32) * 2),
        "ab0bae316339894304e35877b0c28a9b1fd166c796b9cc258a064a8f57e27f2a",
      );
    });

    test('SHAKE-256 with 1600-bit message', () async {
      final sc = StreamController<List<int>>();
      final digest = shake256.of(512).bind(sc.stream);
      final buf = List.filled(20, 0xA3);
      for (int i = 0; i < 200; i += 20) {
        sc.sink.add(buf);
      }
      sc.close();
      final out = await digest.first;
      expect(out.hex().substring((512 - 32) * 2),
          "6a1a9d7846436e4dca5728b6f760eef0ca92bf0be5615e96959d767197a0beeb");
    });

    test('SHAKE-128 generator', () {
      var original = shake128.of(1024).convert([]).bytes;
      expect(shake128generator().take(1024), equals(original));
    });
    test('SHAKE-256 generator', () {
      var original = shake256.of(1024).convert([]).bytes;
      expect(shake256generator().take(1024), equals(original));
    });
    test('SHAKE-128 generator with seed', () {
      var seed = '012345678910111213141516171819'.codeUnits;
      var original = shake128.of(1024).convert(seed).bytes;
      expect(shake128generator(seed).take(1024), equals(original));
    });
    test('SHAKE-256 generator with seed', () {
      var seed = '012345678910111213141516171819'.codeUnits;
      var original = shake256.of(1024).convert(seed).bytes;
      expect(shake256generator(seed).take(1024), equals(original));
    });
  });
}
