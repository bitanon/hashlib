// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/src/core/utils.dart';
import 'package:hashlib/src/sha2_32.dart';

/// Generates a 224-bit SHA224 hash digest from the input.
Uint8List sha224buffer(final Iterable<int> input) {
  final sha224 = SHA224();
  sha224.update(input);
  return sha224.digest();
}

/// Generates a 224-bit SHA224 hash digest from stream
Future<Uint8List> sha224stream(final Stream<List<int>> inputStream) async {
  final sha224 = SHA224();
  await inputStream.forEach((x) {
    sha224.update(x);
  });
  return sha224.digest();
}

/// Generates a 224-bit SHA224 hash as hexadecimal digest from bytes
String sha224sum(final Iterable<int> input) {
  return toHexString(sha224buffer(input));
}

/// Generates a 224-bit SHA224 hash as hexadecimal digest from string
String sha224(final String input, [Encoding encoding = utf8]) {
  return sha224sum(toBytes(input, encoding));
}

/// A generator to produce 224-bit hash value using SHA224 algorithm.
///
/// This implementation is derived from [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://datatracker.ietf.org/doc/html/rfc6234
class SHA224 extends SHA2of32bit {
  @override
  final int hashLengthInBits = 224;

  /// Initializes a new instance of SHA224 message-digest.
  /// An instance can be re-used after calling the [clear] function.
  SHA224()
      : super([
          0xc1059ed8, // a
          0x367cd507, // b
          0x3070dd17, // c
          0xf70e5939, // d
          0xffc00b31, // e
          0x68581511, // f
          0x64f98fa7, // g
          0xbefa4fa4, // h
        ]);
}
