// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('MACSinkBase', () {
    test('derivedKeyLength should be defined', () {
      final algo = md5.hmac.by([]);
      final sink = algo.createSink();
      expect(sink.derivedKeyLength, sink.hashLength);
    });

    test('should initialize with the provided key', () {
      final key = [1, 2, 3, 4, 5];
      final sink1 = md5.hmac.by(key).createSink();
      final sink2 = md5.hmac.by([1]).createSink();
      expect(sink1.innerKey, isNot(equals(sink2.innerKey)));
      expect(sink1.outerKey, isNot(equals(sink2.outerKey)));
      final sink3 = md5.hmac.by([1]).createSink();
      expect(sink2.innerKey, (equals(sink3.innerKey)));
      expect(sink2.outerKey, (equals(sink3.outerKey)));
    });
  });

  group('MACHash', () {
    test('createSink should create a MACSinkBase', () {
      expect(sha256.hmac.by([2]).createSink(), isA<MACSinkBase>());
    });

    test('sign should return a HashDigest', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final result = md5.hmac.by(key).sign(message);
      expect(result, isA<HashDigest>());
      expect(result.bytes.length, equals(16));
    });

    test('verify should return true if the tag matches the message', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final tag = md5.hmac.by(key).sign(message).bytes;
      expect(md5.hmac.by(key).verify(tag, message), isTrue);
    });

    test('verify should return false if the tag does not match', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final tag = [1, 2, 3];
      expect(md5.hmac.by(key).verify(tag, message), isFalse);
    });
  });

  group('MACHashBase', () {
    test('by create a MACHash', () {
      expect(sha1.hmac.by([2]), isA<MACHash>());
    });

    test('sign should return a HashDigest', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final result = md5.hmac.sign(key, message);
      expect(result, isA<HashDigest>());
      expect(result.bytes.length, equals(16));
    });

    test('verify should return true if the tag matches the message', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final tag = md5.hmac.sign(key, message).bytes;
      expect(md5.hmac.verify(key, tag, message), isTrue);
    });

    test('verify should return false if the tag does not match', () {
      final key = [10];
      final message = [1, 2, 3, 4, 5];
      final tag = [1, 2, 3];
      expect(md5.hmac.verify(key, tag, message), isFalse);
    });
  });
}
