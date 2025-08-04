// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc/crc16.dart';
import 'package:hashlib/src/core/hash_base.dart';

export 'package:hashlib/src/algorithms/crc/crc16.dart'
    show CRC16Hash, CRC16Params;

/// A CRC or cyclic redundancy check is code commonly used for error detection
/// and correction of digital data. This generates a 16-bit number as output.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const crc16 = CRC16(CRC16Params.ibm);

/// CRC-16 code generator
class CRC16 extends HashBase {
  final CRC16Params polynomial;

  /// Create a instance for generating CRC-16 hashes
  ///
  /// Parameters:
  /// - [polynomial]: 16-bit polynomial representation
  const CRC16(this.polynomial);

  @override
  String get name => "CRC-16/${polynomial.name}";

  @override
  CRC16Hash createSink() => polynomial.reversed
      ? CRC16ReverseHash(polynomial)
      : CRC16NormalHash(polynomial);

  /// Gets the CRC-16 code for a String
  ///
  /// Parameters:
  /// - [input] is the string to hash
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  int code(String input, [Encoding? encoding]) =>
      string(input, encoding).number();
}

/// Gets the CRC-16 value.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - The [polynomial] is the Polynomial to use. Default: [CRC16Params.ansi]
int crc16code(
  String input, {
  Encoding? encoding,
  CRC16Params polynomial = CRC16Params.ansi,
}) =>
    CRC16(polynomial).code(input, encoding);
