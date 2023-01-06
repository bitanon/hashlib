// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:hashlib/src/sha2_32.dart';

final _sha256 = SHA256();

/// Generates a 256-bit SHA256 hash digest from the input.
HashDigest sha256buffer(final Iterable<int> input) {
  _sha256.$reset();
  _sha256.update(input);
  return _sha256.digest();
}

/// Generates a 256-bit SHA256 hash as hexadecimal digest from string
HashDigest sha256(final String input, [Encoding? encoding]) {
  return sha256buffer(toBytes(input, encoding));
}

/// Generates a 256-bit SHA256 hash digest from stream
Future<HashDigest> sha256stream(final Stream<List<int>> inputStream) async {
  _sha256.$reset();
  await inputStream.forEach(_sha256.update);
  return _sha256.digest();
}

/// A generator to produce 256-bit hash value using SHA256 algorithm.
///
/// This implementation is derived from [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://datatracker.ietf.org/doc/html/rfc6234
class SHA256 extends SHA2of32bit {
  /// Initializes a new instance of SHA256 message-digest.
  SHA256()
      : super(
          hashLengthInBits: 256,
          seed: [
            0x6a09e667, // a
            0xbb67ae85, // b
            0x3c6ef372, // c
            0xa54ff53a, // d
            0x510e527f, // e
            0x9b05688c, // f
            0x1f83d9ab, // g
            0x5be0cd19, // h
          ],
        );
}
