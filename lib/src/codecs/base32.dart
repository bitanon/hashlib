// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'codec.dart';
import 'converter.dart';

const _base32Encoding = [
  65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, //
  84, 85, 86, 87, 88, 89, 90, 50, 51, 52, 53, 54, 55
];

const _base32lowerEncoding = [
  97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, //
  112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 50, 51, 52, 53, 54, 55
];

const _base32Decoding = [
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, //
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2,
  -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, -2, 26, 27, 28, 29, 30, 31, -2,
  -2, -2, -2, -2, -1, -2, -2, -2, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
  14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -2, -2, -2, -2, -2, -2, 0, 1,
  2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22,
  23, 24, 25
];

class B32Codec extends Uint8Codec {
  @override
  final Uint8Encoder encoder;

  @override
  final decoder = const Uint8Decoder(
    bits: 5,
    alphabet: _base32Decoding,
  );

  const B32Codec()
      : encoder = const Uint8Encoder(
          bits: 5,
          alphabet: _base32Encoding,
        );

  const B32Codec.lower()
      : encoder = const Uint8Encoder(
          bits: 5,
          alphabet: _base32lowerEncoding,
        );

  const B32Codec.padded()
      : encoder = const Uint8Encoder(
          bits: 5,
          padding: 61,
          alphabet: _base32Encoding,
        );

  const B32Codec.paddedLower()
      : encoder = const Uint8Encoder(
          bits: 5,
          padding: 61,
          alphabet: _base32lowerEncoding,
        );
}

/// Codec to encode and decode an iterable of 8-bit integers to 5-bit Base32
/// alphabets as described in [RFC-4648][[rfc]:
/// ```
/// ABCDEFGHIJKLMNOPQRSTUVWXYZ234567
/// ```
///
/// [rfc]: https://www.ietf.org/rfc/rfc4648.html
const base32 = B32Codec();

/// Codec to encode and decode an iterable of 8-bit integers to 5-bit Base32
/// alphabets as described in [RFC-4648][[rfc] but in lowercase:
/// ```
/// abcdefghijklmnopqrstuvwxyz234567
/// ```
///
/// [rfc]: https://www.ietf.org/rfc/rfc4648.html
const base32lower = B32Codec.lower();

/// Same as [base32] but appends the padding character `=` in the output.
const base32WithPadding = B32Codec.padded();

/// Same as [base32lower] but appends the padding character `=` in the output.
const base32lowerWithPadding = B32Codec.paddedLower();

/// Encode an array of 8-bit integers to Base32 string
String toBase32(
  Iterable<int> input, {
  bool upper = true,
  bool padding = false,
}) {
  var codec = upper
      ? padding
          ? base32WithPadding
          : base32
      : padding
          ? base32lowerWithPadding
          : base32lower;
  return String.fromCharCodes(codec.encoder.convert(input));
}

/// Decode an array of 8-bit integers from Base32 string
List<int> fromBase32(String input) {
  return base32.decoder.convert(input.codeUnits).toList();
}
