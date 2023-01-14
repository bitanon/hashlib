// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

final Map<int, Uint32List> _tables = {};

/// A CRC-32 code generator with IEEE 802.3 CRC-32 polynomial.
///
/// Reference: https://pkg.go.dev/hash/crc32
class CRC32Hash implements HashDigestSink {
  final int seed;
  final Uint32List table;

  int _crc;
  HashDigest? _digest;
  bool _closed = false;

  CRC32Hash({
    this.seed = 0xFFFFFFFF,
    int polynomial = 0xEDB88320,
  })  : _crc = seed,
        table = _generate32(polynomial);

  @override
  int get hashLength => 4;

  @override
  bool get closed => _closed;

  @override
  void add(List<int> data, [int start = 0, int? end]) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }
    for (end ??= data.length; start < end; start++) {
      _crc = table[(_crc ^ data[start]) & 0xFF] ^ (_crc >>> 8);
    }
  }

  @override
  HashDigest digest() {
    if (_closed) return _digest!;
    _closed = true;
    _crc ^= seed;
    Uint8List bytes = Uint8List.fromList([
      _crc >>> 24,
      _crc >>> 16,
      _crc >>> 8,
      _crc,
    ]);
    _digest = HashDigest(bytes);
    return _digest!;
  }
}

/// Generates the 256-byte table for CRC
Uint32List _generate32(int polynomial) {
  return _tables.putIfAbsent(polynomial, () {
    int i, j, b;
    var table = Uint32List(256);
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
