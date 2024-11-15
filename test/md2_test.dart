// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

final tests = {
  "": "8350e5a3e24c153df2275c9f80692773",
  "a": "32ec01ec4a6dac72c0ab96fb34c0b5d1",
  "abc": "da853b0d3f88d99b30283a69e6ded6bb",
  "message digest": "ab4f496bfb2a530b219ff33031fe06b0",
  "abcdefghijklmnopqrstuvwxyz": "4e8ddff3650292ab5a4108c3aa47940b",
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789":
      "da33def2a42df13975352846c30338cd",
  "12345678901234567890123456789012345678901234567890123456789012345678901234567890":
      "d5976f79d83d3a0dc9806c3c66f3efd8",
};

void main() {
  group('MD2 test', () {
    test('with an empty string', () {
      expect(md2sum(""), tests[""]);
    });

    test('with a single letter', () {
      expect(md2sum("a"), tests["a"]);
    });

    test('with a few letters', () {
      expect(md2sum("abc"), tests["abc"]);
    });

    test('with a short string', () {
      expect(md2sum("message digest"), tests["message digest"]);
    });

    test('with special case', () {
      var key =
          "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
      expect(md2sum(key), tests[key]);
    });

    test('with longest string', () {
      var last = tests.entries.last;
      expect(md2sum(last.key), last.value);
    });

    test('with all known cases', () {
      tests.forEach((key, value) {
        expect(md2sum(key), value);
      });
    });

    test('with stream', () async {
      final last = tests.entries.last;
      final input = last.key.codeUnits;
      final stream = Stream.fromIterable([
        input.take(7).toList(),
        input.skip(7).take(10).toList(),
        input.skip(17).take(15).toList(),
        input.skip(32).toList(),
      ]);
      final result = await md2.bind(stream).first;
      expect(result.hex(), last.value, reason: "'${last.key}'");
    });

    test('sink test', () {
      final last = tests.entries.last;
      final input = last.key.codeUnits;
      final output = last.value;
      final sink = md2.createSink();
      expect(sink.closed, isFalse);
      for (int i = 0; i < input.length; i += 12) {
        sink.add(input.skip(i).take(12).toList());
      }
      expect(sink.digest().hex(), equals(output));
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
      sink.reset();
      sink.add(input);
      sink.close();
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
    });
  });
}
