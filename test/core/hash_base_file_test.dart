// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

@Tags(['skip-vm'])

import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:hashlib/hashlib.dart';

class MockHashBase extends HashBase {
  @override
  final String name = "mock";

  @override
  createSink() {
    throw UnimplementedError();
  }
}

void main() {
  group('HashBaseFileSupport', () {
    test('UnsupportedError for asynchronous file operation', () {
      final mock = MockHashBase();
      expect(() => mock.file('dummy_file.txt'), throwsUnsupportedError);
    });

    test('throws UnsupportedError for synchronous file operation', () {
      final mock = MockHashBase();
      expect(() => mock.fileSync('dummy_file.txt'), throwsUnsupportedError);
    });

    test('UnsupportedError for asynchronous file with parameters', () {
      final mock = MockHashBase();
      expect(
        () => mock.file('dummy_file.txt', 10, 100),
        throwsUnsupportedError,
      );
    });

    test('UnsupportedError for synchronous file with parameters', () {
      final mock = MockHashBase();
      expect(
        () => mock.fileSync('dummy_file.txt',
            start: 10, end: 100, bufferSize: 4096),
        throwsA(isA<UnsupportedError>()),
      );
    });
  });
}
