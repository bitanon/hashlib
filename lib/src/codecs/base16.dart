// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'codec.dart';
import 'converter.dart';

const int _zero = 48;
const int _smallA = 97;
const int _bigA = 65;

const _base16Decoding = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1,
  2, 3, 4, 5, 6, 7, 8, 9, 0, 0, 0, 0, 0, 0, 0, 10, 11, 12, 13, 14, 15, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10,
  11, 12, 13, 14, 15
];

class _B16Encoder extends Uint8Encoder {
  const _B16Encoder()
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
    int a, b;
    for (int x in input) {
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
    int a, b, i, j;
    var norm = <int>[];
    var hex = input.toList();
    // start from the trailing to the leading
    for (i = hex.length - 1; i > 0; i -= 2) {
      a = _base16Decoding[hex[i - 1]];
      b = _base16Decoding[hex[i]];
      norm.add((a << 4) | b);
    }
    // take the leading
    if (i == 0) {
      norm.add(_base16Decoding[hex[i]]);
    }
    // report in reverse
    i = 0;
    j = norm.length - 1;
    for (; i < norm.length; i++, j--) {
      yield norm[j];
      norm[j] = norm[i];
    }
  }
}

class B16Codec extends Uint8Codec {
  @override
  final Uint8Encoder encoder;

  @override
  final decoder = const _B16Decoder();

  /// Base16 codec with lowercase letters
  const B16Codec() : encoder = const _B16Encoder();

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
String toHex(Iterable<int> input, [bool uppercase = false]) {
  if (uppercase) {
    return String.fromCharCodes(base16.encoder.convert(input));
  } else {
    return String.fromCharCodes(base16lower.encoder.convert(input));
  }
}

/// Decode an array of 8-bit integers from Base16 (hexadecimal) string
List<int> fromHex(String input) {
  return base16.decoder.convert(input.codeUnits).toList();
}
