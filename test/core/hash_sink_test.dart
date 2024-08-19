// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:hashlib/hashlib.dart';

// Concrete implementation for testing purposes
class TestHashDigestSink extends HashDigestSink {
  bool _closed = false;
  List<int> _data = [];

  @override
  int get hashLength => 16;

  @override
  bool get closed => _closed;

  @override
  void add(List<int> data, [int start = 0, int? end]) {
    if (_closed) {
      throw StateError('Sink is closed');
    }
    end ??= data.length;
    _data.addAll(data.sublist(start, end));
  }

  @override
  HashDigest digest() {
    _closed = true;
    int hash = _data.fold(0, (prev, elem) => prev ^ elem);
    final result = List.filled(hashLength, hash);
    return HashDigest(Uint8List.fromList(result));
  }

  @override
  void reset() {
    _closed = false;
    _data.clear();
  }
}

class TestHashBase extends HashBase {
  @override
  String get name => 'TestHash';

  @override
  HashDigestSink createSink() => TestHashDigestSink();
}

void main() {
  group('HashBase', () {
    test('convert method', () {
      final hashBase = TestHashBase();
      final digest = hashBase.convert([1, 2, 3, 4]);
      expect(digest.bytes, equals(List.filled(16, 1 ^ 2 ^ 3 ^ 4)));
    });
    test('string method with default encoding', () {
      final hash = TestHashBase();
      final digest = hash.string('test');
      expect(digest.bytes,
          equals(List.filled(16, 'test'.codeUnits.reduce((a, b) => a ^ b))));
    });

    test('string method with custom encoding', () {
      final hash = TestHashBase();
      final digest = hash.string('test', utf8);
      expect(digest.bytes,
          equals(List.filled(16, utf8.encode('test').reduce((a, b) => a ^ b))));
    });

    test('bind method', () async {
      final hash = TestHashBase();
      final stream = Stream.fromIterable([
        [1, 2, 3],
        [4, 5, 6]
      ]);
      final digest = await hash.bind(stream).first;
      expect(digest.bytes, equals(List.filled(16, 1 ^ 2 ^ 3 ^ 4 ^ 5 ^ 6)));
    });

    test('byteStream method', () async {
      final hash = TestHashBase();
      final stream = Stream.fromIterable([1, 2, 3, 4, 5, 6]);
      final digest = await hash.byteStream(stream, 4);
      expect(digest.bytes, equals(List.filled(16, 1 ^ 2 ^ 3 ^ 4 ^ 5 ^ 6)));
    });

    test('stringStream method with default encoding', () async {
      final hash = TestHashBase();
      final stream = Stream.fromIterable(['hello', 'world']);
      final digest = await hash.stringStraem(stream);
      expect(
          digest.bytes,
          equals(
              List.filled(16, 'helloworld'.codeUnits.reduce((a, b) => a ^ b))));
    });

    test('stringStream method with custom encoding', () async {
      final hash = TestHashBase();
      final stream = Stream.fromIterable(['hello', 'world']);
      final digest = await hash.stringStraem(stream, utf8);
      expect(
          digest.bytes,
          equals(List.filled(
              16, utf8.encode('helloworld').reduce((a, b) => a ^ b))));
    });

    test('cast throws error', () {
      final hashBase = TestHashBase();
      expect(() => hashBase.cast(), throwsUnsupportedError);
    });
  });
}
