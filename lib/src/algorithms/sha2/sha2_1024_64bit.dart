// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

// Initialize array of round 64-bit constants
const List<int> _k = [
  0x428A2F98D728AE22, 0x7137449123EF65CD, 0xB5C0FBCFEC4D3B2F, //
  0xE9B5DBA58189DBBC, 0x3956C25BF348B538, 0x59F111F1B605D019,
  0x923F82A4AF194F9B, 0xAB1C5ED5DA6D8118, 0xD807AA98A3030242,
  0x12835B0145706FBE, 0x243185BE4EE4B28C, 0x550C7DC3D5FFB4E2,
  0x72BE5D74F27B896F, 0x80DEB1FE3B1696B1, 0x9BDC06A725C71235,
  0xC19BF174CF692694, 0xE49B69C19EF14AD2, 0xEFBE4786384F25E3,
  0x0FC19DC68B8CD5B5, 0x240CA1CC77AC9C65, 0x2DE92C6F592B0275,
  0x4A7484AA6EA6E483, 0x5CB0A9DCBD41FBD4, 0x76F988DA831153B5,
  0x983E5152EE66DFAB, 0xA831C66D2DB43210, 0xB00327C898FB213F,
  0xBF597FC7BEEF0EE4, 0xC6E00BF33DA88FC2, 0xD5A79147930AA725,
  0x06CA6351E003826F, 0x142929670A0E6E70, 0x27B70A8546D22FFC,
  0x2E1B21385C26C926, 0x4D2C6DFC5AC42AED, 0x53380D139D95B3DF,
  0x650A73548BAF63DE, 0x766A0ABB3C77B2A8, 0x81C2C92E47EDAEE6,
  0x92722C851482353B, 0xA2BFE8A14CF10364, 0xA81A664BBC423001,
  0xC24B8B70D0F89791, 0xC76C51A30654BE30, 0xD192E819D6EF5218,
  0xD69906245565A910, 0xF40E35855771202A, 0x106AA07032BBD1B8,
  0x19A4C116B8D2D0C8, 0x1E376C085141AB53, 0x2748774CDF8EEB99,
  0x34B0BCB5E19B48A8, 0x391C0CB3C5C95A63, 0x4ED8AA4AE3418ACB,
  0x5B9CCA4F7763E373, 0x682E6FF3D6B2B8A3, 0x748F82EE5DEFB2FC,
  0x78A5636F43172F60, 0x84C87814A1F0AB72, 0x8CC702081A6439EC,
  0x90BEFFFA23631E28, 0xA4506CEBDE82BDE9, 0xBEF9A3F7B2C67915,
  0xC67178F2E372532B, 0xCA273ECEEA26619C, 0xD186B8C721C0C207,
  0xEADA7DD6CDE0EB1E, 0xF57D4F7FEE6ED178, 0x06F067AA72176FBA,
  0x0A637DC5A2C898A6, 0x113F9804BEF90DAE, 0x1B710B35131C471B,
  0x28DB77F523047D84, 0x32CAAB7B40C72493, 0x3C9EBE0A15C9BEBC,
  0x431D67C49C100D4C, 0x4CC5D4BECB3E42B6, 0x597F299CFC657E2A,
  0x5FCB6FAB3AD6FAEC, 0x6C44198C4A475817,
];

/// The implementation is derived from [RFC6234][rfc6234] which follows the
/// [FIPS 180-4][fips180] standard for SHA and SHA-based HMAC and HKDF.
///
/// It uses 64-bit integer operations internally which is not supported by
/// Web VM, but a lot faster.
///
/// [rfc6234]: https://www.ietf.org/rfc/rfc6234.html
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
class SHA2of1024 extends BlockHashSink {
  final List<int> seed;
  final Uint32List state;
  final Uint64List chunk;

  @override
  final int hashLength;

  /// For internal use only.
  SHA2of1024({
    required this.seed,
    required this.hashLength,
  })  : chunk = Uint64List(80),
        state = Uint32List.fromList(seed),
        super(1024 >>> 3);

  @override
  void reset() {
    state.setAll(0, seed);
    super.reset();
  }

  /// Rotates 64-bit number x by n bits
  @pragma('vm:prefer-inline')
  static int _bsig0(int x) =>
      ((x >>> 28) | (x << 36)) ^
      ((x >>> 34) | (x << 30)) ^
      ((x >>> 39) | (x << 25));

  @pragma('vm:prefer-inline')
  static int _bsig1(int x) =>
      ((x >>> 14) | (x << 50)) ^
      ((x >>> 18) | (x << 46)) ^
      ((x >>> 41) | (x << 23));

  @pragma('vm:prefer-inline')
  static int _ssig0(int x) =>
      ((x >>> 1) | (x << 63)) ^ ((x >>> 8) | (x << 56)) ^ (x >>> 7);

  @pragma('vm:prefer-inline')
  static int _ssig1(int x) =>
      ((x >>> 19) | (x << 45)) ^ ((x >>> 61) | (x << 3)) ^ (x >>> 6);

  @override
  void $update(List<int> block, [int offset = 0, bool last = false]) {
    // Convert the block to chunk
    for (int i = 0, j = offset; i < 16; i++, j += 8) {
      chunk[i] = ((block[j] & 0xFF) << 56) |
          ((block[j + 1] & 0xFF) << 48) |
          ((block[j + 2] & 0xFF) << 40) |
          ((block[j + 3] & 0xFF) << 32) |
          ((block[j + 4] & 0xFF) << 24) |
          ((block[j + 5] & 0xFF) << 16) |
          ((block[j + 6] & 0xFF) << 8) |
          (block[j + 7] & 0xFF);
    }

    var w = chunk;
    int t1, t2, ch, maj;
    int a, b, c, d, e, f, g, h;
    int ta, tb, tc, td, te, tf, tg, th;

    ta = a = (state[0] << 32) | (state[1]);
    tb = b = (state[2] << 32) | (state[3]);
    tc = c = (state[4] << 32) | (state[5]);
    td = d = (state[6] << 32) | (state[7]);
    te = e = (state[8] << 32) | (state[9]);
    tf = f = (state[10] << 32) | (state[11]);
    tg = g = (state[12] << 32) | (state[13]);
    th = h = (state[14] << 32) | (state[15]);

    // Extend the first 16 words into the 80 words (64-bit)
    for (int i = 16; i < 80; i++) {
      w[i] = _ssig1(w[i - 2]) + w[i - 7] + _ssig0(w[i - 15]) + w[i - 16];
    }

    for (int i = 0; i < 80; ++i) {
      ch = (e & f) ^ ((~e) & g);
      maj = (a & b) ^ (a & c) ^ (b & c);
      t1 = h + _bsig1(e) + ch + _k[i] + w[i];
      t2 = _bsig0(a) + maj;

      h = g;
      g = f;
      f = e;
      e = d + t1;
      d = c;
      c = b;
      b = a;
      a = t1 + t2;
    }

    ta += a;
    tb += b;
    tc += c;
    td += d;
    te += e;
    tf += f;
    tg += g;
    th += h;
    state[0] = ta >>> 32;
    state[1] = ta;
    state[2] = tb >>> 32;
    state[3] = tb;
    state[4] = tc >>> 32;
    state[5] = tc;
    state[6] = td >>> 32;
    state[7] = td;
    state[8] = te >>> 32;
    state[9] = te;
    state[10] = tf >>> 32;
    state[11] = tf;
    state[12] = tg >>> 32;
    state[13] = tg;
    state[14] = th >>> 32;
    state[15] = th;
  }

  @override
  Uint8List $finalize() {
    // Adding the signature byte
    buffer[pos++] = 0x80;

    // If no more space left in buffer for the message length
    if (pos > 112) {
      for (; pos < 128; pos++) {
        buffer[pos] = 0;
      }
      $update(buffer);
      pos = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; pos < 120; pos++) {
      buffer[pos] = 0;
    }

    // Append original message length in bits to message
    int n = messageLengthInBits;
    buffer[120] = n >>> 56;
    buffer[121] = n >>> 48;
    buffer[122] = n >>> 40;
    buffer[123] = n >>> 32;
    buffer[124] = n >>> 24;
    buffer[125] = n >>> 16;
    buffer[126] = n >>> 8;
    buffer[127] = n;

    // Update with the final block
    $update(buffer);

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
