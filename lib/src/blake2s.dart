// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2s.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// For generating un-keyed message digest with BLAKE2s-128.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s128 = Blake2s(null, 128);

/// For generating un-keyed message digest with BLAKE2s-160.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s160 = Blake2s(null, 160);

/// For generating un-keyed message digest with BLAKE2s-224.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s224 = Blake2s(null, 224);

/// For generating un-keyed message digest with BLAKE2s-256.
///
/// Use [Blake2s] for keyed hash generation.
const HashBase blake2s256 = Blake2s(null, 256);

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
/// [rfc]: https://www.rfc-editor.org/rfc/rfc7693
class Blake2s extends HashBase {
  final List<int>? key;
  final int digestSizeInBits;

  /// Create a blake2s instance with optional [key] and [digestSizeInBits]
  const Blake2s([
    this.key,
    this.digestSizeInBits = 256,
  ]) : assert(
          (digestSizeInBits & 7) == 0,
          'Digest size in bits should not make a partial byte',
        );

  @override
  Blake2sHash startChunkedConversion([
    Sink<HashDigest>? sink,
  ]) =>
      Blake2sHash(
        key: key,
        digestSize: digestSizeInBits >>> 3,
      );

  /// Get a new blake2s instance generating 128-bit digest.
  factory Blake2s.of128([List<int>? key]) => Blake2s(key, 128);

  /// Get a new blake2s instance generating 160-bit digest.
  factory Blake2s.of160([List<int>? key]) => Blake2s(key, 160);

  /// Get a new blake2s instance generating 224-bit digest.
  factory Blake2s.of224([List<int>? key]) => Blake2s(key, 224);

  /// Get a new blake2s instance generating 256-bit digest.
  factory Blake2s.of256([List<int>? key]) => Blake2s(key, 256);
}
