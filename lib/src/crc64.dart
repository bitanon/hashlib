// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc64.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// A CRC-64 code generator with **ISO** CRC-64 polynomial.
///
/// A CRC or cyclic redundancy check is code commonly used for error detection
/// and correction of digital data. This generates a 64-bit number as output.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const HashBase crc64 = _CRC64();

class _CRC64 extends HashBase {
  const _CRC64();

  @override
  CRC64Hash startChunkedConversion([Sink<HashDigest>? sink]) => CRC64Hash();
}

/// Gets the CRC-64 remainder value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int crc64code(String input, [Encoding? encoding]) {
  return crc64.string(input, encoding).remainder();
}

/// Extension to [String] to generate [crc64] code
extension CRC64StringExtension on String {
  /// Gets the CRC-64 remainder value of a String
  ///
  /// Parameters:
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  int crc64code([Encoding? encoding]) {
    return crc64.string(this, encoding).remainder();
  }
}