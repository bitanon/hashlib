// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2b.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// For generating un-keyed message digest with BLAKE2b-160.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b160 = Blake2b(outputBits: 160);

/// For generating un-keyed message digest with BLAKE2b-256.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b256 = Blake2b(outputBits: 256);

/// For generating un-keyed message digest with BLAKE2b-384.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b384 = Blake2b(outputBits: 384);

/// For generating un-keyed message digest with BLAKE2b-512.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b512 = Blake2b(outputBits: 512);

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
class Blake2b extends HashBase {
  final int outputBits;
  final List<int>? key;
  final List<int>? salt;
  final List<int>? personalization;

  /// Creates a [Blake2b] instance to generate hash using 64-bit numbers.
  ///
  /// Parameters:
  /// - [outputBits] The number of bits in the output. Must be a multiple of 8.
  /// - [key] An optional key for MAC generation. Must be less than 64 bytes.
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 16 bytes long.
  const Blake2b({
    this.outputBits = 512,
    this.key,
    this.salt,
    this.personalization,
  }) : assert(
          (outputBits & 7) == 0,
          'Output bits should be a multiple of 8',
        );

  @override
  Blake2bHash createSink() => Blake2bHash(
        digestSize: outputBits >>> 3,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2b instance generating 160-bit digest.
  factory Blake2b.of160({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2b(
        outputBits: 160,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2b instance generating 256-bit digest.
  factory Blake2b.of256({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2b(
        outputBits: 256,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2b instance generating 384-bit digest.
  factory Blake2b.of384({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2b(
        outputBits: 384,
        key: key,
        salt: salt,
        personalization: personalization,
      );

  /// Get a new blake2b instance generating 512-bit digest.
  factory Blake2b.of512({
    List<int>? key,
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2b(
        outputBits: 512,
        key: key,
        salt: salt,
        personalization: personalization,
      );
}
