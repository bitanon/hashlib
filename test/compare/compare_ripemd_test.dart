// Copyright (c) 2025, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:pointycastle/digests/ripemd128.dart' as pc;
import 'package:pointycastle/digests/ripemd160.dart' as pc;
import 'package:pointycastle/digests/ripemd256.dart' as pc;
import 'package:pointycastle/digests/ripemd320.dart' as pc;
import 'package:test/test.dart';

void main() {
  group('RIPEMD comparison with pointycastle', () {
    test('RIPEMD-128 for random inputs of length 0..255', () {
      for (int i = 0; i < 256; ++i) {
        final data = randomBytes(i);
        expect(
          ripemd128.convert(data).hex(),
          toHex(pc.RIPEMD128Digest().process(Uint8List.fromList(data))),
          reason: 'Message length: $i',
        );
      }
    });

    test('RIPEMD-160 for random inputs of length 0..255', () {
      for (int i = 0; i < 256; ++i) {
        final data = randomBytes(i);
        expect(
          ripemd160.convert(data).hex(),
          toHex(pc.RIPEMD160Digest().process(Uint8List.fromList(data))),
          reason: 'Message length: $i',
        );
      }
    });

    test('RIPEMD-256 for random inputs of length 0..255', () {
      for (int i = 0; i < 256; ++i) {
        final data = randomBytes(i);
        expect(
          ripemd256.convert(data).hex(),
          toHex(pc.RIPEMD256Digest().process(Uint8List.fromList(data))),
          reason: 'Message length: $i',
        );
      }
    });

    test('RIPEMD-320 for random inputs of length 0..255', () {
      for (int i = 0; i < 256; ++i) {
        final data = randomBytes(i);
        expect(
          ripemd320.convert(data).hex(),
          toHex(pc.RIPEMD320Digest().process(Uint8List.fromList(data))),
          reason: 'Message length: $i',
        );
      }
    });
  });
}
