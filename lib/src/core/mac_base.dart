// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_base.dart';

abstract class MACSinkBase implements HashDigestSink {
  const MACSinkBase();

  /// Whether the MAC instance is initialized with a key
  bool get initialized;

  /// Initialize the MAC sink with the authentication key
  void init(List<int> key);

  @override
  void close() => digest();
}
