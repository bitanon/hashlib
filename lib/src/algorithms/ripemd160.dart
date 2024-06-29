// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask32 = 0xFFFFFFFF;

const _iv = <int>[
  0x67452301,
  0xefcdab89,
  0x98badcfe,
  0x10325476,
  0xc3d2e1f0,
];

/// This implementation is derived from the Bouncy Castle's implementation of
/// [RIPEMD-160][bc].
///
/// [bc]: https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/crypto/digests/RIPEMD160Digest.java
class RIPEMD160Hash extends BlockHashSink {
  final Uint32List state;

  @override
  final int hashLength;

  RIPEMD160Hash()
      : state = Uint32List.fromList(_iv),
        hashLength = 160 >>> 3,
        super(512 >>> 3);

  @override
  void reset() {
    super.reset();
    state.setAll(0, _iv);
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    messageLength += end - start;
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        $update();
        pos = 0;
      }
      buffer[pos] = chunk[start];
    }
    if (pos == blockLength) {
      $update(buffer);
      pos = 0;
    }
  }

  @pragma('vm:prefer-inline')
  static int _rotl32(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  @pragma('vm:prefer-inline')
  static int _f1(int x, int y, int z) => x ^ y ^ z;

  @pragma('vm:prefer-inline')
  static int _f2(int x, int y, int z) => (x & y) | (((~x) & _mask32) & z);

  @pragma('vm:prefer-inline')
  static int _f3(int x, int y, int z) => (x | ((~y) & _mask32)) ^ z;

  @pragma('vm:prefer-inline')
  static int _f4(int x, int y, int z) => (x & z) | (y & ((~z) & _mask32));

  @pragma('vm:prefer-inline')
  static int _f5(int x, int y, int z) => x ^ (y | ((~z) & _mask32));

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int a, b, c, d, e, aa, bb, cc, dd, ee;
    int x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;

    a = aa = state[0];
    b = bb = state[1];
    c = cc = state[2];
    d = dd = state[3];
    e = ee = state[4];

    x0 = sbuffer[0];
    x1 = sbuffer[1];
    x2 = sbuffer[2];
    x3 = sbuffer[3];
    x4 = sbuffer[4];
    x5 = sbuffer[5];
    x6 = sbuffer[6];
    x7 = sbuffer[7];
    x8 = sbuffer[8];
    x9 = sbuffer[9];
    x10 = sbuffer[10];
    x11 = sbuffer[11];
    x12 = sbuffer[12];
    x13 = sbuffer[13];
    x14 = sbuffer[14];
    x15 = sbuffer[15];

    //
    // Rounds 1 - 16
    //
    // left
    a = _rotl32(a + _f1(b, c, d) + x0, 11) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f1(a, b, c) + x1, 14) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f1(e, a, b) + x2, 15) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f1(d, e, a) + x3, 12) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f1(c, d, e) + x4, 5) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f1(b, c, d) + x5, 8) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f1(a, b, c) + x6, 7) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f1(e, a, b) + x7, 9) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f1(d, e, a) + x8, 11) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f1(c, d, e) + x9, 13) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f1(b, c, d) + x10, 14) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f1(a, b, c) + x11, 15) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f1(e, a, b) + x12, 6) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f1(d, e, a) + x13, 7) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f1(c, d, e) + x14, 9) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f1(b, c, d) + x15, 8) + e;
    c = _rotl32(c, 10);

    // right
    aa = _rotl32(aa + _f5(bb, cc, dd) + x5 + 0x50a28be6, 8) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f5(aa, bb, cc) + x14 + 0x50a28be6, 9) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f5(ee, aa, bb) + x7 + 0x50a28be6, 9) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f5(dd, ee, aa) + x0 + 0x50a28be6, 11) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f5(cc, dd, ee) + x9 + 0x50a28be6, 13) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f5(bb, cc, dd) + x2 + 0x50a28be6, 15) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f5(aa, bb, cc) + x11 + 0x50a28be6, 15) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f5(ee, aa, bb) + x4 + 0x50a28be6, 5) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f5(dd, ee, aa) + x13 + 0x50a28be6, 7) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f5(cc, dd, ee) + x6 + 0x50a28be6, 7) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f5(bb, cc, dd) + x15 + 0x50a28be6, 8) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f5(aa, bb, cc) + x8 + 0x50a28be6, 11) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f5(ee, aa, bb) + x1 + 0x50a28be6, 14) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f5(dd, ee, aa) + x10 + 0x50a28be6, 14) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f5(cc, dd, ee) + x3 + 0x50a28be6, 12) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f5(bb, cc, dd) + x12 + 0x50a28be6, 6) + ee;
    cc = _rotl32(cc, 10);

    //
    // Rounds 16-31
    //
    // left
    e = _rotl32(e + _f2(a, b, c) + x7 + 0x5a827999, 7) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f2(e, a, b) + x4 + 0x5a827999, 6) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f2(d, e, a) + x13 + 0x5a827999, 8) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f2(c, d, e) + x1 + 0x5a827999, 13) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f2(b, c, d) + x10 + 0x5a827999, 11) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f2(a, b, c) + x6 + 0x5a827999, 9) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f2(e, a, b) + x15 + 0x5a827999, 7) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f2(d, e, a) + x3 + 0x5a827999, 15) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f2(c, d, e) + x12 + 0x5a827999, 7) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f2(b, c, d) + x0 + 0x5a827999, 12) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f2(a, b, c) + x9 + 0x5a827999, 15) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f2(e, a, b) + x5 + 0x5a827999, 9) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f2(d, e, a) + x2 + 0x5a827999, 11) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f2(c, d, e) + x14 + 0x5a827999, 7) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f2(b, c, d) + x11 + 0x5a827999, 13) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f2(a, b, c) + x8 + 0x5a827999, 12) + d;
    b = _rotl32(b, 10);

    // right
    ee = _rotl32(ee + _f4(aa, bb, cc) + x6 + 0x5c4dd124, 9) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f4(ee, aa, bb) + x11 + 0x5c4dd124, 13) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f4(dd, ee, aa) + x3 + 0x5c4dd124, 15) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f4(cc, dd, ee) + x7 + 0x5c4dd124, 7) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f4(bb, cc, dd) + x0 + 0x5c4dd124, 12) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f4(aa, bb, cc) + x13 + 0x5c4dd124, 8) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f4(ee, aa, bb) + x5 + 0x5c4dd124, 9) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f4(dd, ee, aa) + x10 + 0x5c4dd124, 11) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f4(cc, dd, ee) + x14 + 0x5c4dd124, 7) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f4(bb, cc, dd) + x15 + 0x5c4dd124, 7) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f4(aa, bb, cc) + x8 + 0x5c4dd124, 12) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f4(ee, aa, bb) + x12 + 0x5c4dd124, 7) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f4(dd, ee, aa) + x4 + 0x5c4dd124, 6) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f4(cc, dd, ee) + x9 + 0x5c4dd124, 15) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f4(bb, cc, dd) + x1 + 0x5c4dd124, 13) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f4(aa, bb, cc) + x2 + 0x5c4dd124, 11) + dd;
    bb = _rotl32(bb, 10);

    //
    // Rounds 32-47
    //
    // left
    d = _rotl32(d + _f3(e, a, b) + x3 + 0x6ed9eba1, 11) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f3(d, e, a) + x10 + 0x6ed9eba1, 13) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f3(c, d, e) + x14 + 0x6ed9eba1, 6) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f3(b, c, d) + x4 + 0x6ed9eba1, 7) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f3(a, b, c) + x9 + 0x6ed9eba1, 14) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f3(e, a, b) + x15 + 0x6ed9eba1, 9) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f3(d, e, a) + x8 + 0x6ed9eba1, 13) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f3(c, d, e) + x1 + 0x6ed9eba1, 15) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f3(b, c, d) + x2 + 0x6ed9eba1, 14) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f3(a, b, c) + x7 + 0x6ed9eba1, 8) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f3(e, a, b) + x0 + 0x6ed9eba1, 13) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f3(d, e, a) + x6 + 0x6ed9eba1, 6) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f3(c, d, e) + x13 + 0x6ed9eba1, 5) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f3(b, c, d) + x11 + 0x6ed9eba1, 12) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f3(a, b, c) + x5 + 0x6ed9eba1, 7) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f3(e, a, b) + x12 + 0x6ed9eba1, 5) + c;
    a = _rotl32(a, 10);

    // right
    dd = _rotl32(dd + _f3(ee, aa, bb) + x15 + 0x6d703ef3, 9) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f3(dd, ee, aa) + x5 + 0x6d703ef3, 7) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f3(cc, dd, ee) + x1 + 0x6d703ef3, 15) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f3(bb, cc, dd) + x3 + 0x6d703ef3, 11) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f3(aa, bb, cc) + x7 + 0x6d703ef3, 8) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f3(ee, aa, bb) + x14 + 0x6d703ef3, 6) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f3(dd, ee, aa) + x6 + 0x6d703ef3, 6) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f3(cc, dd, ee) + x9 + 0x6d703ef3, 14) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f3(bb, cc, dd) + x11 + 0x6d703ef3, 12) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f3(aa, bb, cc) + x8 + 0x6d703ef3, 13) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f3(ee, aa, bb) + x12 + 0x6d703ef3, 5) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f3(dd, ee, aa) + x2 + 0x6d703ef3, 14) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f3(cc, dd, ee) + x10 + 0x6d703ef3, 13) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f3(bb, cc, dd) + x0 + 0x6d703ef3, 13) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f3(aa, bb, cc) + x4 + 0x6d703ef3, 7) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f3(ee, aa, bb) + x13 + 0x6d703ef3, 5) + cc;
    aa = _rotl32(aa, 10);

    //
    // Rounds 48-63
    //
    // left
    c = _rotl32(c + _f4(d, e, a) + x1 + 0x8f1bbcdc, 11) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f4(c, d, e) + x9 + 0x8f1bbcdc, 12) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f4(b, c, d) + x11 + 0x8f1bbcdc, 14) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f4(a, b, c) + x10 + 0x8f1bbcdc, 15) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f4(e, a, b) + x0 + 0x8f1bbcdc, 14) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f4(d, e, a) + x8 + 0x8f1bbcdc, 15) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f4(c, d, e) + x12 + 0x8f1bbcdc, 9) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f4(b, c, d) + x4 + 0x8f1bbcdc, 8) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f4(a, b, c) + x13 + 0x8f1bbcdc, 9) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f4(e, a, b) + x3 + 0x8f1bbcdc, 14) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f4(d, e, a) + x7 + 0x8f1bbcdc, 5) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f4(c, d, e) + x15 + 0x8f1bbcdc, 6) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f4(b, c, d) + x14 + 0x8f1bbcdc, 8) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f4(a, b, c) + x5 + 0x8f1bbcdc, 6) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f4(e, a, b) + x6 + 0x8f1bbcdc, 5) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f4(d, e, a) + x2 + 0x8f1bbcdc, 12) + b;
    e = _rotl32(e, 10);

    // right
    cc = _rotl32(cc + _f2(dd, ee, aa) + x8 + 0x7a6d76e9, 15) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f2(cc, dd, ee) + x6 + 0x7a6d76e9, 5) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f2(bb, cc, dd) + x4 + 0x7a6d76e9, 8) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f2(aa, bb, cc) + x1 + 0x7a6d76e9, 11) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f2(ee, aa, bb) + x3 + 0x7a6d76e9, 14) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f2(dd, ee, aa) + x11 + 0x7a6d76e9, 14) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f2(cc, dd, ee) + x15 + 0x7a6d76e9, 6) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f2(bb, cc, dd) + x0 + 0x7a6d76e9, 14) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f2(aa, bb, cc) + x5 + 0x7a6d76e9, 6) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f2(ee, aa, bb) + x12 + 0x7a6d76e9, 9) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f2(dd, ee, aa) + x2 + 0x7a6d76e9, 12) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f2(cc, dd, ee) + x13 + 0x7a6d76e9, 9) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f2(bb, cc, dd) + x9 + 0x7a6d76e9, 12) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f2(aa, bb, cc) + x7 + 0x7a6d76e9, 5) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f2(ee, aa, bb) + x10 + 0x7a6d76e9, 15) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f2(dd, ee, aa) + x14 + 0x7a6d76e9, 8) + bb;
    ee = _rotl32(ee, 10);

    //
    // Rounds 64-79
    //
    // left
    b = _rotl32(b + _f5(c, d, e) + x4 + 0xa953fd4e, 9) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f5(b, c, d) + x0 + 0xa953fd4e, 15) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f5(a, b, c) + x5 + 0xa953fd4e, 5) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f5(e, a, b) + x9 + 0xa953fd4e, 11) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f5(d, e, a) + x7 + 0xa953fd4e, 6) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f5(c, d, e) + x12 + 0xa953fd4e, 8) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f5(b, c, d) + x2 + 0xa953fd4e, 13) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f5(a, b, c) + x10 + 0xa953fd4e, 12) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f5(e, a, b) + x14 + 0xa953fd4e, 5) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f5(d, e, a) + x1 + 0xa953fd4e, 12) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f5(c, d, e) + x3 + 0xa953fd4e, 13) + a;
    d = _rotl32(d, 10);
    a = _rotl32(a + _f5(b, c, d) + x8 + 0xa953fd4e, 14) + e;
    c = _rotl32(c, 10);
    e = _rotl32(e + _f5(a, b, c) + x11 + 0xa953fd4e, 11) + d;
    b = _rotl32(b, 10);
    d = _rotl32(d + _f5(e, a, b) + x6 + 0xa953fd4e, 8) + c;
    a = _rotl32(a, 10);
    c = _rotl32(c + _f5(d, e, a) + x15 + 0xa953fd4e, 5) + b;
    e = _rotl32(e, 10);
    b = _rotl32(b + _f5(c, d, e) + x13 + 0xa953fd4e, 6) + a;
    d = _rotl32(d, 10);

    // right
    bb = _rotl32(bb + _f1(cc, dd, ee) + x12, 8) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f1(bb, cc, dd) + x15, 5) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f1(aa, bb, cc) + x10, 12) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f1(ee, aa, bb) + x4, 9) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f1(dd, ee, aa) + x1, 12) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f1(cc, dd, ee) + x5, 5) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f1(bb, cc, dd) + x8, 14) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f1(aa, bb, cc) + x7, 6) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f1(ee, aa, bb) + x6, 8) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f1(dd, ee, aa) + x2, 13) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f1(cc, dd, ee) + x13, 6) + aa;
    dd = _rotl32(dd, 10);
    aa = _rotl32(aa + _f1(bb, cc, dd) + x14, 5) + ee;
    cc = _rotl32(cc, 10);
    ee = _rotl32(ee + _f1(aa, bb, cc) + x0, 15) + dd;
    bb = _rotl32(bb, 10);
    dd = _rotl32(dd + _f1(ee, aa, bb) + x3, 13) + cc;
    aa = _rotl32(aa, 10);
    cc = _rotl32(cc + _f1(dd, ee, aa) + x9, 11) + bb;
    ee = _rotl32(ee, 10);
    bb = _rotl32(bb + _f1(cc, dd, ee) + x11, 11) + aa;
    dd = _rotl32(dd, 10);

    dd += c + state[1];
    state[1] = state[2] + d + ee;
    state[2] = state[3] + e + aa;
    state[3] = state[4] + a + bb;
    state[4] = state[0] + b + cc;
    state[0] = dd;
  }

  @override
  Uint8List $finalize() {
    // Adding the signature byte
    buffer[pos++] = 0x80;

    // If no more space left in buffer for the message length
    if (pos > 56) {
      for (; pos < 64; pos++) {
        buffer[pos] = 0;
      }
      $update();
      pos = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; pos < 56; pos++) {
      buffer[pos] = 0;
    }

    // Append original message length in bits to message
    bdata.setUint32(56, messageLengthInBits, Endian.little);
    bdata.setUint32(60, messageLengthInBits >>> 32, Endian.little);

    // Update with the final block
    $update();

    // Convert the state to 8-bit byte array
    return Uint8List.view(state.buffer).sublist(0, hashLength);
  }
}
