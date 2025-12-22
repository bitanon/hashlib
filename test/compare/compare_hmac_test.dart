// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:test/test.dart';

void main() {
  group('HMAC comparison', () {
    test('with crypto for MD5', () {
      var key = "key";
      var msg = "The quick brown fox jumps over the lazy dog";
      var expected = "80070713463e7749b90c2dc24911e275";
      var actual = toHex(
        md5.hmac.byString(key).convert(msg.codeUnits).bytes,
      );
      var actual2 = toHex(
        crypto.Hmac(crypto.md5, key.codeUnits).convert(msg.codeUnits).bytes,
      );
      expect(actual2, expected, reason: "Key: $key | Message: $msg");
      expect(actual, expected, reason: "Key: $key | Message: $msg");
    });

    test('with crypto', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final key = randomBytes(i & 0x7F);
        expect(
          toHex(sha1.hmac.by(key).convert(data).bytes),
          toHex(crypto.Hmac(crypto.sha1, key).convert(data).bytes),
          reason: 'Key: "${String.fromCharCodes(key)}" [${key.length}]\n'
              'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        final key = randomBytes(i & 0x7F);
        expect(
          toHex(sha384.hmac.by(key).convert(data).bytes),
          toHex(crypto.Hmac(crypto.sha384, key).convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });
}
