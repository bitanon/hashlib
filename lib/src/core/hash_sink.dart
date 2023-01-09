// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

// Maximum length of message allowed (considering both the JS and the Dart VM)
const int _maxMessageLength = (1 << 50) - 1;

abstract class HashDigestSink {
  const HashDigestSink();

  /// Resets the internal state to make it ready for re-use
  void reset();

  /// Adds [data] to the message-digest.
  ///
  /// Throws [StateError] if called after closing the digest.
  void add(List<int> data);

  /// Finalizes the message-digest and returns a [HashDigest]
  HashDigest digest();
}

abstract class HashSinkBase implements HashDigestSink {
  final List<int> seed;

  /// The length of generated hash in bits
  final int hashLengthInBits;

  /// The length of generated hash in bytes
  final int hashLength;

  /// The internal block length of the algorithm in bits
  final int blockLengthInBits;

  /// The internal block length of the algorithm in bytes
  final int blockLength;

  /// The internal block length of the algorithm in words
  final int blockLengthInWords;

  /// The byte to append at the end of the digest when closing
  final int messageLengthBytes;

  const HashSinkBase({
    required this.seed,
    required this.hashLengthInBits,
    this.blockLengthInBits = 512,
    this.messageLengthBytes = 8,
  })  : hashLength = hashLengthInBits >>> 3,
        blockLength = blockLengthInBits >>> 3,
        blockLengthInWords = blockLengthInBits >>> 5;
}

/// Parent class for hash algorithms with big endian numbers.
///
/// This class only supports big endian numbers. Use [HashSinkLittle] to use
/// little endian numbers.
abstract class HashSink extends HashSinkBase {
  late final Uint32List state;
  late final Uint32List chunk;
  late final Uint8List _buffer;

  int _pos = 0;
  HashDigest? _digest;
  int _messageLength = 0;

  HashSink({
    required List<int> seed,
    required int hashLengthInBits,
    int blockLengthInBits = 512,
    int messageLengthBytes = 8,
    int? extendedChunkLength,
  }) : super(
          seed: seed,
          messageLengthBytes: messageLengthBytes,
          hashLengthInBits: hashLengthInBits,
          blockLengthInBits: blockLengthInBits,
        ) {
    state = Uint32List.fromList(seed);
    _buffer = Uint8List(blockLength);
    chunk = Uint32List(extendedChunkLength ?? blockLength);
  }

  /// The original message length in bytes
  int get messageLength => _messageLength;

  /// The original message length in bits
  int get messageLengthInBits => _messageLength << 3;

  @override
  void reset() {
    _pos = 0;
    _digest = null;
    _messageLength = 0;
    state.setAll(0, seed);
  }

  @override
  void add(List<int> data) {
    if (_digest != null) {
      throw StateError('The message-digest is already closed');
    }

    var n = data.length;
    if (_messageLength + n > _maxMessageLength) {
      throw StateError('Exceeds the maximum message size limit');
    }
    _messageLength += n;

    int t = 0;
    if (_pos > 0) {
      while (t < n && _pos < blockLength) {
        _buffer[_pos++] = data[t++];
      }
      if (_pos < blockLength) return;

      processData(_buffer, blockLength);
      _pos = 0;
    }

    t = processData(data, n, t);
    while (t < n) {
      _buffer[_pos++] = data[t++];
    }
  }

  @override
  HashDigest digest() {
    if (_digest != null) {
      return _digest!;
    }

    // Adding the signature byte
    _buffer[_pos++] = 0x80;

    // If no more space left in buffer for the message length
    if (_pos > blockLength - messageLengthBytes) {
      while (_pos < blockLength) {
        _buffer[_pos++] = 0;
      }
      processData(_buffer, blockLength);
      _pos = 0;
    }

    // Fill remaining buffer to put the message length at the end
    while (_pos + 8 < blockLength) {
      _buffer[_pos++] = 0;
    }

    // Append original message length in bits to message
    writeUint64(_buffer, _pos, messageLengthInBits);
    processData(_buffer, blockLength);
    _pos = 0;

    var result = HashDigest(buildDigest());
    _digest = result;

    return result;
  }

  /// Split data into chunks and update the message digest
  int processData(List<int> data, int n, [int t = 0]) {
    while ((n - t) >= blockLength) {
      for (int i = 0; i < blockLengthInWords; i++, t += 4) {
        chunk[i] = ((data[t] & 0xFF) << 24) |
            ((data[t + 1] & 0xFF) << 16) |
            ((data[t + 2] & 0xFF) << 8) |
            ((data[t + 3] & 0xFF));
      }
      update(chunk);
    }
    return t;
  }

  /// Append 64-bit integer at the end of the buffer
  void writeUint64(Uint8List buffer, int offset, int n) {
    for (int i = blockLength - 1; i >= offset; --i) {
      _buffer[i] = n;
      n >>= 8;
    }
  }

  /// Encodes the 32-bit hash digest to 8-bit array of bytes
  Uint8List buildDigest() {
    var bytes = Uint8List(hashLength);
    for (int j = 0, i = 0; j < hashLength; i++, j += 4) {
      bytes[j] = state[i] >>> 24;
      bytes[j + 1] = state[i] >>> 16;
      bytes[j + 2] = state[i] >>> 8;
      bytes[j + 3] = state[i];
    }
    return bytes;
  }

  /// Update the message-digest with new 32-bit block
  void update(Uint32List block);
}

/// Parent class for hash algorithms with little endian numbers.
///
/// Supports only little endian numbers. Use [HashSink] for big endian numbers.
abstract class HashSinkLittle extends HashSink {
  HashSinkLittle({
    required List<int> seed,
    required int hashLengthInBits,
    int blockLengthInBits = 512,
    int signatureLength = 8,
    int? extendedChunkLength,
  }) : super(
          seed: seed,
          hashLengthInBits: hashLengthInBits,
          blockLengthInBits: blockLengthInBits,
          messageLengthBytes: signatureLength,
          extendedChunkLength: extendedChunkLength,
        );

  @override
  int processData(List<int> data, int n, [int t = 0]) {
    while ((n - t) >= blockLength) {
      for (int i = 0; i < blockLengthInWords; i++, t += 4) {
        chunk[i] = ((data[t] & 0xFF)) |
            ((data[t + 1] & 0xFF) << 8) |
            ((data[t + 2] & 0xFF) << 16) |
            ((data[t + 3] & 0xFF) << 24);
      }
      update(chunk);
    }
    return t;
  }

  @override
  void writeUint64(Uint8List buffer, int offset, int n) {
    while (offset < blockLength) {
      buffer[offset++] = n;
      n >>= 8;
    }
  }

  @override
  Uint8List buildDigest() {
    var bytes = Uint8List(hashLength);
    for (int j = 0, i = 0; j < hashLength; i++, j += 4) {
      bytes[j] = state[i];
      bytes[j + 1] = state[i] >>> 8;
      bytes[j + 2] = state[i] >>> 16;
      bytes[j + 3] = state[i] >>> 24;
    }
    return bytes;
  }
}
