// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'codec.dart';
import 'converter.dart';

const _base64urlEncoding = [
  65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, //
  84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106,
  107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121,
  122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 95
];

const _base64urlDecoding = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 52,
  53, 54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5,
  6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
  0, 0, 0, 0, 63, 0, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
  40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
];

class B64URLCodec extends Uint8Codec {
  const B64URLCodec();

  @override
  final encoder = const Uint8Encoder(
    bits: 6,
    alphabet: _base64urlEncoding,
  );

  @override
  final decoder = const Uint8Decoder(
    bits: 6,
    alphabet: _base64urlDecoding,
  );
}

/// Codec to encode and decode an iterable of 8-bit integers to URL-safe Base64
/// alphabets as described in [RFC-4648][rfc]:
/// ```
/// ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_
/// ```
///
/// [rfc]: https://www.ietf.org/rfc/rfc4648.html
const base64url = B64URLCodec();

/// Encode an array of 8-bit integers to URL-safe Base64 string
String toBase64Url(Iterable<int> input) {
  return String.fromCharCodes(base64url.encoder.convert(input));
}

/// Decode an array of 8-bit integers from URL-safe Base64 string
List<int> fromBase64Url(String input) {
  return base64url.decoder.convert(input.codeUnits).toList();
}
