// Copyright (c) 2025, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:pointycastle/digests/keccak.dart' as pc_keccak;
import 'package:pointycastle/digests/sha3.dart' as pc_sha3;
import 'package:test/test.dart';

// The random-input range spans 0..199 so every SHA3/Keccak rate boundary is
// crossed: SHA3-512 rate = 72, SHA3-384 = 104, SHA3-256 = 136, SHA3-224 = 144.
void main() {
  group('SHA3 comparison with pointycastle', () {
    final variants = {
      224: sha3_224,
      256: sha3_256,
      384: sha3_384,
      512: sha3_512,
    };
    for (final entry in variants.entries) {
      test('SHA3-${entry.key} for random inputs of length 0..199', () {
        for (int i = 0; i < 200; ++i) {
          final data = randomBytes(i);
          expect(
            entry.value.convert(data).hex(),
            toHex(pc_sha3.SHA3Digest(entry.key)
                .process(Uint8List.fromList(data))),
            reason: 'Message length: $i',
          );
        }
      });
    }
  });

  group('Keccak comparison with pointycastle', () {
    final variants = {
      224: keccak224,
      256: keccak256,
      384: keccak384,
      512: keccak512,
    };
    for (final entry in variants.entries) {
      test('Keccak-${entry.key} for random inputs of length 0..199', () {
        for (int i = 0; i < 200; ++i) {
          final data = randomBytes(i);
          expect(
            entry.value.convert(data).hex(),
            toHex(pc_keccak.KeccakDigest(entry.key)
                .process(Uint8List.fromList(data))),
            reason: 'Message length: $i',
          );
        }
      });
    }
  });
}
