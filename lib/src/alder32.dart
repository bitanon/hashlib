// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/alder32.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// [Adler-32][wiki] is composed of two sums accumulated per byte.
///
///
/// According to [RFC-1950][rfc], the algorithm is described as follows:
/// - `a` is the sum of all bytes, `b` is the sum of all `a` values.
/// Both sums are done modulo `65521`.
/// - `a` is initialized to 1, `b` to 0.
/// - Final output is `b * 65536 + a`
///
/// [rfc]: https://rfc-editor.org/rfc/rfc1950.html
/// [wiki]: https://en.wikipedia.org/wiki/Adler-32
///
/// **WARNING: It should not be used for cryptographic purposes.**
const HashBase alder32 = _Alder32();

class _Alder32 extends HashBase {
  const _Alder32();

  @override
  Alder32Hash createSink() => Alder32Hash();
}

/// Gets the Alder-32 remainder value of a String
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
int alder32code(String input, [Encoding? encoding]) {
  return alder32.string(input, encoding).remainder();
}
