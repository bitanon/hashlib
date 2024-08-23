// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2/blake2s.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// For generating un-keyed message digest with BLAKE2s-128.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s128 = Blake2s(128 >>> 3);

/// For generating un-keyed message digest with BLAKE2s-160.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s160 = Blake2s(160 >>> 3);

/// For generating un-keyed message digest with BLAKE2s-224.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s224 = Blake2s(224 >>> 3);

/// For generating un-keyed message digest with BLAKE2s-256.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s256 = Blake2s(256 >>> 3);

/// Blake2s is a cryptographic hash function optimized for 8-bit to 32-bit
/// platforms. It generates hash values of data ranging from 1 to 32 bytes in
/// size. Blake2s is highly secure and can be used in various applications as a
/// fast and secure replacement for legacy algorithms like MD5 and HMAC-MD5.
///
/// This implementation is based on the [RFC-7693][rfc]
///
/// [rfc]: https://www.ietf.org/rfc/rfc7693.html
class Blake2s extends BlockHashBase {
  final int digestSize;
  final List<int>? key;
  final List<int>? salt;
  final List<int>? personalization;

  /// Creates a [Blake2s] instance to generate hash using 32-bit numbers.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  /// - [key] An optional key for MAC generation. Should not exceed 32 bytes.
  /// - [salt] An optional nonce. Must be exactly 8 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 8 bytes long.
  ///
  const Blake2s(
    this.digestSize, {
    this.key,
    this.salt,
    this.personalization,
  });

  @override
  String get name => 'BLAKE2s-${digestSize << 3}';

  @override
  Blake2sHash createSink() => Blake2sHash(
        digestSize,
        key: key,
        salt: salt,
        personalization: personalization,
      );
}

class Blake2sMAC extends MACHashBase {
  final int digestSize;
  final List<int>? salt;
  final List<int>? personalization;

  /// Creates a [Blake2s] instance to generate MAC using a [key].
  ///
  /// Optional parameters:
  /// - [digestSize] The number of bytes in the output
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 16 bytes long.
  const Blake2sMAC(
    this.digestSize,
    List<int> key, {
    this.salt,
    this.personalization,
  }) : super(key);

  @override
  String get name => 'BLAKE2s-${digestSize << 3}-MAC';

  @override
  MACSinkBase createSink() => Blake2sHash(
        digestSize,
        key: key,
        salt: salt,
        personalization: personalization,
      );
}

extension Blake2sFactory on Blake2s {
  Blake2s config({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) {
    return Blake2s(
      digestSize,
      key: key ?? this.key,
      salt: salt ?? this.salt,
      personalization: personalization ?? this.personalization,
    );
  }

  Blake2sMAC mac(
    List<int> key, {
    List<int>? salt,
    List<int>? personalization,
  }) {
    return Blake2sMAC(
      digestSize,
      key,
      salt: salt ?? this.salt,
      personalization: personalization ?? this.personalization,
    );
  }
}
