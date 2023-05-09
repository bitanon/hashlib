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
  0x76543210,
  0xFEDCBA98,
  0x89ABCDEF,
  0x01234567,
];

/// This implementation is derived from the Bouncy Castle's implementation of
/// [RIPEMD-256][bc].
///
/// [bc]: https://github.com/bcgit/bc-java/blob/master/core/src/main/java/org/bouncycastle/crypto/digests/RIPEMD256Digest.java
class RIPEMD256Hash extends BlockHashSink {
  final Uint32List state;

  @override
  final int hashLength;

  RIPEMD256Hash()
      : state = Uint32List.fromList(_iv),
        hashLength = 256 >>> 3,
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
  @pragma('dart2js:tryInline')
  static int _rotl32(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _f1(int x, int y, int z) => x ^ y ^ z;

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _f2(int x, int y, int z) => (x & y) | (((~x) & _mask32) & z);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _f3(int x, int y, int z) => (x | ((~y) & _mask32)) ^ z;

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _f4(int x, int y, int z) => (x & z) | (y & ((~z) & _mask32));

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _lr1(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f1(b, c, d) + x, s);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _lr2(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f2(b, c, d) + x + 0x5a827999, s);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _lr3(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f3(b, c, d) + x + 0x6ed9eba1, s);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _lr4(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f4(b, c, d) + x + 0x8f1bbcdc, s);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _rr1(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f1(b, c, d) + x, s);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _rr2(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f2(b, c, d) + x + 0x6d703ef3, s);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _rr3(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f3(b, c, d) + x + 0x5c4dd124, s);

  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  static int _rr4(int a, int b, int c, int d, int x, int s) =>
      _rotl32(a + _f4(b, c, d) + x + 0x50a28be6, s);

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int a, b, c, d, aa, bb, cc, dd, t;
    int x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;

    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];
    aa = state[4];
    bb = state[5];
    cc = state[6];
    dd = state[7];

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
    // Round 1
    //
    a = _lr1(a, b, c, d, x0, 11);
    d = _lr1(d, a, b, c, x1, 14);
    c = _lr1(c, d, a, b, x2, 15);
    b = _lr1(b, c, d, a, x3, 12);
    a = _lr1(a, b, c, d, x4, 5);
    d = _lr1(d, a, b, c, x5, 8);
    c = _lr1(c, d, a, b, x6, 7);
    b = _lr1(b, c, d, a, x7, 9);
    a = _lr1(a, b, c, d, x8, 11);
    d = _lr1(d, a, b, c, x9, 13);
    c = _lr1(c, d, a, b, x10, 14);
    b = _lr1(b, c, d, a, x11, 15);
    a = _lr1(a, b, c, d, x12, 6);
    d = _lr1(d, a, b, c, x13, 7);
    c = _lr1(c, d, a, b, x14, 9);
    b = _lr1(b, c, d, a, x15, 8);

    aa = _rr4(aa, bb, cc, dd, x5, 8);
    dd = _rr4(dd, aa, bb, cc, x14, 9);
    cc = _rr4(cc, dd, aa, bb, x7, 9);
    bb = _rr4(bb, cc, dd, aa, x0, 11);
    aa = _rr4(aa, bb, cc, dd, x9, 13);
    dd = _rr4(dd, aa, bb, cc, x2, 15);
    cc = _rr4(cc, dd, aa, bb, x11, 15);
    bb = _rr4(bb, cc, dd, aa, x4, 5);
    aa = _rr4(aa, bb, cc, dd, x13, 7);
    dd = _rr4(dd, aa, bb, cc, x6, 7);
    cc = _rr4(cc, dd, aa, bb, x15, 8);
    bb = _rr4(bb, cc, dd, aa, x8, 11);
    aa = _rr4(aa, bb, cc, dd, x1, 14);
    dd = _rr4(dd, aa, bb, cc, x10, 14);
    cc = _rr4(cc, dd, aa, bb, x3, 12);
    bb = _rr4(bb, cc, dd, aa, x12, 6);

    t = a;
    a = aa;
    aa = t;

    //
    // Round 2
    //
    a = _lr2(a, b, c, d, x7, 7);
    d = _lr2(d, a, b, c, x4, 6);
    c = _lr2(c, d, a, b, x13, 8);
    b = _lr2(b, c, d, a, x1, 13);
    a = _lr2(a, b, c, d, x10, 11);
    d = _lr2(d, a, b, c, x6, 9);
    c = _lr2(c, d, a, b, x15, 7);
    b = _lr2(b, c, d, a, x3, 15);
    a = _lr2(a, b, c, d, x12, 7);
    d = _lr2(d, a, b, c, x0, 12);
    c = _lr2(c, d, a, b, x9, 15);
    b = _lr2(b, c, d, a, x5, 9);
    a = _lr2(a, b, c, d, x2, 11);
    d = _lr2(d, a, b, c, x14, 7);
    c = _lr2(c, d, a, b, x11, 13);
    b = _lr2(b, c, d, a, x8, 12);

    aa = _rr3(aa, bb, cc, dd, x6, 9);
    dd = _rr3(dd, aa, bb, cc, x11, 13);
    cc = _rr3(cc, dd, aa, bb, x3, 15);
    bb = _rr3(bb, cc, dd, aa, x7, 7);
    aa = _rr3(aa, bb, cc, dd, x0, 12);
    dd = _rr3(dd, aa, bb, cc, x13, 8);
    cc = _rr3(cc, dd, aa, bb, x5, 9);
    bb = _rr3(bb, cc, dd, aa, x10, 11);
    aa = _rr3(aa, bb, cc, dd, x14, 7);
    dd = _rr3(dd, aa, bb, cc, x15, 7);
    cc = _rr3(cc, dd, aa, bb, x8, 12);
    bb = _rr3(bb, cc, dd, aa, x12, 7);
    aa = _rr3(aa, bb, cc, dd, x4, 6);
    dd = _rr3(dd, aa, bb, cc, x9, 15);
    cc = _rr3(cc, dd, aa, bb, x1, 13);
    bb = _rr3(bb, cc, dd, aa, x2, 11);

    t = b;
    b = bb;
    bb = t;

    //
    // Round 3
    //
    a = _lr3(a, b, c, d, x3, 11);
    d = _lr3(d, a, b, c, x10, 13);
    c = _lr3(c, d, a, b, x14, 6);
    b = _lr3(b, c, d, a, x4, 7);
    a = _lr3(a, b, c, d, x9, 14);
    d = _lr3(d, a, b, c, x15, 9);
    c = _lr3(c, d, a, b, x8, 13);
    b = _lr3(b, c, d, a, x1, 15);
    a = _lr3(a, b, c, d, x2, 14);
    d = _lr3(d, a, b, c, x7, 8);
    c = _lr3(c, d, a, b, x0, 13);
    b = _lr3(b, c, d, a, x6, 6);
    a = _lr3(a, b, c, d, x13, 5);
    d = _lr3(d, a, b, c, x11, 12);
    c = _lr3(c, d, a, b, x5, 7);
    b = _lr3(b, c, d, a, x12, 5);

    aa = _rr2(aa, bb, cc, dd, x15, 9);
    dd = _rr2(dd, aa, bb, cc, x5, 7);
    cc = _rr2(cc, dd, aa, bb, x1, 15);
    bb = _rr2(bb, cc, dd, aa, x3, 11);
    aa = _rr2(aa, bb, cc, dd, x7, 8);
    dd = _rr2(dd, aa, bb, cc, x14, 6);
    cc = _rr2(cc, dd, aa, bb, x6, 6);
    bb = _rr2(bb, cc, dd, aa, x9, 14);
    aa = _rr2(aa, bb, cc, dd, x11, 12);
    dd = _rr2(dd, aa, bb, cc, x8, 13);
    cc = _rr2(cc, dd, aa, bb, x12, 5);
    bb = _rr2(bb, cc, dd, aa, x2, 14);
    aa = _rr2(aa, bb, cc, dd, x10, 13);
    dd = _rr2(dd, aa, bb, cc, x0, 13);
    cc = _rr2(cc, dd, aa, bb, x4, 7);
    bb = _rr2(bb, cc, dd, aa, x13, 5);

    t = c;
    c = cc;
    cc = t;

    //
    // Round 4
    //
    a = _lr4(a, b, c, d, x1, 11);
    d = _lr4(d, a, b, c, x9, 12);
    c = _lr4(c, d, a, b, x11, 14);
    b = _lr4(b, c, d, a, x10, 15);
    a = _lr4(a, b, c, d, x0, 14);
    d = _lr4(d, a, b, c, x8, 15);
    c = _lr4(c, d, a, b, x12, 9);
    b = _lr4(b, c, d, a, x4, 8);
    a = _lr4(a, b, c, d, x13, 9);
    d = _lr4(d, a, b, c, x3, 14);
    c = _lr4(c, d, a, b, x7, 5);
    b = _lr4(b, c, d, a, x15, 6);
    a = _lr4(a, b, c, d, x14, 8);
    d = _lr4(d, a, b, c, x5, 6);
    c = _lr4(c, d, a, b, x6, 5);
    b = _lr4(b, c, d, a, x2, 12);

    aa = _rr1(aa, bb, cc, dd, x8, 15);
    dd = _rr1(dd, aa, bb, cc, x6, 5);
    cc = _rr1(cc, dd, aa, bb, x4, 8);
    bb = _rr1(bb, cc, dd, aa, x1, 11);
    aa = _rr1(aa, bb, cc, dd, x3, 14);
    dd = _rr1(dd, aa, bb, cc, x11, 14);
    cc = _rr1(cc, dd, aa, bb, x15, 6);
    bb = _rr1(bb, cc, dd, aa, x0, 14);
    aa = _rr1(aa, bb, cc, dd, x5, 6);
    dd = _rr1(dd, aa, bb, cc, x12, 9);
    cc = _rr1(cc, dd, aa, bb, x2, 12);
    bb = _rr1(bb, cc, dd, aa, x13, 9);
    aa = _rr1(aa, bb, cc, dd, x9, 12);
    dd = _rr1(dd, aa, bb, cc, x7, 5);
    cc = _rr1(cc, dd, aa, bb, x10, 15);
    bb = _rr1(bb, cc, dd, aa, x14, 8);

    t = d;
    d = dd;
    dd = t;

    //
    // combine the results
    //
    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += aa;
    state[5] += bb;
    state[6] += cc;
    state[7] += dd;
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
    return state.buffer.asUint8List().sublist(0, hashLength);
  }
}
