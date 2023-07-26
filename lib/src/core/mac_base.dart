// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

abstract class MACSinkBase implements HashDigestSink {
  const MACSinkBase();
}

abstract class MACHashBase extends HashBase {
  const MACHashBase();

  /// The current secret key
  ///
  /// If the MAC is not initialized, the key can be null.
  List<int>? get key;

  /// Initialize the MAC with the key
  init(List<int> key);

  @override
  MACSinkBase createSink();

  /// Signing the [message] using this MAC to generate a tag.
  @pragma('vm:prefer-inline')
  HashDigest sign(List<int> message) => convert(message);

  /// Verify if the [tag] is derived from the [message] using this MAC.
  @pragma('vm:prefer-inline')
  bool verify(List<int> tag, List<int> message) =>
      convert(message).isEqual(message);
}
