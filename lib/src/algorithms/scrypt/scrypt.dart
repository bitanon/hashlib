// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/algorithms/pbkdf2.dart';
import 'package:hashlib/src/algorithms/scrypt/security.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/kdf_base.dart';
import 'package:hashlib/src/hmac.dart';
import 'package:hashlib/src/random.dart';
import 'package:hashlib/src/sha256.dart';

const int _mask32 = 0xFFFFFFFF;

/// This is an implementation of Password Based Key Derivation Algorithm,
/// scrypt derived from [RFC-7914][rfc], which internally uses [PBKDF2].
///
/// The function derives one or more secret keys from a secret string. It is
/// based on memory-hard functions, which offer added protection against
/// attacks using custom hardware.
///
/// The strength of the generated password using scrypt depends on the
/// CPU/Memory cost, block size and parallelism parameters. Poor parameter
/// choices can be harmful for security; for example, if you tune the
/// parameters so that memory use is reduced to small amounts that will affect
/// the properties of the algorithm.
///
/// [rfc]: https://www.rfc-editor.org/rfc/rfc7914.html
class Scrypt extends KeyDerivatorBase {
  /// The byte array containing salt
  final List<int> salt;

  /// CPU/Memory cost parameter (N)
  final int cost;

  /// Block size parameter (r)
  final int blockSize;

  /// Parallelization parameter (p)
  final int parallelism;

  @override
  final int derivedKeyLength;

  const Scrypt._({
    required this.salt,
    required this.cost,
    required this.blockSize,
    required this.parallelism,
    required this.derivedKeyLength,
  });

  /// Creates an [Scrypt] instance with a sink for MAC generation.
  factory Scrypt({
    List<int>? salt,
    required int cost,
    int blockSize = 8,
    int parallelism = 1,
    int derivedKeyLength = 64,
  }) {
    // validate parameters
    if (cost < 1) {
      throw StateError('The cost must be at least 1');
    }
    if (cost > 0xFFFFFF) {
      throw StateError('The cost must be less than 2^24');
    }
    if (cost & (cost - 1) != 0) {
      throw StateError('The cost must be a power of 2');
    }
    if (derivedKeyLength < 1) {
      throw StateError('The derivedKeyLength must be at least 1');
    }
    if (blockSize < 1) {
      throw StateError('The blockSize must be at least 1');
    }
    if (parallelism < 1) {
      throw StateError('The parallelism must be at least 1');
    }
    if (blockSize * parallelism > 0x1FFFFFF) {
      throw StateError('The blockSize * parallelism is too big');
    }
    salt ??= randomBytes(16);

    // create instance
    return Scrypt._(
      salt: salt,
      cost: cost,
      blockSize: blockSize,
      parallelism: parallelism,
      derivedKeyLength: derivedKeyLength,
    );
  }

  /// Creates an [Scrypt] instance from [ScryptSecurity] parameter.
  factory Scrypt.fromSecurity(
    ScryptSecurity security, {
    List<int>? salt,
  }) {
    return Scrypt(
      salt: salt,
      cost: security.N,
      blockSize: security.r,
      parallelism: security.p,
    );
  }

  /// Generate a derived key using the scrypt algorithm.
  @override
  HashDigest convert(List<int> password) {
    int N = cost;
    int midRO = (blockSize << 4);
    int roLength = (blockSize << 7);
    int roLength32 = (roLength >>> 2);
    int innerKeyLength = parallelism * roLength;
    int innerKeyLength32 = parallelism * roLength32;
    List<Uint32List> acc = List.generate(N, (_) => Uint32List(roLength32));
    Uint32List inp = Uint32List(roLength32);
    Uint32List out = Uint32List(roLength32);
    Uint32List t = Uint32List(16);
    Uint32List v;

    // Derive the inner blocks
    var mac = sha256.hmac(password);
    var inner = PBKDF2(mac, salt, 1, innerKeyLength).convert();
    var inner32 = Uint32List.view(inner.buffer);

    /// [length] = 128 * r = 2 * 64 * r = 4 * 32 * r bytes
    @pragma('vm:prefer-inline')
    void blockMix() {
      int i, j, p, q;
      p = 0;
      q = midRO;
      for (j = 0; j < 16; j++) {
        t[j] = inp[roLength32 - 16 + j];
      }
      for (i = 0; i < roLength32; i += 32) {
        // even
        for (j = 0; j < 16; j++) {
          t[j] ^= inp[i + j];
        }
        _salsa20(t);
        for (j = 0; j < 16; j++, p++) {
          out[p] = t[j];
        }

        // odd
        for (j = 0; j < 16; j++) {
          t[j] ^= inp[i + j + 16];
        }
        _salsa20(t);
        for (j = 0; j < 16; j++, q++) {
          out[q] = t[j];
        }
      }
    }

    // Mix the inner blocks to derive the outer salt
    for (int i, j, k = 0; k < innerKeyLength32; k += roLength32) {
      /// Number of iterations, [N] is a power of 2
      /// length of [x] = 128 * r = 2 * 64 * r = 4 * 32 * r bytes
      for (j = 0; j < roLength32; ++j) {
        inp[j] = inner32[j + k];
      }
      for (i = 0; i < N; ++i) {
        v = acc[i];
        for (j = 0; j < roLength32; ++j) {
          v[j] = inp[j];
        }
        blockMix();
        // swap inp <-> out
        v = inp;
        inp = out;
        out = v;
      }
      for (i = 0; i < N; ++i) {
        v = acc[inp[roLength32 - 16] & (N - 1)];
        for (j = 0; j < roLength32; ++j) {
          inp[j] ^= v[j];
        }
        blockMix();
        // swap inp <-> out
        v = inp;
        inp = out;
        out = v;
      }
      for (j = 0; j < roLength32; ++j) {
        inner32[j + k] = inp[j];
      }
    }

    // Derive final blocks with the outer salt
    return PBKDF2(mac, inner.bytes, 1, derivedKeyLength).convert(password);
  }

  @pragma('vm:prefer-inline')
  static int _rotl32(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  /// size of [b] = 4 * 16 = 64 bytes
  static void _salsa20(Uint32List b) {
    int i, x0, x1, x2, x3, x4, x5, x6, x7, x8, x9, x10, x11, x12, x13, x14, x15;

    x0 = b[0];
    x1 = b[1];
    x2 = b[2];
    x3 = b[3];
    x4 = b[4];
    x5 = b[5];
    x6 = b[6];
    x7 = b[7];
    x8 = b[8];
    x9 = b[9];
    x10 = b[10];
    x11 = b[11];
    x12 = b[12];
    x13 = b[13];
    x14 = b[14];
    x15 = b[15];

    for (i = 8; i > 0; i -= 2) {
      x4 ^= _rotl32(x0 + x12, 7);
      x8 ^= _rotl32(x4 + x0, 9);
      x12 ^= _rotl32(x8 + x4, 13);
      x0 ^= _rotl32(x12 + x8, 18);
      x9 ^= _rotl32(x5 + x1, 7);
      x13 ^= _rotl32(x9 + x5, 9);
      x1 ^= _rotl32(x13 + x9, 13);
      x5 ^= _rotl32(x1 + x13, 18);
      x14 ^= _rotl32(x10 + x6, 7);
      x2 ^= _rotl32(x14 + x10, 9);
      x6 ^= _rotl32(x2 + x14, 13);
      x10 ^= _rotl32(x6 + x2, 18);
      x3 ^= _rotl32(x15 + x11, 7);
      x7 ^= _rotl32(x3 + x15, 9);
      x11 ^= _rotl32(x7 + x3, 13);
      x15 ^= _rotl32(x11 + x7, 18);
      x1 ^= _rotl32(x0 + x3, 7);
      x2 ^= _rotl32(x1 + x0, 9);
      x3 ^= _rotl32(x2 + x1, 13);
      x0 ^= _rotl32(x3 + x2, 18);
      x6 ^= _rotl32(x5 + x4, 7);
      x7 ^= _rotl32(x6 + x5, 9);
      x4 ^= _rotl32(x7 + x6, 13);
      x5 ^= _rotl32(x4 + x7, 18);
      x11 ^= _rotl32(x10 + x9, 7);
      x8 ^= _rotl32(x11 + x10, 9);
      x9 ^= _rotl32(x8 + x11, 13);
      x10 ^= _rotl32(x9 + x8, 18);
      x12 ^= _rotl32(x15 + x14, 7);
      x13 ^= _rotl32(x12 + x15, 9);
      x14 ^= _rotl32(x13 + x12, 13);
      x15 ^= _rotl32(x14 + x13, 18);
    }

    b[0] += x0;
    b[1] += x1;
    b[2] += x2;
    b[3] += x3;
    b[4] += x4;
    b[5] += x5;
    b[6] += x6;
    b[7] += x7;
    b[8] += x8;
    b[9] += x9;
    b[10] += x10;
    b[11] += x11;
    b[12] += x12;
    b[13] += x13;
    b[14] += x14;
    b[15] += x15;
  }
}
