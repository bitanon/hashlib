// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2b.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// For generating un-keyed message digest with BLAKE2b-160.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b160 = Blake2b(160 >>> 3);

/// For generating un-keyed message digest with BLAKE2b-256.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b256 = Blake2b(256 >>> 3);

/// For generating un-keyed message digest with BLAKE2b-384.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b384 = Blake2b(384 >>> 3);

/// For generating un-keyed message digest with BLAKE2b-512.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b512 = Blake2b(512 >>> 3);

/// The BLAKE-2b is a member of BLAKE-2 family optimized for 64-bit platforms
/// and can generate MACs efficiently.
///
/// The BLAKE2 hash function may be used by digital signature algorithms
/// and message authentication and integrity protection mechanisms in
/// applications such as Public Key Infrastructure (PKI), secure
/// communication protocols, cloud storage, intrusion detection, forensic
/// suites, and version control systems.
///
/// This implementation is based on the [RFC-7693][rfc]
///
/// [rfc]: https://www.ietf.org/rfc/rfc7693.html
class Blake2b extends BlockHashBase {
  final int digestSize;
  final List<int>? key;
  final List<int>? salt;
  final List<int>? personalization;

  /// Creates a [Blake2b] instance to generate hash using 64-bit numbers.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  /// - [key] An optional key for MAC generation. Must be less than 64 bytes.
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 16 bytes long.
  const Blake2b(
    this.digestSize, {
    this.key,
    this.salt,
    this.personalization,
  });

  @override
  String get name => 'BLAKE2b-${digestSize << 3}';

  @override
  Blake2bHash createSink() => Blake2bHash(
        digestSize,
        key: key,
        salt: salt,
        personalization: personalization,
      );
}

class Blake2bMAC extends MACHashBase {
  final int digestSize;
  final List<int>? salt;
  final List<int>? personalization;

  /// Creates a [Blake2b] instance to generate MAC using a [key].
  ///
  /// Optional parameters:
  /// - [digestSize] The number of bytes in the output.
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 16 bytes long.
  const Blake2bMAC(
    this.digestSize,
    List<int> key, {
    this.salt,
    this.personalization,
  }) : super(key);

  @override
  String get name => 'BLAKE2b-${digestSize << 3}-MAC';

  @override
  MACSinkBase createSink() => Blake2bHash(
        digestSize,
        key: key,
        salt: salt,
        personalization: personalization,
      );
}

extension Blake2bFactory on Blake2b {
  Blake2b config({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) {
    return Blake2b(
      digestSize,
      key: key ?? this.key,
      salt: salt ?? this.salt,
      personalization: personalization ?? this.personalization,
    );
  }

  Blake2bMAC mac(
    List<int> key, {
    List<int>? salt,
    List<int>? personalization,
  }) {
    return Blake2bMAC(
      digestSize,
      key,
      salt: salt ?? this.salt,
      personalization: personalization ?? this.personalization,
    );
  }
}
