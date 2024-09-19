// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/codecs.dart';

import 'generators.dart' show secureRandom;

const int _mask32 = 0xFFFFFFFF;
const int _pow32 = _mask32 + 1;

/*
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           unix_ts_ms                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          unix_ts_ms           |  ver  |       rand_a          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|var|                        rand_b                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                            rand_b                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/

class UUIDv7 {
  const UUIDv7();

  /// UUIDv7 features a time-ordered value field derived from the widely
  /// implemented and well-known Unix Epoch timestamp source, the number of
  /// milliseconds since midnight 1 Jan 1970 UTC, leap seconds excluded.
  String generate({
    DateTime? now,
  }) {
    int ra, rbh, rbl, tl, th;
    final rng = secureRandom();
    final codec = Base16Codec.lower.encoder;

    now ??= DateTime.now().toUtc();
    ra = rng.nextInt(0xFFFF);
    rbh = rng.nextInt(_mask32);
    rbl = rng.nextInt(_mask32);
    tl = now.millisecondsSinceEpoch & _mask32;
    th = now.millisecondsSinceEpoch ~/ _pow32;

    final part1 = codec.convert([
      th >>> 8,
      th,
      tl >>> 24,
      tl >>> 16,
    ]);
    final part2 = codec.convert([
      tl >>> 8,
      tl,
    ]);
    final part3 = codec.convert([
      0x70 ^ ((ra >>> 8) & 0xF),
      ra,
    ]);
    final part4 = codec.convert([
      0x80 ^ ((rbh >>> 24) & 0x3F),
      rbh >>> 16,
    ]);
    final part5 = codec.convert([
      rbh >>> 8,
      rbh,
      rbl >>> 24,
      rbl >>> 16,
      rbl >>> 8,
      rbl,
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
