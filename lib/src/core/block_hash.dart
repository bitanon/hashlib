// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

// Maximum length of message allowed (considering both the JS and Dart VM)
const int _maxMessageLength = 0x3FFFFFFFFFFFF; // (1 << 50) - 1

abstract class BlockHashBase extends HashDigestSink {
  // The digest and closing flag
  HashDigest? _digest;
  bool _closed = false;

  /// The current position of data in the [buffer]
  int pos = 0;

  /// The message length in bytes
  int messageLength = 0;

  /// The internal block length of the algorithm in bytes
  final int blockLength;

  /// The buffer as Uint8List
  late final Uint8List buffer;

  /// The buffer as ByteData
  late final ByteData bdata;

  /// The buffer as Uint32List
  late final Uint32List sbuffer;

  /// The buffer as Uint34List
  late final Uint64List qbuffer;

  BlockHashBase({
    required this.blockLength,
    required int hashLength,
    int? bufferLengthInBytes,
  }) : super(hashLength: hashLength) {
    buffer = Uint8List(bufferLengthInBytes ?? blockLength);
    bdata = buffer.buffer.asByteData();
    sbuffer = buffer.buffer.asUint32List();
    qbuffer = buffer.buffer.asUint64List();
  }

  @override
  bool get closed => _closed;

  /// Get the message length in bits
  int get messageLengthInBits => messageLength << 3;

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
  void addSlice(List<int> chunk, int start, int end, [bool isLast = false]) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }
    if (messageLength - start > _maxMessageLength - end) {
      throw StateError('Exceeds the maximum message size limit');
    }

    $process(chunk, start, end);
    if (isLast) digest();
  }

  /// Processes a chunk of input data
  void $process(List<int> chunk, int start, int end) {
    int t = start;
    if (pos > 0) {
      for (; t < end && pos < blockLength; pos++, t++) {
        buffer[pos] = chunk[t];
      }
      messageLength += t - start;
      if (pos < blockLength) return;

      $update(buffer);
      pos = 0;
    }

    while ((end - t) >= blockLength) {
      messageLength += blockLength;
      $update(chunk, t);
      t += blockLength;
    }
    messageLength += end - t;
    for (; t < end; pos++, t++) {
      buffer[pos] = chunk[t];
    }
  }

  @override
  HashDigest digest() {
    if (_closed) return _digest!;
    _closed = true;
    _digest = HashDigest($finalize(buffer, pos));
    return _digest!;
  }
}
