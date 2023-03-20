// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:collection';
import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask32 = 0xFFFFFFFF;

const int _stripeLen = 64;
const int _midsizeMax = 240;
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

/// This implementation is derived from
/// https://github.com/RedSpah/xxhash_cpp/blob/master/include/xxhash.hpp
class XXH3Sink64bit extends BlockHashSink {
  final int seed;
  final int rounds;
  final Uint8List secret;
  final Uint64List acc = Uint64List(8);
  final ListQueue<int> last = ListQueue<int>(_midsizeMax);
  late final Uint64List qbuffer = buffer.buffer.asUint64List();
  late final ByteData secretBD = secret.buffer.asByteData();
  late final Uint64List secret64 = secret.buffer.asUint64List();

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

  factory XXH3Sink64bit.withSeed(int seed) {
    if (seed == 0) {
      return XXH3Sink64bit.withSecret();
    }
    var secret = Uint8List.fromList(_kSecret);
    var secret64 = secret.buffer.asUint64List();
    for (int i = 0; i < secret64.length; i += 2) {
      secret64[i] += seed;
    }
    for (int i = 1; i < secret64.length; i += 2) {
      secret64[i] -= seed;
    }
    return XXH3Sink64bit._(
      seed: seed,
      secret: secret,
      rounds: (secret.lengthInBytes - _stripeLen) >>> 3,
    );
  }

  factory XXH3Sink64bit.withSecret([List<int>? secret]) {
    var key = Uint8List.fromList(secret ?? _kSecret);
    if (key.lengthInBytes < _minSecretSize) {
      throw ArgumentError('The secret length must be at least $_minSecretSize');
    }
    return XXH3Sink64bit._(
      seed: 0,
      secret: key,
      rounds: (key.lengthInBytes - _stripeLen) >>> 3,
    );
  }

  XXH3Sink64bit._({
    required this.seed,
    required this.secret,
    required this.rounds,
  }) : super(rounds << 6) {
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
      if (last.length == _midsizeMax) {
        last.removeFirst();
      }
      last.add(chunk[start]);
    }
  }

  @pragma('vm:prefer-inline')
  static int _crossSwap(int x) => (x & _mask32) * (x >>> 32);

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int n, i, v, l, k;
    // accumulate
    for (n = 0; n < rounds; n++) {
      l = n << 3;
      for (i = 0; i < acc.length; i++) {
        v = qbuffer[l + i];
        acc[i ^ 1] += v;
        v ^= secret64[n + i];
        acc[i] += _crossSwap(v);
      }
    }
    // scramble
    k = secret.lengthInBytes - _stripeLen;
    for (i = 0; i < 8; ++i) {
      acc[i] ^= acc[i] >>> 47;
      acc[i] ^= secretBD.getUint64(k + (i << 3), Endian.little);
      acc[i] *= prime32_1;
    }
  }

  @pragma('vm:prefer-inline')
  static int _avalanche(int _hash) {
    _hash ^= _hash >>> 37;
    _hash *= 0x165667919E3779F9;
    _hash ^= _hash >>> 32;
    return _hash;
  }

  @pragma('vm:prefer-inline')
  static int _midsizeAvalanche(int _hash) {
    _hash ^= _hash >>> 33;
    _hash *= prime64_2;
    _hash ^= _hash >>> 29;
    _hash *= prime64_3;
    _hash ^= _hash >>> 32;
    return _hash;
  }

  @pragma('vm:prefer-inline')
  static int _rrmxmx(int _hash, int length) {
    _hash ^= _rotl64(_hash, 49) ^ _rotl64(_hash, 24);
    _hash *= 0x9FB21C651E98DF25;
    _hash ^= (_hash >>> 35) + length;
    _hash *= 0x9FB21C651E98DF25;
    _hash ^= _hash >>> 28;
    return _hash;
  }

  int _finalizeLong(Uint64List stripe) {
    // void hash_long_internal_loop
    int _hash;
    int t, n, i, v, l, a, b;
    const int _lastAccStart = 7;
    const int _mergeAccStart = 11;

    // last partial block
    for (t = n = 0; t + _stripeLen < pos; n++, t += _stripeLen) {
      l = n << 3;
      for (i = 0; i < acc.length; i++) {
        v = qbuffer[l + i];
        acc[i ^ 1] += v;
        v ^= secret64[n + i];
        acc[i] += _crossSwap(v);
      }
    }

    // last stripe
    t = secret.lengthInBytes - _stripeLen - _lastAccStart;
    for (i = 0; i < acc.length; i++, t += 8) {
      v = stripe[i];
      acc[i ^ 1] += v;
      v ^= secretBD.getUint64(t, Endian.little);
      acc[i] += _crossSwap(v);
    }

    // converge into final hash: uint64_t merge_accs
    _hash = messageLength * prime64_1;
    t = _mergeAccStart;
    for (i = 0; i < 8; i += 2, t += 16) {
      a = acc[i] ^ secretBD.getUint64(t, Endian.little);
      b = acc[i + 1] ^ secretBD.getUint64(t + 8, Endian.little);
      _hash += _mul128fold64(a, b);
    }

    // avalanche
    return _avalanche(_hash);
  }

  @pragma('vm:prefer-inline')
  static int _swap32(int x) =>
      ((x << 24) & 0xff000000) |
      ((x << 8) & 0x00ff0000) |
      ((x >>> 8) & 0x0000ff00) |
      ((x >>> 24) & 0x000000ff);

  @pragma('vm:prefer-inline')
  static int _swap64(int x) =>
      ((x << 56) & 0xff00000000000000) |
      ((x << 40) & 0x00ff000000000000) |
      ((x << 24) & 0x0000ff0000000000) |
      ((x << 8) & 0x000000ff00000000) |
      ((x >>> 8) & 0x00000000ff000000) |
      ((x >>> 24) & 0x0000000000ff0000) |
      ((x >>> 40) & 0x000000000000ff00) |
      ((x >>> 56) & 0x00000000000000ff);

  @pragma('vm:prefer-inline')
  static int _rotl64(int x, int n) => (x << n) | (x >>> (64 - n));

  // Multiply two 64-bit numbers to get 128-bit number and
  // xor the low bits of the product with the high bits
  @pragma('vm:prefer-inline')
  static int _mul128fold64(int a, int b) {
    int al, ah, bl, bh, ll, hl, lh, hh, cross, upper, lower;

    al = a & _mask32;
    ah = a >>> 32;
    bl = b & _mask32;
    bh = b >>> 32;

    ll = al * bl;
    hl = ah * bl;
    lh = al * bh;
    hh = ah * bh;

    cross = (ll >>> 32) + (hl & _mask32) + lh;
    upper = (hl >>> 32) + (cross >>> 32) + hh;
    lower = (cross << 32) | (ll & _mask32);

    return upper ^ lower;
  }

  @pragma('vm:prefer-inline')
  static int _mix16B(ByteData input, int i, ByteData key, int j, int seed) {
    int lhs, rhs;
    lhs = input.getUint64(i, Endian.little);
    rhs = input.getUint64(i + 8, Endian.little);
    lhs ^= key.getUint64(j, Endian.little) + seed;
    rhs ^= key.getUint64(j + 8, Endian.little) - seed;
    return _mul128fold64(lhs, rhs);
  }

  int _finalizeShort(ByteData input, int length, ByteData key) {
    int _hash, lhs, rhs, a, b, c, i;
    if (length == 0) {
      // hash_t<N> len_0to16
      _hash = seed;
      _hash ^= key.getUint64(56, Endian.little);
      _hash ^= key.getUint64(64, Endian.little);
      return _midsizeAvalanche(_hash);
    } else if (length <= 3) {
      // hash_t<N> len_1to3
      a = input.getUint8(0);
      b = input.getUint8(length >>> 1);
      c = input.getUint8(length - 1);
      _hash = key.getUint32(0, Endian.little);
      _hash ^= key.getUint32(4, Endian.little);
      _hash += seed;
      _hash ^= (a << 16) | (b << 24) | (c) | (length << 8);
      return _midsizeAvalanche(_hash);
    } else if (length <= 8) {
      // hash_t<N> len_4to8
      lhs = input.getUint32(0, Endian.little);
      rhs = input.getUint32(length - 4, Endian.little);
      _hash = key.getUint64(8, Endian.little);
      _hash ^= key.getUint64(16, Endian.little);
      _hash -= seed ^ ((_swap32(seed) & _mask32) << 32);
      _hash ^= (lhs << 32) | rhs;
      return _rrmxmx(_hash, length);
    } else if (length <= 16) {
      // hash_t<N> len_9to16
      lhs = key.getUint64(24, Endian.little);
      lhs ^= key.getUint64(32, Endian.little);
      lhs += seed;

      rhs = key.getUint64(40, Endian.little);
      rhs ^= key.getUint64(48, Endian.little);
      rhs -= seed;

      lhs ^= input.getUint64(0, Endian.little);
      rhs ^= input.getUint64(length - 8, Endian.little);

      _hash = length + _swap64(lhs) + rhs + _mul128fold64(lhs, rhs);
      return _avalanche(_hash);
    } else if (length <= 128) {
      // hash_t<N> len_17to128
      _hash = length * prime64_1;
      if (length > 32) {
        if (length > 64) {
          if (length > 96) {
            _hash += _mix16B(input, 48, key, 96, seed);
            _hash += _mix16B(input, length - 64, key, 112, seed);
          }
          _hash += _mix16B(input, 32, key, 64, seed);
          _hash += _mix16B(input, length - 48, key, 80, seed);
        }
        _hash += _mix16B(input, 16, key, 32, seed);
        _hash += _mix16B(input, length - 32, key, 48, seed);
      }
      _hash += _mix16B(input, 0, key, 0, seed);
      _hash += _mix16B(input, length - 16, key, 16, seed);
      return _avalanche(_hash);
    } else {
      // hash_t<N> len_129to240
      const int _startOffset = 3;
      const int _lastOffset = 17;
      _hash = length * prime64_1;
      // first 128 bytes
      for (i = 0; i < 128; i += 16) {
        _hash += _mix16B(input, i, key, i, seed);
      }
      _hash = _avalanche(_hash);
      // remaining bytes
      for (i = 128; i + 16 <= length; i += 16) {
        c = _startOffset + i - 128;
        _hash += _mix16B(input, i, key, c, seed);
      }
      // last byte
      c = _minSecretSize - _lastOffset;
      _hash += _mix16B(input, length - 16, key, c, seed);
      return _avalanche(_hash);
    }
  }

  @override
  Uint8List $finalize() {
    int i;
    int _hash;
    ByteData key;
    Uint64List input = Uint64List(_midsizeMax >>> 3);
    Uint8List input8 = input.buffer.asUint8List();

    if (messageLength <= _midsizeMax) {
      var it = last.iterator;
      for (i = 0; it.moveNext(); ++i) {
        input8[i] = it.current;
      }
      if (seed == 0) {
        key = secretBD;
      } else {
        key = Uint8List.fromList(_kSecret).buffer.asByteData();
      }
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
