// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'codec.dart';
import 'converter.dart';

const _ascii = [
  0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, //
  21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
  40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58,
  59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77,
  78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96,
  97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112,
  113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127
];

class ASCIICodec extends Uint8Codec {
  const ASCIICodec();

  @override
  final encoder = const Uint8Encoder(
    bits: 7,
    alphabet: _ascii,
  );

  @override
  final decoder = const Uint8Decoder(
    bits: 7,
    alphabet: _ascii,
  );
}

/// Codec to encode and decode an iterable of 8-bit integers to 7-bit ASCII
/// alphabets as described in [ISO/IEC 646][[wiki].
///
/// [wiki]: https://en.wikipedia.org/wiki/ISO/IEC_646
const ascii = ASCIICodec();

/// Encode an array of 8-bit integers to ASCII string
String toAscii(Iterable<int> input) {
  return String.fromCharCodes(ascii.encoder.convert(input));
}

/// Decode an array of 8-bit integers from ASCII string
List<int> fromAscii(String input) {
  return ascii.decoder.convert(input.codeUnits).toList();
}
