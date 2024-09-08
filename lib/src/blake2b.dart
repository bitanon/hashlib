// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2/blake2b.dart';
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

/// Blake2b is a highly secure cryptographic hash function optimized for 64-bit
/// platforms. It generates hash values of data ranging from 1 to 64 bytes in
/// size. It doesn't require a separate keying mechanism and can be used in
/// various applications, serving as a more efficient alternative to other hash
/// algorithms like SHA and HMAC-SHA.
///
/// This implementation is based on the [RFC-7693][rfc]
///
/// [rfc]: https://www.ietf.org/rfc/rfc7693.html
class Blake2b extends BlockHashBase {
  final int digestSize;
  final List<int>? salt;
  final List<int>? personalization;

  @override
  String get name => 'BLAKE-2b/${digestSize << 3}';

  /// Creates an instance to generate hash using BLAKE-2b algorithm.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 16 bytes long.
  ///
  /// See also:
  /// - [mac] or [Blake2bMAC] for generating MAC with this algorithm.
  const Blake2b(
    this.digestSize, {
    this.salt,
    this.personalization,
  });

  @override
  Blake2bHash createSink() => Blake2bHash(
        digestSize,
        salt: salt,
        personalization: personalization,
      );

  /// Get a builder to generate MAC using this algorithm.
  ///
  /// Example:
  /// ```
  /// final key = 'secret key'.codeUnits;
  /// final message = 'plain message'.codeUnits;
  /// final mac = blake2s256.mac.by(key).convert(message);
  /// ```
  Blake2bMAC get mac => Blake2bMAC._(this);

  /// Get a new instance with different [salt] and [personalization] value.
  ///
  /// If a parameter is null, it passes the current one to the new instance.
  Blake2b config({
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2b(
        digestSize,
        salt: salt ?? this.salt,
        personalization: personalization ?? this.personalization,
      );
}

class Blake2bMAC extends MACHashBase<Blake2bHash> {
  final Blake2b _algo;

  const Blake2bMAC._(this._algo);

  @override
  String get name => '${_algo.name}/MAC';

  /// Get an [MACHash] instance initialized by a [key].
  ///
  /// Parameters:
  /// - [key] An optional key for MAC generation. Should not exceed 64 bytes.
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 16 bytes long.
  @override
  @pragma('vm:prefer-inline')
  MACHash<Blake2bHash> by(
    List<int> key, {
    List<int>? salt,
    List<int>? personalization,
  }) {
    final sink = Blake2bHash(
      _algo.digestSize,
      key: key,
      salt: salt ?? _algo.salt,
      personalization: personalization ?? _algo.personalization,
    );
    return MACHash(name, sink);
  }
}
