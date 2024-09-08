// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

abstract class MACSinkBase extends HashDigestSink {
  /// The length of generated key in bytes
  int get derivedKeyLength => hashLength;
}

class MACHash<T extends MACSinkBase> extends HashBase {
  final T _sink;

  @override
  final String name;

  const MACHash(this.name, this._sink);

  @override
  @pragma('vm:prefer-inline')
  T createSink() {
    _sink.reset();
    return _sink;
  }

  /// Signing the [message] using this MAC to generate a tag.
  @pragma('vm:prefer-inline')
  HashDigest sign(List<int> message) => convert(message);

  /// Verify if the [tag] is derived from the [message] using this MAC.
  @pragma('vm:prefer-inline')
  bool verify(List<int> tag, List<int> message) =>
      convert(message).isEqual(tag);
}

abstract class MACHashBase<T extends MACSinkBase> {
  const MACHashBase();

  /// The name of this algorithm
  String get name;

  /// Get an [MACHash] instance initialized by a [key].
  @pragma('vm:prefer-inline')
  MACHash<T> by(List<int> key);

  /// Get an [MACHash] instance initialized by a string [key].
  ///
  /// If [encoding] is not specified, the [String.codeUnits] are used.
  @pragma('vm:prefer-inline')
  MACHash<T> byString(String key, [Encoding? encoding]) =>
      by(encoding != null ? encoding.encode(key) : key.codeUnits);

  /// Signing the [message] using a [key] to generate a tag.
  @pragma('vm:prefer-inline')
  HashDigest sign(List<int> key, List<int> message) => by(key).sign(message);

  /// Verify if the [tag] is derived from the [message] using a [key].
  @pragma('vm:prefer-inline')
  bool verify(List<int> key, List<int> tag, List<int> message) =>
      by(key).verify(tag, message);
}
