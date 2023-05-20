// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'codec.dart';
import 'converter.dart';

const int _zero = 48;
const int _bigA = 65;
const int _smallA = 97;

class _B16Encoder extends Uint8Encoder {
  final int startCode;

  const _B16Encoder._(this.startCode)
      : super(
          bits: 4,
          alphabet: const <int>[],
        );

  static const upper = _B16Encoder._(_bigA - 10);
  static const lower = _B16Encoder._(_smallA - 10);

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    int a, b;
    for (int x in input) {
      a = (x >>> 4) & 0xF;
      b = x & 0xF;
      a += a < 10 ? _zero : startCode;
      b += b < 10 ? _zero : startCode;
      yield a;
      yield b;
    }
  }
}

class _B16Decoder extends Uint8Decoder {
  const _B16Decoder()
      : super(
          bits: 4,
          alphabet: const <int>[],
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    bool f;
    int p, x, y, n;
    p = 0;
    n = input.length;
    f = (n & 1 != 0);
    for (y in input) {
      if (y >= _smallA) {
        x = y - _smallA + 10;
      } else if (y >= _bigA) {
        x = y - _bigA + 10;
      } else if (y >= _zero) {
        x = y - _zero;
      } else {
        x = -1;
      }
      if (x < 0 || x > 15) {
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
  const B16Codec() : encoder = _B16Encoder.upper;

  /// Base16 codec with uppercase letters
  const B16Codec.lower() : encoder = _B16Encoder.lower;
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
///
/// Parameters:
/// - If [upper] is true, the string will be in uppercase alphabets.
/// - If [padding] is true, the string will be padded with 0 at the start.
String toHex(
  Iterable<int> input, {
  bool upper = false,
  bool padding = true,
}) {
  Iterable<int> out;
  if (upper) {
    out = base16.encoder.convert(input);
  } else {
    out = base16lower.encoder.convert(input);
  }
  if (!padding) {
    out = out.skipWhile((value) => value == _zero);
  }
  return String.fromCharCodes(out);
}

/// Decode an array of 8-bit integers from Base16 (hexadecimal) string
List<int> fromHex(String input) {
  return base16.decoder.convert(input.codeUnits).toList();
}
