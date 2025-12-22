// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'dart:io';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:pointycastle/digests/md4.dart' as pc_md4;
import 'package:test/test.dart';

void main() {
  group('MD4 comparison', () {
    test('with pointy-castle', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(md4.convert(data).bytes),
          toHex(pc_md4.MD4Digest().process(data)),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('for a file sync', () {
      var file = File('LICENSE');
      var hash = pc_md4.MD4Digest().process(file.readAsBytesSync());
      var hash2 = md4.fileSync(file);
      expect(hash2.hex(), toHex(hash));
    }, tags: 'vm-only');
  });
}
