// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

const int maxAllowedMessageLength = (1 << 50);

abstract class HashBase {
  HashDigest? _digest;

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

  HashBase({
    this.bit2exp = 2,
    this.blockLengthInBits = 512,
    required this.hashLengthInBits,
    required,
  })  : wordLength = 1 << bit2exp,
        wordLengthInBits = (1 << bit2exp) << 3,
        hashLength = hashLengthInBits >>> 3,
        blockLength = blockLengthInBits >>> 3 {
    $reset();
  }

  /// Internal method to reset the message-digest for re-use
  void $reset() {
    _digest = null;
  }

  /// Whether the generator is closed
  bool get closed => _digest != null;

  /// Updates the message-digest.
  ///
  /// Throws an [StateError] if the message-digest is already closed.
  void update(final Iterable<int> input) {
    if (closed) {
      throw StateError('The message-digest is already closed');
    }
  }

  /// Finalizes the message-digest operation and returns a [HashDigest].
  HashDigest digest() {
    if (_digest != null) {
      return _digest!;
    }
    _digest = HashDigest(
      algorithm: this,
      bytes: $close(),
    );
    return _digest!;
  }

  /// Internal method to close the message-digest
  Uint8List $close();
}
