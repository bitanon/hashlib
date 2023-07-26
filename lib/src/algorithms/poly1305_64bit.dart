// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

const int _mask32 = 0xFFFFFFFF;
const int _mask26 = 0x03FFFFFF;

/// This implementation is derived from the [The Poly1305 Algorithms] described
/// in the [ChaCha20 and Poly1305 for IETF Protocols][rfc] document.
///
/// The Reference implementation used for optimization:
/// https://github.com/floodyberry/poly1305-opt
///
/// [rfc]: https://www.ietf.org/rfc/rfc8439.html
class Poly1305Sink extends BlockHashSink implements MACSinkBase {
  // secret key: r
  late int _r0;
  late int _r1;
  late int _r2;
  late int _r3;
  late int _r4;
  // authentication key: s
  late int _s0;
  late int _s1;
  late int _s2;
  late int _s3;
  // g = 5 * r
  late int _g1;
  late int _g2;
  late int _g3;
  late int _g4;
  // accumulator: a
  int _h0 = 0;
  int _h1 = 0;
  int _h2 = 0;
  int _h3 = 0;
  int _h4 = 0;

  @override
  final int hashLength = 16;

  /// Initialize the Poly1305 with the secret and the authentication
  ///
  /// Parameters:
  /// - [key] : The key-pair (`r`, `s`) - can either be 16-bytes or 32-bytes.
  ///   The first 16-bytes is `r` and last 16-bytes is `s`. If [key] is only
  ///   16-bytes long, the `s` is assumed to be 0.
  Poly1305Sink(Uint8List key) : super(16, bufferLength: 17) {
    if (key.lengthInBytes != 16 && key.lengthInBytes != 32) {
      throw StateError('The key length must be either 16 or 32 bytes');
    }

    // r = key[15..0]
    _r0 = ((key[0] & 0xFF)) |
        ((key[1] & 0xFF) << 8) |
        ((key[2] & 0xFF) << 16) |
        ((key[3] & 0xFF) << 24);
    _r1 = ((key[3] & 0xFF) >>> 2) |
        ((key[4] & 0xFF) << 6) |
        ((key[5] & 0xFF) << 14) |
        ((key[6] & 0xFF) << 22);
    _r2 = ((key[6] & 0xFF) >>> 4) |
        ((key[7] & 0xFF) << 4) |
        ((key[8] & 0xFF) << 12) |
        ((key[9] & 0xFF) << 20);
    _r3 = ((key[9] & 0xFF) >>> 6) |
        ((key[10] & 0xFF) << 2) |
        ((key[11] & 0xFF) << 10) |
        ((key[12] & 0xFF) << 18);
    _r4 = (key[13] & 0xFF) | //
        ((key[14] & 0xFF) << 8) |
        ((key[15] & 0xFF) << 16);

    // clamp(r): r &= 0x0ffffffc0ffffffc0ffffffc0fffffff
    _r0 &= 0x03ffffff;
    _r1 &= 0x03ffff03;
    _r2 &= 0x03ffc0ff;
    _r3 &= 0x03f03fff;
    _r4 &= 0x000fffff;

    _g1 = 5 * _r1;
    _g2 = 5 * _r2;
    _g3 = 5 * _r3;
    _g4 = 5 * _r4;

    if (key.length == 32) {
      // s = secret[15..0]
      _s0 = ((key[16] & 0xFF)) |
          ((key[17] & 0xFF) << 8) |
          ((key[18] & 0xFF) << 16) |
          ((key[19] & 0xFF) << 24);
      _s1 = ((key[20] & 0xFF)) |
          ((key[21] & 0xFF) << 8) |
          ((key[22] & 0xFF) << 16) |
          ((key[23] & 0xFF) << 24);
      _s2 = ((key[24] & 0xFF)) |
          ((key[25] & 0xFF) << 8) |
          ((key[26] & 0xFF) << 16) |
          ((key[27] & 0xFF) << 24);
      _s3 = ((key[28] & 0xFF)) |
          ((key[29] & 0xFF) << 8) |
          ((key[30] & 0xFF) << 16) |
          ((key[31] & 0xFF) << 24);
    } else {
      _s0 = 0;
      _s1 = 0;
      _s2 = 0;
      _s3 = 0;
    }
  }

  @override
  void reset() {
    super.reset();
    _h0 = 0;
    _h1 = 0;
    _h2 = 0;
    _h3 = 0;
    _h4 = 0;
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    buffer[16] = 1;
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        $update();
        pos = 0;
      }
      buffer[pos] = chunk[start];
    }
    if (pos == blockLength) {
      $update();
      pos = 0;
    }
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int d0, d1, d2, d3, d4;

    // a += n
    _h0 += ((buffer[0] & 0xFF)) |
        ((buffer[1] & 0xFF) << 8) |
        ((buffer[2] & 0xFF) << 16) |
        ((buffer[3] & 0x03) << 24);
    _h1 += ((buffer[3] & 0xFF) >>> 2) |
        ((buffer[4] & 0xFF) << 6) |
        ((buffer[5] & 0xFF) << 14) |
        ((buffer[6] & 0xF) << 22);
    _h2 += ((buffer[6] & 0xFF) >>> 4) |
        ((buffer[7] & 0xFF) << 4) |
        ((buffer[8] & 0xFF) << 12) |
        ((buffer[9] & 0x3F) << 20);
    _h3 += ((buffer[9] & 0xFF) >>> 6) |
        ((buffer[10] & 0xFF) << 2) |
        ((buffer[11] & 0xFF) << 10) |
        ((buffer[12] & 0xFF) << 18);
    _h4 += (buffer[13] & 0xFF) | //
        ((buffer[14] & 0xFF) << 8) |
        ((buffer[15] & 0xFF) << 16) |
        ((buffer[16] & 0x03) << 24);

    // a *= r
    d0 = _h0 * _r0 + _h1 * _g4 + _h2 * _g3 + _h3 * _g2 + _h4 * _g1;
    d1 = _h0 * _r1 + _h1 * _r0 + _h2 * _g4 + _h3 * _g3 + _h4 * _g2;
    d2 = _h0 * _r2 + _h1 * _r1 + _h2 * _r0 + _h3 * _g4 + _h4 * _g3;
    d3 = _h0 * _r3 + _h1 * _r2 + _h2 * _r1 + _h3 * _r0 + _h4 * _g4;
    d4 = _h0 * _r4 + _h1 * _r3 + _h2 * _r2 + _h3 * _r1 + _h4 * _r0;

    // a %= 2^130 - 5;
    d1 += d0 >>> 26;
    d2 += d1 >>> 26;
    d3 += d2 >>> 26;
    d4 += d3 >>> 26;
    _h0 = d0 & _mask26;
    _h1 = d1 & _mask26;
    _h2 = d2 & _mask26;
    _h3 = d3 & _mask26;
    _h4 = d4 & _mask26;
    _h0 += 5 * (d4 >>> 26);
    _h1 += _h0 >>> 26;
    _h0 &= _mask26;
  }

  @override
  Uint8List $finalize() {
    if (pos > 0) {
      buffer[pos] = 1;
      for (pos++; pos <= 16; pos++) {
        buffer[pos] = 0;
      }
      $update();
    }

    int d0, d1, d2, d3, d4;

    // fully carry
    _h1 += _h0 >>> 26;
    _h2 += _h1 >>> 26;
    _h3 += _h2 >>> 26;
    _h4 += _h3 >>> 26;
    _h0 &= _mask26;
    _h1 &= _mask26;
    _h2 &= _mask26;
    _h3 &= _mask26;

    // compute d = h - p
    d0 = _h0 + 5;
    d1 = _h1 + (d0 >>> 26);
    d2 = _h2 + (d1 >>> 26);
    d3 = _h3 + (d2 >>> 26);
    d4 = _h4 + (d3 >>> 26) - (1 << 26);
    d4 &= _mask32;

    // if h < p, take h; else, take d
    if ((d4 >>> 31) != 1) {
      _h0 = d0 & _mask26;
      _h1 = d1 & _mask26;
      _h2 = d2 & _mask26;
      _h3 = d3 & _mask26;
      _h4 = d4 & _mask26;
    }

    // modulus 2^128
    _h0 = ((_h0) | (_h1 << 26)) & _mask32;
    _h1 = ((_h1 >>> 6) | (_h2 << 20)) & _mask32;
    _h2 = ((_h2 >>> 12) | (_h3 << 14)) & _mask32;
    _h3 = ((_h3 >>> 18) | (_h4 << 8)) & _mask32;

    // h += s
    _h0 += _s0;
    _h1 += _s1 + (_h0 >>> 32);
    _h2 += _s2 + (_h1 >>> 32);
    _h3 += _s3 + (_h2 >>> 32);

    return Uint32List.fromList([
      _h0,
      _h1,
      _h2,
      _h3,
    ]).buffer.asUint8List();
  }
}
