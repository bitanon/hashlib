// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/hmac.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/mac_base.dart';
import 'package:hashlib/src/sha256.dart';

/// The HMAC/SHA-256 algorithm
// ignore: constant_identifier_names
const hmac_sha256 = HMAC(sha256);

/// HMAC is a hash-based message authentication code that can be used to
/// simultaneously verify both the data integrity and authenticity of a message.
class _HMAC<T extends BlockHashBase> extends HashBase<HMACSink<T>>
    with MACHashBase<HMACSink<T>> {
  /// The algorithm for the MAC generation
  final T algo;
  final List<int> key;

  const _HMAC(this.algo, this.key);

  @override
  String get name => '${algo.name}/HMAC';

  @override
  HMACSink<T> createSink() => HMACSink(algo, key);
}

/// HMAC is a hash-based message authentication code that can be used to
/// simultaneously verify both the data integrity and authenticity of a message.
class HMAC<T extends BlockHashBase> extends MACHash<HMACSink<T>> {
  /// The algorithm for the MAC generation
  final T algo;

  const HMAC(this.algo);

  @override
  String get name => '${algo.name}/HMAC';

  @override
  MACHashBase<HMACSink<T>> by(List<int> key) => _HMAC(algo, key);
}

/// Extension on [BlockHashBase] to get an [HMAC] instance
extension HMAConBlockHashBase<T extends BlockHashBase> on T {
  /// Gets a [HMAC] instance builder for this algorithm.
  ///
  /// HMAC is a hash-based message authentication code that can be used to
  /// simultaneously verify both the data integrity and authenticity of a message.
  HMAC<T> get hmac => HMAC(this);
}
