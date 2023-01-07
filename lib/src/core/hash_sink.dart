// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

// Maximum length of message allowed (considering both the JS and the Dart VM)
const int _maxMessageLength = (1 << 50) - 1;

abstract class HashSink extends Sink<List<int>> {
  final Sink<HashDigest>? sink;
  final List<int> seed;
  final Uint32List state;
  final Uint32List chunk;
  final Uint8List _buffer;

  int _pos = 0;
  bool _closed = false;
  int _messageLength = 0;
  HashDigest? _digest;

  HashSink({
    this.sink,
    required this.seed,
    required int hashLengthInBits,
    this.blockLengthInBits = 512,
    this.endian = Endian.big,
    this.signatureByte = 0x80,
    int? extendedChunkLength,
  })  : state = Uint32List.fromList(seed),
        hashLength = hashLengthInBits >>> 3,
        blockLength = blockLengthInBits >>> 3,
        blockLengthInWords = blockLengthInBits >>> 5,
        _buffer = Uint8List(blockLengthInBits >>> 3),
        chunk = Uint32List(extendedChunkLength ?? blockLengthInBits >>> 5);

  /// The endianness of the buffers
  final Endian endian;

  /// The length of generated hash in bytes
  final int hashLength;

  /// The internal block length of the algorithm in bits
  final int blockLengthInBits;

  /// The internal block length of the algorithm in bytes
  final int blockLength;

  /// The internal block length of the algorithm in words
  final int blockLengthInWords;

  /// The original message length in bytes
  int get messageLength => _messageLength;

  /// The original message length in bits
  int get messageLengthInBits => _messageLength << 3;

  /// The byte to append at the end of the digest when closing
  final int signatureByte;

  /// The final message-digest.
  ///
  /// Throws [StateError] if called before closing the digest.
  HashDigest get digest {
    if (_digest == null) {
      throw StateError('The message-digest is not yet closed.');
    }
    return _digest!;
  }

  /// Internal method to update the message-digest with new block
  void update(Uint32List block);

  /// Resets all state to make it ready for re-use
  void reset() {
    _pos = 0;
    _digest = null;
    _closed = false;
    _messageLength = 0;
    state.setAll(0, seed);
  }

  @override
  void add(List<int> data) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }

    _messageLength += data.length;
    if (_messageLength > _maxMessageLength) {
      throw StateError('Maximum limit of message size reached');
    }

    for (int i = 0; i < data.length; ++i) {
      _buffer[_pos++] = data[i];
      if (_pos == blockLength) {
        _process();
      }
    }
  }

  @override
  void close() {
    if (_closed) return;
    _closed = true;

    // Adding the signature byte
    _buffer[_pos++] = signatureByte;

    // If no more space left in buffer for the message length
    if (_pos > blockLength - 8) {
      while (_pos < blockLength) {
        _buffer[_pos++] = 0;
      }
      _process();
    }

    // Fill remaining buffer to put the message length at the end
    while (_pos < blockLength - 8) {
      _buffer[_pos++] = 0;
    }

    // Append original message length in bits to message
    var count = messageLengthInBits;
    if (endian == Endian.big) {
      for (int i = blockLength - 1; i >= _pos; --i) {
        _buffer[i] = count;
        count >>= 8;
      }
      _pos = blockLength;
    } else {
      while (_pos < blockLength) {
        _buffer[_pos++] = count;
        count >>= 8;
      }
    }
    _process();

    // Encode the hash state to 8-bit byte array
    Uint8List bytes;
    if (endian == Endian.host) {
      bytes = state.buffer.asUint8List(0, hashLength);
    } else if (endian == Endian.big) {
      bytes = Uint8List(hashLength);
      for (int j = 0, i = 0; j < hashLength; i++) {
        bytes[j++] = state[i] >> 24;
        bytes[j++] = state[i] >> 16;
        bytes[j++] = state[i] >> 8;
        bytes[j++] = state[i];
      }
    } else {
      bytes = Uint8List(hashLength);
      for (int j = 0, i = 0; j < hashLength; i++) {
        bytes[j++] = state[i];
        bytes[j++] = state[i] >> 8;
        bytes[j++] = state[i] >> 16;
        bytes[j++] = state[i] >> 24;
      }
    }

    _digest = HashDigest(bytes);
    if (sink != null) {
      sink!.add(_digest!);
      sink!.close();
    }
  }

  void _process() {
    int j = 0;
    if (endian == Endian.big) {
      for (int i = 0; i < blockLengthInWords; i++, j += 4) {
        chunk[i] = (_buffer[j] << 24) |
            (_buffer[j + 1] << 16) |
            (_buffer[j + 2] << 8) |
            (_buffer[j + 3]);
      }
    } else {
      for (int i = 0; i < blockLengthInWords; i++, j += 4) {
        chunk[i] = (_buffer[j + 3] << 24) |
            (_buffer[j + 2] << 16) |
            (_buffer[j + 1] << 8) |
            (_buffer[j]);
      }
    }
    update(chunk);
    _pos = 0;
  }
}
