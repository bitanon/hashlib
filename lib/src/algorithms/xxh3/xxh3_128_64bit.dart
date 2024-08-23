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
class XXH3Sink128bit extends BlockHashSink {
  final int seed;
  final int rounds;
  final Uint8List secret;
  final Uint64List state = Uint64List(8);
  final ListQueue<int> last = ListQueue<int>(_midsizeMax);
  late final Uint64List qbuffer = Uint64List.view(buffer.buffer);
  late final Uint64List secret64 = Uint64List.view(secret.buffer);
  late final ByteData secretBD = secret.buffer.asByteData();

  @override
  final int hashLength = 16;

  static const int prime32_1 = 0x9E3779B1;
  static const int prime32_2 = 0x85EBCA77;
  static const int prime32_3 = 0xC2B2AE3D;
  static const int prime64_1 = 0x9E3779B185EBCA87;
  static const int prime64_2 = 0xC2B2AE3D27D4EB4F;
  static const int prime64_3 = 0x165667B19E3779F9;
  static const int prime64_4 = 0x85EBCA77C2B2AE63;
  static const int prime64_5 = 0x27D4EB2F165667C5;

  factory XXH3Sink128bit.withSeed(int seed) {
    if (seed == 0) {
      return XXH3Sink128bit.withSecret();
    }
    var secret = Uint8List.fromList(_kSecret);
    var secret64 = Uint64List.view(secret.buffer);
    for (int i = 0; i < secret64.length; i += 2) {
      secret64[i] += seed;
    }
    for (int i = 1; i < secret64.length; i += 2) {
      secret64[i] -= seed;
    }
    return XXH3Sink128bit._(
      seed: seed,
      secret: secret,
      rounds: (secret.lengthInBytes - _stripeLen) >>> 3,
    );
  }

  factory XXH3Sink128bit.withSecret([List<int>? secret]) {
    var key = Uint8List.fromList(secret ?? _kSecret);
    if (key.lengthInBytes < _minSecretSize) {
      throw ArgumentError('The secret length must be at least $_minSecretSize');
    }
    return XXH3Sink128bit._(
      seed: 0,
      secret: key,
      rounds: (key.lengthInBytes - _stripeLen) >>> 3,
    );
  }

  XXH3Sink128bit._({
    required this.seed,
    required this.secret,
    required this.rounds,
  }) : super(rounds << 6) {
    reset();
  }

  @override
  void reset() {
    state[0] = prime32_3;
    state[1] = prime64_1;
    state[2] = prime64_2;
    state[3] = prime64_3;
    state[4] = prime64_4;
    state[5] = prime32_2;
    state[6] = prime64_5;
    state[7] = prime32_1;
    super.reset();
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
      for (i = 0; i < state.length; i++) {
        v = qbuffer[l + i];
        state[i ^ 1] += v;
        v ^= secret64[n + i];
        state[i] += _crossSwap(v);
      }
    }
    // scramble
    k = secret.lengthInBytes - _stripeLen;
    for (i = 0; i < 8; ++i) {
      state[i] ^= state[i] >>> 47;
      state[i] ^= secretBD.getUint64(k + (i << 3), Endian.little);
      state[i] *= prime32_1;
    }
  }

  @pragma('vm:prefer-inline')
  static int _avalanche(int hash) {
    hash ^= hash >>> 37;
    hash *= 0x165667919E3779F9;
    hash ^= hash >>> 32;
    return hash;
  }

  @pragma('vm:prefer-inline')
  static int _midsizeAvalanche(int hash) {
    hash ^= hash >>> 33;
    hash *= prime64_2;
    hash ^= hash >>> 29;
    hash *= prime64_3;
    hash ^= hash >>> 32;
    return hash;
  }

  @pragma('vm:prefer-inline')
  static Uint8List _combine(int a, int b) {
    return Uint8List.fromList([
      b >>> 56,
      b >>> 48,
      b >>> 40,
      b >>> 32,
      b >>> 24,
      b >>> 16,
      b >>> 8,
      b,
      a >>> 56,
      a >>> 48,
      a >>> 40,
      a >>> 32,
      a >>> 24,
      a >>> 16,
      a >>> 8,
      a,
    ]);
  }

  Uint8List _finalizeLong(Uint64List stripe) {
    // XXH3_hashLong_128b
    int low, high;
    int t, n, i, v, l, a, b;
    const int lastAccStart = 7;
    const int mergeAccStart = 11;

    // accumulate last partial block
    for (t = n = 0; t + _stripeLen < pos; n++, t += _stripeLen) {
      l = n << 3;
      for (i = 0; i < state.length; i++) {
        v = qbuffer[l + i];
        state[i ^ 1] += v;
        v ^= secret64[n + i];
        state[i] += _crossSwap(v);
      }
    }

    // last stripe
    t = secret.lengthInBytes - _stripeLen - lastAccStart;
    for (i = 0; i < state.length; i++, t += 8) {
      v = stripe[i];
      state[i ^ 1] += v;
      v ^= secretBD.getUint64(t, Endian.little);
      state[i] += _crossSwap(v);
    }

    // converge into final hash
    low = messageLength * prime64_1;
    high = ~(messageLength * prime64_2);
    t = mergeAccStart;
    for (i = 0; i < 8; i += 2, t += 16) {
      a = secretBD.getUint64(t, Endian.little);
      b = secretBD.getUint64(t + 8, Endian.little);
      low += _mul128fold64(state[i] ^ a, state[i + 1] ^ b);
    }
    t = secret.lengthInBytes - _stripeLen - mergeAccStart;
    for (i = 0; i < 8; i += 2, t += 16) {
      a = secretBD.getUint64(t, Endian.little);
      b = secretBD.getUint64(t + 8, Endian.little);
      high += _mul128fold64(state[i] ^ a, state[i + 1] ^ b);
    }

    // avalanche
    return _combine(_avalanche(low), _avalanche(high));
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
  static int _rotl32(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  // Multiply two 64-bit numbers to get 128-bit number
  static void _mul128(int a, int b, Uint64List result) {
    int al, ah, bl, bh, ll, hl, lh, hh, cross;

    al = a & _mask32;
    ah = a >>> 32;
    bl = b & _mask32;
    bh = b >>> 32;

    ll = al * bl;
    hl = ah * bl;
    lh = al * bh;
    hh = ah * bh;

    cross = (ll >>> 32) + (hl & _mask32) + lh;
    result[0] = (cross << 32) | (ll & _mask32);
    result[1] = (hl >>> 32) + (cross >>> 32) + hh;
  }

  // Multiply two 64-bit numbers to get 128-bit number and
  // xor the low bits of the product with the high bits
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

  static int _mix16B(ByteData input, int i, ByteData key, int j, int seed) {
    int lhs, rhs;
    lhs = key.getUint64(j, Endian.little) + seed;
    rhs = key.getUint64(j + 8, Endian.little) - seed;
    lhs ^= input.getUint64(i, Endian.little);
    rhs ^= input.getUint64(i + 8, Endian.little);
    return _mul128fold64(lhs, rhs);
  }

  static void _mix32B(
    Uint64List acc,
    ByteData input,
    int a,
    int b,
    ByteData key,
    int c,
    int seed,
  ) {
    acc[0] += _mix16B(input, a, key, c, seed);
    acc[0] ^= input.getUint64(b, Endian.little) +
        input.getUint64(b + 8, Endian.little);
    acc[1] += _mix16B(input, b, key, c + 16, seed);
    acc[1] ^= input.getUint64(a, Endian.little) +
        input.getUint64(a + 8, Endian.little);
  }

  Uint8List _finalizeShort(ByteData input, int length, ByteData key) {
    int low, high;
    int i, lhs, rhs, a, b, c, x, y;
    Uint64List acc = Uint64List(2);
    if (length == 0) {
      // hash_t<N> len_0to16
      low = seed;
      low ^= key.getUint64(64, Endian.little);
      low ^= key.getUint64(72, Endian.little);

      high = seed;
      high ^= key.getUint64(80, Endian.little);
      high ^= key.getUint64(88, Endian.little);

      low = _midsizeAvalanche(low);
      high = _midsizeAvalanche(high);
    } else if (length <= 3) {
      // hash_t<N> len_1to3
      a = input.getUint8(0);
      b = input.getUint8(length >>> 1);
      c = input.getUint8(length - 1);
      x = (a << 16) | (b << 24) | (c) | (length << 8);
      y = _rotl32(_swap32(x), 13);

      low = key.getUint32(0, Endian.little);
      low ^= key.getUint32(4, Endian.little);
      low += seed;
      low ^= x;

      high = key.getUint32(8, Endian.little);
      high ^= key.getUint32(12, Endian.little);
      high -= seed;
      high ^= y;

      low = _midsizeAvalanche(low);
      high = _midsizeAvalanche(high);
    } else if (length <= 8) {
      // hash_t<N> len_4to8
      lhs = input.getUint32(0, Endian.little);
      rhs = input.getUint32(length - 4, Endian.little);

      x = key.getUint64(16, Endian.little);
      x ^= key.getUint64(24, Endian.little);
      x += seed ^ (_swap32(seed & _mask32) << 32);
      x ^= (rhs << 32) | lhs;

      _mul128(x, prime64_1 + (length << 2), acc);
      low = acc[0];
      high = acc[1];

      high += low << 1;
      low ^= high >>> 3;
      low ^= low >>> 35;
      low *= 0x9FB21C651E98DF25;
      low ^= low >>> 28;

      high = _avalanche(high);
    } else if (length <= 16) {
      // hash_t<N> len_9to16
      lhs = key.getUint64(32, Endian.little);
      lhs ^= key.getUint64(40, Endian.little);
      lhs -= seed;
      lhs ^= input.getUint64(0, Endian.little);
      lhs ^= input.getUint64(length - 8, Endian.little);

      rhs = key.getUint64(48, Endian.little);
      rhs ^= key.getUint64(56, Endian.little);
      rhs += seed;
      rhs ^= input.getUint64(length - 8, Endian.little);

      _mul128(lhs, prime64_1, acc);
      low = acc[0];
      high = acc[1];
      low += length - 1 << 54;
      high += (rhs & (_mask32 << 32)) + ((rhs & _mask32) * prime32_2);

      low ^= _swap64(high);
      _mul128(low, prime64_2, acc);
      low = acc[0];
      high = acc[1] + (high * prime64_2);

      low = _avalanche(low);
      high = _avalanche(high);
    } else if (length <= 128) {
      // hash_t<N> len_17to128
      acc[0] = length * prime64_1;
      acc[1] = 0;
      if (length > 32) {
        if (length > 64) {
          if (length > 96) {
            _mix32B(acc, input, 48, length - 64, key, 96, seed);
          }
          _mix32B(acc, input, 32, length - 48, key, 64, seed);
        }
        _mix32B(acc, input, 16, length - 32, key, 32, seed);
      }
      _mix32B(acc, input, 0, length - 16, key, 0, seed);

      low = acc[0] + acc[1];
      high = acc[0] * prime64_1 + acc[1] * prime64_4;
      high += (length - seed) * prime64_2;
      low = _avalanche(low);
      high = -_avalanche(high);
    } else {
      // hash_t<N> len_129to240
      const int startOffset = 3;
      const int lastOffset = 17;
      acc[0] = length * prime64_1;
      acc[1] = 0;
      // first 128 bytes
      for (i = 0; i < 128; i += 32) {
        _mix32B(
          acc,
          input,
          i,
          i + 16,
          key,
          i,
          seed,
        );
      }
      acc[0] = _avalanche(acc[0]);
      acc[1] = _avalanche(acc[1]);
      // remaining bytes
      for (i = 128; i + 32 <= length; i += 32) {
        _mix32B(
          acc,
          input,
          i,
          i + 16,
          key,
          startOffset + i - 128,
          seed,
        );
      }
      // last byte
      _mix32B(
        acc,
        input,
        length - 16,
        length - 32,
        key,
        _minSecretSize - lastOffset - 16,
        -seed,
      );
      // mid-range avalanche
      low = _avalanche(acc[0] + acc[1]);
      high = acc[1] * prime64_4;
      high += acc[0] * prime64_1;
      high += (length - seed) * prime64_2;
      high = -_avalanche(high);
    }
    // combine
    return _combine(low, high);
  }

  @override
  Uint8List $finalize() {
    int i;
    ByteData key;
    Uint64List input = Uint64List(_midsizeMax >>> 3);
    Uint8List input8 = Uint8List.view(input.buffer);

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
      return _finalizeShort(input.buffer.asByteData(), i, key);
    } else {
      for (i = _stripeLen - 1; i >= 0; --i) {
        input8[i] = last.removeLast();
      }
      return _finalizeLong(input);
    }
  }
}
