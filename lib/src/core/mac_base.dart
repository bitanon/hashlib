// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_base.dart';

abstract class MACSinkBase implements HashDigestSink {
  /// The length of generated key in bytes
  int get derivedKeyLength => hashLength;

  /// Initialize the MAC sink with the authentication key
  void init(List<int> key);
}

abstract class MACHashBase extends HashBase {
  final List<int> key;

  const MACHashBase(this.key);

  @override
  MACSinkBase createSink();
}
