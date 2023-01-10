// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

// Maximum length of message allowed (considering both the JS and Dart VM)
const int _maxMessageLength = 0x3FFFFFFFFFFFF; // (1 << 50) - 1

abstract class HashDigestSink implements ByteConversionSink {
  /// The length of generated hash in bytes
  final int hashLength;

  /// The internal block length of the algorithm in bytes
  final int blockLength;

  const HashDigestSink({
    required this.hashLength,
    required this.blockLength,
  });

  /// Returns true if the sink is closed, false otherwise
  bool get closed;

  /// Adds [data] to the message-digest.
  ///
  /// The [addSlice] function is preferred over [add]
  ///
  /// Throws [StateError], if it is called after closing the digest.
  @override
  void add(List<int> data) => addSlice(data, 0, data.length);

  /// Adds [data] to the message-digest.
  ///
  /// Throws [StateError], if it is called after closing the digest.
  @override
  void addSlice(List<int> chunk, int start, int end, [bool isLast = false]);

  /// Finalizes the message-digest and returns a [HashDigest]
  HashDigest digest();

  @override
  void close() => digest();
}

abstract class BlockHashBase extends HashDigestSink {
  int _pos = 0;
  HashDigest? _digest;
  bool _closed = false;
  int _messageLength = 0;

  /// The internal buffer for processing
  final Uint8List _buffer;

  BlockHashBase({
    required int hashLength,
    required int blockLength,
  })  : _buffer = Uint8List(blockLength),
        super(
          hashLength: hashLength,
          blockLength: blockLength,
        );

  /// Get the message length in bytes
  int get messageLength => _messageLength;

  /// Get the message length in bits
  int get messageLengthInBits => _messageLength << 3;

  /// Internal method to update the message-digest with a single [block].
  ///
  /// The method starts reading the block from [offset] index
  void $update(List<int> block, [int offset = 0]);

  /// Finalizes the message digest with the remaining message block,
  /// and returns the output as byte array.
  ///
  /// The [length] must be less than the [blockLength]
  Uint8List $finalize(Uint8List block, int length);

  @override
  bool get closed => _closed;

  @override
  void addSlice(List<int> chunk, int start, int end, [bool isLast = false]) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }

    if (_messageLength - start > _maxMessageLength - end) {
      throw StateError('Exceeds the maximum message size limit');
    }
    _messageLength += end - start;

    int t = start;
    if (_pos > 0) {
      for (; t < end && _pos < blockLength; _pos++, t++) {
        _buffer[_pos] = chunk[t];
      }
      if (_pos < blockLength) return;

      $update(_buffer);
      _pos = 0;
    }

    while ((end - t) >= blockLength) {
      $update(chunk, t);
      t += blockLength;
    }
    for (; t < end; _pos++, t++) {
      _buffer[_pos] = chunk[t];
    }

    if (isLast) digest();
  }

  @override
  HashDigest digest() {
    if (_closed) return _digest!;
    _closed = true;
    _digest = HashDigest($finalize(_buffer, _pos));
    return _digest!;
  }
}
