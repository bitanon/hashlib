// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('RIPEMD-256 test', () {
    test('with defined cases', () {
      var m = [
        "",
        "a",
        "abc",
        "message digest",
        "abcdefghijklmnopqrstuvwxyz",
        "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq",
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789",
        "12345678901234567890123456789012345678901234567890123456789012345678901234567890"
      ];
      var r = [
        "02ba4c4e5f8ecd1877fc52d64d30e37a2d9774fb1e5d026380ae0168e3c5522d",
        "f9333e45d857f5d90a91bab70a1eba0cfb1be4b0783c9acfcd883a9134692925",
        "afbd6e228b9d8cbbcef5ca2d03e6dba10ac0bc7dcbe4680e1e42d2e975459b65",
        "87e971759a1ce47a514d5c914c392c9018c7c46bc14465554afcdf54a5070c0e",
        "649d3034751ea216776bf9a18acc81bc7896118a5197968782dd1fd97d8d5133",
        "3843045583aac6c8c8d9128573e7a9809afb2a0f34ccc36ea9e72f16f6368e3f",
        "5740a408ac16b720b84424ae931cbb1fe363d1d0bf4017f1a89f7ea6de77a0b8",
        "06fdcc7a409548aaf91368c06a6275b553e3f099bf0ea4edfd6778df89a890dd"
      ];
      for (var i = 0; i < m.length; ++i) {
        expect(ripemd256sum(m[i]), r[i]);
      }
    });
    test('with a millian "a"', () {
      var m = List<int>.filled(1000000, 'a'.codeUnitAt(0));
      var r = "ac953744e10e31514c150d4d8d7b6773"
          "42e33399788296e43ae4850ce4f97978";
      expect(ripemd256.convert(m).hex(), r);
    }, tags: ['skip-js']);
  });
}
