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
  final List<int>? salt;
  final List<int>? personalization;

  @override
  String get name => 'BLAKE-2s/${digestSize << 3}';

  /// Creates an instance to generate hash using BLAKE-2s algorithm.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  /// - [salt] An optional nonce. Must be exactly 8 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 8 bytes long.
  ///
  /// See also:
  /// - [mac] or [Blake2sMAC] for generating MAC with this algorithm.
  const Blake2s(
    this.digestSize, {
    this.salt,
    this.personalization,
  });

  @override
  Blake2sHash createSink() => Blake2sHash(
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
  Blake2sMAC get mac => Blake2sMAC._(this);

  /// Get a new instance with different [salt] and [personalization] value.
  ///
  /// If a parameter is null, it passes the current one to the new instance.
  Blake2s config({
    List<int>? salt,
    List<int>? personalization,
  }) =>
      Blake2s(
        digestSize,
        salt: salt ?? this.salt,
        personalization: personalization ?? this.personalization,
      );
}

class Blake2sMAC extends MACHashBase<Blake2sHash> {
  final Blake2s _algo;

  const Blake2sMAC._(this._algo);

  @override
  String get name => '${_algo.name}/MAC';

  /// Get an [MACHash] instance initialized by a [key].
  ///
  /// Parameters:
  /// - [key] The key for MAC generation. Should not exceed 32 bytes.
  /// - [salt] An optional nonce. Must be exactly 8 bytes long.
  /// - [personalization] Second optional nonce. Must be exactly 8 bytes long.
  @override
  @pragma('vm:prefer-inline')
  MACHash<Blake2sHash> by(
    List<int> key, {
    List<int>? salt,
    List<int>? personalization,
  }) {
    final sink = Blake2sHash(
      _algo.digestSize,
      key: key,
      salt: salt ?? _algo.salt,
      personalization: personalization ?? _algo.personalization,
    );
    return MACHash(name, sink);
  }
}
