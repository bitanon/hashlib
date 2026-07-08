// Copyright (c) 2025, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:test/test.dart';

void main() {
  group('SHA-256 comparison', () {
    test('with random inputs of length 0..999', () {
      for (int i = 0; i < 1000; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha256.convert(data).bytes),
          toHex(crypto.sha256.convert(data).bytes),
          reason: 'Message length: ${data.length}',
        );
      }
    });

    test('around the 64-byte block boundary', () {
      // Exercises the message-length/padding overflow cases explicitly.
      for (final n in [55, 56, 57, 63, 64, 65, 119, 120, 128, 129]) {
        final data = randomBytes(n);
        expect(
          toHex(sha256.convert(data).bytes),
          toHex(crypto.sha256.convert(data).bytes),
          reason: 'Message length: $n',
        );
      }
    });

    test('with SHA-224 against crypto', () {
      for (int i = 0; i < 256; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha224.convert(data).bytes),
          toHex(crypto.sha224.convert(data).bytes),
          reason: 'Message length: ${data.length}',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        expect(
          toHex(sha256.convert(data).bytes),
          toHex(crypto.sha256.convert(data).bytes),
          reason: 'Message length: ${data.length}',
        );
      }));
    });
  });
}
