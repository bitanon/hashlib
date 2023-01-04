// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_digest.dart';

abstract class HashAlgo extends HashDigest {
  /// The length of generated hash in bits
  abstract final int hashLengthInBits;

  /// Clears all contexts and resets the instance for re-use.
  void clear();

  /// Updates the MD5 message-digest.
  ///
  /// _This method only supports 8-bit big-endian input array._
  ///
  /// Throws an [StateError] if the message-digest is already closed.
  void update(final Iterable<int> input);

  /// The length of generated hash in bytes
  int get hashLength => hashLengthInBits >> 3;
}
