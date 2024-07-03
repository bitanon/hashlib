// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';
import 'package:pointycastle/digests/sm3.dart' as pc_sm3;

final tests = {
  "": "1ab21d8355cfa17f8e61194831e81a8f22bec8c728fefb747ed035eb5082aa2b",
  "a": "623476ac18f65a2909e43c7fec61b49c7e764a91a18ccb82f1917a29c86c5e88",
  "abc": "66c7f0f462eeedd9d1f2d46bdc10e4e24167c4875cf2f7a2297da02b8f4ba8e0",
  "message digest":
      "c522a942e89bd80d97dd666e7a5531b36188c9817149e9b258dfe51ece98ed77",
  "abcdefghijklmnopqrstuvwxyz":
      "b80fe97a4da24afc277564f66a359ef440462ad28dcc6d63adb24d5c20a61595",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789":
      "2971d10c8842b70c979e55063480c50bacffd90e98e2e60d2512ab8abfdfcec5",
  "12345678901234567890123456789012345678901234567890123456789012345678901234567890":
      "ad81805321f3e69d251235bf886a564844873b56dd7dde400f055b7dde39307a",
  "123": "6e0f9e14344c5406a0cf5a3b4dfb665f87f4a771a31f7edbb5c72874a32b2957",
  "test": "55e12e91650d2fec56ec74e1d3e4ddbfce2ef3a65890c2a19ecf88a307e76a23",
  'message': "1756ac517f85ffda751dcdebf3c89575272fc56904f9baad983ec44c36feac7b",
  "Hello World":
      "77015816143ee627f4fa410b6dad2bdb9fcbdf1e061a452a686b8711a484c5d7",
  List.filled(512, "a").join():
      "d2219631eeb014040abf9716ebba9b35aaba4ecc2065088df0a2cbd0db1b9ce9",
  List.filled(128, "a").join():
      "5fd947effbe82a5925faaee9123d43cea200cc257b28ed797505694b4bb020f6",
  List.filled(513, "a").join():
      "97baef04b5211a439b17eb067ad904e52b12058d7510669ad29b63b9d4609479",
  List.filled(511, "a").join():
      "5f4141700026fec7880a6d1d5f34dcc9253dea2df32928f71bc93860d675b38c",
  List.filled(1000000, "a").join():
      "c8aaf89429554029e231941a2acc0ad61ff2a5acd8fadd25847a3a732b3b02c3",
};

void main() {
  group('SM3 test', () {
    test('with empty string', () {
      expect(sm3sum(""), tests[""]);
    });

    test('with single letter -pc', () {
      pc_sm3.SM3Digest().process(Uint8List.fromList("a".codeUnits));
    });

    test('with single letter', () {
      expect(sm3sum("a"), tests["a"]);
    });

    test('with few letters', () {
      expect(sm3sum("abc"), tests["abc"]);
    });

    test('with longest string', () {
      var last = tests.entries.last;
      expect(sm3sum(last.key), last.value);
    });

    test('with special case', () {
      var key =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      expect(sm3sum(key), tests[key]);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(sm3sum(key), value);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(sm3sum(key), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map((s) => s.codeUnits);
        final result = await sm3.bind(stream).first;
        expect(result.hex(), entry.value);
      }
    });
  });
}
