// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/codecs.dart';

import 'generators.dart' show secureRandom;

const int _mask32 = 0xFFFFFFFF;
const int _pow32 = _mask32 + 1;

/*
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           time_low                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           time_mid            |  ver  |       time_high       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|var|         clock_seq         |             node              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                              node                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/

/// Implementation of Universally Unique Identifier version 1
class UUIDv1 {
  const UUIDv1();

  static const int _g0 = 0x13814000;
  static const int _g1 = 0x01b21dd2;

  /// UUIDv1 is a time-based UUID featuring a 60-bit timestamp represented by
  /// Coordinated Universal Time (UTC) as a count of 100-nanosecond intervals
  /// since 00:00:00.00, 15 October 1582.
  String generate({
    DateTime? now,
    int? clockSeq,
    int? node,
  }) {
    final rng = secureRandom();
    final codec = Base16Codec.lower.encoder;

    now ??= DateTime.now().toUtc();
    clockSeq ??= rng.nextInt(0xFFFF);

    int tl, th, t0, t1, t2;
    t0 = now.millisecondsSinceEpoch & _mask32;
    t1 = now.millisecondsSinceEpoch ~/ _pow32;
    t2 = now.microsecondsSinceEpoch % 1000;

    tl = (10000 * t0 + 10 * t2 + _g0);
    th = (10000 * t1 + _g1);
    th += tl ~/ _pow32;
    tl &= _mask32;

    int nl, nh;
    if (node != null) {
      nl = node & _mask32;
      nh = node ~/ _pow32;
    } else {
      nl = rng.nextInt(_mask32);
      nh = rng.nextInt(0xFFFF);
    }

    final part1 = codec.convert([
      tl >>> 24,
      tl >>> 16,
      tl >>> 8,
      tl,
    ]);
    final part2 = codec.convert([
      th >>> 8,
      th,
    ]);
    final part3 = codec.convert([
      0x10 ^ ((th >>> 24) & 0xF),
      th >>> 16,
    ]);
    final part4 = codec.convert([
      0x80 ^ ((clockSeq >>> 8) & 0x3F),
      clockSeq,
    ]);
    final part5 = codec.convert([
      nh >>> 8,
      nh,
      nl >>> 24,
      nl >>> 16,
      nl >>> 8,
      nl,
    ]);

    return [
      String.fromCharCodes(part1),
      String.fromCharCodes(part2),
      String.fromCharCodes(part3),
      String.fromCharCodes(part4),
      String.fromCharCodes(part5),
    ].join('-');
  }
}
