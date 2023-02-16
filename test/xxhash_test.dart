// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

@OnPlatform({
  'node': Skip('not supported'),
})

import 'dart:io';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('xxHash test with fixures', () {
    fixtureFile(String filename) {
      return File(Directory('test/fixures/$filename').absolute.path);
    }

    final text = fixtureFile('long.txt').readAsBytesSync();

    test('for xxh32', () {
      var actual = fixtureFile('xxh32.csv');
      for (var line in actual.readAsLinesSync()) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        expect(
          parts[1],
          xxh32.convert(text.take(len).toList()).hex(),
          reason: 'At length: $len',
        );
      }
    });

    test('for xxh64', () {
      var actual = fixtureFile('xxh64.csv');
      for (var line in actual.readAsLinesSync()) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        expect(
          parts[1],
          xxh64.convert(text.take(len).toList()).hex(),
          reason: 'At length: $len',
        );
      }
    });

    test('for xxh3-64', () {
      var actual = fixtureFile('xxh3_64.csv');
      for (var line in actual.readAsLinesSync()) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        expect(
          xxh3.convert(text.take(len).toList()).hex(),
          parts[1],
          reason: 'At length: $len',
        );
      }
    });

    test('for xxh3-128', () {
      var actual = fixtureFile('xxh3_128.csv');
      for (var line in actual.readAsLinesSync()) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        expect(
          xxh128.convert(text.take(len).toList()).hex(),
          parts[1],
          reason: 'At length: $len',
        );
      }
    });
  });
}
