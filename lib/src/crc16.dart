// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc/crc16.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// A CRC or cyclic redundancy check is code commonly used for error detection
/// and correction of digital data. This generates a 16-bit number as output.
///
/// **WARNING: It should not be used for cryptographic purposes.**
const HashBase crc16 = _CRC16();

class _CRC16 extends HashBase {
  const _CRC16();

  @override
  final String name = 'CRC-16';

  @override
  CRC16Hash createSink() => CRC16Hash();
}

/// Gets the CRC-16 value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int crc16code(String input, [Encoding? encoding]) {
  return crc16.string(input, encoding).number();
}
