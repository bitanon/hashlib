// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';

const int _mask16 = 0xFFFF;

/// Predefined polynomials for CRC-16.
///
/// The predefined polynomials comes from various sources:
/// - https://crccalc.com/
/// - https://docs.rs/crate/crc16
/// - https://crcmod.sourceforge.net/crcmod.predefined.html
/// - https://en.wikipedia.org/wiki/Cyclic_redundancy_check
class CRC16Params {
  // 0x8005 group

  /// `CRC-16/ARC` with polynomial `0x8005` (reflected). Check value: `0xBB3D`.
  static const arc = CRC16Params._('ARC', 0x8005, 0x0000, true, 0x0000);

  /// `CRC-16/CMS` with polynomial `0x8005`. Check value: `0xAEE7`.
  static const cms = CRC16Params._('CMS', 0x8005, 0xFFFF, false, 0x0000);

  /// `CRC-16/DDS-110` with polynomial `0x8005`. Check value: `0x9ECF`.
  static const dds110 = CRC16Params._('DDS-110', 0x8005, 0x800D, false, 0x0000);

  /// `CRC-16/MAXIM-DOW` with polynomial `0x8005` (reflected). Check value: `0x44C2`.
  static const maximDow =
      CRC16Params._('MAXIM-DOW', 0x8005, 0x0000, true, 0xFFFF);

  /// `CRC-16/MODBUS` with polynomial `0x8005` (reflected). Check value: `0x4B37`.
  static const modbus = CRC16Params._('MODBUS', 0x8005, 0xFFFF, true, 0x0000);

  /// `CRC-16/UMTS` with polynomial `0x8005`. Check value: `0xFEE8`.
  static const umts = CRC16Params._('UMTS', 0x8005, 0x0000, false, 0x0000);

  /// `CRC-16/USB` with polynomial `0x8005` (reflected). Check value: `0xB4C8`.
  static const usb = CRC16Params._('USB', 0x8005, 0xFFFF, true, 0xFFFF);

  // 0x1021 group

  /// `CRC-16/GENIBUS` with polynomial `0x1021`. Check value: `0xD64E`.
  static const genibus =
      CRC16Params._('GENIBUS', 0x1021, 0xFFFF, false, 0xFFFF);

  /// `CRC-16/GSM` with polynomial `0x1021`. Check value: `0xCE3C`.
  static const gsm = CRC16Params._('GSM', 0x1021, 0x0000, false, 0xFFFF);

  /// `CRC-16/IBM-3740` with polynomial `0x1021`. Check value: `0x29B1`.
  static const ibm3740 =
      CRC16Params._('IBM-3740', 0x1021, 0xFFFF, false, 0x0000);

  /// `CRC-16/CCITT-FALSE` with polynomial `0x1021`. Check value: `0x29B1`.
  static const ccittFalse =
      CRC16Params._('CCITT-FALSE', 0x1021, 0xFFFF, false, 0x0000);

  /// `CRC-16/IBM-SDLC` with polynomial `0x1021` (reflected). Check value: `0x906E`.
  static const ibmSdlc =
      CRC16Params._('IBM-SDLC', 0x1021, 0xFFFF, true, 0xFFFF);

  /// `CRC-16/X-25` with polynomial `0x1021` (reflected). Check value: `0x906E`.
  static const x25 = CRC16Params._('X-25', 0x1021, 0xFFFF, true, 0xFFFF);

  /// `CRC-16/ISO-IEC-14443-3-A` with polynomial `0x1021` (reflected). Check value: `0xBF05`.
  static const iso = CRC16Params._('ISO-IEC-14443-3-A', 0x1021, 0x6363, true);

  /// `CRC-16/KERMIT` with polynomial `0x1021` (reflected). Check value: `0x2189`.
  static const kermit = CRC16Params._('KERMIT', 0x1021, 0x0000, true, 0x0000);

  /// `CRC-16/MCRF4XX` with polynomial `0x1021` (reflected). Check value: `0x6F91`.
  static const mcrf4xx = CRC16Params._('MCRF4XX', 0x1021, 0xFFFF, true, 0x0000);

  /// `CRC-16/RIELLO` with polynomial `0x1021` (reflected). Check value: `0x63D0`.
  static const riello = CRC16Params._('RIELLO', 0x1021, 0x554D, true, 0x0000);

  /// `CRC-16/AUG-CCITT` with polynomial `0x1021`. Check value: `0xE5CC`.
  static const augCcitt =
      CRC16Params._('AUG-CCITT', 0x1021, 0x1D0F, false, 0x0000);

  /// `CRC-16/SPI-FUJITSU` with polynomial `0x1021`. Check value: `0xE5CC`.
  static const spiFujitsu =
      CRC16Params._('SPI-FUJITSU', 0x1021, 0x1D0F, false, 0x0000);

  /// `CRC-16/TMS37157` with polynomial `0x1021` (reflected). Check value: `0x26B1`.
  static const tms37157 =
      CRC16Params._('TMS37157', 0x1021, 0x3791, true, 0x0000);

  /// `CRC-16/XMODEM` with polynomial `0x1021`. Check value: `0x31C3`.
  static const xmodem = CRC16Params._('XMODEM', 0x1021, 0x0000, false, 0x0000);

  // Others

  /// `CRC-16/CDMA2000` with polynomial `0xC867`. Check value: `0x4C06`.
  static const cdma2000 =
      CRC16Params._('CDMA2000', 0xC867, 0xFFFF, false, 0x0000);

  /// `CRC-16/DECT-R` with polynomial `0x0589`. Check value: `0x007E`.
  static const dectR = CRC16Params._('DECT-R', 0x0589, 0x0000, false, 0x0001);

  /// `CRC-16/DECT-X` with polynomial `0x0589`. Check value: `0x007F`.
  static const dectX = CRC16Params._('DECT-X', 0x0589, 0x0000, false, 0x0000);

  /// `CRC-16/DNP` with polynomial `0x3D65` (reflected). Check value: `0xEA82`.
  static const dnp = CRC16Params._('DNP', 0x3D65, 0x0000, true, 0xFFFF);

  /// `CRC-16/EN-13757` with polynomial `0x3D65`. Check value: `0xC2B7`.
  static const en13757 =
      CRC16Params._('EN-13757', 0x3D65, 0x0000, false, 0xFFFF);

  /// `CRC-16/LJ1200` with polynomial `0x6F63`. Check value: `0xBDF4`.
  static const lj1200 = CRC16Params._('LJ1200', 0x6F63, 0x0000, false, 0x0000);

  /// `CRC-16/NRSC-5` with polynomial `0x080B` (reflected). Check value: `0xA066`.
  static const nrsc5 = CRC16Params._('NRSC-5', 0x080B, 0xFFFF, true, 0x0000);

  /// `CRC-16/M17` with polynomial `0x5935`. Check value: `0x772B`.
  static const m17 = CRC16Params._('M17', 0x5935, 0xFFFF, false, 0x0000);

  /// `CRC-16/OPENSAFETY-A` with polynomial `0x5935`. Check value: `0x5D38`.
  static const opensafetyA =
      CRC16Params._('OPENSAFETY-A', 0x5935, 0x0000, false, 0x0000);

  /// `CRC-16/OPENSAFETY-B` with polynomial `0x755B`. Check value: `0x20FE`.
  static const opensafetyB =
      CRC16Params._('OPENSAFETY-B', 0x755B, 0x0000, false, 0x0000);

  /// `CRC-16/PROFIBUS` with polynomial `0x1DCF`. Check value: `0xA819`.
  static const profibus =
      CRC16Params._('PROFIBUS', 0x1DCF, 0xFFFF, false, 0xFFFF);

  /// `CRC-16/T10-DIF` with polynomial `0x8BB7`. Check value: `0xD0DB`.
  static const t10Dif = CRC16Params._('T10-DIF', 0x8BB7, 0x0000, false, 0x0000);

  /// `CRC-16/TELEDISK` with polynomial `0xA097`. Check value: `0x0FB3`.
  static const teledisk =
      CRC16Params._('TELEDISK', 0xA097, 0x0000, false, 0x0000);

  // From Wikipedia

  /// `CRC-16/ARINC` with polynomial `0xA02B`. Check value: `0xEBA4`.
  static const arinc = CRC16Params._("ARINC", 0xA02B, 0x0000, false, 0x0000);

  // aliases

  /// Alias for [arc] (also known as `CRC-16/IBM`).
  static const ibm = arc;

  /// Alias for [arc] (also known as `CRC-16/ANSI`).
  static const ansi = arc;

  /// Alias for [arc] (also known as `CRC-16/LHA`).
  static const lha = arc;

  /// Alias for [arc] (also known as `CRC-16/ARINC-453`).
  static const arinc453 = arc;

  /// Alias for [kermit] (also known as `CRC-16/CCITT`).
  static const ccitt = kermit;

  /// Alias for [kermit] (also known as `CRC-16/BLUETOOTH`).
  static const bluetooth = kermit;

  /// Alias for [umts] (also known as `CRC-16/BUYPASS`).
  static const buypass = umts;

  /// Alias for [genibus] (also known as `CRC-16/AUTOSAR`).
  static const autosar = genibus;

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

  const CRC16Params._(
    this.name,
    this.poly,
    this.seed,
    this.reversed, [
    this.xorOut = 0,
  ]);

  /// Create a custom polynomial for CRC-16
  ///
  /// Parameters:
  /// - [seed]: initial counter to start from
  /// - [xorOut]: the value to xor with the final output
  /// - [reversed]: to use reversed or reflected polynomial and input
  CRC16Params(
    this.poly, {
    this.seed = 0,
    this.xorOut = 0,
    this.reversed = false,
  }) : name = poly.toRadixString(16);
}

/// A CRC-16 code generator with a polynomial.
abstract class CRC16Hash extends HashDigestSink {
  /// The initial value of the CRC register.
  final int seed;

  /// The value to XOR with the CRC register before output.
  final int xorOut;

  /// The generator polynomial.
  final int polynomial;

  /// The precomputed 256-entry lookup table for byte-wise processing.
  final table = Uint16List(256);

  int _crc;

  /// Creates a sink for generating CRC-16 Hash
  CRC16Hash(CRC16Params params)
      : seed = params.seed,
        xorOut = params.xorOut,
        polynomial = params.poly,
        _crc = params.seed {
    $generate();
  }

  @override
  final int hashLength = 2;

  @override
  void reset() {
    _crc = seed;
    super.reset();
  }

  /// Generates the lookup table for CRC-16
  void $generate();

  @override
  Uint8List $finalize() {
    _crc ^= xorOut;
    return Uint8List.fromList([
      _crc >>> 8,
      _crc,
    ]);
  }
}

/// A CRC-16 code generator with a polynomial.
class CRC16NormalHash extends CRC16Hash {
  /// Creates a sink for generating CRC-16 Hash
  CRC16NormalHash(super.params);

  @override
  void $generate() {
    int i, j, r, p;
    p = polynomial & _mask16;
    for (i = 0; i < 256; ++i) {
      r = i << 8;
      for (j = 0; j < 8; ++j) {
        r = (((r >>> 15) & 1) * p) ^ (r << 1);
      }
      table[i] = r;
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (int index; start < end; start++) {
      index = ((_crc >>> 8) ^ chunk[start]) & 0xFF;
      _crc = table[index] ^ (_crc << 8);
    }
  }
}

/// A CRC-16 code generator with a reversed or reflected polynomial.
class CRC16ReverseHash extends CRC16Hash {
  /// Creates a sink for generating CRC-16 Hash
  CRC16ReverseHash(super.params);

  @override
  void $generate() {
    int i, j, r, p;

    // reverse polynomial
    p = 0;
    for (i = 0; i < 16; ++i) {
      p ^= ((polynomial >>> i) & 1) << (15 - i);
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
