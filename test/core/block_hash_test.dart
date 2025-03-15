// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:hashlib/hashlib.dart';

// Concrete implementation for testing purposes
class TestBlockHashSink extends BlockHashSink {
  TestBlockHashSink(super.blockLength, [int? bufferLength])
      : super(bufferLength: bufferLength);

  @override
  int hashLength = 8;

  @override
  void $update(List<int> block, [int offset = 0, bool last = false]) {
    //
  }

  @override
  Uint8List $finalize() {
    return buffer;
  }
}

void main() {
  group('BlockHashSink', () {
    test('Invalid block size', () {
      expect(
        () => TestBlockHashSink(0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => TestBlockHashSink(-1),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => TestBlockHashSink(-10),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Invalid buffer size', () {
      TestBlockHashSink(1, 0);
      expect(
        () => TestBlockHashSink(10, -1),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => TestBlockHashSink(10, -100),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Initial state', () {
      final sink = TestBlockHashSink(16);
      expect(sink.closed, isFalse);
      expect(sink.messageLength, equals(0));
      expect(sink.pos, equals(0));
    });

    test('Reset method', () {
      final sink = TestBlockHashSink(16);
      sink.add([1, 2, 3]);
      sink.reset();
      expect(sink.closed, isFalse);
      expect(sink.messageLength, equals(0));
      expect(sink.pos, equals(0));
    });

    test('Add and process data', () {
      final sink = TestBlockHashSink(16);
      sink.add([1, 2, 3, 4, 5]);
      expect(sink.messageLength, equals(5));
      expect(sink.pos, equals(5));
    });

    test('Digest after close', () {
      final sink = TestBlockHashSink(16);
      sink.add([1, 2, 3, 4, 5]);
      final digest = sink.digest();
      expect(sink.closed, isTrue);
      expect(digest.bytes.isNotEmpty, isTrue);
    });

    test('Throws error if adding data after close', () {
      final sink = TestBlockHashSink(16);
      sink.add([1, 2, 3, 4, 5]);
      sink.close();
      expect(() => sink.add([6, 7, 8]), throwsA(isA<StateError>()));
    });

    test('Buffer processing', () {
      final sink = TestBlockHashSink(16);
      final data = List<int>.filled(32, 1); // Two full blocks
      sink.add(data);
      expect(sink.messageLength, equals(32));
      expect(sink.pos, equals(0)); // Should be 0 after processing full blocks
    });
  });
}
