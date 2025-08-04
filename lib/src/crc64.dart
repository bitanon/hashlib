// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc/crc64.dart';
import 'package:hashlib/src/core/hash_base.dart';

export 'package:hashlib/src/algorithms/crc/crc64.dart'
    show CRC64Hash, CRC64Params;

/// A CRC-64 code generator with **ISO** CRC-64 polynomial.
///
/// A CRC or cyclic redundancy check is code commonly used for error detection
/// and correction of digital data. This generates a 64-bit number as output.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const crc64 = CRC64(CRC64Params.iso);

/// CRC-64 code generator
class CRC64 extends HashBase {
  final CRC64Params polynomial;

  /// Create a instance for generating CRC-64 hashes
  ///
  /// Parameters:
  /// - [polynomial]: 64-bit polynomial representation
  const CRC64([this.polynomial = CRC64Params.iso]);

  @override
  String get name => "CRC-64/${polynomial.name}";

  @override
  CRC64Hash createSink() => polynomial.reversed
      ? CRC64ReverseHash(polynomial)
      : CRC64NormalHash(polynomial);

  /// Gets the CRC-64 code for a String
  ///
  /// Parameters:
  /// - [input] is the string to hash
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  @pragma('vm:prefer-inline')
  int code(String input, [Encoding? encoding]) =>
      string(input, encoding).number();

  /// Gets the CRC-64 checksum for a String
  ///
  /// Parameters:
  /// - [input] is the string to hash
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  @pragma('vm:prefer-inline')
  String checksum(String input, [Encoding? encoding]) =>
      string(input, encoding).hex();
}

/// Gets the CRC-64 value.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - The [polynomial] is the Polynomial to use. Default: [CRC64Params.iso]
int crc64code(
  String input, {
  Encoding? encoding,
  CRC64Params polynomial = CRC64Params.iso,
}) =>
    CRC64(polynomial).code(input, encoding);

/// Gets the CRC-64 hash in hexadecimal.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - The [polynomial] is the Polynomial to use. Default: [CRC64Params.iso]
String crc64sum(
  String input, {
  Encoding? encoding,
  CRC64Params polynomial = CRC64Params.iso,
}) =>
    CRC64(polynomial).checksum(input, encoding);
