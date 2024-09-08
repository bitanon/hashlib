// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore: library_annotations
@Tags(['vm-only'])

import 'dart:io';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

List<String> readLines(String filename) {
  final file = File(Directory('test/fixures/$filename').absolute.path);
  final text = file.readAsStringSync();
  return text.split(RegExp(r'(\r)?\n'));
}

void main() {
  group('XXH test with fixures', () {
    const int maxLength = 1500;
    final text = readLines('long.txt').join('\n').codeUnits;

    test('for xxh32', () {
      var actual = readLines('xxh32.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        var out = xxh32.hex(text.take(len).toList());
        expect(out, equals(parts[1]), reason: 'length: $len');
      }
    });

    test('for xxh64', () {
      var actual = readLines('xxh64.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        var out = xxh64.hex(text.take(len).toList());
        expect(out, equals(parts[1]), reason: 'length: $len');
      }
    });

    test('for xxh3-64', () {
      var actual = readLines('xxh3_64.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        var out = xxh3.hex(text.take(len).toList());
        expect(out, equals(parts[1]), reason: 'length: $len');
      }
    });

    test('for xxh3-128', () {
      var actual = readLines('xxh3_128.csv');
      for (var line in actual) {
        var parts = line.split(',');
        if (parts.length != 2) continue;
        int len = int.parse(parts[0]);
        if (len > maxLength) break;
        var out = xxh128.hex(text.take(len).toList());
        expect(out, equals(parts[1]), reason: 'length: $len');
      }
    });
  });
}
