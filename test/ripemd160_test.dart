// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('MD5 test', () {
    test('with empty string', () {
      var m = "";
      var r = "9c1185a5c5e9fc54612808977ee8f548b2258d31";
      expect(ripemd160sum(m), r);
    });
    test('with long string 1', () {
      var m = "The quick brown fox jumps over the lazy dog";
      var r = "37f332f68db77bd9d7edd4969571ad671cf9dd3b";
      expect(ripemd160sum(m), r);
    });
    test('with long string 2', () {
      var m = "The quick brown fox jumps over the lazy cog";
      var r = "132072df690933835eb8b6ad0b77e7b6f14acad7";
      expect(ripemd160sum(m), r);
    });
    test('with defined cases', () {
      var m = [
        "a",
        "abc",
        "message digest",
        "abcdefghijklmnopqrstuvwxyz",
        "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
        "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
      ];
      var r = [
        "0bdc9d2d256b3ee9daae347be6f4dc835a467ffe",
        "8eb208f7e05d987a9b044a8e98c6b087f15a0bfc",
        "5d0689ef49d2fae572b881b123a85ffa21595f36",
        "f71c27109c692c1b56bbdceb5b9d2865b3708dbc",
        "12a053384a9c0c88e405a06c27dcf49ada62eb2b",
        "b0e20b6e3116640286ed3a87a5713079b21f5189",
        "9b752e45573d4b39f4dbd3323cab82bf63326bfb"
      ];
      for (var i = 0; i < m.length; ++i) {
        expect(ripemd160sum(m[i]), r[i]);
      }
    });
    test('with a millian "a"', () {
      var m = List<int>.filled(1000000, 'a'.codeUnitAt(0));
      var r = '52783243c1697bdbe16d37f97f68f08325dc1528';
      expect(ripemd160.convert(m).hex(), r);
    });
    test('string: "Hello, world!"', () {
      var m = "Hello, world!";
      var r = "58262d1fbdbe4530d8865d3518c6d6e41002610f";
      expect(ripemd160sum(m), r);
    });
  });
}
