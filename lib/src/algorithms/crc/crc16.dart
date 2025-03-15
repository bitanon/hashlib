// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';

final Map<int, Uint16List> _tables = {};

/// A CRC-16 code generator with IBM CRC-16 polynomial.
///
/// Reference: https://en.wikipedia.org/wiki/Cyclic_redundancy_check
class CRC16Hash extends HashDigestSink {
  final int seed;
  final Uint16List table;

  int _crc;

  CRC16Hash({
    this.seed = 0,
    int polynomial = 0xA001,
  })  : _crc = seed,
        table = _generate16(polynomial);

  @override
  final int hashLength = 2;

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
      _crc >>> 8,
      _crc,
    ]);
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
