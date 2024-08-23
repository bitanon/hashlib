// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore: library_annotations
@Tags(['vm-only'])

import 'dart:io';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

File fixtureFile(String filename) {
  return File(Directory('test/fixures/$filename').absolute.path);
}

List<String> readLines(String filename) {
  final text = fixtureFile('long.txt').readAsStringSync();
  return text.split(RegExp(r'(\r)?\n'));
}

void main() {
  group('XXH test with fixures', () {
    const int maxLength = 1000;
    final text = fixtureFile('long.txt').readAsBytesSync();

    test('for xxh32', () {
      var actual = readLines('xxh32.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        expect(
          parts[1],
          xxh32.hex(text.take(len).toList()),
          reason: 'At length: $len',
        );
      }
    });

    test('for xxh64', () {
      var actual = readLines('xxh64.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        expect(
          parts[1],
          xxh64.hex(text.take(len).toList()),
          reason: 'At length: $len',
        );
      }
    });

    test('for xxh3-64', () {
      var actual = readLines('xxh3_64.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        expect(
          xxh3.hex(text.take(len).toList()),
          parts[1],
          reason: 'At length: $len',
        );
      }
    });

    test('for xxh3-128', () {
      var actual = readLines('xxh3_128.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        expect(
          xxh128.hex(text.take(len).toList()),
          parts[1],
          reason: 'At length: $len',
        );
      }
    });
  });
}
