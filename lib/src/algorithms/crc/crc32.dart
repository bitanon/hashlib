// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';

final Map<int, Uint32List> _tables = {};

/// A CRC-32 code generator with IEEE 802.3 CRC-32 polynomial.
///
/// Reference: https://pkg.go.dev/hash/crc32
class CRC32Hash extends HashDigestSink {
  int _crc;
  final int seed;
  final Uint32List table;

  CRC32Hash({
    this.seed = 0xFFFFFFFF,
    int polynomial = 0xEDB88320,
  })  : _crc = seed,
        table = _generate32(polynomial);

  @override
  final int hashLength = 4;

  @override
  void reset() {
    _crc = seed;
    super.reset();
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (; start < end; start++) {
      _crc = table[(_crc ^ chunk[start]) & 0xFF] ^ (_crc >>> 8);
    }
  }

  @override
  Uint8List $finalize() {
    _crc ^= seed;
    return Uint8List.fromList([
      _crc >>> 24,
      _crc >>> 16,
      _crc >>> 8,
      _crc,
    ]);
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
