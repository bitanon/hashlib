// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/src/core/hash_base.dart';

const int _pow32 = 2 ^ 32;
const int _mask32 = 0xFFFFFFFF;

/// Predefined polynomials for CRC-64.
///
/// The predefined polynomials comes from various sources:
/// - https://pkg.go.dev/hash/crc64
/// - https://crcmod.sourceforge.net/crcmod.predefined.html
/// - https://en.wikipedia.org/wiki/Cyclic_redundancy_check
/// - https://github.com/emn178/js-crc/blob/master/src/models.js
class CRC64Params {
  /// Defined in ISO 3309 (HDLC), Swiss-Prot/TrEMBL.
  static const iso = CRC64Params._("ISO-HDLC", 0x00000000, 0x0000001B, true,
      0x00000000, 0x00000000, 0x00000000, 0x00000000); // 46a5a9388a5beffe

  /// Defined in ECMA-182 p. 51, XZ Utils.
  static const ecma = CRC64Params._("ECMA-182", 0x42F0E1EB, 0xA9EA3693, false,
      0x00000000, 0x00000000, 0x00000000, 0x00000000); // b90956c775a41001

  static const goIso = CRC64Params._("GO-ISO", 0x00000000, 0x0000001B, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF); // 46a5a9388a5beffe
  static const goEcma = CRC64Params._("GO-ECMA", 0x42F0E1EB, 0xA9EA3693, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF); // 995dc9bbdf1939fa
  static const ms = CRC64Params._("MS", 0x259C84CB, 0xA6426349, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000); // 75d4b74f024eceea
  static const nvme = CRC64Params._("NVME", 0xAD93D235, 0x94C93659, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF); // ae8b14860a799888
  static const redis = CRC64Params._("Redis", 0xAD93D235, 0x94C935A9, true,
      0x00000000, 0x00000000, 0x00000000, 0x00000000); // e9c6d914c4b8d9ca
  static const we = CRC64Params._("WE", 0x42F0E1EB, 0xA9EA3693, false,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF); // 62ec59e3f1a4f00a
  static const xz = CRC64Params._("XZ", 0x42F0E1EB, 0xA9EA3693, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF); // 995dc9bbdf1939fa
  static const jones = CRC64Params._("Jones", 0xAD93D235, 0x94C935A9, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000); // caa717168609f281

  //--------------------------------------------------------------------------
  // Implementation
  //--------------------------------------------------------------------------

  /// Polynomial name
  final String name;

  /// Most significant 32-bytes of polynomial (first 32)
  final int high;

  /// Least significant 32-bytes of polynomial (last 32)
  final int low;

  /// Initial CRC (most significant 32-bytes)
  final int seedHigh;

  /// Initial CRC (least significant 32-bytes)
  final int seedLow;

  /// Output XOR value (least significant 32-bytes)
  final int xorOutHigh;

  /// Output XOR value (most significant 32-bytes)
  final int xorOutLow;

  /// To use the reverse of the polynomial
  final bool reversed;

  const CRC64Params._(
    this.name,
    this.high,
    this.low,
    this.reversed,
    this.seedHigh,
    this.seedLow, [
    this.xorOutHigh = 0,
    this.xorOutLow = 0,
  ]);

  /// Create a custom polynomial for CRC-64
  ///
  /// Parameters:
  /// - [seed]: initial counter to start from
  /// - [xorOut]: the value to xor with the final output
  /// - [reversed]: to use reverse / reflected polynomial and input
  CRC64Params(
    int poly, {
    this.reversed = false,
    int seed = 0,
    int xorOut = 0,
  })  : high = poly ~/ _pow32,
        low = poly % _pow32,
        seedHigh = seed ~/ _pow32,
        seedLow = seed % _pow32,
        xorOutHigh = xorOut ~/ _pow32,
        xorOutLow = xorOut % _pow32,
        name = poly.toRadixString(16);

  /// Create a custom polynomial from hexadecimal
  ///
  /// Parameters:
  /// - [poly]: the polynomial in hexadecimal (MSB first)
  factory CRC64Params.hex(
    String poly, {
    bool reversed = false,
    String seed = "0000000000000000",
    String xorOut = "0000000000000000",
  }) {
    Uint8List p = fromHex(poly);
    Uint8List s = fromHex(seed);
    Uint8List x = fromHex(xorOut);
    int high = (p[0] << 24) ^ (p[1] << 16) ^ (p[2] << 8) ^ (p[3]);
    int low = (p[4] << 24) ^ (p[5] << 16) ^ (p[6] << 8) ^ (p[7]);
    int seedHigh = (s[0] << 24) ^ (s[1] << 16) ^ (s[2] << 8) ^ (s[3]);
    int seedLow = (s[4] << 24) ^ (s[5] << 16) ^ (s[6] << 8) ^ (s[7]);
    int xorOutHigh = (x[0] << 24) ^ (x[1] << 16) ^ (x[2] << 8) ^ (x[3]);
    int xorOutLow = (x[4] << 24) ^ (x[5] << 16) ^ (x[6] << 8) ^ (x[7]);
    return CRC64Params._(
      poly,
      high,
      low,
      reversed,
      seedHigh,
      seedLow,
      xorOutHigh,
      xorOutLow,
    );
  }
}

/// A CRC-64 code generator with a polynomial.
abstract class CRC64Hash extends HashDigestSink {
  final int polyHigh;
  final int polyLow;
  final int seedHigh;
  final int seedLow;
  final int xorOutHigh;
  final int xorOutLow;
  final table = Uint32List(512);

  int _high, _low;

  /// Creates a sink for generating CRC-64 Hash
  CRC64Hash(CRC64Params params)
      : polyHigh = params.high,
        polyLow = params.low,
        seedHigh = params.seedHigh,
        seedLow = params.seedLow,
        xorOutHigh = params.xorOutHigh,
        xorOutLow = params.xorOutLow,
        _high = params.seedHigh,
        _low = params.seedLow {
    $generate();
  }

  @override
  final int hashLength = 8;

  @override
  void reset() {
    super.reset();
    _high = seedHigh;
    _low = seedLow;
  }

  /// Generates the lookup table for CRC-64
  void $generate();

  @override
  Uint8List $finalize() {
    _high ^= xorOutHigh;
    _low ^= xorOutLow;
    return Uint8List.fromList([
      _high >>> 24,
      _high >>> 16,
      _high >>> 8,
      _high,
      _low >>> 24,
      _low >>> 16,
      _low >>> 8,
      _low,
    ]);
  }
}

/// A CRC-64 code generator with a normal polynomial.
class CRC64NormalHash extends CRC64Hash {
  /// Creates a sink for generating CRC-64 Hash
  CRC64NormalHash(super.params);

  @override
  void $generate() {
    int i, j, h, l, f, ph, pl;
    ph = polyHigh & _mask32;
    pl = polyLow & _mask32;
    for (i = 0; i < 512; i += 2) {
      h = i << 23; // (i / 2) << 24
      l = 0;
      for (j = 0; j < 8; ++j) {
        f = (h >>> 31) & 1;
        h = (f * ph) ^ (h << 1) ^ ((l >>> 31) & 1);
        l = (f * pl) ^ (l << 1);
      }
      table[i] = h;
      table[i + 1] = l;
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (int i; start < end; start++) {
      i = (((_high >>> 24) ^ chunk[start]) & 0xFF) << 1;
      _high = table[i] ^ (_high << 8) ^ ((_low >>> 24) & 0xFF);
      _low = table[i + 1] ^ (_low << 8);
    }
  }
}

/// A CRC-64 code generator with reversed or reflected polynomial.
class CRC64ReverseHash extends CRC64Hash {
  /// Creates a sink for generating CRC-64 Hash
  CRC64ReverseHash(super.params);

  @override
  void $generate() {
    int i, j, h, l, f, ph, pl;

    // reverse polynomial
    ph = 0;
    pl = 0;
    for (i = 0; i < 32; ++i) {
      pl ^= ((polyHigh >>> i) & 1) << (31 - i);
      ph ^= ((polyLow >>> i) & 1) << (31 - i);
    }

    // generate table
    for (i = 0; i < 512; i += 2) {
      h = 0;
      l = i >>> 1;
      for (j = 0; j < 8; ++j) {
        f = l & 1;
        l = (f * pl) ^ ((h & 1) << 31) ^ ((l & _mask32) >>> 1);
        h = (f * ph) ^ ((h & _mask32) >>> 1);
      }
      table[i] = h;
      table[i + 1] = l;
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (int i; start < end; start++) {
      i = ((_low ^ chunk[start]) & 0xFF) << 1;
      _low = table[i + 1] ^ ((_high & 0xFF) << 24) ^ ((_low & _mask32) >>> 8);
      _high = table[i] ^ ((_high & _mask32) >>> 8);
    }
  }
}
