// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

// Initialize array of round 64-bit constants
const List<int> _k = [
  0x428A2F98, 0xD728AE22, 0x71374491, 0x23EF65CD, 0xB5C0FBCF, 0xEC4D3B2F, //
  0xE9B5DBA5, 0x8189DBBC, 0x3956C25B, 0xF348B538, 0x59F111F1, 0xB605D019,
  0x923F82A4, 0xAF194F9B, 0xAB1C5ED5, 0xDA6D8118, 0xD807AA98, 0xA3030242,
  0x12835B01, 0x45706FBE, 0x243185BE, 0x4EE4B28C, 0x550C7DC3, 0xD5FFB4E2,
  0x72BE5D74, 0xF27B896F, 0x80DEB1FE, 0x3B1696B1, 0x9BDC06A7, 0x25C71235,
  0xC19BF174, 0xCF692694, 0xE49B69C1, 0x9EF14AD2, 0xEFBE4786, 0x384F25E3,
  0x0FC19DC6, 0x8B8CD5B5, 0x240CA1CC, 0x77AC9C65, 0x2DE92C6F, 0x592B0275,
  0x4A7484AA, 0x6EA6E483, 0x5CB0A9DC, 0xBD41FBD4, 0x76F988DA, 0x831153B5,
  0x983E5152, 0xEE66DFAB, 0xA831C66D, 0x2DB43210, 0xB00327C8, 0x98FB213F,
  0xBF597FC7, 0xBEEF0EE4, 0xC6E00BF3, 0x3DA88FC2, 0xD5A79147, 0x930AA725,
  0x06CA6351, 0xE003826F, 0x14292967, 0x0A0E6E70, 0x27B70A85, 0x46D22FFC,
  0x2E1B2138, 0x5C26C926, 0x4D2C6DFC, 0x5AC42AED, 0x53380D13, 0x9D95B3DF,
  0x650A7354, 0x8BAF63DE, 0x766A0ABB, 0x3C77B2A8, 0x81C2C92E, 0x47EDAEE6,
  0x92722C85, 0x1482353B, 0xA2BFE8A1, 0x4CF10364, 0xA81A664B, 0xBC423001,
  0xC24B8B70, 0xD0F89791, 0xC76C51A3, 0x0654BE30, 0xD192E819, 0xD6EF5218,
  0xD6990624, 0x5565A910, 0xF40E3585, 0x5771202A, 0x106AA070, 0x32BBD1B8,
  0x19A4C116, 0xB8D2D0C8, 0x1E376C08, 0x5141AB53, 0x2748774C, 0xDF8EEB99,
  0x34B0BCB5, 0xE19B48A8, 0x391C0CB3, 0xC5C95A63, 0x4ED8AA4A, 0xE3418ACB,
  0x5B9CCA4F, 0x7763E373, 0x682E6FF3, 0xD6B2B8A3, 0x748F82EE, 0x5DEFB2FC,
  0x78A5636F, 0x43172F60, 0x84C87814, 0xA1F0AB72, 0x8CC70208, 0x1A6439EC,
  0x90BEFFFA, 0x23631E28, 0xA4506CEB, 0xDE82BDE9, 0xBEF9A3F7, 0xB2C67915,
  0xC67178F2, 0xE372532B, 0xCA273ECE, 0xEA26619C, 0xD186B8C7, 0x21C0C207,
  0xEADA7DD6, 0xCDE0EB1E, 0xF57D4F7F, 0xEE6ED178, 0x06F067AA, 0x72176FBA,
  0x0A637DC5, 0xA2C898A6, 0x113F9804, 0xBEF90DAE, 0x1B710B35, 0x131C471B,
  0x28DB77F5, 0x23047D84, 0x32CAAB7B, 0x40C72493, 0x3C9EBE0A, 0x15C9BEBC,
  0x431D67C4, 0x9C100D4C, 0x4CC5D4BE, 0xCB3E42B6, 0x597F299C, 0xFC657E2A,
  0x5FCB6FAB, 0x3AD6FAEC, 0x6C44198C, 0x4A475817,
];

const int _sig1 = 0;
const int _sig2 = _sig1 + 2;
const int _sig3 = _sig2 + 2;
const int _sig4 = _sig3 + 2;
const int _a = _sig4 + 2;
const int _b = _a + 2;
const int _c = _b + 2;
const int _d = _c + 2;
const int _e = _d + 2;
const int _f = _e + 2;
const int _g = _f + 2;
const int _h = _g + 2;
const int _t1 = _h + 2;
const int _t2 = _t1 + 2;
const int _t3 = _t2 + 2;
const int _t4 = _t3 + 2;
const int _t5 = _t4 + 2;

/// The implementation is derived from [RFC6234][rfc6234] which follows the
/// [FIPS 180-4][fips180] standard for SHA and SHA-based HMAC and HKDF.
///
/// It uses 32-bit integers to accommodate 64-bit integer operations, designed
/// specially to be supported by Web VM. It is albeit slower than the native
/// implementation.
///
/// [rfc6234]: https://www.rfc-editor.org/rfc/rfc6234
/// [fips180]: https://csrc.nist.gov/publications/detail/fips/180/4/final
class SHA2of1024 extends BlockHash {
  final List<int> seed;
  final Uint32List state;
  final Uint32List chunk;
  final _var = Uint32List(_t5 + 2);

  /// For internal use only.
  SHA2of1024({
    required this.seed,
    required int hashLength,
  })  : chunk = Uint32List(160),
        state = Uint32List.fromList(seed),
        super(
          blockLength: 1024 >>> 3,
          hashLength: hashLength,
        );

  /// z = x ^ y
  static void _xor(List<int> x, int i, List<int> y, int j, List<int> z, int k) {
    z[k] = x[i] ^ y[j];
    z[k + 1] = x[i + 1] ^ y[j + 1];
  }

  /// z = x + y
  static void _add(List<int> x, int i, List<int> y, int j, List<int> z, int k) {
    z[k + 1] = x[i + 1] + y[j + 1];
    z[k] = x[i] + y[j] + (z[k + 1] < x[i + 1] ? 1 : 0);
  }

  /// x += z
  static void _addAndSet(List<int> x, int i, List<int> z, int j) {
    var t = x[i + 1];
    x[i + 1] += z[j + 1];
    x[i] += z[j] + (x[i + 1] < t ? 1 : 0);
  }

  // x >>> n
  static void _shr(int n, List<int> x, int i, List<int> z, int k) {
    var a = x[i];
    var b = x[i + 1];
    if (n == 32) {
      z[k] = 0;
      z[k + 1] = a;
    } else if (n < 32) {
      z[k] = a >>> n;
      z[k + 1] = (a << (32 - n)) | (b >>> n);
    } else {
      z[k] = 0;
      z[k + 1] = a >>> (n - 32);
    }
  }

  // (x << (64 - n)) | (x >>> n)
  static void _rotr(int n, List<int> x, int i, List<int> z, int k) {
    var a = x[i];
    var b = x[i + 1];
    if (n == 32) {
      z[k] = b;
      z[k + 1] = a;
    } else if (n < 32) {
      z[k] = (b << (32 - n)) | (a >>> n);
      z[k + 1] = (a << (32 - n)) | (b >>> n);
    } else {
      z[k] = (a << (64 - n)) | (b >>> (n - 32));
      z[k + 1] = (b << (64 - n)) | (a >>> (n - 32));
    }
  }

  // z = _rotr(x, 28) ^ _rotr(x, 34) ^ _rotr(x, 39)
  void _bsig0(List<int> x, int i, List<int> z, int j) {
    _rotr(28, x, i, _var, _sig1);
    _rotr(34, x, i, _var, _sig2);
    _rotr(39, x, i, _var, _sig3);
    _xor(_var, _sig2, _var, _sig3, _var, _sig4);
    _xor(_var, _sig1, _var, _sig4, z, j);
  }

  // z = _rotr(x, 14) ^ _rotr(x, 18) ^ _rotr(x, 41)
  void _bsig1(List<int> x, int i, List<int> z, int j) {
    _rotr(14, x, i, _var, _sig1);
    _rotr(18, x, i, _var, _sig2);
    _rotr(41, x, i, _var, _sig3);
    _xor(_var, _sig2, _var, _sig3, _var, _sig4);
    _xor(_var, _sig1, _var, _sig4, z, j);
  }

  // z = _rotr(x, 1) ^ _rotr(x, 8) ^ (x >>> 7)
  void _ssig0(List<int> x, int i, List<int> z, int j) {
    _rotr(1, x, i, _var, _sig1);
    _rotr(8, x, i, _var, _sig2);
    _shr(7, x, i, _var, _sig3);
    _xor(_var, _sig2, _var, _sig3, _var, _sig4);
    _xor(_var, _sig1, _var, _sig4, z, j);
  }

  // z = _rotr(x, 19) ^ _rotr(x, 61) ^ (x >>> 6)
  void _ssig1(List<int> x, int i, List<int> z, int j) {
    _rotr(19, x, i, _var, _sig1);
    _rotr(61, x, i, _var, _sig2);
    _shr(6, x, i, _var, _sig3);
    _xor(_var, _sig2, _var, _sig3, _var, _sig4);
    _xor(_var, _sig1, _var, _sig4, z, j);
  }

  // z = (e & f) ^ ((~e) & g)
  static void _ch(List<int> e, int i, List<int> f, int j, List<int> g, int k,
      List<int> z, int l) {
    z[l] = (e[i] & (f[j] ^ g[k])) ^ g[k];
    z[l + 1] = (e[i + 1] & (f[j + 1] ^ g[k + 1])) ^ g[k + 1];
  }

  // z = (a & b) ^ (a & c) ^ (b & c)
  static void _maj(List<int> a, int i, List<int> b, int j, List<int> c, int k,
      List<int> z, int l) {
    z[l] = (a[i] & (b[j] | c[k])) | (b[j] & c[k]);
    z[l + 1] = (a[i + 1] & (b[j + 1] | c[k + 1])) | (b[j + 1] & c[k + 1]);
  }

  @override
  void $update(List<int> block, [int offset = 0]) {
    var w = chunk;

    _var.setAll(_a, state);

    // Convert the block to chunk
    for (int i = 0, j = offset; i < 32; i++, j += 4) {
      w[i] = ((block[j] & 0xFF) << 24) |
          ((block[j + 1] & 0xFF) << 16) |
          ((block[j + 2] & 0xFF) << 8) |
          ((block[j + 3] & 0xFF));
    }

    // Extend the first 32 words into nest 160 words
    for (var i = 32; i < 160; i += 2) {
      // w[i] = _ssig1(w[i - 2]) + w[i - 7] + _ssig0(w[i - 15]) + w[i - 16];
      _ssig1(w, i - 4, _var, _t1);
      _add(_var, _t1, w, i - 14, _var, _t2);
      _ssig0(w, i - 30, _var, _t1);
      _add(_var, _t1, w, i - 32, _var, _t3);
      _add(_var, _t2, _var, _t3, w, i);
    }

    for (int i = 0; i < 160; i += 2) {
      // t1 = h + _bsig1(e) + _ch(e, f, g) + k[i] + w[i];
      _bsig1(_var, _e, _var, _t1);
      _add(_var, _h, _var, _t1, _var, _t2);
      _ch(_var, _e, _var, _f, _var, _g, _var, _t3);
      _add(_var, _t2, _var, _t3, _var, _t4);
      _add(_k, i, w, i, _var, _t5);
      _add(_var, _t4, _var, _t5, _var, _t1);

      // t2 = _bsig0(A) + _maj(a, b, c);
      _bsig0(_var, _a, _var, _t3);
      _maj(_var, _a, _var, _b, _var, _c, _var, _t4);
      _add(_var, _t3, _var, _t4, _var, _t2);

      // h = g;
      _var[_h] = _var[_g];
      _var[_h + 1] = _var[_g + 1];
      // g = f;
      _var[_g] = _var[_f];
      _var[_g + 1] = _var[_f + 1];
      // f = e;
      _var[_f] = _var[_e];
      _var[_f + 1] = _var[_e + 1];
      // e = d + t1;
      _add(_var, _d, _var, _t1, _var, _e);
      // d = c;
      _var[_d] = _var[_c];
      _var[_d + 1] = _var[_c + 1];
      // c = b;
      _var[_c] = _var[_b];
      _var[_c + 1] = _var[_b + 1];
      // b = a;
      _var[_b] = _var[_a];
      _var[_b + 1] = _var[_a + 1];
      // a = t1 + t2;
      _add(_var, _t1, _var, _t2, _var, _a);
    }

    _addAndSet(state, 0, _var, _a);
    _addAndSet(state, 2, _var, _b);
    _addAndSet(state, 4, _var, _c);
    _addAndSet(state, 6, _var, _d);
    _addAndSet(state, 8, _var, _e);
    _addAndSet(state, 10, _var, _f);
    _addAndSet(state, 12, _var, _g);
    _addAndSet(state, 14, _var, _h);
  }

  @override
  Uint8List $finalize(Uint8List block, int length) {
    // Adding the signature byte
    block[length++] = 0x80;

    // If no more space left in buffer for the message length
    if (length > 112) {
      for (; length < 128; length++) {
        block[length] = 0;
      }
      $update(block);
      length = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; length < 120; length++) {
      block[length] = 0;
    }

    // Append original message length in bits to message
    int n = messageLengthInBits;
    block[120] = n >>> 56;
    block[121] = n >>> 48;
    block[122] = n >>> 40;
    block[123] = n >>> 32;
    block[124] = n >>> 24;
    block[125] = n >>> 16;
    block[126] = n >>> 8;
    block[127] = n;

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
