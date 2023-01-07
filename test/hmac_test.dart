import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

void main() {
  group('HMAC test', () {
    test('with MD5', () {
      var key = "key";
      var msg = "The quick brown fox jumps over the lazy dog";
      var expected = "80070713463e7749b90c2dc24911e275";
      var actual = toHex(
        md5.hmacBy(key).convert(toBytes(msg)).bytes,
      );
      var actual2 = toHex(
        crypto.Hmac(crypto.md5, toBytes(key)).convert(toBytes(msg)).bytes,
      );
      expect(actual2, expected, reason: "Key: $key | Message: $msg");
      expect(actual, expected, reason: "Key: $key | Message: $msg");
    });

    test('with SHA1', () {
      var key = "key";
      var msg = "The quick brown fox jumps over the lazy dog";
      var expected = "de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9";
      var actual = sha1.hmac(toBytes(key)).convert(toBytes(msg)).hex();
      expect(actual, expected, reason: "Key: $key | Message: $msg");
    });

    test('with SHA256', () {
      var key = "key";
      var msg = "The quick brown fox jumps over the lazy dog";
      var expected =
          "f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8";
      var actual = sha256.hmac(toBytes(key)).convert(toBytes(msg)).hex();
      expect(actual, expected, reason: "Key: $key | Message: $msg");
    });

    test('with SHA512', () {
      var key = "key";
      var msg = "The quick brown fox jumps over the lazy dog";
      var expected =
          "b42af09057bac1e2d41708e48a902e09b5ff7f12ab428a4fe86653c73dd248fb82f948a549f7b791a5b41915ee4d1ec3935357e4e2317250d0372afa2ebeeb3a";
      var actual = sha512.hmac(toBytes(key)).convert(toBytes(msg)).hex();
      expect(actual, expected, reason: "Key: $key | Message: $msg");
    });

    test('to compare against known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        final key = List<int>.filled(i & 0x7F, 99);
        expect(
          toHex(sha1.hmac(key).convert(data).bytes),
          toHex(crypto.Hmac(crypto.sha1, key).convert(data).bytes),
          reason: 'Key: "${String.fromCharCodes(key)}" [${key.length}]\n'
              'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        final key = List<int>.filled(i & 0x7F, 99);
        expect(
          toHex(sha384.hmac(key).convert(data).bytes),
          toHex(crypto.Hmac(crypto.sha384, key).convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });
}
