// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';

import 'generators.dart' show secureRandom;

const int _mask32 = 0xFFFFFFFF;

/*
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                             nonce                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|            nonce              |  ver  |        nonce          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|var|                         nonce                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                             nonce                             |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/

class UUIDv8 {
  const UUIDv8();

  /// UUIDv8 provides a format for experimental or vendor-specific use cases.
  /// This implementation uses random number by default.
  String generate({Uint8List? nonce}) {
    int a, b, c, d;
    final rng = secureRandom();
    final codec = Base16Codec.lower.encoder;

    if (nonce != null) {
      if (nonce.length != 16) {
        throw ArgumentError('Nonce length must be 16-byte');
      }
      var nonce32 = Uint32List.view(nonce.buffer);
      a = nonce32[0];
      b = nonce32[1];
      c = nonce32[2];
      d = nonce32[3];
    } else {
      a = rng.nextInt(_mask32);
      b = rng.nextInt(_mask32);
      c = rng.nextInt(_mask32);
      d = rng.nextInt(_mask32);
    }

    final part1 = codec.convert([
      a,
      a >>> 8,
      a >>> 16,
      a >>> 24,
    ]);
    final part2 = codec.convert([
      b,
      b >>> 8,
    ]);
    final part3 = codec.convert([
      0x80 ^ ((b >>> 16) & 0xF),
      b >>> 24,
    ]);
    final part4 = codec.convert([
      0x80 ^ (c & 0x3F),
      c >>> 8,
    ]);
    final part5 = codec.convert([
      c >>> 16,
      c >>> 24,
      d,
      d >>> 8,
      d >>> 16,
      d >>> 24,
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
