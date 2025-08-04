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
/// This implementation uses IBM polynomial `0xA001`.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const crc16 = CRC16(CRC16Params.ibm);

/// CRC-16 code generator
class CRC16 extends HashBase {
  final CRC16Params params;

  /// Create a instance for generating CRC-16 hashes
  const CRC16(this.params);

  @override
  String get name => "CRC-16/${params.name}";

  @override
  CRC16Hash createSink() =>
      params.reversed ? CRC16ReverseHash(params) : CRC16NormalHash(params);

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
/// - The [params] is the parameters to use. Default: [CRC16Params.ansi]
int crc16code(
  String input, {
  Encoding? encoding,
  CRC16Params params = CRC16Params.ansi,
}) =>
    CRC16(params).code(input, encoding);
