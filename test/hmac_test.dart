import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('HMAC test', () {
    test("with MD5", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected = "80070713463e7749b90c2dc24911e275";
      final actual = md5.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA-1", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected = "de7c9b85b8b78aa6bc8a7a36f70a90701c9db4d9";
      final actual = sha1.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA-224", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "88ff8b54675d39b8f72322e65ff945c52d96379988ada25639747e69";
      final actual = sha224.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA-256", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "f7bc83f430538424b13298e6aa6fb143ef4d59a14946175997479dbc2d1a3cd8";
      final actual = sha256.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA-384", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected = "d7f4727e2c0b39ae0f1e40cc96f60242d5b7801841cea6"
          "fc592c5d3e1ae50700582a96cf35e1e554995fe4e03381c237";
      final actual = sha384.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA-512", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "b42af09057bac1e2d41708e48a902e09b5ff7f12ab428a4fe86653c73dd248fb"
          "82f948a549f7b791a5b41915ee4d1ec3935357e4e2317250d0372afa2ebeeb3a";
      final actual = sha512.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA-512/224", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "a1afb4f708cb63570639195121785ada3dc615989cc3c73f38e306a3";
      final actual = sha512t224.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA-512/256", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "7fb65e03577da9151a1016e9c2e514d4d48842857f13927f348588173dca6d89";
      final actual = sha512t256.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA3-224", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "ff6fa8447ce10fb1efdccfe62caf8b640fe46c4fb1007912bf85100f";
      final actual = sha3_224.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA3-256", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "8c6e0683409427f8931711b10ca92a506eb1fafa48fadd66d76126f47ac2c333";
      final actual = sha3_256.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA3-384", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected = "aa739ad9fcdf9be4a04f06680ade7a1bd1e01a0af6"
          "4accb04366234cf9f6934a0f8589772f857681fcde8acc256091a2";
      final actual = sha3_384.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
    test("with SHA3-512", () {
      final key = "key";
      final msg = "The quick brown fox jumps over the lazy dog";
      final expected =
          "237a35049c40b3ef5ddd960b3dc893d8284953b9a4756611b1b61bffcf53edd979"
          "f93547db714b06ef0a692062c609b70208ab8d4a280ceee40ed8100f293063";
      final actual = sha3_512.hmacBy(key).string(msg).hex();
      expect(actual, expected);
    });
  });
}
