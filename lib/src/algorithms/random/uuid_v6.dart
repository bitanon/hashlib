// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/codecs.dart';

import 'generator_vm.dart' if (dart.library.js) 'generator_js.dart';

const int _mask32 = 0xFFFFFFFF;
const int _pow32 = _mask32 + 1;

/*
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           time_high                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|           time_mid            |  ver  |       time_low        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|var|         clock_seq         |             node              |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                              node                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/

class UUIDv6 {
  const UUIDv6();

  static const int _g0 = 0x13814000;
  static const int _g1 = 0x01b21dd2;

  /// UUIDv6 is a field-compatible version of UUIDv1 reordered for improved DB
  /// locality.
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
      th >>> 20,
      th >>> 12,
      th >>> 4,
      ((th & 0xF) << 4) ^ (tl >>> 28),
    ]);
    final part2 = codec.convert([
      tl >>> 20,
      tl >>> 12,
    ]);
    final part3 = codec.convert([
      0x60 ^ ((tl >>> 8) & 0xF),
      tl,
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
