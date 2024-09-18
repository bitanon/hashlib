// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/src/algorithms/md5.dart';
import 'package:hashlib/src/random.dart';

/*
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                            md5_high                           |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|          md5_high             |  ver  |       md5_mid         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|var|                        md5_low                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                            md5_low                            |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
*/

class UUIDv3 {
  const UUIDv3();

  /// UUIDv3 values are created by computing an MD5 hash over a given
  /// [namespace] concatenated with the desired [name] value.
  String generate({
    String? namespace,
    String? name,
  }) {
    final codec = Base16Codec.lower.encoder;

    final sink = MD5Hash();
    if (namespace != null) {
      sink.add(fromHex(namespace.split('-').join()));
    } else {
      sink.add(randomBytes(16));
    }
    if (name != null) {
      sink.add(utf8.encode(name));
    }
    final hash = Uint32List.view(sink.digest().buffer);
    int h0 = hash[0];
    int h1 = hash[1];
    int h2 = hash[2];
    int h3 = hash[3];

    final part1 = codec.convert([
      h0,
      h0 >>> 8,
      h0 >>> 16,
      h0 >>> 24,
    ]);
    final part2 = codec.convert([
      h1,
      h1 >>> 8,
    ]);
    final part3 = codec.convert([
      0x30 ^ ((h1 >>> 16) & 0xF),
      h1 >>> 24,
    ]);
    final part4 = codec.convert([
      0x80 ^ (h2 & 0x3F),
      h2 >>> 8,
    ]);
    final part5 = codec.convert([
      h2 >>> 16,
      h2 >>> 24,
      h3,
      h3 >>> 8,
      h3 >>> 16,
      h3 >>> 24,
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
