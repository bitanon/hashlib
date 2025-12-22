// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:test/test.dart';

void main() {
  group('SHA-512 comparison', () {
    test('with known implementations', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha512.convert(data).bytes),
          toHex(crypto.sha512.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        expect(
          toHex(sha512.convert(data).bytes),
          toHex(crypto.sha512.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });
}
