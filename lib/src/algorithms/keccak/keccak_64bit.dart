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
const List<int> _rc = <int>[
  0x0000000000000001,
  0x0000000000008082,
  0x800000000000808a,
  0x8000000080008000,
  0x000000000000808b,
  0x0000000080000001,
  0x8000000080008081,
  0x8000000000008009,
  0x000000000000008a,
  0x0000000000000088,
  0x0000000080008009,
  0x000000008000000a,
  0x000000008000808b,
  0x800000000000008b,
  0x8000000000008089,
  0x8000000000008003,
  0x8000000000008002,
  0x8000000000000080,
  0x000000000000800a,
  0x800000008000000a,
  0x8000000080008081,
  0x8000000000008080,
  0x0000000080000001,
  0x8000000080008008,
];

/// This is an implementation of Keccak-f\[1600\] derived from
/// [FIPS-202 SHA-3 Standard][fips202] published by NIST.
///
/// Followed the optimizations in [PyCryptodome's implementation][keccak].
/// Special thanks to [tiny_sha3] for readable code and test cases.
///
/// It uses 64-bit integer operations internally which is not supported by
/// Web VM, but a lot faster.
///
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
/// [keccak]: https://github.com/Legrandin/pycryptodome/blob/master/src/keccak.c
/// [tiny_sha3]: https://github.com/mjosaarinen/tiny_sha3/blob/master/sha3.c
class KeccakHash extends BlockHashSink {
  final int stateSize;
  final int paddingByte;
  late final Uint64List qstate;

  @override
  final int hashLength;

  KeccakHash({
    required this.stateSize,
    required this.paddingByte,
    int? outputSize, // equals to state size if not provided
  })  : hashLength = outputSize ?? stateSize,
        super(
          200 - (stateSize << 1), // rate as blockLength
          bufferLength: 200, // 1600-bit state as buffer
        ) {
    if (stateSize < 0 || stateSize >= 100) {
      throw ArgumentError('The state size is not valid');
    }
    qstate = Uint64List.view(buffer.buffer);
  }

  @override
  void reset() {
    super.reset();
    buffer.fillRange(0, buffer.length, 0);
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        $update();
        pos = 0;
      }
      buffer[pos] ^= chunk[start];
    }
    if (pos == blockLength) {
      $update();
      pos = 0;
    }
  }

  @override
  Uint8List $finalize() {
    // Update the final block
    if (pos == blockLength) {
      $update();
      pos = 0;
    }

    // Setting the signature bytes
    buffer[pos] ^= paddingByte;
    buffer[blockLength - 1] ^= 0x80;
    $update();

    if (hashLength <= stateSize) {
      return buffer.sublist(0, hashLength);
    }

    // sponge construction
    var bytes = Uint8List(hashLength);
    for (int i = 0, j = 0; i < hashLength; i++, j++) {
      if (j == blockLength) {
        $update();
        j = 0;
      }
      bytes[i] = buffer[j];
    }
    return bytes;
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    // Use variables to avoid index processing
    int a0, a1, a2, a3, a4, a5, a6, a7, a8, a9, a10, a11, a12;
    int a13, a14, a15, a16, a17, a18, a19, a20, a21, a22, a23, a24;

    int b0, b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, b11, b12;
    int b13, b14, b15, b16, b17, b18, b19, b20, b21, b22, b23, b24;

    int c0, c1, c2, c3, c4, d, r;

    // Prepare the state (little-endian)
    a0 = qstate[0];
    a1 = qstate[1];
    a2 = qstate[2];
    a3 = qstate[3];
    a4 = qstate[4];
    a5 = qstate[5];
    a6 = qstate[6];
    a7 = qstate[7];
    a8 = qstate[8];
    a9 = qstate[9];
    a10 = qstate[10];
    a11 = qstate[11];
    a12 = qstate[12];
    a13 = qstate[13];
    a14 = qstate[14];
    a15 = qstate[15];
    a16 = qstate[16];
    a17 = qstate[17];
    a18 = qstate[18];
    a19 = qstate[19];
    a20 = qstate[20];
    a21 = qstate[21];
    a22 = qstate[22];
    a23 = qstate[23];
    a24 = qstate[24];

    for (r in _rc) {
      // ---- Theta parity ----
      c0 = a0 ^ a5 ^ a10 ^ a15 ^ a20;
      c1 = a1 ^ a6 ^ a11 ^ a16 ^ a21;
      c2 = a2 ^ a7 ^ a12 ^ a17 ^ a22;
      c3 = a3 ^ a8 ^ a13 ^ a18 ^ a23;
      c4 = a4 ^ a9 ^ a14 ^ a19 ^ a24;

      // ---- Theta + Rho + Pi ----
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

      // ---- Chi + Iota ----
      a0 = b0 ^ ((~b1) & b2) ^ r;
      a1 = b1 ^ ((~b2) & b3);
      a2 = b2 ^ ((~b3) & b4);
      a3 = b3 ^ ((~b4) & b0);
      a4 = b4 ^ ((~b0) & b1);

      a5 = b5 ^ ((~b6) & b7);
      a6 = b6 ^ ((~b7) & b8);
      a7 = b7 ^ ((~b8) & b9);
      a8 = b8 ^ ((~b9) & b5);
      a9 = b9 ^ ((~b5) & b6);

      a10 = b10 ^ ((~b11) & b12);
      a11 = b11 ^ ((~b12) & b13);
      a12 = b12 ^ ((~b13) & b14);
      a13 = b13 ^ ((~b14) & b10);
      a14 = b14 ^ ((~b10) & b11);

      a15 = b15 ^ ((~b16) & b17);
      a16 = b16 ^ ((~b17) & b18);
      a17 = b17 ^ ((~b18) & b19);
      a18 = b18 ^ ((~b19) & b15);
      a19 = b19 ^ ((~b15) & b16);

      a20 = b20 ^ ((~b21) & b22);
      a21 = b21 ^ ((~b22) & b23);
      a22 = b22 ^ ((~b23) & b24);
      a23 = b23 ^ ((~b24) & b20);
      a24 = b24 ^ ((~b20) & b21);
    }

    // Save the state (little-endian)
    qstate[0] = a0;
    qstate[1] = a1;
    qstate[2] = a2;
    qstate[3] = a3;
    qstate[4] = a4;
    qstate[5] = a5;
    qstate[6] = a6;
    qstate[7] = a7;
    qstate[8] = a8;
    qstate[9] = a9;
    qstate[10] = a10;
    qstate[11] = a11;
    qstate[12] = a12;
    qstate[13] = a13;
    qstate[14] = a14;
    qstate[15] = a15;
    qstate[16] = a16;
    qstate[17] = a17;
    qstate[18] = a18;
    qstate[19] = a19;
    qstate[20] = a20;
    qstate[21] = a21;
    qstate[22] = a22;
    qstate[23] = a23;
    qstate[24] = a24;
  }

  /// Rotates 64-bit number x by n bits
  @pragma('vm:prefer-inline')
  static int _rotl(int x, int n) => (x << n) ^ (x >>> (64 - n));
}
