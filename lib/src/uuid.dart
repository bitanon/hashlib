// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'random/uuid_v1.dart';
import 'random/uuid_v3.dart';
import 'random/uuid_v4.dart';
import 'random/uuid_v5.dart';
import 'random/uuid_v6.dart';
import 'random/uuid_v7.dart';
import 'random/uuid_v8.dart';

const _v1 = UUIDv1();
const _v3 = UUIDv3();
const _v4 = UUIDv4();
const _v5 = UUIDv5();
const _v6 = UUIDv6();
const _v7 = UUIDv7();
const _v8 = UUIDv8();

/// A UUID is 128 bits long and is intended to guarantee uniqueness. This class
/// contains implementations for different versions of UUIDs based on the
/// specification from [RFC-9562][rfc].
///
/// [rfc]: https://www.ietf.org/rfc/rfc9562.html
const uuid = _UUID();

enum Namespace {
  dns,
  url,
  oid,
  x500,
  nil,
  max,
  time,
}

/// Adds a [value] attribute to [Namespace] enum to get the string value.
extension NamespaceValue on Namespace {
  String get value {
    switch (this) {
      case Namespace.dns:
        return '6ba7b810-9dad-11d1-80b4-00c04fd430c8';
      case Namespace.url:
        return '6ba7b811-9dad-11d1-80b4-00c04fd430c8';
      case Namespace.oid:
        return '6ba7b812-9dad-11d1-80b4-00c04fd430c8';
      case Namespace.x500:
        return '6ba7b814-9dad-11d1-80b4-00c04fd430c8';
      case Namespace.nil:
        return '00000000-0000-0000-0000-000000000000';
      case Namespace.max:
        return 'ffffffff-ffff-ffff-ffff-ffffffffffff';
      case Namespace.time:
        return _v6.generate();
    }
  }
}

class _UUID {
  const _UUID();

  /// Generate a time-based UUID. Use [v6] instead of [v1] wherever possible.
  ///
  /// Parameters:
  /// - [utc] : The time in UTC (Default: current time).
  /// - [node] : The node ID (48-bit integer, Default: random).
  /// - [clockSeq] : The clock sequence (14-bit integer, Default: random).
  @pragma('vm:prefer-inline')
  String v1({
    DateTime? utc,
    int? node,
    int? clockSeq,
  }) =>
      _v1.generate(
        now: utc,
        node: node,
        clockSeq: clockSeq,
      );

  /// Generate a UUID based on MD5-hash. Due to vulnerability of MD5, it is
  /// recommended to use [v5] instead.
  ///
  /// The [namespace] must be a valid UUID. Some predefined namespaces are
  /// available in [Namespace]. i.e.: `Namespace.dns.value`. A random namespace
  /// is used if not provided.
  @pragma('vm:prefer-inline')
  String v3({
    String? namespace,
    String? name,
  }) =>
      _v3.generate(
        name: name,
        namespace: namespace,
      );

  /// Generate a random-based UUID.
  @pragma('vm:prefer-inline')
  String v4() => _v4.generate();

  /// Generate a UUID based on SHA1-hash.
  ///
  /// The [namespace] must be a valid UUID. Some predefined namespaces are
  /// available in [Namespace]. i.e.: `Namespace.dns.value`. A random namespace
  /// is used if not provided.
  @pragma('vm:prefer-inline')
  String v5({
    String? namespace,
    String? name,
  }) =>
      _v5.generate(
        name: name,
        namespace: namespace,
      );

  /// Generate a time-based UUID.
  ///
  /// Parameters:
  /// - [utc] : The time in UTC (Default: current time).
  /// - [node] : The node ID (48-bit integer, Default: random).
  /// - [clockSeq] : The clock sequence (14-bit integer, Default: random).
  @pragma('vm:prefer-inline')
  String v6({
    DateTime? utc,
    int? node,
    int? clockSeq,
  }) =>
      _v6.generate(
        now: utc,
        node: node,
        clockSeq: clockSeq,
      );

  /// Generate a time-based and random-based UUID.
  ///
  /// Parameters:
  /// - [utc] : The time in UTC (Default: current time).
  @pragma('vm:prefer-inline')
  String v7({
    DateTime? utc,
  }) =>
      _v7.generate(now: utc);

  /// Generate a nonce based UUID.
  ///
  /// Parameters:
  /// - [nonce] : A 16-byte nonce (128-bit)
  @pragma('vm:prefer-inline')
  String v8({
    Uint8List? nonce,
  }) =>
      _v8.generate(
        nonce: nonce,
      );
}
