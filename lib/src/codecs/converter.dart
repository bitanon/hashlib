// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' show Converter;

abstract class Uint8Converter extends Converter<Iterable<int>, Iterable<int>> {
  final int bits;
  final int? padding;
  final List<int> alphabet;

  const Uint8Converter({
    this.padding,
    required this.bits,
    required this.alphabet,
  });

  int get radix => 1 << bits;

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
    int? padding,
    required int bits,
    required List<int> alphabet,
  }) : super(
          bits: bits,
          padding: padding,
          alphabet: alphabet,
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    int p, n, x, l;
    p = n = l = 0;
    for (x in input) {
      p = (p << 8) | x;
      for (n += 8; n >= bits; n -= bits, p &= (1 << n) - 1) {
        l += bits;
        yield alphabet[p >>> (n - bits)];
      }
    }
    if (n > 0) {
      l += bits;
      yield alphabet[p << (bits - n)];
    }
    if (padding != null) {
      p = padding!;
      for (; (l & 7) != 0; l += bits) {
        yield p;
      }
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
    int p, n, x, y;
    p = n = 0;
    for (y in input) {
      if (y >= alphabet.length || (x = alphabet[y]) == -2) {
        throw FormatException('Invalid character $y');
      }
      if (x < 0) return;
      p = (p << bits) | x;
      for (n += bits; n >= 8; n -= 8, p &= (1 << n) - 1) {
        yield (p >>> (n - 8));
      }
    }
    if (p > 0) {
      yield p;
    }
  }
}
