// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/alder32.dart';
import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Alder-32 test', () {
    test("name", () {
      expect(alder32.name, 'ALDER-32');
    });
    test('alder32code with empty string', () {
      expect(alder32code(""), 1);
    });
    test('alder32code with a string', () {
      expect(alder32code("Wikipedia"), 300286872);
    });
    test('sink test', () {
      final sink = Alder32Hash();
      expect(sink.closed, isFalse);
      expect(sink.a, 1);
      expect(sink.b, 0);
      sink.add([10, 20]);
      expect(sink.closed, isFalse);
      sink.close();
      expect(sink.closed, isTrue);
      expect(() => sink.add([10]), throwsStateError);
      sink.reset();
      expect(sink.closed, isFalse);
      expect(sink.a, 1);
      expect(sink.b, 0);
      sink.add([10, 20]);
      expect(sink.digest().number(), (sink.b << 16) | sink.a);
      expect(sink.closed, isTrue);
    });
  });
}
