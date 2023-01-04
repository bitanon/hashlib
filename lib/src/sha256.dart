// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/src/core/utils.dart';
import 'package:hashlib/src/sha2_32.dart';

/// Generates a 256-bit SHA256 hash digest from the input.
Uint8List sha256buffer(final Iterable<int> input) {
  final sha256 = SHA256();
  sha256.update(input);
  return sha256.digest();
}

/// Generates a 256-bit SHA256 hash digest from stream
Future<Uint8List> sha256stream(final Stream<List<int>> inputStream) async {
  final sha256 = SHA256();
  await inputStream.forEach((x) {
    sha256.update(x);
  });
  return sha256.digest();
}

/// Generates a 256-bit SHA256 hash as hexadecimal digest from bytes
String sha256sum(final Iterable<int> input) {
  return toHexString(sha256buffer(input));
}

/// Generates a 256-bit SHA256 hash as hexadecimal digest from string
String sha256(final String input, [Encoding encoding = utf8]) {
  return sha256sum(toBytes(input, encoding));
}

/// A generator to produce 256-bit hash value using SHA256 algorithm.
///
/// This implementation is derived from [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://datatracker.ietf.org/doc/html/rfc6234
class SHA256 extends SHA2of32bit {
  @override
  final int hashLengthInBits = 256;

  /// Initializes a new instance of SHA256 message-digest.
  SHA256()
      : super([
          0x6a09e667, // a
          0xbb67ae85, // b
          0x3c6ef372, // c
          0xa54ff53a, // d
          0x510e527f, // e
          0x9b05688c, // f
          0x1f83d9ab, // g
          0x5be0cd19, // h
        ]);
}
