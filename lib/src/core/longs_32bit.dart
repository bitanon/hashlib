// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

const int mask16 = 0xFFFF;
const int mask32 = 0xFFFFFFFF;
const int mask48 = 0xFFFFFFFFFFFF;

abstract class Longs {
  /// Returns ([a] * [b]) & [mask32]
  static int cross32(int a, int b) {
    int ah = (a >>> 16) & mask16;
    int al = a & mask16;
    int bh = (b >>> 16) & mask16;
    int bl = b & mask16;
    a = (ah * bl + al * bh) & mask32;
    b = (al * bl) & mask32;
    return ((a << 16) + b) & mask32;
  }

  /// Rotates 32-bit number [x] by [n] bits
  static int rotl32(int x, int n) =>
      ((x << n) & mask32) | ((x & mask32) >>> (32 - n));
}
