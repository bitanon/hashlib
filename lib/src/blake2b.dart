// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/blake2/blake2b.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

export 'algorithms/blake2/blake2b.dart' show Blake2bHash;

/// For generating un-keyed message digest with BLAKE2b-160.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b160 = Blake2b._(160 >>> 3);

/// For generating un-keyed message digest with BLAKE2b-256.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b256 = Blake2b._(256 >>> 3);

/// For generating un-keyed message digest with BLAKE2b-384.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b384 = Blake2b._(384 >>> 3);

/// For generating un-keyed message digest with BLAKE2b-512.
///
/// Use [Blake2b] for keyed hash generation.
const Blake2b blake2b512 = Blake2b._(512 >>> 3);

/// Blake2b is a highly secure cryptographic hash function optimized for 64-bit
/// platforms. It generates hash values of data ranging from 1 to 64 bytes in
/// size. It doesn't require a separate keying mechanism and can be used in
/// various applications, serving as a more efficient alternative to other hash
/// algorithms like SHA and HMAC-SHA.
///
/// This implementation is based on the [RFC-7693][rfc]
///
/// [rfc]: https://www.ietf.org/rfc/rfc7693.html
class Blake2b extends BlockHashBase<Blake2bHash> with MACHashBase<Blake2bHash> {
  final List<int>? _key;
  final List<int>? _salt;
  final List<int>? _aad;

  /// The number of bytes in the output.
  final int digestSize;

  @override
  final String name;

  const Blake2b._(
    this.digestSize, [
    this._key,
    this._salt,
    this._aad,
    String? _name,
  ]) : name = _name ?? 'BLAKE2b-${digestSize << 3}';

  /// Creates an instance to generate hash using BLAKE-2b algorithm.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [aad] Second optional nonce. Must be exactly 16 bytes long.
  ///
  /// See also:
  /// - [mac] or [Blake2bMAC] for generating MAC with this algorithm.
  factory Blake2b(
    int digestSize, {
    List<int>? salt,
    List<int>? aad,
  }) =>
      Blake2b._(digestSize, null, salt, aad);

  @override
  Blake2bHash createSink() => Blake2bHash(
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
  Blake2bMAC get mac => Blake2bMAC(digestSize);
}

/// A MAC generator based on Blake2b algorithm.
class Blake2bMAC extends MACHash<Blake2bHash> {
  /// The number of bytes in the output.
  final int digestSize;

  @override
  final String name;

  /// Creates an instance to generate MAC using BLAKE-2b algorithm.
  ///
  /// Parameters:
  /// - [digestSize] The number of bytes in the output.
  ///
  /// See also:
  /// - [Blake2b] for generating hash only.
  const Blake2bMAC(
    this.digestSize,
  ) : name = 'BLAKE2b-${digestSize << 3}/MAC';

  /// Get an [MACHashBase] instance initialized by a [key].
  ///
  /// Parameters:
  /// - [key] An optional key for MAC generation. Should not exceed 64 bytes.
  /// - [salt] An optional nonce. Must be exactly 16 bytes long.
  /// - [aad] Second optional nonce. Must be exactly 16 bytes long.
  @override
  @pragma('vm:prefer-inline')
  MACHashBase<Blake2bHash> by(
    List<int> key, {
    List<int>? salt,
    List<int>? aad,
  }) =>
      Blake2b._(digestSize, key, salt, aad, name);
}
