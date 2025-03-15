// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// Base class for the sink used by Message-Authentication-Code generators
abstract class MACSinkBase extends HashDigestSink {
  /// The length of generated key in bytes
  int get derivedKeyLength => hashLength;
}

/// This can be used as a mixin for MAC algorithm interfaces
abstract class MACHashBase<T extends HashDigestSink> implements HashBase<T> {
  /// Signing the [message] using this MAC to generate a tag.
  @pragma('vm:prefer-inline')
  HashDigest sign(List<int> message) => convert(message);

  /// Verify if the [tag] is derived from the [message] using this MAC.
  @pragma('vm:prefer-inline')
  bool verify(List<int> tag, List<int> message) =>
      convert(message).isEqual(tag);
}

abstract class MACHash<T extends HashDigestSink> {
  const MACHash();

  /// The name of this algorithm
  String get name;

  /// Get a [MACHashBase] instance initialized by a [key].
  @pragma('vm:prefer-inline')
  MACHashBase<T> by(List<int> key);

  /// Get a [MACHashBase] instance initialized by a string [key].
  ///
  /// If [encoding] is not specified, the [String.codeUnits] are used.
  @pragma('vm:prefer-inline')
  MACHashBase<T> byString(String key, [Encoding? encoding]) =>
      by(encoding != null ? encoding.encode(key) : key.codeUnits);

  /// Signing the [message] using a [key] to generate a tag.
  @pragma('vm:prefer-inline')
  HashDigest sign(List<int> key, List<int> message) => by(key).sign(message);

  /// Verify if the [tag] is derived from the [message] using a [key].
  @pragma('vm:prefer-inline')
  bool verify(List<int> key, List<int> tag, List<int> message) =>
      by(key).verify(tag, message);
}
