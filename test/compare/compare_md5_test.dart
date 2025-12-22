// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'dart:io';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:test/test.dart';

void main() {
  group('MD5 comparison', () {
    test('for a file async', () async {
      var file = File('LICENSE');
      var hash = await crypto.md5.bind(file.openRead()).first;
      var hash2 = await md5.file(file);
      expect(hash2.hex(), toHex(hash.bytes));
    }, tags: 'vm-only');

    test('for a file sync', () async {
      var file = File('LICENSE');
      var hash = await crypto.md5.bind(file.openRead()).first;
      var hash2 = md5.fileSync(file);
      expect(hash2.hex(), toHex(hash.bytes));
    }, tags: 'vm-only');

    test('with crypto', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(md5.convert(data).bytes),
          toHex(crypto.md5.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        expect(
          toHex(md5.convert(data).bytes),
          toHex(crypto.md5.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });
}
