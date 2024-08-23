// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';

final Map<String, Uint32List> _tables = {};

/// A CRC-64 code generator with ISO polynomial.
///
/// Reference: https://pkg.go.dev/hash/crc64
class CRC64Hash extends HashDigestSink {
  int high, low;
  final int seedHigh, seedLow;
  final Uint32List table;

  CRC64Hash({
    this.seedHigh = 0, // MSB of seed
    this.seedLow = 0, // LSB of seed
    int polynomialHigh = 0xD8000000, // MSB of polynomial
    int polynomialLow = 0x00000000, // LSB of polynomial
  })  : high = seedHigh,
        low = seedLow,
        table = _generate64(polynomialHigh, polynomialLow);

  @override
  final int hashLength = 8;

  @override
  void reset() {
    high = seedHigh;
    low = seedLow;
    super.reset();
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (int i, h, l; start < end; start++) {
      i = ((low ^ chunk[start]) & 0xFF) << 1;
      h = high >>> 8;
      l = (low >>> 8) | ((high & 0xFF) << 24);
      high = table[i] ^ h;
      low = table[i + 1] ^ l;
    }
  }

  @override
  Uint8List $finalize() {
    high ^= seedHigh;
    low ^= seedLow;
    return Uint8List.fromList([
      high >>> 24,
      high >>> 16,
      high >>> 8,
      high,
      low >>> 24,
      low >>> 16,
      low >>> 8,
      low,
    ]);
  }
}

const int _bitToggle = 0x80000000;

/// Generates the 256-byte table for CRC
Uint32List _generate64(int high, int low) {
  return _tables.putIfAbsent('$high.$low', () {
    int i, j, h, l, f;
    var table = Uint32List(512);
    for (i = 0; i < 512; i += 2) {
      h = 0;
      l = i >>> 1;
      for (j = 0; j < 8; ++j) {
        f = l & 1;
        l >>>= 1;
        if (h & 1 == 1) l ^= _bitToggle;
        h >>>= 1;
        if (f == 0) continue;
        h ^= high;
        l ^= low;
      }
      table[i] = h;
      table[i + 1] = l;
    }
    return table;
  });
}
