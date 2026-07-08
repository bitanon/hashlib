// Copyright (c) 2025, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:pointycastle/digests/md2.dart' as pc_md2;
import 'package:test/test.dart';

void main() {
  group('MD2 comparison', () {
    test('with pointy-castle for random inputs of length 0..255', () {
      for (int i = 0; i < 256; ++i) {
        final data = randomBytes(i);
        expect(
          md2.convert(data).hex(),
          toHex(pc_md2.MD2Digest().process(Uint8List.fromList(data))),
          reason: 'Message length: $i',
        );
      }
    });
  });
}
