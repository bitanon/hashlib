// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:collection';
import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask32 = 0xFFFFFFFF;

const int _stripeLen = 64;
const int _midSizeMax = 240;
const int _minSecretSize = 136;

// Pseudorandom secret taken directly from FARSH (little-endian)
const List<int> _kSecret = <int>[
  0xb8, 0xfe, 0x6c, 0x39, 0x23, 0xa4, 0x4b, 0xbe, 0x7c, 0x01, 0x81, 0x2c, //
  0xf7, 0x21, 0xad, 0x1c, 0xde, 0xd4, 0x6d, 0xe9, 0x83, 0x90, 0x97, 0xdb,
  0x72, 0x40, 0xa4, 0xa4, 0xb7, 0xb3, 0x67, 0x1f, 0xcb, 0x79, 0xe6, 0x4e,
  0xcc, 0xc0, 0xe5, 0x78, 0x82, 0x5a, 0xd0, 0x7d, 0xcc, 0xff, 0x72, 0x21,
  0xb8, 0x08, 0x46, 0x74, 0xf7, 0x43, 0x24, 0x8e, 0xe0, 0x35, 0x90, 0xe6,
  0x81, 0x3a, 0x26, 0x4c, 0x3c, 0x28, 0x52, 0xbb, 0x91, 0xc3, 0x00, 0xcb,
  0x88, 0xd0, 0x65, 0x8b, 0x1b, 0x53, 0x2e, 0xa3, 0x71, 0x64, 0x48, 0x97,
  0xa2, 0x0d, 0xf9, 0x4e, 0x38, 0x19, 0xef, 0x46, 0xa9, 0xde, 0xac, 0xd8,
  0xa8, 0xfa, 0x76, 0x3f, 0xe3, 0x9c, 0x34, 0x3f, 0xf9, 0xdc, 0xbb, 0xc7,
  0xc7, 0x0b, 0x4f, 0x1d, 0x8a, 0x51, 0xe0, 0x4b, 0xcd, 0xb4, 0x59, 0x31,
  0xc8, 0x9f, 0x7e, 0xc9, 0xd9, 0x78, 0x73, 0x64, 0xea, 0xc5, 0xac, 0x83,
  0x34, 0xd3, 0xeb, 0xc3, 0xc5, 0x81, 0xa0, 0xff, 0xfa, 0x13, 0x63, 0xeb,
  0x17, 0x0d, 0xdd, 0x51, 0xb7, 0xf0, 0xda, 0x49, 0xd3, 0x16, 0x55, 0x26,
  0x29, 0xd4, 0x68, 0x9e, 0x2b, 0x16, 0xbe, 0x58, 0x7d, 0x47, 0xa1, 0xfc,
  0x8f, 0xf8, 0xb8, 0xd1, 0x7a, 0xd0, 0x31, 0xce, 0x45, 0xcb, 0x3a, 0x8f,
  0x95, 0x16, 0x04, 0x28, 0xaf, 0xd7, 0xfb, 0xca, 0xbb, 0x4b, 0x40, 0x7e,
];

class XX3Hash64bSink extends BlockHashSink {
  final int seed;
  final Uint64List secret;
  final Uint64List acc = Uint64List(8);
  final ListQueue<int> last = ListQueue<int>(_midSizeMax);
  late final Uint64List qbuffer = buffer.buffer.asUint64List();

  @override
  final int hashLength = 8;

  static const int prime32_1 = 0x9E3779B1;
  static const int prime32_2 = 0x85EBCA77;
  static const int prime32_3 = 0xC2B2AE3D;
  static const int prime64_1 = 0x9E3779B185EBCA87;
  static const int prime64_2 = 0xC2B2AE3D27D4EB4F;
  static const int prime64_3 = 0x165667B19E3779F9;
  static const int prime64_4 = 0x85EBCA77C2B2AE63;
  static const int prime64_5 = 0x27D4EB2F165667C5;

  factory XX3Hash64bSink.withSeed(int seed) {
    if (seed == 0) {
      return XX3Hash64bSink.withSecret();
    }
    Uint64List secret = Uint8List.fromList(_kSecret).buffer.asUint64List();
    for (int i = 0; i < secret.length; i += 2) {
      secret[i] += seed;
    }
    for (int i = 1; i < secret.length; i += 2) {
      secret[i] -= seed;
    }
    return XX3Hash64bSink._(
      seed: seed,
      secret: secret,
    );
  }

  factory XX3Hash64bSink.withSecret([Uint64List? secret]) {
    secret ??= Uint8List.fromList(_kSecret).buffer.asUint64List();
    if (secret.lengthInBytes < _minSecretSize) {
      throw ArgumentError('The secret length must be at least $_minSecretSize');
    }
    return XX3Hash64bSink._(
      seed: 0,
      secret: secret,
    );
  }

  XX3Hash64bSink._({
    required this.seed,
    required this.secret,
  }) : super((secret.lengthInBytes - _stripeLen) << 3) {
    reset();
  }

  @override
  void reset() {
    super.reset();
    acc[0] = prime32_3;
    acc[1] = prime64_1;
    acc[2] = prime64_2;
    acc[3] = prime64_3;
    acc[4] = prime64_4;
    acc[5] = prime32_2;
    acc[6] = prime64_5;
    acc[7] = prime32_1;
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
      if (last.length == _midSizeMax) {
        last.removeFirst();
      }
      last.add(buffer[pos]);
    }
    if (pos == blockLength) {
      $update();
      pos = 0;
    }
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int n, i, v, l, k;
    k = secret.length - 8;
    // accumulate
    for (n = 0; n < k; n++) {
      l = n << 3;
      for (i = 0; i < acc.length; i++) {
        v = qbuffer[l + i];
        acc[i] += v;
        v ^= secret[n + i];
        acc[i] += (v & _mask32) * (v >>> 32);
      }
    }
    // scramble
    for (i = 0; i < 8; ++i) {
      acc[i] ^= acc[i] >>> 47;
      acc[i] ^= secret[k + i];
      acc[i] *= prime32_1;
    }
  }

  static int _avalanche(int _hash) {
    _hash ^= _hash >>> 37;
    _hash *= 0x165667919E3779F9;
    _hash ^= _hash >>> 32;
    return _hash;
  }

  int _finalizeLong(Uint64List stripe) {
    int _hash;
    int t, n, i, v, l, a, b;
    var key = secret.buffer.asByteData();

    // accumulate last partial block
    for (t = n = 0; t + 64 <= pos; n++, t += 64) {
      l = n << 3;
      for (i = 0; i < acc.length; i++) {
        v = qbuffer[l + i];
        acc[i] += v;
        v ^= secret[n + i];
        acc[i] += (v & _mask32) * (v >>> 32);
      }
    }

    // print(acc.buffer.asUint32List());

    // last stripe
    if (messageLength & 63 != 0) {
      t = key.lengthInBytes - 64 - 7;
      for (i = 0; i < acc.length; i++) {
        v = stripe[i];
        acc[i] += v;
        v ^= key.getUint64(t + (i << 3), Endian.little);
        acc[i] += (v & _mask32) * (v >>> 32);
      }
    }

    // converge into final hash
    _hash = messageLength * prime64_1;
    for (i = 0; i < 8; i += 2) {
      t = i << 3;
      a = key.getUint64(11 + t, Endian.little);
      b = key.getUint64(11 + t + 8, Endian.little);
      _hash += _fold64(acc[i] ^ a, acc[i + 1] ^ b);
    }

    // avalanche
    return _avalanche(_hash);
  }

  static int _swap32(int x) =>
      ((x << 24) & 0xff000000) |
      ((x << 8) & 0x00ff0000) |
      ((x >>> 8) & 0x0000ff00) |
      ((x >>> 24) & 0x000000ff);

  static int _swap64(int x) =>
      ((x << 56) & 0xff00000000000000) |
      ((x << 40) & 0x00ff000000000000) |
      ((x << 24) & 0x0000ff0000000000) |
      ((x << 8) & 0x000000ff00000000) |
      ((x >>> 8) & 0x00000000ff000000) |
      ((x >>> 24) & 0x0000000000ff0000) |
      ((x >>> 40) & 0x000000000000ff00) |
      ((x >>> 56) & 0x00000000000000ff);

  static int _rotl64(int x, int n) => (x << n) | (x >>> (64 - n));

  // Multiply two 64-bit numbers to get 128-bit number and
  // xor the low bits of the product with the high bits
  static int _fold64(int a, int b) {
    int al = a & _mask32;
    int ah = a >>> 32;
    int bl = b & _mask32;
    int bh = b >>> 32;

    int ll = al * bl;
    int hl = ah * bl;
    int lh = al * bh;
    int hh = ah * bh;

    int cross = (ll >>> 32) + (hl & _mask32) + lh;
    int upper = (hl >>> 32) + (cross >>> 32) + hh;
    int lower = (cross << 32) | (ll & _mask32);

    return upper ^ lower;
  }

  static int _mix16B(ByteData input, int i, ByteData key, int j, int seed) {
    int lhs, rhs;
    lhs = key.getUint64(j, Endian.little) + seed;
    rhs = key.getUint64(j + 8, Endian.little) - seed;
    lhs ^= input.getUint64(i, Endian.little);
    rhs ^= input.getUint64(i + 8, Endian.little);
    return _fold64(lhs, rhs);
  }

  int _finalizeShort(ByteData input, int length, ByteData key) {
    int _hash, i, lhs, rhs, a, b, c;
    if (length == 0) {
      // XXH3_len_0_64b
      _hash = seed;
      _hash += prime64_1;
      _hash ^= key.getUint64(56, Endian.little);
      _hash ^= key.getUint64(64, Endian.little);
    } else if (length <= 3) {
      // XXH3_len_1to3_64b
      a = input.getUint8(0);
      b = input.getUint8(length > 1 ? 1 : 0);
      c = input.getUint8(length - 1);
      _hash = key.getUint32(0, Endian.little);
      _hash ^= key.getUint32(4, Endian.little);
      _hash += seed;
      _hash ^= (a << 16) | (b << 24) | (c) | (length << 8);
      _hash *= prime64_1;
    } else if (length <= 8) {
      // XXH3_len_4to8_64b
      rhs = input.getUint32(0, Endian.little);
      lhs = input.getUint32(length - 4, Endian.little);
      _hash = key.getUint64(8, Endian.little);
      _hash ^= key.getUint64(16, Endian.little);
      _hash -= seed ^ (_swap32(seed & _mask32) << 32);
      _hash ^= (rhs << 32) | lhs;
      // rrmxmx mix
      _hash ^= _rotl64(_hash, 49) ^ _rotl64(_hash, 24);
      _hash *= 0x9FB21C651E98DF25;
      _hash ^= (_hash >>> 35) + length;
      _hash *= 0x9FB21C651E98DF25;
      _hash ^= _hash >>> 28;
      return _hash; // skips avalanche
    } else if (length <= 16) {
      // XXH3_len_9to16_64b
      lhs = key.getUint64(24, Endian.little);
      lhs ^= key.getUint64(32, Endian.little);
      lhs += seed;
      lhs ^= input.getUint64(0, Endian.little);
      rhs = key.getUint64(40, Endian.little);
      rhs ^= key.getUint64(48, Endian.little);
      rhs -= seed;
      rhs ^= input.getUint64(length - 8, Endian.little);
      _hash = length + _swap64(lhs) + rhs + _fold64(lhs, rhs);
    } else if (length <= 128) {
      // XXH3_len_17to128_64b
      _hash = length * prime64_1;
      for (i = 0; i < length; i += 32) {
        b = i >>> 1;
        c = length - b - 16;
        // first
        lhs = key.getUint64(i, Endian.little) + seed;
        rhs = key.getUint64(i + 8, Endian.little) - seed;
        lhs ^= input.getUint64(b, Endian.little);
        rhs ^= input.getUint64(b + 8, Endian.little);
        _hash += _fold64(lhs, rhs);
        // second
        lhs = key.getUint64(i + 16, Endian.little) + seed;
        rhs = key.getUint64(i + 24, Endian.little) - seed;
        lhs ^= input.getUint64(c, Endian.little);
        rhs ^= input.getUint64(c + 8, Endian.little);
        _hash += _fold64(lhs, rhs);
      }
    } else {
      // XXH3_len_129to240_64b
      _hash = length * prime64_1;
      // first 128 bytes
      for (i = 0; i < 8; i++) {
        _hash += _mix16B(input, i << 4, key, i << 4, seed);
      }
      _hash = _avalanche(_hash);
      // remaining bytes
      c = length >>> 4;
      for (i = 8; i < c; i++) {
        _hash += _mix16B(input, i << 4, key, ((i - 8) << 4) + 3, seed);
      }
      // last byte
      _hash += _mix16B(input, length - 16, key, _minSecretSize - 17, seed);
    }
    // avalanche
    return _avalanche(_hash);
  }

  @override
  Uint8List $finalize() {
    int i;
    int _hash;
    Uint64List input = Uint64List(_midSizeMax >>> 3);
    Uint8List input8 = input.buffer.asUint8List();

    if (messageLength <= _midSizeMax) {
      var it = last.iterator;
      for (i = 0; it.moveNext(); ++i) {
        input8[i] = it.current;
      }
      var key = Uint8List.fromList(_kSecret).buffer.asByteData();
      _hash = _finalizeShort(input.buffer.asByteData(), i, key);
    } else {
      for (i = 63; i >= 0; --i) {
        input8[i] = last.removeLast();
      }
      _hash = _finalizeLong(input);
    }

    return Uint8List.fromList([
      _hash >>> 56,
      _hash >>> 48,
      _hash >>> 40,
      _hash >>> 32,
      _hash >>> 24,
      _hash >>> 16,
      _hash >>> 8,
      _hash,
    ]);
  }
}
