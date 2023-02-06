// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc32.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// A CRC-32 code generator with **IEEE** 802.3 CRC-32 polynomial.
///
/// A CRC or cyclic redundancy check is code commonly used for error detection
/// and correction of digital data. This generates a 32-bit number as output.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const HashBase crc32 = _CRC32();

class _CRC32 extends HashBase {
  const _CRC32();

  @override
  CRC32Hash createSink() => CRC32Hash();
}

/// Gets the CRC-32 value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int crc32code(String input, [Encoding? encoding]) {
  return crc32.string(input, encoding).remainder();
}

/// Extension to [String] to generate [crc32] code
extension CRC32StringExtension on String {
  /// Gets the CRC-32 value of a String
  ///
  /// Parameters:
  /// - If no [encoding] is defined, the `codeUnits` is used to get the bytes.
  int crc32code([Encoding? encoding]) {
    return crc32.string(this, encoding).remainder();
  }
}
