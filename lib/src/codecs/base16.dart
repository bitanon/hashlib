// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'codec.dart';
import 'converter.dart';

const int _zero = 48;
const int _smallA = 97;
const int _bigA = 65;

const _base16Decoding = <int>[
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, //
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, -2, -2,
  -2, -2, -2, -2, -2, 10, 11, 12, 13, 14, 15, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 10,
  11, 12, 13, 14, 15,
];

class _B16UpperEncoder extends Uint8Encoder {
  const _B16UpperEncoder()
      : super(
          bits: 4,
          alphabet: const <int>[],
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    int a, b;
    for (int x in input) {
      a = (x >>> 4) & 0xF;
      b = x & 0xF;
      a += a < 10 ? _zero : (_bigA - 10);
      b += b < 10 ? _zero : (_bigA - 10);
      yield a;
      yield b;
    }
  }
}

class _B16LowerEncoder extends Uint8Encoder {
  const _B16LowerEncoder()
      : super(
          bits: 4,
          alphabet: const <int>[],
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    int a, b, x;
    for (x in input) {
      a = (x >>> 4) & 0xF;
      b = x & 0xF;
      a += a < 10 ? _zero : (_smallA - 10);
      b += b < 10 ? _zero : (_smallA - 10);
      yield a;
      yield b;
    }
  }
}

class _B16Decoder extends Uint8Decoder {
  const _B16Decoder()
      : super(
          bits: 4,
          alphabet: _base16Decoding,
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    bool f;
    int p, x, y, n;
    p = 0;
    n = input.length;
    f = (n & 1 != 0);
    for (y in input) {
      if (y >= alphabet.length || (x = alphabet[y]) < 0) {
        throw FormatException('Invalid character $y');
      }
      if (f) {
        yield (p | x);
      } else {
        p = x << 4;
      }
      f = !f;
    }
  }
}

class B16Codec extends Uint8Codec {
  @override
  final Uint8Encoder encoder;

  @override
  final decoder = const _B16Decoder();

  /// Base16 codec with lowercase letters
  const B16Codec() : encoder = const _B16UpperEncoder();

  /// Base16 codec with uppercase letters
  const B16Codec.lower() : encoder = const _B16LowerEncoder();
}

/// Codec to encode and decode an iterable of 8-bit integers to 4-bit Base16
/// alphabets (hexadecimal) as described in [RFC-4648][[rfc]:
/// ```
/// 0123456789ABCDEF
/// ```
///
/// [rfc]: https://www.ietf.org/rfc/rfc4648.html
const base16 = B16Codec();

/// Codec to encode and decode an iterable of 8-bit integers to 4-bit Base16
/// alphabets (hexadecimal) as described in [RFC-4648][[rfc] but in lowercase:
/// ```
/// 0123456789abcdef
/// ```
///
/// [rfc]: https://www.ietf.org/rfc/rfc4648.html
const base16lower = B16Codec.lower();

/// Encode an array of 8-bit integers to Base16 (hexadecimal) string
String toHex(Iterable<int> input, {bool upper = false}) {
  if (upper) {
    return String.fromCharCodes(base16.encoder.convert(input));
  } else {
    return String.fromCharCodes(base16lower.encoder.convert(input));
  }
}

/// Decode an array of 8-bit integers from Base16 (hexadecimal) string
List<int> fromHex(String input) {
  return base16.decoder.convert(input.codeUnits).toList();
}
