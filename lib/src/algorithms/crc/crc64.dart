// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/src/core/hash_base.dart';

const int _pow32 = 0x100000000;
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
  ///
  /// Polynomial `0x000000000000001B` (reflected). Check value: `0x46A5A9388A5BEFFE`.
  static const iso = CRC64Params._("ISO-HDLC", 0x00000000, 0x0000001B, true,
      0x00000000, 0x00000000, 0x00000000, 0x00000000);

  /// Defined in ECMA-182 p. 51, XZ Utils.
  ///
  /// Polynomial `0x42F0E1EBA9EA3693`. Check value: `0x6C40DF5F0B497347`.
  static const ecma = CRC64Params._("ECMA-182", 0x42F0E1EB, 0xA9EA3693, false,
      0x00000000, 0x00000000, 0x00000000, 0x00000000);

  /// `CRC-64/GO-ISO` with polynomial `0x000000000000001B` (reflected).
  /// Check value: `0xB90956C775A41001`.
  static const goIso = CRC64Params._("GO-ISO", 0x00000000, 0x0000001B, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);

  /// `CRC-64/GO-ECMA` with polynomial `0x42F0E1EBA9EA3693` (reflected).
  /// Check value: `0x995DC9BBDF1939FA`.
  static const goEcma = CRC64Params._("GO-ECMA", 0x42F0E1EB, 0xA9EA3693, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);

  /// `CRC-64/MS` with polynomial `0x259C84CBA6426349` (reflected).
  /// Check value: `0x75D4B74F024ECEEA`.
  static const ms = CRC64Params._("MS", 0x259C84CB, 0xA6426349, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000);

  /// `CRC-64/NVME` with polynomial `0xAD93D23594C93659` (reflected).
  /// Check value: `0xAE8B14860A799888`.
  static const nvme = CRC64Params._("NVME", 0xAD93D235, 0x94C93659, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);

  /// `CRC-64/Redis` with polynomial `0xAD93D23594C935A9` (reflected).
  /// Check value: `0xE9C6D914C4B8D9CA`.
  static const redis = CRC64Params._("Redis", 0xAD93D235, 0x94C935A9, true,
      0x00000000, 0x00000000, 0x00000000, 0x00000000);

  /// `CRC-64/WE` with polynomial `0x42F0E1EBA9EA3693`.
  /// Check value: `0x62EC59E3F1A4F00A`.
  static const we = CRC64Params._("WE", 0x42F0E1EB, 0xA9EA3693, false,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);

  /// `CRC-64/XZ` with polynomial `0x42F0E1EBA9EA3693` (reflected).
  /// Check value: `0x995DC9BBDF1939FA`.
  static const xz = CRC64Params._("XZ", 0x42F0E1EB, 0xA9EA3693, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF, 0xFFFFFFFF);

  /// `CRC-64/Jones` with polynomial `0xAD93D23594C935A9` (reflected).
  /// Check value: `0xCAA717168609F281`.
  static const jones = CRC64Params._("Jones", 0xAD93D235, 0x94C935A9, true,
      0xFFFFFFFF, 0xFFFFFFFF, 0x00000000, 0x00000000);

  //--------------------------------------------------------------------------
  // Implementation
  //--------------------------------------------------------------------------

  /// Polynomial name
  final String name;

  /// Most significant 32 bits of polynomial (first 32)
  final int high;

  /// Least significant 32 bits of polynomial (last 32)
  final int low;

  /// Initial CRC (most significant 32 bits)
  final int seedHigh;

  /// Initial CRC (least significant 32 bits)
  final int seedLow;

  /// Output XOR value (most significant 32 bits)
  final int xorOutHigh;

  /// Output XOR value (least significant 32 bits)
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
  /// - [reversed]: to use reversed or reflected polynomial and input
  ///
  /// **Note**: On the web platform, integers are limited to 53 bits. Use
  /// [CRC64Params.hex] to pass full 64-bit values there.
  CRC64Params(
    int poly, {
    this.reversed = false,
    int seed = 0,
    int xorOut = 0,
  })  : high = _upper32(poly),
        low = _lower32(poly),
        seedHigh = _upper32(seed),
        seedLow = _lower32(seed),
        xorOutHigh = _upper32(xorOut),
        xorOutLow = _lower32(xorOut),
        name = poly.toRadixString(16);

  /// The least significant 32 bits of [value]
  static int _lower32(int value) => value.toUnsigned(32);

  /// The most significant 32 bits of a 64-bit [value].
  ///
  /// Avoids shift operators, which are truncated to 32 bits on the web, and
  /// plain division, which rounds towards zero for negative values.
  static int _upper32(int value) =>
      ((value - value.toUnsigned(32)) ~/ _pow32).toUnsigned(32);

  /// Create a custom polynomial from hexadecimal
  ///
  /// Parameters:
  /// - [poly]: the polynomial in hexadecimal (MSB first)
  /// - [seed]: initial counter to start from (MSB first)
  /// - [xorOut]: the value to xor with the final output (MSB first)
  /// - [reversed]: to use reversed or reflected polynomial and input
  factory CRC64Params.hex({
    required String poly,
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
  /// The most significant 32 bits of the generator polynomial.
  final int polyHigh;

  /// The least significant 32 bits of the generator polynomial.
  final int polyLow;

  /// The most significant 32 bits of the initial CRC register value.
  final int seedHigh;

  /// The least significant 32 bits of the initial CRC register value.
  final int seedLow;

  /// The most significant 32 bits of the output XOR value.
  final int xorOutHigh;

  /// The least significant 32 bits of the output XOR value.
  final int xorOutLow;

  /// The precomputed lookup table for byte-wise processing (two 32-bit words
  /// per entry).
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
