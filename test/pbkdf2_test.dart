// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('PBKDF2 test', () {
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
      var hash = md5.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        100,
        32,
      );
      var matcher =
          '592e779487b7c4dc20ca5cd276163bbb760a40960bb17187cd4895238361d201';
      expect(hash.hex(), matcher);
    });

    test("with MD5 through HMAC", () {
      var hash = md5.hmacBy('password').pbkdf2("some salt".codeUnits, 100);
      var matcher = '592e779487b7c4dc20ca5cd276163bbb';
      expect(hash.hex(), matcher);
    });

    test("with SHA-1", () {
      var hash = sha1.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        100,
        32,
      );
      var matcher =
          'a001e5ddf0b823ccc74edc957ab881e7924ef5c608956cd7d32606b8d7c8acb1';
      expect(hash.hex(), matcher);
    });

    test("with SHA-224", () {
      var hash = sha224.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '57f86bc67aad5fa335f8f0f8ecd7b550c7f2462502d3058897299f49111f8948';
      expect(hash.hex(), matcher);
    });

    test("with SHA-256", () {
      var hash = sha256.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '09d106dccc35eae63c48aa472394de511547ce296ab55685b7ba8b304bec68fe';
      expect(hash.hex(), matcher);
    });

    test("with SHA-384", () {
      var hash = sha384.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '6091b46523e28ffa34d777f81c9ef446cd2983601a6dbdd8cc63aa0fa461b624';
      expect(hash.hex(), matcher);
    });

    test("with SHA-512", () {
      var hash = sha512.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '05f45e131d21985a38c25cb30c9edee0bfe697d19fb84a0d55e89e2a347c7905';
      expect(hash.hex(), matcher);
    });

    test("with SHA-512/224", () {
      var hash = sha512t224.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '7b03e2f53046cf52a0d8ace8f469bef3fdbe0a2b4b112b10586d33119a98aa94';
      expect(hash.hex(), matcher);
    });

    test("with SHA-512/256", () {
      var hash = sha512t256.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '73b02a03a67fe08ab8fee80f2d135f4afb954380406994b0f2670a0f5d0c7faa';
      expect(hash.hex(), matcher);
    });

    test("with SHA3-224", () {
      var hash = sha3_224.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '3543a75506759d603c2058847f39969f8d6c164ebc50c53eb44f290c7835521c';
      expect(hash.hex(), matcher);
    });

    test("with SHA3-256", () {
      var hash = sha3_256.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          'c4aae4cbf79071757bf167a8cff387a615295bed94320d394e9ed15a4b53a9c1';
      expect(hash.hex(), matcher);
    });

    test("with SHA3-384", () {
      var hash = sha3_384.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          'e39eef6add54c1b1cddb35dcf44cce8163941b1e73a26bd6f422dbdf4a98b7c0';
      expect(hash.hex(), matcher);
    });

    test("with SHA3-512", () {
      var hash = sha3_512.pbkdf2(
        'password'.codeUnits,
        "some salt".codeUnits,
        50,
        32,
      );
      var matcher =
          '349d16a5e9cb37d277c0d05235c63bf1d094367c27968262d9d9460d96bbed79';
      expect(hash.hex(), matcher);
    });

    test("long password with SHA-256", () {
      var hash = sha256.pbkdf2(
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
