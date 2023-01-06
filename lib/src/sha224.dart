// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:hashlib/src/sha2_32.dart';

final _sha224 = SHA224();

/// Generates a 224-bit SHA224 hash digest from the input.
HashDigest sha224buffer(final Iterable<int> input) {
  _sha224.$reset();
  _sha224.update(input);
  return _sha224.digest();
}

/// Generates a 224-bit SHA224 hash as hexadecimal digest from string
HashDigest sha224(final String input, [Encoding? encoding]) {
  return sha224buffer(toBytes(input, encoding));
}

/// Generates a 224-bit SHA224 hash digest from stream
Future<HashDigest> sha224stream(final Stream<List<int>> inputStream) async {
  _sha224.$reset();
  await inputStream.forEach(_sha224.update);
  return _sha224.digest();
}

/// A generator to produce 224-bit hash value using SHA224 algorithm.
///
/// This implementation is derived from [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://datatracker.ietf.org/doc/html/rfc6234
class SHA224 extends SHA2of32bit {
  /// Initializes a new instance of SHA224 message-digest.
  SHA224()
      : super(
          hashLengthInBits: 224,
          seed: [
            0xc1059ed8, // a
            0x367cd507, // b
            0x3070dd17, // c
            0xf70e5939, // d
            0xffc00b31, // e
            0x68581511, // f
            0x64f98fa7, // g
            0xbefa4fa4, // h
          ],
        );
}
