// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/codecs.dart';

import 'generators.dart' show secureRandom;

const int _mask32 = 0xFFFFFFFF;

/*
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           random_a                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          random_a             |  ver  |       random_b        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|var|                       random_c                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                           random_c                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/

class UUIDv4 {
  const UUIDv4();

  /// UUIDv4 is meant for generating UUIDs from random numbers.
  String generate() {
    int rah, ral, rb, rch, rcl;
    final rng = secureRandom();
    final codec = Base16Codec.lower.encoder;

    rah = rng.nextInt(0xFFFF);
    ral = rng.nextInt(_mask32);
    rb = rng.nextInt(0xFFFF);
    rch = rng.nextInt(_mask32);
    rcl = rng.nextInt(_mask32);

    final part1 = codec.convert([
      rah >>> 8,
      rah,
      ral >>> 24,
      ral >>> 16,
    ]);
    final part2 = codec.convert([
      ral >>> 8,
      ral,
    ]);
    final part3 = codec.convert([
      0x40 ^ ((rb >>> 8) & 0xF),
      rb,
    ]);
    final part4 = codec.convert([
      0x80 ^ ((rch >>> 24) & 0x3F),
      rch >>> 16,
    ]);
    final part5 = codec.convert([
      rch >>> 8,
      rch,
      rcl >>> 24,
      rcl >>> 16,
      rcl >>> 8,
      rcl,
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
