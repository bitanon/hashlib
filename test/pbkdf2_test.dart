// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('PBKDF2 test', () {
    test("name", () {
      final iv = "key".codeUnits;
      expect(sha256.pbkdf2(iv).name, 'SHA-256/HMAC/PBKDF2');
      expect(sha256.hmac.pbkdf2(iv).name, 'SHA-256/HMAC/PBKDF2');
      expect(sha1.pbkdf2(iv).name, 'SHA1/HMAC/PBKDF2');
      expect(sha1.hmac.pbkdf2(iv).name, 'SHA1/HMAC/PBKDF2');
      expect(md5.pbkdf2(iv).name, 'MD5/HMAC/PBKDF2');
      expect(md5.hmac.pbkdf2(iv).name, 'MD5/HMAC/PBKDF2');
    });
    test('fromSecurity', () {
      var pw = 'password'.codeUnits;
      var out = PBKDF2.fromSecurity(PBKDF2Security.little).convert(pw);
      expect(out.length, PBKDF2Security.little.dklen);
    });

    test("Default method: pbkdf2", () {
      var hash = pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '09d106dccc35eae63c48aa472394de511547ce296ab55685b7ba8b304bec68fe';
      expect(hash.hex(), matcher);
    });

    test("with MD5", () {
      final pw = 'password'.codeUnits;
      final iv = "some salt".codeUnits;
      final result =
          '592e779487b7c4dc20ca5cd276163bbb760a40960bb17187cd4895238361d201';
      final output = md5.pbkdf2(iv, iterations: 100, keyLength: 32).hex(pw);
      expect(output, equals(result));
    });

    test("with MD5 through HMAC", () {
      final pw = 'password'.codeUnits;
      final iv = "some salt".codeUnits;
      final result = '592e779487b7c4dc20ca5cd276163bbb';
      final output = md5.pbkdf2(iv, iterations: 100, keyLength: 16).hex(pw);
      expect(output, equals(result));
    });

    test("with SHA-1", () {
      final pw = 'password'.codeUnits;
      final iv = "some salt".codeUnits;
      final result =
          'a001e5ddf0b823ccc74edc957ab881e7924ef5c608956cd7d32606b8d7c8acb1';
      final output = sha1.pbkdf2(iv, iterations: 100, keyLength: 32).hex(pw);
      expect(output, equals(result));
    });

    test("with SHA-224", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha224.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '57f86bc67aad5fa335f8f0f8ecd7b550c7f2462502d3058897299f49111f8948';
      expect(output, equals(matcher));
    });

    test("with SHA-256", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha256.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '09d106dccc35eae63c48aa472394de511547ce296ab55685b7ba8b304bec68fe';
      expect(output, equals(matcher));
    });

    test("with SHA-384", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha384.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '6091b46523e28ffa34d777f81c9ef446cd2983601a6dbdd8cc63aa0fa461b624';
      expect(output, equals(matcher));
    });

    test("with SHA-512", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha512.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '05f45e131d21985a38c25cb30c9edee0bfe697d19fb84a0d55e89e2a347c7905';
      expect(output, equals(matcher));
    });

    test("with SHA-512/224", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha512t224.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '7b03e2f53046cf52a0d8ace8f469bef3fdbe0a2b4b112b10586d33119a98aa94';
      expect(output, equals(matcher));
    });

    test("with SHA-512/256", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha512t256.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '73b02a03a67fe08ab8fee80f2d135f4afb954380406994b0f2670a0f5d0c7faa';
      expect(output, equals(matcher));
    });

    test("with SHA3-224", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha3_224.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '3543a75506759d603c2058847f39969f8d6c164ebc50c53eb44f290c7835521c';
      expect(output, equals(matcher));
    });

    test("with SHA3-256", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha3_256.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          'c4aae4cbf79071757bf167a8cff387a615295bed94320d394e9ed15a4b53a9c1';
      expect(output, equals(matcher));
    });

    test("with SHA3-384", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha3_384.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          'e39eef6add54c1b1cddb35dcf44cce8163941b1e73a26bd6f422dbdf4a98b7c0';
      expect(output, equals(matcher));
    });

    test("with SHA3-512", () {
      var pw = 'password'.codeUnits;
      var iv = "some salt".codeUnits;
      var output = sha3_512.pbkdf2(iv, iterations: 50, keyLength: 32).hex(pw);
      var matcher =
          '349d16a5e9cb37d277c0d05235c63bf1d094367c27968262d9d9460d96bbed79';
      expect(output, equals(matcher));
    });

    test("long password with SHA-256", () {
      var hash = pbkdf2(
        'passwd'.codeUnits,
        "salt".codeUnits,
        1,
        256,
      );
      var matcher =
          '55ac046e56e3089fec1691c22544b605f94185216dde0465e68b9d57c20dacbc'
          '49ca9cccf179b645991664b39d77ef317c71b845b1e30bd509112041d3a19783'
          'c294e850150390e1160c34d62e9665d659ae49d314510fc98274cc7968196810'
          '4b8f89237e69b2d549111868658be62f59bd715cac44a1147ed5317c9bae6b2a'
          'd89a7e71d005442240f5d97bd6d58c2cec9417c63f4ebf19661303a083c430c5'
          'ac29e5732761e3659cdf6a7b0f13f630042fadef4ed2c2a59d805b39590beedf'
          '906b7f15744f4f2403cd27c0b61d9c270f6395a47e72cd57ff14a63eb0d38a7e'
          'fac778f409b9d733e12ca7afb23690b212e5f55397bdc884c73193cb2feec7ef';
      expect(hash.hex(), matcher);
    });

    test("The iterations must be at least 1", () {
      expect(() => pbkdf2([9], [5], 0), throwsStateError);
      expect(() => pbkdf2([9], [5], -1), throwsStateError);
    });

    test("The iterations must be less than 2^31", () {
      expect(() => pbkdf2([9], [5], 0x80000000), throwsStateError);
      expect(() => pbkdf2([9], [5], 0x8FFFFFFF), throwsStateError);
      expect(() => pbkdf2([9], [5], 0xFFFFFFFF), throwsStateError);
    });

    test("The keyLength must be at least 1", () {
      expect(() => pbkdf2([9], [5], 10, 0), throwsStateError);
      expect(() => pbkdf2([9], [5], 10, -1), throwsStateError);
    });
  });
}
