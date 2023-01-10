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

// 200-bit round constants iota mapping
const _rc = <int>[
  0x00000000, 0x00000001, //d
  0x00000000, 0x00008082,
  0x80000000, 0x0000808a,
  0x80000000, 0x80008000,
  0x00000000, 0x0000808b,
  0x00000000, 0x80000001,
  0x80000000, 0x80008081,
  0x80000000, 0x00008009,
  0x00000000, 0x0000008a,
  0x00000000, 0x00000088,
  0x00000000, 0x80008009,
  0x00000000, 0x8000000a,
  0x00000000, 0x8000808b,
  0x80000000, 0x0000008b,
  0x80000000, 0x00008089,
  0x80000000, 0x00008003,
  0x80000000, 0x00008002,
  0x80000000, 0x00000080,
  0x00000000, 0x0000800a,
  0x80000000, 0x8000000a,
  0x80000000, 0x80008081,
  0x80000000, 0x00008080,
  0x00000000, 0x80000001,
  0x80000000, 0x80008008,
];

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
  final int rounds;
  final int stateSize;
  final int paddingByte;
  final Uint32List state;
  late final Uint8List bstate;
  late final Uint64List qstate;

  KeccakHash({
    this.rounds = 24,
    required this.stateSize,
    this.paddingByte = 0x06,
    int? outputSize, // equals to state size if not provided
  })  : assert(
          stateSize >= 0 && stateSize <= 100,
          'The state size is not valid',
        ),
        assert(
          rounds == 24 || rounds == 12,
          'Only 12 or 24 rounds are supported',
        ),
        state = Uint32List(50), // 1600-bit state
        super(
          blockLength: 200 - (stateSize << 1), // rate
          hashLength: outputSize ?? stateSize, // output length
        ) {
    bstate = state.buffer.asUint8List();
    qstate = state.buffer.asUint64List();
    throw UnsupportedError('Sorry! Keccak is yet not supported for Web');
  }

  /// Rotates 64-bit number x by n bits
  static int _rotl(int x, int n) => (x << n) | (x >>> (64 - n));

  @override
  void $update(List<int> block, [int offset = 0]) {
    if (offset + blockLength <= block.length) {
      // Put the block in the state
      for (int i = 0; i < blockLength; ++i, offset++) {
        bstate[i] ^= block[offset];
      }
    }

    // Use variables to avoid index processing
    int a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12;
    int a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24;

    int b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12;
    int b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24;

    int c0, c1, c2, c3, c4, d;

    // Use the 64-bit state
    var st = qstate;

    // Prepare the state (little-endian)
    a0 = st[0];
    a1 = st[1];
    a2 = st[2];
    a3 = st[3];
    a4 = st[4];
    a5 = st[5];
    a6 = st[6];
    a7 = st[7];
    a8 = st[8];
    a9 = st[9];
    a10 = st[10];
    a11 = st[11];
    a12 = st[12];
    a13 = st[13];
    a14 = st[14];
    a15 = st[15];
    a16 = st[16];
    a17 = st[17];
    a18 = st[18];
    a19 = st[19];
    a20 = st[20];
    a21 = st[21];
    a22 = st[22];
    a23 = st[23];
    a24 = st[24];

    for (int r in _rc.skip(24 - rounds)) {
      // Theta parity
      c0 = a0 ^ a5 ^ a10 ^ a15 ^ a20;
      c1 = a1 ^ a6 ^ a11 ^ a16 ^ a21;
      c2 = a2 ^ a7 ^ a12 ^ a17 ^ a22;
      c3 = a3 ^ a8 ^ a13 ^ a18 ^ a23;
      c4 = a4 ^ a9 ^ a14 ^ a19 ^ a24;

      // Theta + Rho + Pi
      d = c4 ^ _rotl(c1, 1);
      b0 = d ^ a0;
      b16 = _rotl(d ^ a5, _rot01);
      b7 = _rotl(d ^ a10, _rot02);
      b23 = _rotl(d ^ a15, _rot03);
      b14 = _rotl(d ^ a20, _rot04);

      d = c0 ^ _rotl(c2, 1);
      b10 = _rotl(d ^ a1, _rot05);
      b1 = _rotl(d ^ a6, _rot06);
      b17 = _rotl(d ^ a11, _rot07);
      b8 = _rotl(d ^ a16, _rot08);
      b24 = _rotl(d ^ a21, _rot09);

      d = c1 ^ _rotl(c3, 1);
      b20 = _rotl(d ^ a2, _rot10);
      b11 = _rotl(d ^ a7, _rot11);
      b2 = _rotl(d ^ a12, _rot12);
      b18 = _rotl(d ^ a17, _rot13);
      b9 = _rotl(d ^ a22, _rot14);

      d = c2 ^ _rotl(c4, 1);
      b5 = _rotl(d ^ a3, _rot15);
      b21 = _rotl(d ^ a8, _rot16);
      b12 = _rotl(d ^ a13, _rot17);
      b3 = _rotl(d ^ a18, _rot18);
      b19 = _rotl(d ^ a23, _rot19);

      d = c3 ^ _rotl(c0, 1);
      b15 = _rotl(d ^ a4, _rot20);
      b6 = _rotl(d ^ a9, _rot21);
      b22 = _rotl(d ^ a14, _rot22);
      b13 = _rotl(d ^ a19, _rot23);
      b4 = _rotl(d ^ a24, _rot24);

      // Chi + Iota
      a0 = b0 ^ (~b1 & b2) ^ r;
      a1 = b1 ^ (~b2 & b3);
      a2 = b2 ^ (~b3 & b4);
      a3 = b3 ^ (~b4 & b0);
      a4 = b4 ^ (~b0 & b1);

      a5 = b5 ^ (~b6 & b7);
      a6 = b6 ^ (~b7 & b8);
      a7 = b7 ^ (~b8 & b9);
      a8 = b8 ^ (~b9 & b5);
      a9 = b9 ^ (~b5 & b6);

      a10 = b10 ^ (~b11 & b12);
      a11 = b11 ^ (~b12 & b13);
      a12 = b12 ^ (~b13 & b14);
      a13 = b13 ^ (~b14 & b10);
      a14 = b14 ^ (~b10 & b11);

      a15 = b15 ^ (~b16 & b17);
      a16 = b16 ^ (~b17 & b18);
      a17 = b17 ^ (~b18 & b19);
      a18 = b18 ^ (~b19 & b15);
      a19 = b19 ^ (~b15 & b16);

      a20 = b20 ^ (~b21 & b22);
      a21 = b21 ^ (~b22 & b23);
      a22 = b22 ^ (~b23 & b24);
      a23 = b23 ^ (~b24 & b20);
      a24 = b24 ^ (~b20 & b21);
    }

    // Save the state (little-endian)
    st[0] = a0;
    st[1] = a1;
    st[2] = a2;
    st[3] = a3;
    st[4] = a4;
    st[5] = a5;
    st[6] = a6;
    st[7] = a7;
    st[8] = a8;
    st[9] = a9;
    st[10] = a10;
    st[11] = a11;
    st[12] = a12;
    st[13] = a13;
    st[14] = a14;
    st[15] = a15;
    st[16] = a16;
    st[17] = a17;
    st[18] = a18;
    st[19] = a19;
    st[20] = a20;
    st[21] = a21;
    st[22] = a22;
    st[23] = a23;
    st[24] = a24;
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
}