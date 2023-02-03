// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/algorithms/xxhash32.dart';
import 'package:hashlib/src/core/longs.dart';
import 'package:test/test.dart';

void main() {
  final data = <int>[];
  for (int i = 0, g = prime32_1; i < 101; ++i) {
    data.add(g >>> 24);
    g = Longs.cross32(g, g);
  }
  group('XXHash test', () {
    test('with seed = 0 and an empty string', () {
      expect(xxh32.convert([]).hex(true), "02CC5D05");
    });
    test('with seed = $prime32_1 and an empty string', () {
      expect(xxh32_1.convert([]).hex(true), "36B78AE7");
    });
    test('with seed = 0 and a single letter', () {
      expect(xxh32.convert([data[0]]).hex(true), "B85CBEE5");
    });
    test('with seed = $prime32_1 and a single letter', () {
      expect(xxh32_1.convert([data[0]]).hex(true), "D5845D64");
    });
    test('with seed = 0 and 14 letters', () {
      expect(xxh32.convert(data.take(14).toList()).hex(true), "E5AA0AB4");
    });
    test('with seed = $prime32_1 and 14 letters', () {
      expect(xxh32_1.convert(data.take(14).toList()).hex(true), "4481951D");
    });
    test('with seed = 0 and 101 letters', () {
      expect(xxh32.convert(data).hex(true), "1F1AA412");
    });
    test('with seed = $prime32_1 and 101 letters', () {
      expect(xxh32_1.convert(data).hex(true), "498EC8E2");
    });
  });
}
