// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sm3.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// SM3 [ISO.IEC.10118-3] [GBT.32905-2016] is a cryptographic hash algorithm
/// published by the [State Cryptography Administration (SCA) of China][SCA]
/// as an authorized cryptographic hash algorithm for the use within China.
///
/// It can be used on digital signatures, generating message authentication
/// codes, and random numbers.
///
/// [SCA]: http://www.sca.gov.cn
/// [ISO.IEC.10118-3]: https://www.iso.org/standard/67116.html
/// [GBT.32905-2016]: https://www.chinesestandard.net/PDF.aspx/GBT32905-2016
const BlockHashBase sm3 = _SM3();

class _SM3 extends BlockHashBase {
  const _SM3();

  @override
  final String name = 'SM3';

  @override
  SM3Hash createSink() => SM3Hash();
}

/// Generates a SM3 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sm3sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sm3.string(input, encoding).hex(uppercase);
}
