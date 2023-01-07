// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_sink.dart';

class SHA384Sink extends _SHA2of64bit {
  SHA384Sink()
      : super(
          hashLengthInBits: 384,
          seed: [
            0xCBBB9D5D, 0xC1059ED8, // a
            0x629A292A, 0x367CD507, // b
            0x9159015A, 0x3070DD17, // c
            0x152FECD8, 0xF70E5939, // d
            0x67332667, 0xFFC00B31, // e
            0x8EB44A87, 0x68581511, // f
            0xDB0C2E0D, 0x64F98FA7, // g
            0x47B5481D, 0xBEFA4FA4, // h
          ],
        );
}

class SHA512Sink extends _SHA2of64bit {
  SHA512Sink()
      : super(
          hashLengthInBits: 512,
          seed: [
            0x6A09E667, 0xF3BCC908, // a
            0xBB67AE85, 0x84CAA73B, // b
            0x3C6EF372, 0xFE94F82B, // c
            0xA54FF53A, 0x5F1D36F1, // d
            0x510E527F, 0xADE682D1, // e
            0x9B05688C, 0x2B3E6C1F, // f
            0x1F83D9AB, 0xFB41BD6B, // g
            0x5BE0CD19, 0x137E2179, // h
          ],
        );
}

class SHA512t224Sink extends _SHA2of64bit {
  SHA512t224Sink()
      : super(
          hashLengthInBits: 224,
          seed: [
            0x8C3D37C8, 0x19544DA2, // a
            0x73E19966, 0x89DCD4D6, // b
            0x1DFAB7AE, 0x32FF9C82, // c
            0x679DD514, 0x582F9FCF, // d
            0x0F6D2B69, 0x7BD44DA8, // e
            0x77E36F73, 0x04C48942, // f
            0x3F9D85A8, 0x6A1D36C8, // g
            0x1112E6AD, 0x91D692A1, // h
          ],
        );
}

class SHA512t256Sink extends _SHA2of64bit {
  SHA512t256Sink()
      : super(
          hashLengthInBits: 256,
          seed: [
            0x22312194, 0xFC2BF72C, // a
            0x9F555FA3, 0xC84C64C2, // b
            0x2393B86B, 0x6F53B151, // c
            0x96387719, 0x5940EABD, // d
            0x96283EE2, 0xA88EFFE3, // e
            0xBE5E1E25, 0x53863992, // f
            0x2B0199FC, 0x2C85B8AA, // g
            0x0EB72DDC, 0x81C52CA2, // h
          ],
        );
}

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

/// The implementation is derived from the US Secure Hash Algorithms document
/// of [SHA and SHA-based HMAC and HKDF][rfc6234].
///
/// [rfc6234]: https://www.rfc-editor.org/rfc/rfc6234
abstract class _SHA2of64bit extends HashSink {
  final Uint64List _extended = Uint64List(80);

  /// For internal use only.
  _SHA2of64bit({
    required List<int> seed,
    required int hashLengthInBits,
  }) : super(
          seed: seed,
          signatureLength: 16,
          blockLengthInBits: 1024,
          hashLengthInBits: hashLengthInBits,
        );

  /// Rotates 64-bit number `(w[i] << 32) | w[i+1]` right by n bits in place
  // void _rotr32(Uint32List w, int i, int n) {
  //   // x = w[i] << 32 | w[i+1]
  //   // original: (x << (32 - n)) | (x >>> n)
  //   var a = w[i];
  //   var b = w[i + 1];
  //   if (n == 32) {
  //     w[i] = b;
  //     w[i + 1] = a;
  //   } else if (n < 32) {
  //     w[i] = (b << (32 - n)) | (a >>> n);
  //     w[i + 1] = (a << (32 - n)) | (b >>> n);
  //   } else if (n > 31) {
  //     w[i] = (a << (32 - n)) | (b >>> n);
  //     w[i + 1] = (b << (32 - n)) | (a >>> n);
  //   }
  // }

  /// Rotates 64-bit number x by n bits
  int _rotr(int x, int n) => (x >>> n) | (x << (64 - n));

  int _bsig0(int x) => (_rotr(x, 28) ^ _rotr(x, 34) ^ _rotr(x, 39));

  int _bsig1(int x) => (_rotr(x, 14) ^ _rotr(x, 18) ^ _rotr(x, 41));

  int _ssig0(int x) => (_rotr(x, 1) ^ _rotr(x, 8) ^ (x >>> 7));

  int _ssig1(int x) => (_rotr(x, 19) ^ _rotr(x, 61) ^ (x >>> 6));

  @override
  void update(Uint32List block) {
    var w = _extended;
    for (int i = 0; i < 32; i += 2) {
      w[i >> 1] = (block[i] << 32) | block[i + 1];
    }

    int a, b, c, d, e, f, g, h;
    int ta, tb, tc, td, te, tf, tg, th;
    ta = a = (state[0] << 32) | state[1];
    tb = b = (state[2] << 32) | state[3];
    tc = c = (state[4] << 32) | state[5];
    td = d = (state[6] << 32) | state[7];
    te = e = (state[8] << 32) | state[9];
    tf = f = (state[10] << 32) | state[11];
    tg = g = (state[12] << 32) | state[13];
    th = h = (state[14] << 32) | state[15];

    // Extend the first 16 words into the 80 words (64-bit)
    for (int i = 16; i < 80; i++) {
      w[i] = _ssig1(w[i - 2]) + w[i - 7] + _ssig0(w[i - 15]) + w[i - 16];
    }

    for (int i = 0; i < 80; ++i) {
      var ch = (e & f) ^ ((~e) & g);
      var t1 = h + _bsig1(e) + ch + _k[i] + w[i];
      var t2 = _bsig0(a) + ((a & b) ^ (a & c) ^ (b & c));

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

    state[0] = ta >> 32;
    state[1] = ta;
    state[2] = tb >> 32;
    state[3] = tb;
    state[4] = tc >> 32;
    state[5] = tc;
    state[6] = td >> 32;
    state[7] = td;
    state[8] = te >> 32;
    state[9] = te;
    state[10] = tf >> 32;
    state[11] = tf;
    state[12] = tg >> 32;
    state[13] = tg;
    state[14] = th >> 32;
    state[15] = th;
  }
}
