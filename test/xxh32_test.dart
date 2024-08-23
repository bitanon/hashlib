// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

const seed = 0x9E3779B1;
const data = <int>[
  158, 255, 31, 75, 94, 83, 47, 221, 181, 84, 77, 42, 149, 43, 87, 174, 93, //
  186, 116, 233, 211, 166, 76, 152, 48, 96, 192, 128, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
];

void main() {
  group('XXHash32 test', () {
    test('xxh32code', () {
      expect(xxh32code(String.fromCharCodes(data)), 0x1f1aa412);
    });

    test('with seed = 0 and an empty string', () {
      expect(xxh32.convert([]).hex(), "02cc5d05");
    });
    test('with seed = 0 and a single letter', () {
      expect(xxh32.convert([data[0]]).hex(), "b85cbee5");
    });
    test('with seed = 0 and 14 letters', () {
      final input = String.fromCharCodes(data.take(14));
      expect(xxh32sum(input), "e5aa0ab4");
    });
    test('with seed = 0 and 101 letters', () {
      expect(xxh32.convert(data).number(), 0x1f1aa412);
    });

    test('with a seed and an empty string', () {
      final input = <int>[];
      expect(xxh32.withSeed(seed).convert(input).hex(), "36b78ae7");
    });

    test('with a seed and a single letter', () {
      final input = <int>[data[0]];
      expect(xxh32.withSeed(seed).convert(input).hex(), "d5845d64");
    });

    test('with a seed and 14 letters', () {
      final input = data.take(14).toList();
      expect(xxh32.withSeed(seed).convert(input).hex(), "4481951d");
    });

    test('with a seed and 101 letters', () {
      expect(xxh32.withSeed(seed).convert(data).hex(), "498ec8e2");
    });

    test('with 32-byte message', () {
      final input = "string of 32-bytes long for test";
      expect(xxh32code(input), 0x90d90755);
    });

    test('with 64-byte message', () {
      final input =
          "string of 64-bytes for test. twice the size of 32-byte string.";
      expect(xxh32code(input), 0x0b438557);
    });
  });
}
