// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

const int maxAllowedMessageLength = (1 << 50);

abstract class Hash32bit extends HashBase {
  /// Then endian-ness of the buffers
  final Endian endian;
  final List<int> seed;
  final ByteData _buffer;
  final Uint32List _state;

  int _pos = 0;
  int _messageLength = 0;
  HashDigest? _digest;

  Hash32bit({
    required this.seed,
    this.endian = Endian.big,
    int blockLengthInBits = 512,
    required int hashLengthInBits,
  })  : _state = Uint32List.fromList(seed),
        _buffer = ByteData(blockLengthInBits >>> 3),
        super(
          bit2exp: 2,
          hashLengthInBits: hashLengthInBits,
          blockLengthInBits: blockLengthInBits,
        );

  /// Whether the generator is closed
  bool get closed => _digest != null;

  /// The original message length in bytes
  int get messageLength => _messageLength;

  /// The original message length in bits
  int get messageLengthInBits => _messageLength << 3;

  /// Internal method to process input chunk
  void $process(final Uint32List state, ByteData buffer);

  /// Internal method to finalize the digest
  void $finalize(final Uint32List state, ByteData buffer, int pos);

  @override
  void $reset() {
    _pos = 0;
    _messageLength = 0;
    _state.setAll(0, seed);
    _digest = null;
  }

  @override
  void update(final Iterable<int> input) {
    if (_digest != null) {
      throw StateError('The message-digest is already closed');
    }

    // Transform as many times as possible.
    for (int x in input) {
      if (_messageLength >= maxAllowedMessageLength) {
        throw StateError('Maximum limit of message size reached');
      }
      _buffer.setUint8(_pos++, x);
      if (_pos == blockLength) {
        $process(_state, _buffer);
        _pos = 0;
      }
      _messageLength++;
    }
  }

  Uint8List _close() {
    $finalize(_state, _buffer, _pos);

    if (endian == Endian.host) {
      return _state.buffer.asUint8List(0, hashLength);
    }

    var data = ByteData(hashLength);
    for (int j = 0, i = 0; j < hashLength; i++, j += 4) {
      data.setUint32(j, _state[i], endian);
    }
    return data.buffer.asUint8List();
  }

  @override
  HashDigest digest() {
    if (_digest != null) {
      return _digest!;
    }
    _digest = HashDigest(
      algorithm: this,
      bytes: _close(),
    );
    return _digest!;
  }
}
