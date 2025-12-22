// Copyright (c) 2023, Sudipto Chandra
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

void main() {
  group('Keccak comparison', () {
    test('with keccak256', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        var pc = pc_keccak.KeccakDigest(256);
        var other = pc.process(Uint8List.fromList(data));
        expect(
          keccak256.convert(data).hex(),
          toHex(other),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('with sha3', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        var pc = pc_sha3.SHA3Digest(256);
        var other = pc.process(Uint8List.fromList(data));
        expect(
          sha3_256.convert(data).hex(),
          toHex(other),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });
  });
}
