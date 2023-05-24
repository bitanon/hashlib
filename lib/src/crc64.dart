// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/crc64.dart';
import 'package:hashlib/src/core/hash_base.dart';

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
  final String name = 'CRC-64';

  @override
  CRC64Hash createSink() => CRC64Hash();
}

/// Gets the CRC-64 value of a String.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int crc64code(String input, [Encoding? encoding]) {
  return crc64.string(input, encoding).number();
}

/// Gets the CRC-64 hash of a String in hexadecimal.
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
String crc64sum(String input, [Encoding? encoding]) {
  return crc64.string(input, encoding).hex();
}
