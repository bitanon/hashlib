// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';

const int _mask32 = 0xFFFFFFFF;

/// Predefined polynomials for CRC-32.
///
/// The predefined polynomials comes from various sources:
/// - https://crccalc.com/
/// - https://pkg.go.dev/hash/crc32
/// - https://crcmod.sourceforge.net/crcmod.predefined.html
/// - https://en.wikipedia.org/wiki/Cyclic_redundancy_check
class CRC32Params {
  /// IEEE is by far and away the most common CRC-32 polynomial.
  /// Used by ethernet (IEEE 802.3), v.42, fddi, gzip, zip, png, etc.
  ///
  /// Polynomial `0x04C11DB7` (reflected). Check value: `0xCBF43926`.
  static const ieee =
      CRC32Params._('IEEE', 0x04C11DB7, 0xFFFFFFFF, true, 0xFFFFFFFF);

  /// Castagnoli's polynomial, used in iSCSI.
  /// Has better error detection characteristics than IEEE.
  /// https://dx.doi.org/10.1109/26.231911
  ///
  /// Polynomial `0x1EDC6F41` (reflected). Check value: `0xE3069283`.
  static const castagnoli =
      CRC32Params._('Castagnoli', 0x1EDC6F41, 0xFFFFFFFF, true, 0xFFFFFFFF);

  /// Koopman's polynomial.
  /// Also has better error detection characteristics than IEEE.
  /// https://dx.doi.org/10.1109/DSN.2002.1028931
  ///
  /// Polynomial `0x741B8CD7` (reflected). Check value: `0xD2C22F51`.
  static const koopman =
      CRC32Params._('Koopman', 0x741B8CD7, 0xFFFFFFFF, true, 0x00000000);

  // 0x04C11DB7 group

  /// `CRC-32/BZIP2` with polynomial `0x04C11DB7`. Check value: `0xFC891918`.
  static const bzip2 =
      CRC32Params._('BZIP2', 0x04C11DB7, 0xFFFFFFFF, false, 0xFFFFFFFF);

  /// `CRC-32/CKSUM` (POSIX) with polynomial `0x04C11DB7`. Check value: `0x765E7680`.
  static const cksum =
      CRC32Params._('CKSUM', 0x04C11DB7, 0x00000000, false, 0xFFFFFFFF);

  /// `CRC-32/JAMCRC` with polynomial `0x04C11DB7` (reflected). Check value: `0x340BC6D9`.
  static const jamcrc =
      CRC32Params._('JAMCRC', 0x04C11DB7, 0xFFFFFFFF, true, 0x00000000);

  /// `CRC-32/MPEG-2` with polynomial `0x04C11DB7`. Check value: `0x0376E6E7`.
  static const mpeg2 =
      CRC32Params._('MPEG-2', 0x04C11DB7, 0xFFFFFFFF, false, 0x00000000);

  // Others

  /// `CRC-32/AIXM` with polynomial `0x814141AB`. Check value: `0x3010BF7F`.
  static const aixm =
      CRC32Params._('AIXM', 0x814141AB, 0x00000000, false, 0x00000000);

  /// `CRC-32/AUTOSAR` with polynomial `0xF4ACFB13` (reflected). Check value: `0x1697D06A`.
  static const autosar =
      CRC32Params._('AUTOSAR', 0xF4ACFB13, 0xFFFFFFFF, true, 0xFFFFFFFF);

  /// `CRC-32/BASE91-D` with polynomial `0xA833982B` (reflected). Check value: `0x87315576`.
  static const base91D =
      CRC32Params._('BASE91-D', 0xA833982B, 0xFFFFFFFF, true, 0xFFFFFFFF);

  /// `CRC-32/CD-ROM-EDC` with polynomial `0x8001801B` (reflected). Check value: `0x6EC2EDC4`.
  static const cdRomEdc =
      CRC32Params._('CD-ROM-EDC', 0x8001801B, 0x00000000, true, 0x00000000);

  /// `CRC-32/XFER` with polynomial `0x000000AF`. Check value: `0xBD0BE338`.
  static const xfer =
      CRC32Params._('XFER', 0x000000AF, 0x00000000, false, 0x00000000);

  // aliases

  /// Alias for [ieee] (also known as `CRC-32/ISO`).
  static const iso = ieee;

  /// Alias for [ieee] (also known as `CRC-32/ISO-HDLC`).
  static const isoHdlc = ieee;

  /// Alias for [ieee] (also known as `CRC-32/ADCCP`).
  static const adccp = ieee;

  /// Alias for [ieee] (also known as `CRC-32/V-42`).
  static const v42 = ieee;

  /// Alias for [ieee] (also known as `CRC-32/XZ`).
  static const xz = ieee;

  /// Alias for [ieee] (also known as `CRC-32/PKZIP`).
  static const pkzip = ieee;

  /// Alias for [castagnoli] (also known as `CRC-32/ISCSI`).
  static const iscsi = castagnoli;

  /// Alias for [castagnoli] (also known as `CRC-32/INTERLAKEN`).
  static const interlaken = castagnoli;

  /// Alias for [castagnoli] (also known as `CRC-32/NVME`).
  static const nvme = castagnoli;

  /// Alias for [castagnoli] (also known as `CRC-32/BASE91-C`).
  static const base91C = castagnoli;

  /// Alias for [koopman] (also known as `CRC-32/MEF`).
  static const mef = koopman;

  /// Alias for [bzip2] (also known as `CRC-32/AAL5`).
  static const aal5 = bzip2;

  /// Alias for [bzip2] (also known as `CRC-32/DECT-B`).
  static const dectB = bzip2;

  /// Alias for [cksum] (also known as `CRC-32/POSIX`).
  static const posix = cksum;

  //--------------------------------------------------------------------------
  // Implementation
  //--------------------------------------------------------------------------

  /// Polynomial name
  final String name;

  /// Polynomial value
  final int poly;

  /// Initial CRC
  final int seed;

  /// Output XOR value
  final int xorOut;

  /// To use the reverse of the polynomial
  final bool reversed;

  const CRC32Params._(
    this.name,
    this.poly,
    this.seed,
    this.reversed, [
    this.xorOut = 0,
  ]);

  /// Create a custom polynomial for CRC-32
  ///
  /// Parameters:
  /// - [seed]: initial counter to start from
  /// - [xorOut]: the value to xor with the final output
  /// - [reversed]: to use reversed or reflected polynomial and input
  CRC32Params(
    this.poly, {
    this.seed = 0,
    this.xorOut = 0,
    this.reversed = false,
  }) : name = poly.toRadixString(16);
}

/// A CRC-32 code generator with a polynomial.
abstract class CRC32Hash extends HashDigestSink {
  /// The initial value of the CRC register.
  final int seed;

  /// The value to XOR with the CRC register before output.
  final int xorOut;

  /// The generator polynomial.
  final int polynomial;

  /// The precomputed 256-entry lookup table for byte-wise processing.
  final table = Uint32List(256);

  int _crc;

  /// Creates a sink for generating CRC-32 Hash
  CRC32Hash(CRC32Params params)
      : seed = params.seed,
        xorOut = params.xorOut,
        polynomial = params.poly,
        _crc = params.seed {
    $generate();
  }

  @override
  final int hashLength = 4;

  @override
  void reset() {
    _crc = seed;
    super.reset();
  }

  /// Generates the lookup table for CRC-32
  void $generate();

  @override
  Uint8List $finalize() {
    _crc ^= xorOut;
    return Uint8List.fromList([
      _crc >>> 24,
      _crc >>> 16,
      _crc >>> 8,
      _crc,
    ]);
  }
}

/// A CRC-32 code generator with a polynomial.
class CRC32NormalHash extends CRC32Hash {
  /// Creates a sink for generating CRC-32 Hash
  CRC32NormalHash(super.params);

  @override
  void $generate() {
    int i, j, r, p;
    p = polynomial & _mask32;
    for (i = 0; i < 256; ++i) {
      r = i << 24;
      for (j = 0; j < 8; ++j) {
        r = (((r >>> 31) & 1) * p) ^ (r << 1);
      }
      table[i] = r;
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (int index; start < end; start++) {
      index = ((_crc >>> 24) ^ chunk[start]) & 0xFF;
      _crc = table[index] ^ (_crc << 8);
    }
  }
}

/// A CRC-32 code generator with a reversed or reflected polynomial.
class CRC32ReverseHash extends CRC32Hash {
  /// Creates a sink for generating CRC-32 Hash
  CRC32ReverseHash(super.params);

  @override
  void $generate() {
    int i, j, r, p;

    // reverse polynomial
    p = 0;
    for (i = 0; i < 32; ++i) {
      p ^= ((polynomial >>> i) & 1) << (31 - i);
    }

    // generate table
    for (i = 0; i < 256; ++i) {
      r = i;
      for (j = 0; j < 8; ++j) {
        r = ((r & 1) * p) ^ (r >>> 1);
      }
      table[i] = r;
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (int index; start < end; start++) {
      index = (_crc ^ chunk[start]) & 0xFF;
      _crc = table[index] ^ (_crc >>> 8);
    }
  }
}
