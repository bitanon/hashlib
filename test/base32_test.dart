// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/codecs_base.dart';
import 'package:test/test.dart';

void main() {
  group('Test base32', () {
    // source: https://github.com/daegalus/dart-base32
    group('encoding', () {
      test('"" -> ""', () {
        var s = '';
        expect(toBase32(s.codeUnits), equals(''));
      });
      test('f -> MY', () {
        var s = 'f';
        expect(toBase32(s.codeUnits), equals('MY'));
      });
      test('fo -> MZXQ', () {
        var s = 'fo';
        expect(toBase32(s.codeUnits), equals('MZXQ'));
      });
      test('foo -> MZXW6', () {
        var s = 'foo';
        expect(toBase32(s.codeUnits), equals('MZXW6'));
      });
      test('foob -> MZXW6YQ', () {
        var s = 'foob';
        expect(toBase32(s.codeUnits), equals('MZXW6YQ'));
      });
      test('fooba -> MZXW6YTB', () {
        var s = 'fooba';
        expect(toBase32(s.codeUnits), equals('MZXW6YTB'));
      });
      test('foobar -> MZXW6YTBOI', () {
        var s = 'foobar';
        expect(toBase32(s.codeUnits), equals('MZXW6YTBOI'));
      });
      test('48656c6c6f21deadbeef -> JBSWY3DPEHPK3PXP', () {
        var encoded = fromHex('48656c6c6f21deadbeef');
        expect(toBase32(encoded), equals('JBSWY3DPEHPK3PXP'));
      });
      test('48656c6c6f21deadbe -> JBSWY3DPEHPK3PQ', () {
        var encoded = fromHex('48656c6c6f21deadbe');
        expect(toBase32(encoded), equals('JBSWY3DPEHPK3PQ'));
      });
      test('foobar --lower--> mzxw6ytboi', () {
        var s = 'foobar';
        expect(toBase32(s.codeUnits, upper: false), equals('mzxw6ytboi'));
      });
      test('48656c6c6f21deadbeef --lower--> jbswy3dpehpk3pxp', () {
        var encoded = fromHex('48656c6c6f21deadbeef');
        expect(toBase32(encoded, upper: false), equals('jbswy3dpehpk3pxp'));
      });
    });

    group('decoding', () {
      test('"" -> ""', () {
        var s = '';
        expect(fromBase32(''), equals(s.codeUnits));
      });
      test('MY -> f', () {
        var s = 'f';
        expect(fromBase32('MY'), equals(s.codeUnits));
      });
      test('MZXQ -> fo', () {
        var s = 'fo';
        expect(fromBase32('MZXQ'), equals(s.codeUnits));
      });
      test('MZXW6 -> foo', () {
        var s = 'foo';
        expect(fromBase32('MZXW6'), equals(s.codeUnits));
      });
      test('MZXW6YQ -> foob', () {
        var s = 'foob';
        expect(fromBase32('MZXW6YQ'), equals(s.codeUnits));
      });
      test('MZXW6YTB -> fooba', () {
        var s = 'fooba';
        expect(fromBase32('MZXW6YTB'), equals(s.codeUnits));
      });
      test('MZXW6YTBOI -> foobar', () {
        var s = 'foobar';
        expect(fromBase32('MZXW6YTBOI'), equals(s.codeUnits));
      });
      test('JBSWY3DPEHPK3PXP -> 48656c6c6f21deadbeef', () {
        var decoded = fromBase32('JBSWY3DPEHPK3PXP');
        expect(toHex(decoded), equals('48656c6c6f21deadbeef'));
      });
      test('JBSWY3DPEHPK3PQ -> 48656c6c6f21deadbe', () {
        var decoded = fromBase32('JBSWY3DPEHPK3PQ');
        expect(toHex(decoded), equals('48656c6c6f21deadbe'));
      });
      test('mzxw6ytboi -> foobar', () {
        var s = 'foobar';
        expect(fromBase32('mzxw6ytboi'), equals(s.codeUnits));
      });
      test('jbswy3dpehpk3pxp -> 48656c6c6f21deadbeef', () {
        var decoded = fromBase32('jbswy3dpehpk3pxp');
        expect(toHex(decoded), equals('48656c6c6f21deadbeef'));
      });
      test('jbswy3dpehpk3pq -> 48656c6c6f21deadbe', () {
        var decoded = fromBase32('jbswy3dpehpk3pq');
        expect(toHex(decoded), equals('48656c6c6f21deadbe'));
      });
    });

    group('encoding with padding', () {
      test('f -> MY======', () {
        var s = 'f';
        var r = 'MY======';
        expect(toBase32(s.codeUnits, padding: true), equals(r));
      });
      test('fo -> MZXQ====', () {
        var s = 'fo';
        var r = 'MZXQ====';
        expect(toBase32(s.codeUnits, padding: true), equals(r));
      });
      test('foo -> MZXW6===', () {
        var s = 'foo';
        var r = 'MZXW6===';
        expect(toBase32(s.codeUnits, padding: true), equals(r));
      });
      test('foob -> MZXW6YQ=', () {
        var s = 'foob';
        var r = 'MZXW6YQ=';
        expect(toBase32(s.codeUnits, padding: true), equals(r));
      });
      test('foobar -> MZXW6YTBOI======', () {
        var s = 'foobar';
        var r = 'MZXW6YTBOI======';
        expect(toBase32(s.codeUnits, padding: true), equals(r));
      });
      test('48656c6c6f21deadbe -> JBSWY3DPEHPK3PQ=', () {
        var s = String.fromCharCodes(fromHex('48656c6c6f21deadbe'));
        var r = 'JBSWY3DPEHPK3PQ=';
        expect(toBase32(s.codeUnits, padding: true), equals(r));
      });
    });

    group('decoding with padding', () {
      test('MY====== -> f', () {
        var s = 'MY======';
        var r = 'f';
        expect(fromBase32(s), equals(r.codeUnits));
      });
      test('MZXQ==== -> fo', () {
        var s = 'MZXQ====';
        var r = 'fo';
        expect(fromBase32(s), equals(r.codeUnits));
      });
      test('MZXW6=== -> foo', () {
        var s = 'MZXW6===';
        var r = 'foo';
        expect(fromBase32(s), equals(r.codeUnits));
      });
      test('MZXW6YQ= -> foob', () {
        var s = 'MZXW6YQ=';
        var r = 'foob';
        expect(fromBase32(s), equals(r.codeUnits));
      });
      test('MZXW6YTBOI====== -> foobar', () {
        var s = 'MZXW6YTBOI======';
        var r = 'foobar';
        expect(fromBase32(s), equals(r.codeUnits));
      });
      test('JBSWY3DPEHPK3PQ= -> 48656c6c6f21deadbe', () {
        var s = 'JBSWY3DPEHPK3PQ=';
        var r = String.fromCharCodes(fromHex('48656c6c6f21deadbe'));
        expect(fromBase32(s), equals(r.codeUnits));
      });
    });
  });
}