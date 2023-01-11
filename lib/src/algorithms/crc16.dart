// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

final Map<int, Uint16List> _tables = {};

class CRC16Hash extends HashDigestSink {
  final int seed;
  final Uint16List table;

  int _crc;
  HashDigest? _digest;
  bool _closed = false;

  CRC16Hash({
    this.seed = 0,
    int polynomial = 0xA001,
  })  : _crc = seed,
        table = _generate16(polynomial),
        super(hashLength: 2);

  @override
  bool get closed => _closed;

  @override
  void addSlice(List<int> chunk, int start, int end, [bool isLast = false]) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }
    for (; start < end; start++) {
      _crc = table[(_crc ^ chunk[start]) & 0xFF] ^ (_crc >>> 8);
    }
    if (isLast) digest();
  }

  @override
  HashDigest digest() {
    if (_closed) return _digest!;
    _closed = true;
    _crc ^= seed;
    Uint8List bytes = Uint8List.fromList([
      _crc >>> 8,
      _crc,
    ]);
    _digest = HashDigest(bytes);
    return _digest!;
  }
}

/// Generates the 256-byte table for CRC
Uint16List _generate16(int polynomial) {
  return _tables.putIfAbsent(polynomial, () {
    int i, j, b;
    var table = Uint16List(256);
    for (i = 0; i < 256; ++i) {
      b = i;
      for (j = 0; j < 8; ++j) {
        b = (b & 1) == 1 ? polynomial ^ (b >>> 1) : (b >>> 1);
      }
      table[i] = b;
    }
    return table;
  });
}
