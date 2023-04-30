// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' show Converter;

abstract class Uint8Converter extends Converter<Iterable<int>, Iterable<int>> {
  final int bits;
  final List<int> alphabet;

  const Uint8Converter({
    required this.bits,
    required this.alphabet,
  });

  /// Converts an input string using this converter and returns a string
  @pragma('vm:prefer-inline')
  String string(String input) {
    return String.fromCharCodes(convert(input.codeUnits));
  }

  /// Converts an array of bytes using this converter and returns a string
  @pragma('vm:prefer-inline')
  String asString(Iterable<int> input) {
    return String.fromCharCodes(convert(input));
  }

  /// Converts a string using this converter and returns an array of bytes
  @pragma('vm:prefer-inline')
  Iterable<int> fromString(String input) {
    return convert(input.codeUnits);
  }
}

class Uint8Encoder extends Uint8Converter {
  const Uint8Encoder({
    required int bits,
    required List<int> alphabet,
  }) : super(
          bits: bits,
          alphabet: alphabet,
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    int p, n, x;
    p = n = 0;
    for (x in input) {
      p = (p << 8) | x;
      for (n += 8; n >= bits; n -= bits, p &= (1 << n) - 1) {
        yield alphabet[p >>> (n - bits)];
      }
    }
    if (n > 0) {
      yield alphabet[p << (bits - n)];
    }
  }
}

class Uint8Decoder extends Uint8Converter {
  const Uint8Decoder({
    required int bits,
    required List<int> alphabet,
  }) : super(
          bits: bits,
          alphabet: alphabet,
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    int p, n, x;
    p = n = 0;
    for (x in input) {
      p = (p << bits) | alphabet[x];
      for (n += bits; n >= 8; n -= 8, p &= (1 << n) - 1) {
        yield (p >>> (n - 8));
      }
    }
    if (p > 0) {
      yield p;
    }
  }
}
