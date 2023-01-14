// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2b.dart';
import 'package:hashlib/src/core/hash_base.dart';

/// For generating un-keyed message digest with BLAKE2b-160.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b160 = Blake2b(null, 160);

/// For generating un-keyed message digest with BLAKE2b-256.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b256 = Blake2b(null, 256);

/// For generating un-keyed message digest with BLAKE2b-384.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b384 = Blake2b(null, 384);

/// For generating un-keyed message digest with BLAKE2b-512.
///
/// Use [Blake2b] for keyed hash generation.
const HashBase blake2b512 = Blake2b(null, 512);

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
/// [rfc]: https://www.rfc-editor.org/rfc/rfc7693
///
/// **WARNING: Not supported in Web VM**
class Blake2b extends HashBase {
  final List<int>? key;
  final int digestSizeInBits;

  /// Create a blake2b instance with optional [key] and [digestSizeInBits]
  const Blake2b([
    this.key,
    this.digestSizeInBits = 512,
  ]) : assert(
          (digestSizeInBits & 7) == 0,
          'Digest size in bits should not make a partial byte',
        );

  @override
  Blake2bHash createSink() => Blake2bHash(
        key: key,
        digestSize: digestSizeInBits >>> 3,
      );

  /// Get a new blake2b instance generating 160-bit digest.
  factory Blake2b.of160([List<int>? key]) => Blake2b(key, 160);

  /// Get a new blake2b instance generating 256-bit digest.
  factory Blake2b.of256([List<int>? key]) => Blake2b(key, 256);

  /// Get a new blake2b instance generating 384-bit digest.
  factory Blake2b.of384([List<int>? key]) => Blake2b(key, 384);

  /// Get a new blake2b instance generating 512-bit digest.
  factory Blake2b.of512([List<int>? key]) => Blake2b(key, 512);
}
