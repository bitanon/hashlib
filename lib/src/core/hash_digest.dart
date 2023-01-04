// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/utils.dart';

abstract class HashDigest {
  /// Finalizes the MD5 message-digest operation,
  /// and returns the 128-bit long hash.
  Uint8List digest();

  /// Finalizes the MD5 message-digest operation,
  /// and returns a hexadecimal string.
  String hexdigest([bool uppercase = false]) {
    return toHexString(digest(), uppercase);
  }
}
