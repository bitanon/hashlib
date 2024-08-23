// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('RIPEMD-320 test', () {
    test('with defined cases', () {
      var m = [
        "",
        "a",
        "abc",
        "message digest",
        "abcdefghijklmnopqrstuvwxyz",
        "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
        "1234567890123456789012345678901234567890123456789012345678901234"
            "5678901234567890",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678901",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678901"
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz012345678901",
      ];
      var r = [
        "22d65d5661536cdc75c1fdf5c6de7b41b9f27325ebc61e8557177d705a0ec880151c3a32a00899b8",
        "ce78850638f92658a5a585097579926dda667a5716562cfcf6fbe77f63542f99b04705d6970dff5d",
        "de4c01b3054f8930a79d09ae738e92301e5a17085beffdc1b8d116713e74f82fa942d64cdbc4682d",
        "3a8e28502ed45d422f68844f9dd316e7b98533fa3f2a91d29f84d425c88d6b4eff727df66a7c0197",
        "cabdb1810b92470a2093aa6bce05952c28348cf43ff60841975166bb40ed234004b8824463e6b009",
        "d034a7950cf722021ba4b84df769a5de2060e259df4c9bb4a4268c0e935bbc7470a969c9d072a1ac",
        "ed544940c86d67f250d232c30b7b3e5770e0c60c8cb9a4cafe3b11388af9920e1b99230b843c86a4",
        "557888af5f6d8ed62ab66945c6d2a0a47ecd5341e915eb8fea1d0524955f825dc717e4a008ab2d42",
        "6904accd706958e5a3945d41229c6d043a80d3524a04e1fe9f9570b64ab1d91629b31c40a76d2ca6",
        "44723549cc506a8e0782494e87d510837225c493185b4c4a630b807d5e40e73038aa5923f3c3309e",
      ];
      for (var i = 0; i < m.length; ++i) {
        expect(ripemd320sum(m[i]), r[i]);
      }
    });
    test('with a millian "a"', () {
      var m = List<int>.filled(1000000, 'a'.codeUnitAt(0));
      var r = "bdee37f4371e20646b8b0d862dda16292ae36f4"
          "0965e8c8509e63d1dbddecc503e2b63eb9245bb66";
      expect(ripemd320.convert(m).hex(), r);
    }, skip: true);

    test('sink test', () {
      final input =
          "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
              .codeUnits;
      final output =
          "557888af5f6d8ed62ab66945c6d2a0a47ecd5341e915eb8fea1d0524955f825dc717e4a008ab2d42";
      final sink = ripemd320.createSink();
      expect(sink.closed, isFalse);
      for (int i = 0; i < input.length; i += 48) {
        sink.add(input.skip(i).take(48).toList());
      }
      expect(sink.digest().hex(), equals(output));
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
      sink.reset();
      sink.add(input);
      sink.close();
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
    });
  });
}
