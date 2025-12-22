// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:pointycastle/digests/blake2b.dart' as pc_blake2b;
import 'package:test/test.dart';

void main() {
  group('blake2b512 comparison', () {
    test('with pointycastle', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = blake2b512.convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(digestSize: 64).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with key', () {
      final key = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = blake2b512.mac.by(key).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(digestSize: 64, key: key).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with salt', () {
      final salt = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(64, salt: salt).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(digestSize: 64, salt: salt).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with personalization', () {
      final personalization = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(
          64,
          aad: personalization,
        ).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(
            digestSize: 64,
            personalization: personalization,
          ).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with salt and personalization', () {
      final salt = randomBytes(16);
      final personalization = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(
          64,
          salt: salt,
          aad: personalization,
        ).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(
            digestSize: 64,
            salt: salt,
            personalization: personalization,
          ).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with key, salt and personalization', () {
      final key = randomBytes(16);
      final salt = randomBytes(16);
      final aad = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(64).mac.by(key, salt: salt, aad: aad).hex(data);
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(
            digestSize: 64,
            key: key,
            salt: salt,
            personalization: aad,
          ).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });
  });
}
