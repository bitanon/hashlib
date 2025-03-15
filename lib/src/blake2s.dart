// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2/blake2s.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

export 'algorithms/blake2/blake2s.dart' show Blake2sHash;

/// For generating un-keyed message digest with BLAKE2s-128.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s128 = Blake2s._(128 >>> 3);

/// For generating un-keyed message digest with BLAKE2s-160.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s160 = Blake2s._(160 >>> 3);

/// For generating un-keyed message digest with BLAKE2s-224.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s224 = Blake2s._(224 >>> 3);

/// For generating un-keyed message digest with BLAKE2s-256.
///
/// Use [Blake2s] for keyed hash generation.
const Blake2s blake2s256 = Blake2s._(256 >>> 3);

/// Blake2s is a cryptographic hash function optimized for 8-bit to 32-bit
/// platforms. It generates hash values of data ranging from 1 to 32 bytes in
/// size. Blake2s is highly secure and can be used in various applications as a
/// fast and secure replacement for legacy algorithms like MD5 and HMAC-MD5.
///
/// This implementation is based on the [RFC-7693][rfc]
///
/// [rfc]: https://www.ietf.org/rfc/rfc7693.html
class Blake2s extends BlockHashBase<Blake2sHash> with MACHashBase<Blake2sHash> {
  final List<int>? _key;
  final List<int>? _salt;
  final List<int>? _aad;

  /// The number of bytes in the output.
  final int digestSize;

  @override
  final String name;

  const Blake2s._(
    this.digestSize, [
    this._key,
    this._salt,
    this._aad,
    String? _name,
  ]) : name = _name ?? 'BLAKE2s-${digestSize << 3}';

  /// Creates an instance to generate hash using BLAKE-2s algorithm.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  /// - [salt] An optional nonce. Must be exactly 8 bytes long.
  /// - [aad] Second optional nonce. Must be exactly 8 bytes long.
  ///
  /// See also:
  /// - [mac] or [Blake2sMAC] for generating MAC with this algorithm.
  factory Blake2s(
    int digestSize, {
    List<int>? salt,
    List<int>? aad,
  }) =>
      Blake2s._(digestSize, null, salt, aad);

  @override
  Blake2sHash createSink() => Blake2sHash(
        digestSize,
        key: _key,
        salt: _salt,
        aad: _aad,
      );

  /// Get a builder to generate MAC using this algorithm.
  ///
  /// Example:
  /// ```
  /// final key = 'secret key'.codeUnits;
  /// final message = 'plain message'.codeUnits;
  /// final mac = blake2s256.mac.by(key).convert(message);
  /// ```
  Blake2sMAC get mac => Blake2sMAC(digestSize);
}

/// A MAC generator based on Blake2s algorithm.
class Blake2sMAC extends MACHash<Blake2sHash> {
  /// The number of bytes in the output.
  final int digestSize;

  @override
  final String name;

  /// Creates an instance to generate MAC using BLAKE-2s algorithm.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  ///
  /// See also:
  /// - [Blake2s] for generating hash only.
  const Blake2sMAC(
    this.digestSize,
  ) : name = 'BLAKE2s-${digestSize << 3}/MAC';

  /// Get an [MACHashBase] instance initialized by a [key].
  ///
  /// Parameters:
  /// - [key] The key for MAC generation. Should not exceed 32 bytes.
  /// - [salt] An optional nonce. Must be exactly 8 bytes long.
  /// - [aad] Second optional nonce. Must be exactly 8 bytes long.
  @override
  @pragma('vm:prefer-inline')
  MACHashBase<Blake2sHash> by(
    List<int> key, {
    List<int>? salt,
    List<int>? aad,
  }) =>
      Blake2s._(digestSize, key, salt, aad, name);
}
