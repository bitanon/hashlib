// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';

const int _mask32 = 0xFFFFFFFF;

// Initialize array of round constants
const List<int> _k = [
  0x428A2F98, 0x71374491, 0xB5C0FBCF, 0xE9B5DBA5, //
  0x3956C25B, 0x59F111F1, 0x923F82A4, 0xAB1C5ED5,
  0xD807AA98, 0x12835B01, 0x243185BE, 0x550C7DC3,
  0x72BE5D74, 0x80DEB1FE, 0x9BDC06A7, 0xC19BF174,
  0xE49B69C1, 0xEFBE4786, 0x0FC19DC6, 0x240CA1CC,
  0x2DE92C6F, 0x4A7484AA, 0x5CB0A9DC, 0x76F988DA,
  0x983E5152, 0xA831C66D, 0xB00327C8, 0xBF597FC7,
  0xC6E00BF3, 0xD5A79147, 0x06CA6351, 0x14292967,
  0x27B70A85, 0x2E1B2138, 0x4D2C6DFC, 0x53380D13,
  0x650A7354, 0x766A0ABB, 0x81C2C92E, 0x92722C85,
  0xA2BFE8A1, 0xA81A664B, 0xC24B8B70, 0xC76C51A3,
  0xD192E819, 0xD6990624, 0xF40E3585, 0x106AA070,
  0x19A4C116, 0x1E376C08, 0x2748774C, 0x34B0BCB5,
  0x391C0CB3, 0x4ED8AA4A, 0x5B9CCA4F, 0x682E6FF3,
  0x748F82EE, 0x78A5636F, 0x84C87814, 0x8CC70208,
  0x90BEFFFA, 0xA4506CEB, 0xBEF9A3F7, 0xC67178F2,
];

/// The implementation is derived from [RFC6234][rfc6234] which follows the
/// [FIPS 180-4][fips180] standard for SHA and SHA-based HMAC and HKDF.
///
/// [rfc6234]: https://www.rfc-editor.org/rfc/rfc6234
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
class SHA2of512 extends BlockHash {
  final Uint32List state;
  final Uint32List chunk;

  @override
  final int hashLength;

  /// For internal use only.
  SHA2of512({
    required List<int> seed,
    required this.hashLength,
  })  : chunk = Uint32List(64),
        state = Uint32List.fromList(seed),
        super(64);

  /// Rotates x right by n bits.
  static int _bsig0(int x) =>
      (((x & _mask32) >>> 2) | ((x << 30) & _mask32)) ^
      (((x & _mask32) >>> 13) | ((x << 19) & _mask32)) ^
      (((x & _mask32) >>> 22) | ((x << 10) & _mask32));

  static int _bsig1(int x) =>
      (((x & _mask32) >>> 6) | ((x << 26) & _mask32)) ^
      (((x & _mask32) >>> 11) | ((x << 21) & _mask32)) ^
      (((x & _mask32) >>> 25) | ((x << 7) & _mask32));

  static int _ssig0(int x) =>
      (((x & _mask32) >>> 7) | ((x << 25) & _mask32)) ^
      (((x & _mask32) >>> 18) | ((x << 14) & _mask32)) ^
      (x >>> 3);

  static int _ssig1(int x) =>
      (((x & _mask32) >>> 17) | ((x << 15) & _mask32)) ^
      (((x & _mask32) >>> 19) | ((x << 13) & _mask32)) ^
      (x >>> 10);

  @override
  void $update(List<int> block, [int offset = 0, bool last = false]) {
    // Convert the block to chunk
    for (int i = 0, j = offset; i < 16; i++, j += 4) {
      chunk[i] = ((block[j] & 0xFF) << 24) |
          ((block[j + 1] & 0xFF) << 16) |
          ((block[j + 2] & 0xFF) << 8) |
          (block[j + 3] & 0xFF);
    }

    var w = chunk;
    int t1, t2, ch, maj;
    int a, b, c, d, e, f, g, h;

    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];
    e = state[4];
    f = state[5];
    g = state[6];
    h = state[7];

    // Extend the first 16 words into the 64 words
    for (int i = 16; i < 64; i++) {
      w[i] = _ssig1(w[i - 2]) + w[i - 7] + _ssig0(w[i - 15]) + w[i - 16];
    }

    for (int i = 0; i < 64; ++i) {
      ch = (e & f) ^ ((~e) & g);
      maj = (a & b) ^ (a & c) ^ (b & c);
      t1 = h + _bsig1(e) + ch + _k[i] + w[i];
      t2 = _bsig0(a) + maj;

      h = g;
      g = f;
      f = e;
      e = (d + t1) & _mask32;
      d = c;
      c = b;
      b = a;
      a = (t1 + t2) & _mask32;
    }

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
    state[4] += e;
    state[5] += f;
    state[6] += g;
    state[7] += h;
  }

  @override
  Uint8List $finalize(Uint8List block, int length) {
    // Adding the signature byte
    block[length++] = 0x80;

    // If no more space left in buffer for the message length
    if (length > 56) {
      for (; length < 64; length++) {
        block[length] = 0;
      }
      $update(block);
      length = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; length < 56; length++) {
      block[length] = 0;
    }

    // Append original message length in bits to message
    int n = messageLengthInBits;
    block[56] = n >>> 56;
    block[57] = n >>> 48;
    block[58] = n >>> 40;
    block[59] = n >>> 32;
    block[60] = n >>> 24;
    block[61] = n >>> 16;
    block[62] = n >>> 8;
    block[63] = n;

    // Update with the final block
    $update(block);

    // Convert the state to 8-bit byte array
    var bytes = Uint8List(hashLength);
    for (int j = 0, i = 0; j < hashLength; i++, j += 4) {
      bytes[j] = state[i] >>> 24;
      bytes[j + 1] = state[i] >>> 16;
      bytes[j + 2] = state[i] >>> 8;
      bytes[j + 3] = state[i];
    }
    return bytes;
  }
}
