// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'codec.dart';
import 'converter.dart';

const int _zero = 48;

class _BinaryEncoder extends Uint8Encoder {
  const _BinaryEncoder()
      : super(
          bits: 2,
          alphabet: const <int>[],
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    for (int x in input) {
      yield _zero + ((x >>> 7) & 1);
      yield _zero + ((x >>> 6) & 1);
      yield _zero + ((x >>> 5) & 1);
      yield _zero + ((x >>> 4) & 1);
      yield _zero + ((x >>> 3) & 1);
      yield _zero + ((x >>> 2) & 1);
      yield _zero + ((x >>> 1) & 1);
      yield _zero + ((x) & 1);
    }
  }
}

class _BinaryDecoder extends Uint8Decoder {
  const _BinaryDecoder()
      : super(
          bits: 2,
          alphabet: const <int>[],
        );

  @override
  Iterable<int> convert(Iterable<int> input) sync* {
    int p, n, x, y;
    n = (8 - (input.length & 7)) & 7;
    p = 0;
    for (y in input) {
      x = y - _zero;
      if (x != 0 && x != 1) {
        throw FormatException('Invalid character $y');
      }
      p = (p << 1) ^ x;
      if (n < 7) {
        n++;
      } else {
        yield p;
        n = p = 0;
      }
    }
    if (n > 0) {
      yield p;
    }
  }
}

class BinaryCodec extends Uint8Codec {
  @override
  final encoder = const _BinaryEncoder();

  @override
  final decoder = const _BinaryDecoder();

  /// Base2 (binary) codec
  const BinaryCodec();
}

/// Codec to encode and decode an iterable of 8-bit integers to 2-bit Base2
/// alphabets (binary): `0` or `1`
const base2 = BinaryCodec();

/// Encode an array of 8-bit integers to Base2 (binary) string
///
/// Parameters:
/// - If [padding] is true, the string will be padded with 0 at the start.
String toBinary(
  Iterable<int> input, {
  bool padding = true,
}) {
  var out = base2.encoder.convert(input);
  if (!padding) {
    out = out.skipWhile((value) => value == _zero);
  }
  return String.fromCharCodes(out);
}

/// Decode an array of 8-bit integers from Base2 (binary) string
List<int> fromBinary(String input) {
  return base2.decoder.convert(input.codeUnits).toList();
}
