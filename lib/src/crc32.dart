// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc/crc32.dart';
import 'package:hashlib/src/core/hash_base.dart';

export 'package:hashlib/src/algorithms/crc/crc32.dart'
    show CRC32Hash, CRC32Params;

/// A CRC-32 code generator with **IEEE** 802.3 CRC-32 polynomial.
///
/// A CRC or cyclic redundancy check is code commonly used for error detection
/// and correction of digital data. This generates a 32-bit number as output.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const crc32 = CRC32(CRC32Params.ieee);

/// CRC-32 code generator
class CRC32 extends HashBase {
  final CRC32Params params;

  /// Create a instance for generating CRC-32 hashes
  const CRC32(this.params);

  @override
  String get name => "CRC-32/${params.name}";

  @override
  CRC32Hash createSink() =>
      params.reversed ? CRC32ReverseHash(params) : CRC32NormalHash(params);

  /// Gets the CRC-32 code for a String
  ///
  /// Parameters:
  /// - [input] is the string to hash
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  @pragma('vm:prefer-inline')
  int code(String input, [Encoding? encoding]) =>
      string(input, encoding).number();
}

/// Gets the CRC-32 value.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - The [params] is the parameters to use. Default: [CRC32Params.ieee]
int crc32code(
  String input, {
  Encoding? encoding,
  CRC32Params params = CRC32Params.ieee,
}) =>
    CRC32(params).code(input, encoding);
