// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/hash_digest.dart';

const int maxAllowedMessageLength = (1 << 50);

abstract class HashBase {
  /// The number of bits in a single [word] in terms of 2's exponent
  final int bit2exp;

  /// The number of bits in a single [word]
  final int wordLengthInBits;

  /// The number of bytes in a single [word]
  final int wordLength;

  /// The length of generated hash in bits
  final int hashLengthInBits; // _hashSize;

  /// The length of generated hash in bytes
  final int hashLength; // hashLengthInBits >>> 3;

  /// The internal block length of the algorithm in bits
  final int blockLengthInBits; // _blockSize;

  /// The internal block length of the algorithm in bytes
  final int blockLength; // _blockSize >>> 3;

  const HashBase({
    this.bit2exp = 2,
    this.blockLengthInBits = 512,
    required this.hashLengthInBits,
    required,
  })  : wordLength = 1 << bit2exp,
        wordLengthInBits = (1 << bit2exp) << 3,
        hashLength = hashLengthInBits >>> 3,
        blockLength = blockLengthInBits >>> 3;

  /// Internal method to reset the message-digest for re-use
  void $reset();

  /// Updates the message-digest.
  ///
  /// Throws an [StateError] if the message-digest is already closed.
  void update(final Iterable<int> input);

  /// Finalizes the message-digest operation and returns a [HashDigest].
  HashDigest digest();
}
