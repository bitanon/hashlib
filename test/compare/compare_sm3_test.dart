// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'dart:io';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:pointycastle/digests/sm3.dart' as pc_sm3;
import 'package:test/test.dart';

void main() {
  group('SM3 comparison', () {
    test('with pointy-castle', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          sm3.convert(data).hex(),
          toHex(pc_sm3.SM3Digest().process(data)),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('for a file sync', () {
      var file = File('LICENSE');
      var hash = pc_sm3.SM3Digest().process(file.readAsBytesSync());
      var hash2 = sm3.fileSync(file);
      expect(hash2.hex(), toHex(hash));
    }, tags: 'vm-only');
  });
}
