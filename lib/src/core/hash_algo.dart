import 'dart:typed_data';

import 'package:hashlib/src/core/utils.dart';

abstract class HashAlgo {
  /// Clears all contexts and resets the instance for re-use.
  void clear();

  /// Finalizes the MD5 message-digest operation,
  /// and returns the 128-bit long hash.
  Uint8List digest();

  /// Updates the MD5 message-digest.
  ///
  /// Throws an [StateError] if the message-digest is already closed.
  void update(final Iterable<int> input);

  /// Finalizes the MD5 message-digest operation,
  /// and returns a hexadecimal string.
  String hexdigest() {
    return toHexString(digest());
  }
}
