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
  late final ByteData buffer;

  int _pos = 0;
  bool _closed = false;
  int _messageLength = 0;
  HashDigest? _digest;

  HashSink({
    this.sink,
    required this.seed,
    required this.hashLengthInBits,
    this.blockLengthInBits = 512,
    this.endian = Endian.big,
    this.signatureByte = 0x80,
    int? extendedChunkLength,
  })  : state = Uint32List.fromList(seed),
        hashLength = hashLengthInBits >>> 3,
        blockLength = blockLengthInBits >>> 3,
        _buffer = Uint8List(blockLengthInBits >>> 3),
        chunk = Uint32List(extendedChunkLength ?? (blockLengthInBits >>> 5)) {
    buffer = _buffer.buffer.asByteData();
  }

  /// The endianness of the buffers
  final Endian endian;

  /// The length of generated hash in bits
  final int hashLengthInBits;

  /// The length of generated hash in bytes
  final int hashLength;

  /// The internal block length of the algorithm in bits
  final int blockLengthInBits;

  /// The internal block length of the algorithm in bytes
  final int blockLength;

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

    // If buffer length > 56 bytes, skip this block
    if (_pos > 56) {
      while (_pos < 64) {
        _buffer[_pos++] = 0;
      }
      _process();
    }

    // Padding with 0s until buffer length is 56 bytes
    while (_pos < 56) {
      _buffer[_pos++] = 0;
    }

    // Append original message length in bits to message
    buffer.setUint64(_pos, messageLengthInBits, endian);
    _process();

    // Encode the hash state to 8-bit byte array
    Uint8List bytes;
    if (endian == Endian.host) {
      bytes = state.buffer.asUint8List(0, hashLength);
    } else {
      var data = Uint8List(hashLength);
      for (int j = 0, i = 0; j < hashLength; i++) {
        data[j++] = state[i] >> 24;
        data[j++] = state[i] >> 16;
        data[j++] = state[i] >> 8;
        data[j++] = state[i];
      }
      bytes = data.buffer.asUint8List();
    }

    _digest = HashDigest(bytes);
    if (sink != null) {
      sink!.add(_digest!);
      sink!.close();
    }
  }

  void _process() {
    _pos = 0;
    for (int i = 0, j = 0; j < blockLength; i++, j += 4) {
      chunk[i] = buffer.getUint32(j, endian);
    }
    update(chunk);
  }
}
