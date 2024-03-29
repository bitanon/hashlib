// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

const seed = 0x9E3779B1;
const xxh32_1 = XXHash32(seed);
const data = <int>[
  158, 255, 31, 75, 94, 83, 47, 221, 181, 84, 77, 42, 149, 43, 87, 174, 93, //
  186, 116, 233, 211, 166, 76, 152, 48, 96, 192, 128, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
];

void main() {
  group('XXHash32 test', () {
    test('with seed = 0 and an empty string', () {
      expect(xxh32.convert([]).hex(), "02cc5d05");
    });
    test('with seed = 0 and a single letter', () {
      expect(xxh32.convert([data[0]]).hex(), "b85cbee5");
    });
    test('with seed = 0 and 14 letters', () {
      expect(xxh32.convert(data.take(14).toList()).hex(), "e5aa0ab4");
    });
    test('with seed = 0 and 101 letters', () {
      expect(xxh32.convert(data).hex(), "1f1aa412");
    });

    test('with seed = $seed and an empty string', () {
      expect(xxh32_1.convert([]).hex(), "36b78ae7");
    });

    test('with seed = $seed and a single letter', () {
      expect(xxh32_1.convert([data[0]]).hex(), "d5845d64");
    });

    test('with seed = $seed and 14 letters', () {
      expect(xxh32_1.convert(data.take(14).toList()).hex(), "4481951d");
    });

    test('with seed = $seed and 101 letters', () {
      expect(xxh32_1.convert(data).hex(), "498ec8e2");
    });
  });
}
