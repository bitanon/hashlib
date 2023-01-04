// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

const int maxAllowedMessageLength = (1 << 50);

abstract class HashAlgo {
  final Endian endian;
  final int _blockSize; /* block size in bits */
  final int _hashSize; /* output hash length in bits */
  final Uint32List _state; /* internal hash state */
  final Uint8List _buffer; /* fixed size input buffer */
  int _messageLength = 0; /* original message length in bytes */
  int _pos = 0; /* running position in the buffer */
  HashDigest? _digest; /* the final digest */

  HashAlgo({
    required List<int> seed,
    required int hashSize,
    int blockSize = 512,
    this.endian = Endian.big,
  })  : _hashSize = hashSize,
        _blockSize = blockSize,
        _state = Uint32List.fromList(seed),
        _buffer = Uint8List(blockSize >>> 3);

  /// Whether the generator is closed
  bool get closed => _digest != null;

  /// The length of generated hash in bits
  int get hashLengthInBits => _hashSize;

  /// The length of generated hash in bytes
  int get hashLength => hashLengthInBits >>> 3;

  /// The internal block length of the algorithm in bits
  int get blockLengthInBits => _blockSize;

  /// The internal block length of the algorithm in bytes
  int get blockLength => _blockSize >>> 3;

  /// The original message length in bits
  int get messageLengthInBits => _messageLength << 3;

  /// The original message length in bytes
  int get messageLength => _messageLength;

  /// Updates the message-digest.
  ///
  /// Throws an [StateError] if the message-digest is already closed.
  void update(final Iterable<int> input) {
    if (closed) {
      throw StateError('The message-digest is already closed');
    }

    // Transform as many times as possible.
    for (int x in input) {
      if (_messageLength >= maxAllowedMessageLength) {
        throw StateError('Maximum limit of message size reached');
      }
      _buffer[_pos++] = x;
      if (_pos == blockLength) {
        $process(_state, _buffer);
        _pos = 0;
      }
      _messageLength++;
    }
  }

  /// Finalizes the message-digest operation and returns a [HashDigest].
  HashDigest digest() {
    // The final message digest is available in [_digest]
    if (_digest != null) {
      return _digest!;
    }

    $finalize(_state, _buffer, _pos);
    $encode(_state, _buffer);

    _digest = HashDigest(
      algorithm: this,
      bytes: _buffer.getRange(0, hashLength),
    );

    return _digest!;
  }

  /// Internal method to process input chunk
  void $process(final Uint32List state, Uint8List buffer);

  /// Internal method to finalize the digest
  void $finalize(final Uint32List state, Uint8List buffer, int pos);

  /// Internal method to read a block from buffer
  void $decode(Uint8List buffer, Uint32List target, [int offset = 0]) {
    if (endian == Endian.big) {
      for (int i = offset, j = 0; j < buffer.length; i++, j += 4) {
        target[i] = (buffer[j] << 24) |
            (buffer[j + 1] << 16) |
            (buffer[j + 2] << 8) |
            (buffer[j + 3]);
      }
    } else {
      for (int i = offset, j = 0; j < buffer.length; i++, j += 4) {
        target[i] = (buffer[j + 3] << 24) |
            (buffer[j + 2] << 16) |
            (buffer[j + 1] << 8) |
            (buffer[j]);
      }
    }
  }

  /// Internal method write Uint32List to Uint8List
  void $encode(Uint32List source, Uint8List target, [int offset = 0]) {
    if (endian == Endian.big) {
      for (int i = 0, j = offset; i < source.length; i++, j += 4) {
        target[j] = (source[i] >>> 24) & 0xff;
        target[j + 1] = (source[i] >>> 16) & 0xff;
        target[j + 2] = (source[i] >>> 8) & 0xff;
        target[j + 3] = (source[i] & 0xff);
      }
    } else {
      for (int i = 0, j = offset; i < source.length; i++, j += 4) {
        target[j + 3] = (source[i] >>> 24) & 0xff;
        target[j + 2] = (source[i] >>> 16) & 0xff;
        target[j + 1] = (source[i] >>> 8) & 0xff;
        target[j] = (source[i] & 0xff);
      }
    }
  }

  /// Internal method write Uint64List to Uint8List
  void $encode64(Uint64List source, Uint8List target, [int offset = 0]) {
    if (endian == Endian.big) {
      for (int i = 0, j = offset; i < source.length; i++, j += 8) {
        target[j] = (source[i] >>> 56) & 0xff;
        target[j + 1] = (source[i] >>> 48) & 0xff;
        target[j + 2] = (source[i] >>> 40) & 0xff;
        target[j + 3] = (source[i] >>> 32) & 0xff;
        target[j + 4] = (source[i] >>> 24) & 0xff;
        target[j + 5] = (source[i] >>> 16) & 0xff;
        target[j + 6] = (source[i] >>> 8) & 0xff;
        target[j + 7] = (source[i] & 0xff);
      }
    } else {
      for (int i = 0, j = offset; i < source.length; i++, j += 8) {
        target[j + 7] = (source[i] >>> 56) & 0xff;
        target[j + 6] = (source[i] >>> 48) & 0xff;
        target[j + 5] = (source[i] >>> 40) & 0xff;
        target[j + 4] = (source[i] >>> 32) & 0xff;
        target[j + 3] = (source[i] >>> 24) & 0xff;
        target[j + 2] = (source[i] >>> 16) & 0xff;
        target[j + 1] = (source[i] >>> 8) & 0xff;
        target[j] = (source[i] & 0xff);
      }
    }
  }
}
