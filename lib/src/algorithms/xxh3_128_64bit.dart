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

class XXH3Sink128bit extends BlockHashSink {
  final int seed;
  final int rounds;
  final Uint8List secret;
  final Uint64List state = Uint64List(8);
  final ListQueue<int> last = ListQueue<int>(_midSizeMax);
  late final Uint64List qbuffer = buffer.buffer.asUint64List();
  late final ByteData secretBD = secret.buffer.asByteData();
  late final Uint64List secret64 = secret.buffer.asUint64List();

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
    var secret64 = secret.buffer.asUint64List();
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
    super.reset();
    state[0] = prime32_3;
    state[1] = prime64_1;
    state[2] = prime64_2;
    state[3] = prime64_3;
    state[4] = prime64_4;
    state[5] = prime32_2;
    state[6] = prime64_5;
    state[7] = prime32_1;
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
    // accumulate
    for (n = 0; n < rounds; n++) {
      l = n << 3;
      for (i = 0; i < state.length; i++) {
        v = qbuffer[l + i];
        state[i ^ 1] += v;
        v ^= secret64[n + i];
        state[i] += (v & _mask32) * (v >>> 32);
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

  static int _avalanche(int _hash) {
    _hash ^= _hash >>> 37;
    _hash *= 0x165667919E3779F9;
    _hash ^= _hash >>> 32;
    return _hash;
  }

  static Uint8List _combine(int a, int b) {
    return Uint64List.fromList([a, b]).buffer.asUint8List();
  }

  Uint8List _finalizeLong(Uint64List stripe) {
    // XXH3_hashLong_128b
    int low, high;
    int t, n, i, v, l, a, b;

    // accumulate last partial block
    for (t = n = 0; t + _stripeLen <= pos; n++, t += _stripeLen) {
      l = n << 3;
      for (i = 0; i < state.length; i++) {
        v = qbuffer[l + i];
        state[i ^ 1] += v;
        v ^= secret64[n + i];
        state[i] += (v & _mask32) * (v >>> 32);
      }
    }

    // last stripe
    if (messageLength & 63 != 0) {
      t = secret.lengthInBytes - _stripeLen - 7;
      for (i = 0; i < state.length; i++, t += 8) {
        v = stripe[i];
        state[i ^ 1] += v;
        v ^= secretBD.getUint64(t, Endian.little);
        state[i] += (v & _mask32) * (v >>> 32);
      }
    }

    // converge into final hash
    low = messageLength * prime64_1;
    high = ~(messageLength * prime64_2);
    for (i = t = 0; i < 8; i += 2, t += 16) {
      l = t + 11;
      a = secretBD.getUint64(l, Endian.little);
      b = secretBD.getUint64(l + 8, Endian.little);
      low += _fold64(state[i] ^ a, state[i + 1] ^ b);

      l = t + secret.lengthInBytes - _stripeLen - 11;
      a = secretBD.getUint64(l, Endian.little);
      b = secretBD.getUint64(l + 8, Endian.little);
      high += _fold64(state[i] ^ a, state[i + 1] ^ b);
    }

    // avalanche
    return _combine(_avalanche(low), _avalanche(high));
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

  static int _rotl32(int x, int n) =>
      ((x << n) & _mask32) | ((x & _mask32) >>> (32 - n));

  // Multiply two 64-bit numbers to get 128-bit number
  static List<int> _cross128(int a, int b) {
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

    return [lower, upper];
  }

  // Multiply two 64-bit numbers to get 128-bit number and
  // xor the low bits of the product with the high bits
  static int _fold64(int a, int b) {
    var r = _cross128(a, b);
    return r[0] ^ r[1];
  }

  static int _mix16B(ByteData input, int i, ByteData key, int j, int seed) {
    int lhs, rhs;
    lhs = key.getUint64(j, Endian.little) + seed;
    rhs = key.getUint64(j + 8, Endian.little) - seed;
    lhs ^= input.getUint64(i, Endian.little);
    rhs ^= input.getUint64(i + 8, Endian.little);
    return _fold64(lhs, rhs);
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
    int i, lhs, rhs, a, b, c, x;
    Uint64List acc = Uint64List(2);
    if (length == 0) {
      // XXH3_len_0_128b
      low = prime64_1 + seed;
      low ^= key.getUint64(64, Endian.little);
      low ^= key.getUint64(72, Endian.little);

      high = prime64_2 - seed;
      high ^= key.getUint64(80, Endian.little);
      high ^= key.getUint64(88, Endian.little);

      low = _avalanche(low);
      high = _avalanche(high);
    } else if (length <= 3) {
      // XXH3_len_1to3_128b
      a = input.getUint8(0);
      b = input.getUint8(length > 1 ? 1 : 0);
      c = input.getUint8(length - 1);
      x = (a << 16) | (b << 24) | (c) | (length << 8);

      low = key.getUint32(0, Endian.little);
      low ^= key.getUint32(4, Endian.little);
      low += seed;
      low ^= x;
      low *= prime64_1;

      high = key.getUint32(8, Endian.little);
      high ^= key.getUint32(12, Endian.little);
      high -= seed;
      high ^= _rotl32(_swap32(x), 13);
      high *= prime64_5;

      low = _avalanche(low);
      high = _avalanche(high);
    } else if (length <= 8) {
      // XXH3_len_4to8_128b
      lhs = input.getUint32(0, Endian.little);
      rhs = input.getUint32(length - 4, Endian.little);

      x = key.getUint64(16, Endian.little);
      x ^= key.getUint64(24, Endian.little);
      x += seed ^ (_swap32(seed & _mask32) << 32);
      x ^= (rhs << 32) | lhs;

      var r = _cross128(x, prime64_1 + (length << 2));
      low = r[0];
      high = r[1];

      high += low << 1;
      low ^= high >>> 3;

      low ^= low >>> 35;
      low *= 0x9FB21C651E98DF25;
      low ^= low >>> 28;

      high = _avalanche(high);
    } else if (length <= 16) {
      // XXH3_len_9to16_128b
      lhs = key.getUint64(32, Endian.little);
      lhs ^= key.getUint64(40, Endian.little);
      lhs -= seed;
      lhs ^= input.getUint64(0, Endian.little);
      lhs ^= input.getUint64(length - 8, Endian.little);

      rhs = key.getUint64(48, Endian.little);
      rhs ^= key.getUint64(56, Endian.little);
      rhs += seed;
      rhs ^= input.getUint64(length - 8, Endian.little);

      var r = _cross128(lhs, prime64_1);
      low = r[0];
      high = r[1];
      low += length - 1 << 54;
      high += (rhs & (_mask32 << 32)) + ((rhs & _mask32) * prime32_2);

      low ^= _swap64(high);
      r = _cross128(low, prime64_2);
      low = r[0];
      high = r[1] + (high * prime64_2);

      low = _avalanche(low);
      high = _avalanche(high);
    } else if (length <= 128) {
      // XXH3_len_17to128_128b
      acc[0] = length * prime64_1;
      acc[1] = 0;
      i = (length - 1) >>> 5;
      for (; i >= 0; i--) {
        _mix32B(
          acc,
          input,
          i << 4,
          length - ((i + 1) << 4),
          key,
          i << 5,
          seed,
        );
      }
      // mid-range avalanche
      low = _avalanche(acc[0] + acc[1]);
      high = acc[1] * prime64_4;
      high += acc[0] * prime64_1;
      high += (length - seed) * prime64_2;
      high = -_avalanche(high);
    } else {
      // XXH3_len_129to240_128b
      const int _startOffset = 3;
      const int _lastOffset = 17;
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
          _startOffset + i - 128,
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
        _minSecretSize - _lastOffset - 16,
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
    Uint64List input = Uint64List(_midSizeMax >>> 3);
    Uint8List input8 = input.buffer.asUint8List();

    if (messageLength <= _midSizeMax) {
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
