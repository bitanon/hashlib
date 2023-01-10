// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

// Rotation constants
const int _rot01 = 36;
const int _rot02 = 3;
const int _rot03 = 41;
const int _rot04 = 18;
const int _rot05 = 1;
const int _rot06 = 44;
const int _rot07 = 10;
const int _rot08 = 45;
const int _rot09 = 2;
const int _rot10 = 62;
const int _rot11 = 6;
const int _rot12 = 43;
const int _rot13 = 15;
const int _rot14 = 61;
const int _rot15 = 28;
const int _rot16 = 55;
const int _rot17 = 25;
const int _rot18 = 21;
const int _rot19 = 56;
const int _rot20 = 27;
const int _rot21 = 20;
const int _rot22 = 39;
const int _rot23 = 8;
const int _rot24 = 14;

// 200-bit round constants iota mapping [little endian]
const _rc = <int>[
  0x00000001, 0x00000000, //
  0x00008082, 0x00000000,
  0x0000808a, 0x80000000,
  0x80008000, 0x80000000,
  0x0000808b, 0x00000000,
  0x80000001, 0x00000000,
  0x80008081, 0x80000000,
  0x00008009, 0x80000000,
  0x0000008a, 0x00000000,
  0x00000088, 0x00000000,
  0x80008009, 0x00000000,
  0x8000000a, 0x00000000,
  0x8000808b, 0x00000000,
  0x0000008b, 0x80000000,
  0x00008089, 0x80000000,
  0x00008003, 0x80000000,
  0x00008002, 0x80000000,
  0x00000080, 0x80000000,
  0x0000800a, 0x00000000,
  0x8000000a, 0x80000000,
  0x80008081, 0x80000000,
  0x00008080, 0x80000000,
  0x80000001, 0x00000000,
  0x80008008, 0x80000000,
];

// State variable indices
const int _a0 = 0;
const int _a1 = _a0 + 2;
const int _a2 = _a1 + 2;
const int _a3 = _a2 + 2;
const int _a4 = _a3 + 2;
const int _a5 = _a4 + 2;
const int _a6 = _a5 + 2;
const int _a7 = _a6 + 2;
const int _a8 = _a7 + 2;
const int _a9 = _a8 + 2;
const int _a10 = _a9 + 2;
const int _a11 = _a10 + 2;
const int _a12 = _a11 + 2;
const int _a13 = _a12 + 2;
const int _a14 = _a13 + 2;
const int _a15 = _a14 + 2;
const int _a16 = _a15 + 2;
const int _a17 = _a16 + 2;
const int _a18 = _a17 + 2;
const int _a19 = _a18 + 2;
const int _a20 = _a19 + 2;
const int _a21 = _a20 + 2;
const int _a22 = _a21 + 2;
const int _a23 = _a22 + 2;
const int _a24 = _a23 + 2;

// Temp variable indices
const int _b0 = 0;
const int _b1 = _b0 + 2;
const int _b2 = _b1 + 2;
const int _b3 = _b2 + 2;
const int _b4 = _b3 + 2;
const int _b5 = _b4 + 2;
const int _b6 = _b5 + 2;
const int _b7 = _b6 + 2;
const int _b8 = _b7 + 2;
const int _b9 = _b8 + 2;
const int _b10 = _b9 + 2;
const int _b11 = _b10 + 2;
const int _b12 = _b11 + 2;
const int _b13 = _b12 + 2;
const int _b14 = _b13 + 2;
const int _b15 = _b14 + 2;
const int _b16 = _b15 + 2;
const int _b17 = _b16 + 2;
const int _b18 = _b17 + 2;
const int _b19 = _b18 + 2;
const int _b20 = _b19 + 2;
const int _b21 = _b20 + 2;
const int _b22 = _b21 + 2;
const int _b23 = _b22 + 2;
const int _b24 = _b23 + 2;
const int _c0 = _b24 + 2;
const int _c1 = _c0 + 2;
const int _c2 = _c1 + 2;
const int _c3 = _c2 + 2;
const int _c4 = _c3 + 2;
const int _d = _c4 + 2;

/// This is an implementation of Keccak-f\[1600\] derived from
/// [FIPS-202 SHA-3 Standard][fips202] published by NIST.
///
/// Followed the optimizations in [PyCryptodome's implementation][keccak].
/// Special thanks to [tiny_sha3] for readable code and test cases.
///
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
/// [keccak]: https://github.com/Legrandin/pycryptodome/blob/master/src/keccak.c
/// [tiny_sha3]: https://github.com/mjosaarinen/tiny_sha3/blob/master/sha3.c
abstract class KeccakHash extends BlockHashBase {
  final int stateSize;
  final int paddingByte;
  final Uint32List state;
  late final Uint8List bstate;
  final _var = Uint32List(_d + 2);

  KeccakHash({
    required this.stateSize,
    this.paddingByte = 0x06,
    int? outputSize, // equals to state size if not provided
  })  : assert(
          stateSize >= 0 && stateSize <= 100,
          'The state size is not valid',
        ),
        state = Uint32List(50), // 1600-bit state
        super(
          blockLength: 200 - (stateSize << 1), // rate
          hashLength: outputSize ?? stateSize, // output length
        ) {
    bstate = state.buffer.asUint8List();
  }

  // static void _shr(int n, List<int> x, int i, List<int> z, int k) {
  //   var a = x[i];
  //   var b = x[i + 1];
  //   if (n == 32) {
  //     z[k] = 0;
  //     z[k + 1] = a;
  //   } else if (n < 32) {
  //     z[k] = a >>> n;
  //     z[k + 1] = (a << (32 - n)) | (b >>> n);
  //   } else {
  //     z[k] = 0;
  //     z[k + 1] = a >>> (n - 32);
  //   }
  // }

  // static void _shl(int n, List<int> x, int i, List<int> z, int k) {
  //   var a = x[i];
  //   var b = x[i + 1];
  //   if (n == 32) {
  //     z[k] = b;
  //     z[k + 1] = 0;
  //   } else if (n < 32) {
  //     z[k] = (a << n) | (b >> (32 - n));
  //     z[k + 1] = b << n;
  //   } else {
  //     z[k] = b << (n - 32);
  //     z[k + 1] = 0;
  //   }
  // }

  // static void _rotl(int n, List<int> x, int i, List<int> z, int k) {
  //   var t = Uint32List(4);
  //   _shl(n, x, i, t, 0);
  //   _shr(64 - n, x, i, t, 2);
  //   z[k] = t[0] | t[2];
  //   z[k + 1] = t[1] | t[3];
  // }

  // (x << n) | (x >>> (64 - n))
  static void _rotl(int n, List<int> x, int i, List<int> z, int k) {
    // *numbers are in little-endian order*
    var a = x[i];
    var b = x[i + 1];
    if (n == 32) {
      z[k] = b;
      z[k + 1] = a;
    } else if (n < 32) {
      z[k] = (a << n) | (b >> (32 - n));
      z[k + 1] = (b << n) | a >>> (32 - n);
    } else {
      z[k] = (b << (n - 32)) | (a >>> (64 - n));
      z[k + 1] = (a << (n - 32)) | (b >>> (64 - n));
    }
  }

  // z = x ^ y
  static void _xor(List<int> x, int i, List<int> y, int j, List<int> z, int k) {
    z[k] = x[i] ^ y[j];
    z[k + 1] = x[i + 1] ^ y[j + 1];
  }

  // z = x[i1] ^ x[i2] ^ x[i3] ^ x[i4] ^ x[i5]
  static void _xor5(
      List<int> x, int i1, int i2, int i3, int i4, int i5, List<int> z, int k) {
    z[k] = x[i1] ^ x[i2] ^ x[i3] ^ x[i4] ^ x[i5];
    z[k + 1] = x[i1 + 1] ^ x[i2 + 1] ^ x[i3 + 1] ^ x[i4 + 1] ^ x[i5 + 1];
  }

  // z = x[i1] ^ (~x[i2] & x[i3]);
  static void _chi(List<int> x, int i1, int i2, int i3, List<int> z, int k) {
    z[k] = x[i1] ^ (~x[i2] & x[i3]);
    z[k + 1] = x[i1 + 1] ^ (~x[i2 + 1] & x[i3 + 1]);
  }

  @override
  void $update(List<int> block, [int offset = 0]) {
    if (offset + blockLength <= block.length) {
      // Put the block in the state
      for (int i = 0; i < blockLength; ++i, offset++) {
        bstate[i] ^= block[offset];
      }
    }

    for (int r = 0; r < _rc.length; r += 2) {
      // ---- Theta parity ----
      // c0 = a0 ^ a5 ^ a10 ^ a15 ^ a20;
      _xor5(state, _a0, _a5, _a10, _a15, _a20, _var, _c0);
      // c1 = a1 ^ a6 ^ a11 ^ a16 ^ a21;
      _xor5(state, _a1, _a6, _a11, _a16, _a21, _var, _c1);
      // c2 = a2 ^ a7 ^ a12 ^ a17 ^ a22;
      _xor5(state, _a2, _a7, _a12, _a17, _a22, _var, _c2);
      // c3 = a3 ^ a8 ^ a13 ^ a18 ^ a23;
      _xor5(state, _a3, _a8, _a13, _a18, _a23, _var, _c3);
      // c4 = a4 ^ a9 ^ a14 ^ a19 ^ a24;
      _xor5(state, _a4, _a9, _a14, _a19, _a24, _var, _c4);

      // ---- Theta + Rho + Pi ----
      // d = c4 ^ _rotl(c1, 1);
      _rotl(1, _var, _c1, _var, _d);
      _xor(_var, _c4, _var, _d, _var, _d);
      // b0 = d ^ a0;
      _xor(_var, _d, state, _a0, _var, _b0);
      // b16 = _rotl(d ^ a5, _rot01);
      _xor(_var, _d, state, _a5, _var, _b16);
      _rotl(_rot01, _var, _b16, _var, _b16);
      // b7 = _rotl(d ^ a10, _rot02);
      _xor(_var, _d, state, _a10, _var, _b7);
      _rotl(_rot02, _var, _b7, _var, _b7);
      // b23 = _rotl(d ^ a15, _rot03);
      _xor(_var, _d, state, _a15, _var, _b23);
      _rotl(_rot03, _var, _b23, _var, _b23);
      // b14 = _rotl(d ^ a20, _rot04);
      _xor(_var, _d, state, _a20, _var, _b14);
      _rotl(_rot04, _var, _b14, _var, _b14);

      // d = c0 ^ _rotl(c2, 1);
      _rotl(1, _var, _c2, _var, _d);
      _xor(_var, _c0, _var, _d, _var, _d);
      // b10 = _rotl(d ^ a1, _rot05);
      _xor(_var, _d, state, _a1, _var, _b10);
      _rotl(_rot05, _var, _b10, _var, _b10);
      // b1 = _rotl(d ^ a6, _rot06);
      _xor(_var, _d, state, _a6, _var, _b1);
      _rotl(_rot06, _var, _b1, _var, _b1);
      // b17 = _rotl(d ^ a11, _rot07);
      _xor(_var, _d, state, _a11, _var, _b17);
      _rotl(_rot07, _var, _b17, _var, _b17);
      // b8 = _rotl(d ^ a16, _rot08);
      _xor(_var, _d, state, _a16, _var, _b8);
      _rotl(_rot08, _var, _b8, _var, _b8);
      // b24 = _rotl(d ^ a21, _rot09);
      _xor(_var, _d, state, _a21, _var, _b24);
      _rotl(_rot09, _var, _b24, _var, _b24);

      // d = c1 ^ _rotl(c3, 1);
      _rotl(1, _var, _c3, _var, _d);
      _xor(_var, _d, _var, _c1, _var, _d);
      // b20 = _rotl(d ^ a2, _rot10);
      _xor(_var, _d, state, _a2, _var, _b20);
      _rotl(_rot10, _var, _b20, _var, _b20);
      // b11 = _rotl(d ^ a7, _rot11);
      _xor(_var, _d, state, _a7, _var, _b11);
      _rotl(_rot11, _var, _b11, _var, _b11);
      // b2 = _rotl(d ^ a12, _rot12);
      _xor(_var, _d, state, _a12, _var, _b2);
      _rotl(_rot12, _var, _b2, _var, _b2);
      // b18 = _rotl(d ^ a17, _rot13);
      _xor(_var, _d, state, _a17, _var, _b18);
      _rotl(_rot13, _var, _b18, _var, _b18);
      // b9 = _rotl(d ^ a22, _rot14);
      _xor(_var, _d, state, _a22, _var, _b9);
      _rotl(_rot14, _var, _b9, _var, _b9);

      // d = c2 ^ _rotl(c4, 1);
      _rotl(1, _var, _c4, _var, _d);
      _xor(_var, _c2, _var, _d, _var, _d);
      // b5 = _rotl(d ^ a3, _rot15);
      _xor(_var, _d, state, _a3, _var, _b5);
      _rotl(_rot15, _var, _b5, _var, _b5);
      // b21 = _rotl(d ^ a8, _rot16);
      _xor(_var, _d, state, _a8, _var, _b21);
      _rotl(_rot16, _var, _b21, _var, _b21);
      // b12 = _rotl(d ^ a13, _rot17);
      _xor(_var, _d, state, _a13, _var, _b12);
      _rotl(_rot17, _var, _b12, _var, _b12);
      // b3 = _rotl(d ^ a18, _rot18);
      _xor(_var, _d, state, _a18, _var, _b3);
      _rotl(_rot18, _var, _b3, _var, _b3);
      // b19 = _rotl(d ^ a23, _rot19);
      _xor(_var, _d, state, _a23, _var, _b19);
      _rotl(_rot19, _var, _b19, _var, _b19);

      // d = c3 ^ _rotl(c0, 1);
      _rotl(1, _var, _c0, _var, _d);
      _xor(_var, _c3, _var, _d, _var, _d);
      // b15 = _rotl(d ^ a4, _rot20);
      _xor(_var, _d, state, _a4, _var, _b15);
      _rotl(_rot20, _var, _b15, _var, _b15);
      // b6 = _rotl(d ^ a9, _rot21);
      _xor(_var, _d, state, _a9, _var, _b6);
      _rotl(_rot21, _var, _b6, _var, _b6);
      // b22 = _rotl(d ^ a14, _rot22);
      _xor(_var, _d, state, _a14, _var, _b22);
      _rotl(_rot22, _var, _b22, _var, _b22);
      // b13 = _rotl(d ^ a19, _rot23);
      _xor(_var, _d, state, _a19, _var, _b13);
      _rotl(_rot23, _var, _b13, _var, _b13);
      // b4 = _rotl(d ^ a24, _rot24);
      _xor(_var, _d, state, _a24, _var, _b4);
      _rotl(_rot24, _var, _b4, _var, _b4);

      // ---- Chi + Iota ----
      // a0 = b0 ^ (~b1 & b2) ^ r;
      _chi(_var, _b0, _b1, _b2, state, _a0);
      _xor(state, _a0, _rc, r, state, _a0);
      // a1 = b1 ^ (~b2 & b3);
      _chi(_var, _b1, _b2, _b3, state, _a1);
      // a2 = b2 ^ (~b3 & b4);
      _chi(_var, _b2, _b3, _b4, state, _a2);
      // a3 = b3 ^ (~b4 & b0);
      _chi(_var, _b3, _b4, _b0, state, _a3);
      // a4 = b4 ^ (~b0 & b1);
      _chi(_var, _b4, _b0, _b1, state, _a4);

      // a5 = b5 ^ (~b6 & b7);
      _chi(_var, _b5, _b6, _b7, state, _a5);
      // a6 = b6 ^ (~b7 & b8);
      _chi(_var, _b6, _b7, _b8, state, _a6);
      // a7 = b7 ^ (~b8 & b9);
      _chi(_var, _b7, _b8, _b9, state, _a7);
      // a8 = b8 ^ (~b9 & b5);
      _chi(_var, _b8, _b9, _b5, state, _a8);
      // a9 = b9 ^ (~b5 & b6);
      _chi(_var, _b9, _b5, _b6, state, _a9);

      // a10 = b10 ^ (~b11 & b12);
      _chi(_var, _b10, _b11, _b12, state, _a10);
      // a11 = b11 ^ (~b12 & b13);
      _chi(_var, _b11, _b12, _b13, state, _a11);
      // a12 = b12 ^ (~b13 & b14);
      _chi(_var, _b12, _b13, _b14, state, _a12);
      // a13 = b13 ^ (~b14 & b10);
      _chi(_var, _b13, _b14, _b10, state, _a13);
      // a14 = b14 ^ (~b10 & b11);
      _chi(_var, _b14, _b10, _b11, state, _a14);

      // a15 = b15 ^ (~b16 & b17);
      _chi(_var, _b15, _b16, _b17, state, _a15);
      // a16 = b16 ^ (~b17 & b18);
      _chi(_var, _b16, _b17, _b18, state, _a16);
      // a17 = b17 ^ (~b18 & b19);
      _chi(_var, _b17, _b18, _b19, state, _a17);
      // a18 = b18 ^ (~b19 & b15);
      _chi(_var, _b18, _b19, _b15, state, _a18);
      // a19 = b19 ^ (~b15 & b16);
      _chi(_var, _b19, _b15, _b16, state, _a19);

      // a20 = b20 ^ (~b21 & b22);
      _chi(_var, _b20, _b21, _b22, state, _a20);
      // a21 = b21 ^ (~b22 & b23);
      _chi(_var, _b21, _b22, _b23, state, _a21);
      // a22 = b22 ^ (~b23 & b24);
      _chi(_var, _b22, _b23, _b24, state, _a22);
      // a23 = b23 ^ (~b24 & b20);
      _chi(_var, _b23, _b24, _b20, state, _a23);
      // a24 = b24 ^ (~b20 & b21);
      _chi(_var, _b24, _b20, _b21, state, _a24);
    }
  }

  @override
  Uint8List $finalize(Uint8List block, int length) {
    // Update the state with the final block
    for (int i = 0; i < length; ++i) {
      bstate[i] ^= block[i];
    }

    // Setting the signature bytes
    bstate[length] ^= paddingByte;
    bstate[blockLength - 1] ^= 0x80;
    $update([]);

    if (hashLength <= stateSize) {
      return bstate.sublist(0, hashLength);
    }

    // sponge construction
    var bytes = Uint8List(hashLength);
    for (int i = 0, j = 0; i < hashLength; i++, j++) {
      if (j == blockLength) {
        $update([]);
        j = 0;
      }
      bytes[i] = bstate[j];
    }
    return bytes;
  }

  /// Returns a iterable of bytes generated from the Keccak sponge.
  ///
  /// It will produce exactly [outputSize] bytes before closing the stream.
  ///
  /// If [outputSize] is 0, it will generate an infinite sequence of
  /// bytes.
  ///
  /// **WARNING: Be careful to not go down the rabbit hole of infinite looping!**
  Iterable<int> generate() sync* {
    // make sure that the digest is closed
    var b = digest().bytes;
    if (b.isNotEmpty) {
      yield* b;
      return;
    }

    // infinite sponge construction
    for (int j = 0;; j++) {
      if (j == blockLength) {
        $update([]);
        j = 0;
      }
      yield bstate[j];
    }
  }
}
