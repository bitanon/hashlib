// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc16.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// A CRC or cyclic redundancy check is code commonly used for error detection
/// and correction of digital data. This generates a 16-bit number as output.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const HashBase crc16 = _CRC16();

class _CRC16 extends HashBase {
  const _CRC16();

  @override
  CRC16Hash startChunkedConversion([Sink<HashDigest>? sink]) => CRC16Hash();
}

/// Gets the CRC-16 remainder value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int crc16code(String input, [Encoding? encoding]) {
  return crc16.string(input, encoding).remainder();
}

/// Extension to [String] to generate [crc16] code
extension CRC16StringExtension on String {
  /// Gets the CRC-16 remainder value of a String
  ///
  /// Parameters:
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  int crc16code([Encoding? encoding]) {
    return crc16.string(this, encoding).remainder();
  }
}
