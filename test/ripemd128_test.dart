// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('RIPEMD-128 test', () {
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
        "cdf26213a150dc3ecb610f18f6b38b46",
        "86be7afa339d0fc7cfc785e72f578d33",
        "c14a12199c66e4ba84636b0f69144c77",
        "9e327b3d6e523062afc1132d7df9d1b8",
        "fd2aa607f71dc8f510714922b371834e",
        "a1aa0689d0fafa2ddc22e88b49133a06",
        "d1e959eb179c911faea4624c60c5c702",
        "3f45ef194732c2dbb2c4a2c769795fa3",
        "7388178e5d59f3a68b4bf524f6c7a970",
        "f49f55294493b91df0a2592440a5e2ca",
      ];
      for (var i = 0; i < m.length; ++i) {
        expect(ripemd128sum(m[i]), r[i]);
      }
    });
    test('with a millian "a"', () {
      var m = List<int>.filled(1000000, 'a'.codeUnitAt(0));
      var r = "4a7f5723f954eba1216c9d8f6320431f";
      expect(ripemd128.convert(m).hex(), r);
    }, skip: true);

    test('sink test', () {
      final input =
          "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
              .codeUnits;
      final output = "3f45ef194732c2dbb2c4a2c769795fa3";
      final sink = ripemd128.createSink();
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
