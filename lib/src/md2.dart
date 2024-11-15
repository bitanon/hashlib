// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/md2.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// MD2 was primarily used in early software systems and digital signature
/// standards (such as early versions of X.509 certificates), but its use has
/// been deprecated due to security weaknesses.
///
/// **WARNING: It is considered cryptographically broken and insecure.**
const BlockHashBase md2 = _MD2();

class _MD2 extends BlockHashBase {
  const _MD2();

  @override
  final String name = 'MD2';

  @override
  MD2Hash createSink() => MD2Hash();
}

/// Generates a MD2 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String md2sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return md2.string(input, encoding).hex(uppercase);
}
