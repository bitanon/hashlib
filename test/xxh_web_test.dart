// Copyright (c) 2026, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore: library_annotations
@Tags(['node-only'])

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

// XXHash64, XXH3 and XXH128 require 64-bit integers, which are not available
// on the web platform. Their implementations are intentionally replaced with
// stubs that throw [UnimplementedError] there. These tests lock that behavior
// in; if real web support ever lands, they will fail as a reminder to update
// the documentation in README.md and the class doc comments.
void main() {
  group('xxHash on the web platform', () {
    test('xxh64 throws UnimplementedError', () {
      expect(() => xxh64.convert([1, 2, 3]), throwsUnimplementedError);
    });
    test('xxh64 with a seed throws UnimplementedError', () {
      expect(
          () => xxh64.withSeed(1).convert([1, 2, 3]), throwsUnimplementedError);
    });
    test('xxh3 throws UnimplementedError', () {
      expect(() => xxh3.convert([1, 2, 3]), throwsUnimplementedError);
    });
    test('xxh128 throws UnimplementedError', () {
      expect(() => xxh128.convert([1, 2, 3]), throwsUnimplementedError);
    });
    test('xxh32 works on the web', () {
      expect(xxh32.convert([1, 2, 3]).hex(), isNotEmpty);
    });
  });
}
