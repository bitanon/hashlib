import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

void main() {
  group('HMAC test', () {
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
  });
}
