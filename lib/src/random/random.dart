// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'generators.dart';

const int _mask32 = 0xFFFFFFFF;

const String _alphaLower = 'abcdefghijklmnopqrstuvwxyz';
const String _alphaUpper = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
const String _numeric = '0123456789';
const List<int> _controls = [
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, //
  11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31,
  127
];
const List<int> _punctuations = [
  33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, //
  58, 59, 60, 61, 62, 63, 64, 91, 92, 93, 94, 95, 96, 123, 124, 125, 126,
];

/// Provides a generator for secure random values
class HashlibRandom {
  final NextIntFunction _nextInt;

  /// Create a instance with custom generator
  const HashlibRandom.custom(this._nextInt);

  /// Creates an instance based on [generator] with optional [seed] value.
  factory HashlibRandom(RNG generator, {int? seed}) =>
      HashlibRandom.custom(generator.build(seed));

  /// Creates an instance based on `RNG.secure` generator with
  /// optional [seed] value.
  factory HashlibRandom.secure({int? seed}) =>
      HashlibRandom.custom(RNG.secure.build(seed));

  /// Generates a 32-bit bit random  number
  @pragma('vm:prefer-inline')
  int nextInt() => _nextInt();

  /// Generates a 16-bit bit random  number
  @pragma('vm:prefer-inline')
  int nextWord() => nextInt() & 0xFFFF;

  /// Generates a 8-bit bit random number
  @pragma('vm:prefer-inline')
  int nextByte() => (nextInt() >>> 11) & 0xFF;

  /// Generates a boolean value
  @pragma('vm:prefer-inline')
  bool nextBool() => nextByte() & 0x55 == 0;

  /// Generates a double number
  @pragma('vm:prefer-inline')
  double nextDouble() => nextInt() / _mask32;

  /// Generates a 32-bit bit random number between [low] and [high], inclusive.
  int nextBetween(int low, int high) {
    if (low == high) {
      return low;
    }
    if (low > high) {
      int t = low;
      low = high;
      high = t;
    }
    return (nextInt() % (high - low)) + low;
  }

  /// Fill the buffer with random values.
  ///
  /// Paramters:
  /// - [offsetInBytes] the start offset in bytes for the fill operation.
  /// - [lengthInBytes] the total bytes to fill. If `null`, fills to the end.
  void fill(ByteBuffer buffer, [int offsetInBytes = 0, int? lengthInBytes]) {
    int i, n;
    i = offsetInBytes;
    n = lengthInBytes ?? buffer.lengthInBytes;
    if (n <= 0) return;
    var list8 = Uint8List.view(buffer);
    for (; n > 0 && i < list8.length && i & 3 != 0; i++, n--) {
      list8[i] = nextByte();
    }
    if (n <= 0) return;
    var list32 = Uint32List.view(buffer);
    for (i >>>= 2; n >= 4 && i < list32.length; i++, n -= 4) {
      list32[i] = nextInt();
    }
    if (n <= 0) return;
    for (i <<= 2; n > 0 && i < list8.length; i++, n--) {
      list8[i] = nextByte();
    }
  }

  /// Generate a list of random 8-bit bytes of size [length]
  @pragma('vm:prefer-inline')
  Uint8List nextBytes(int length) {
    var data = Uint8List(length);
    fill(data.buffer);
    return data;
  }

  /// Generate a list of random 32-bit numbers of size [length]
  @pragma('vm:prefer-inline')
  Uint32List nextNumbers(int length) {
    var data = Uint32List(length);
    fill(data.buffer);
    return data;
  }

  /// Generate the next random string of specific [length].
  ///
  /// If no parameter is provided, it will return a random string using
  /// ASCII characters only (character code 0 to 127).
  ///
  /// If [whitelist] or [blacklist] are provided, they will get priority over
  /// other parameters. Otherwise, these two list will be generated from the
  /// other parameter.
  ///
  /// Other Parameters:
  /// - [lower] : lowercase letters.
  /// - [upper] : uppercase letters.
  /// - [controls] : control characters.
  /// - [punctuations] : punctuations.
  ///
  /// If these parameters are set, it will be ignored. Otherwise, if `true`, the
  /// corresponding characters will be added to the [whitelist], or if `false`,
  /// to the [blacklist].
  ///
  /// If the [whitelist] is already set, these parameters has no effect when
  /// they are set to true. If the [blacklist] is already set, these parameters
  /// has no effect when they are set to false.
  String nextString(
    int length, {
    bool? lower,
    bool? upper,
    bool? numeric,
    bool? controls,
    bool? punctuations,
    List<int>? whitelist,
    List<int>? blacklist,
  }) {
    Set<int> white = {};
    Set<int> black = {};
    if (lower != null) {
      if (lower) {
        white.addAll(_alphaLower.codeUnits);
      } else {
        black.addAll(_alphaLower.codeUnits);
      }
    }
    if (upper != null) {
      if (upper) {
        white.addAll(_alphaUpper.codeUnits);
      } else {
        black.addAll(_alphaUpper.codeUnits);
      }
    }
    if (numeric != null) {
      if (numeric) {
        white.addAll(_numeric.codeUnits);
      } else {
        black.addAll(_numeric.codeUnits);
      }
    }
    if (controls != null) {
      if (controls) {
        white.addAll(_controls);
      } else {
        black.addAll(_controls);
      }
    }
    if (punctuations != null) {
      if (punctuations) {
        white.addAll(_punctuations);
      } else {
        black.addAll(_punctuations);
      }
    }

    if (whitelist != null) {
      white.addAll(whitelist);
      black.removeAll(whitelist);
    } else if (white.isEmpty) {
      white.addAll(List.generate(128, (i) => i));
    }
    white.removeAll(black);
    if (blacklist != null) {
      white.removeAll(blacklist);
    }
    if (white.isEmpty) {
      throw StateError('Empty whitelist');
    }

    var list = white.toList(growable: false);
    Iterable<int> codes = nextBytes(length);
    codes = codes.map((x) => list[x % list.length]);
    return String.fromCharCodes(codes);
  }
}
