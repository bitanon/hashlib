// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:test/test.dart';
import 'package:hashlib/hashlib.dart';

void main() {
  group('MACSinkBase', () {
    test('derivedKeyLength should return the hashLength', () {
      final sink = md5.hmac(List.empty()).createSink();
      expect(sink.derivedKeyLength, sink.hashLength);
    });

    test('init should initialize with the provided key', () {
      final key = [1, 2, 3, 4, 5];
      final sink = md5.hmac([1]).createSink();
      var inner = [...sink.innerKey];
      var outer = [...sink.outerKey];
      sink.init(key);
      expect(inner, isNot(equals(sink.innerKey)));
      expect(outer, isNot(equals(sink.outerKey)));
      sink.init([1]);
      expect(inner, equals(sink.innerKey));
      expect(outer, equals(sink.outerKey));
    });
  });

  group('MACHashBase', () {
    test('createSink should create a MACSinkBase', () {
      expect(sha256.hmac([2]).createSink(), isInstanceOf<MACSinkBase>());
    });

    test('sign should return a HashDigest', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final result = md5.hmac(key).sign(message);
      expect(result, isInstanceOf<HashDigest>());
      expect(result.bytes.length, equals(16));
    });

    test('verify should return true if the tag matches the message', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final tag = md5.hmac(key).sign(message).bytes;
      expect(md5.hmac(key).verify(tag, message), isTrue);
    });

    test('verify should return false if the tag does not match', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final tag = [1, 2, 3];
      expect(md5.hmac(key).verify(tag, message), isFalse);
    });
  });
}
