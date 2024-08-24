// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';

abstract class BlockHashBase extends HashBase {
  const BlockHashBase();

  @override
  BlockHashSink createSink();
}

abstract class BlockHashSink extends HashDigestSink {
  /// The current position of data in the [buffer]
  int pos = 0;

  /// The message length in bytes
  int messageLength = 0;

  /// The internal block length of the algorithm in bytes
  final int blockLength;

  /// The main buffer
  final Uint8List buffer;

  /// The [buffer] as Uint32List
  late final Uint32List sbuffer = Uint32List.view(buffer.buffer);

  /// The [buffer] as ByteData
  late final ByteData bdata = buffer.buffer.asByteData();

  /// Get the message length in bits
  int get messageLengthInBits => messageLength << 3;

  /// Initialize a new sink for the block hash
  ///
  /// Parameters:
  /// - [blockLength] is the length of each block in each [$update] call.
  /// - [bufferLength] is the buffer length where blocks are stored temporarily
  BlockHashSink(this.blockLength, {int? bufferLength})
      : assert(blockLength > 0 && (bufferLength ?? 0) >= 0),
        buffer = Uint8List(bufferLength ?? blockLength);

  @override
  void reset() {
    pos = 0;
    messageLength = 0;
    super.reset();
  }

  @override
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

  /// Internal method to update the message-digest with a single [block].
  ///
  /// The method starts reading the block from [offset] index
  void $update(List<int> block, [int offset = 0, bool last = false]);
}
