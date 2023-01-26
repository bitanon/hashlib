// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2s.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// For generating un-keyed message digest with BLAKE2s-128.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s128 = Blake2s(outputBits: 128);

/// For generating un-keyed message digest with BLAKE2s-160.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s160 = Blake2s(outputBits: 160);

/// For generating un-keyed message digest with BLAKE2s-224.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s224 = Blake2s(outputBits: 224);

/// For generating un-keyed message digest with BLAKE2s-256.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s256 = Blake2s(outputBits: 256);

/// The BLAKE-2s is a member of BLAKE-2 family optimized for 32-bit platforms
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
class Blake2s extends HashBase {
  final int outputBits;
  final List<int>? key;
  final List<int>? salt;
  final List<int>? personalization;

  /// Creates a [Blake2s] instance to generate hash using 32-bit numbers.
  ///
  /// Parameters:
  /// - [outputBits] The number of bits in the output. Must be a multiple of 8.
  /// - [key] An optional key for MAC generation. Must be less than 32 bytes.
  /// - [salt] An optional nonce. Must be exactly 8 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 8 bytes long.
  ///
  const Blake2s({
    this.outputBits = 256,
    this.key,
    this.salt,
    this.personalization,
  }) : assert(
          (outputBits & 7) == 0,
          'Output bits should be a multiple of 8',
        );

  @override
  Blake2sHash createSink() => Blake2sHash(
        digestSize: outputBits >>> 3,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2s instance generating 128-bit digest.
  factory Blake2s.of128({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2s(
        outputBits: 128,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2s instance generating 160-bit digest.
  factory Blake2s.of160({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2s(
        outputBits: 160,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2s instance generating 224-bit digest.
  factory Blake2s.of224({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2s(
        outputBits: 224,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2s instance generating 256-bit digest.
  factory Blake2s.of256({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2s(
        outputBits: 256,
        key: key,
        salt: salt,
        personalization: personalization,
      );
}
