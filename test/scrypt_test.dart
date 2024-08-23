// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('scrypt test', () {
    test("with empty password and empty salt and r=1", () {
      var hash = scrypt(
        [],
        [],
        N: 16,
        r: 1,
        p: 1,
        dklen: 64,
      );
      var matcher =
          '77d6576238657b203b19ca42c18a0497f16b4844e3074ae8dfdffa3fede21442'
          'fcd0069ded0948f8326a753a0fc81f17e8d3e0fb2e0d3628cf35e20c38d18906';
      expect(hash.hex(), matcher);
    });

    test("with empty password and empty salt and r=2", () {
      var hash = scrypt(
        [],
        [],
        N: 16,
        r: 2,
        p: 1,
        dklen: 64,
      );
      var matcher =
          '5517696d05d1df94fb42f067d9fcdb14d9effe8ac37500957e1b6f1d383ea029'
          '61accf2409bba1ae87c94c6fc69f9b32393eea0b877eb7803c2f151a888acdb6';
      expect(hash.hex(), matcher);
    });

    test("with empty password and empty salt and p=2", () {
      var hash = scrypt(
        [],
        [],
        N: 16,
        r: 1,
        p: 2,
        dklen: 64,
      );
      var matcher =
          '7e0ce022d41610408361d487a4962d0b39f8172397d62e911108b5ad4adb3dc7'
          'faf817f593b6b83cc42b040d975d564ce1fdb2c432e7cbe8cdcaa5a0ad6bf647';
      expect(hash.hex(), matcher);
    });

    test("with empty password and 'salt'", () {
      var hash = scrypt(
        [],
        "salt".codeUnits,
        N: 16,
        r: 1,
        p: 1,
        dklen: 64,
      );
      var matcher =
          'eec80a460eeaab62fe1630b19497e7ba6a1ff85f50807b9cfe52a9f192e5b60c'
          'b73563d28e4cb148ba301a2271de3682b88c4677caa2e061d2d0e29990cd4e09';
      expect(hash.hex(), matcher);
    });

    test("with 'password' and empty salt", () {
      var hash = scrypt(
        "password".codeUnits,
        [],
        N: 16,
        r: 1,
        p: 1,
        dklen: 64,
      );
      var matcher =
          'd33c6ec1818daaf728f55afadfeaa558b38efa81305b3521a7f12f4be097e84d'
          '184092d2a2e93bf71fd1efe052710f66b956ce45da43aa9099de7406d3a05e2a';
      expect(hash.hex(), matcher);
    });

    test("with empty 'passwd' and 'salt'", () {
      var hash = scrypt(
        "passwd".codeUnits,
        "salt".codeUnits,
        N: 16,
        r: 1,
        p: 1,
        dklen: 64,
      );
      var matcher =
          'd1635540c8e908f949eaf651eef261cd38e73e0c5c0fe1673e21d72442edb957'
          '7bcaa47ea345a789ec687efd4c21224c7cc9fd892954c40df024bf44d6b8bf2a';
      expect(hash.hex(), matcher);
    });

    test("with a long key length", () {
      var hash = scrypt(
        "a test key".codeUnits,
        "some salt".codeUnits,
        N: 16,
        r: 8,
        p: 2,
        dklen: 256,
      );
      var matcher = '9ddb1ba07f1973893a3f2629c23449b4ab189eef07a3a8b521cd129'
          'ee43cb39067ce849085311849736159ec828d09b0f8f423051dddfb85835730eb'
          '455af9a27a46f198d301e5f6ad678c0ec7c3559bf390887563e951d1070f1613f'
          '8f68eeb565196bf8896a948e183af3e10127e098230e86870c3b6b62f43a7ac9f'
          '9078619d93c4dadffb4d198bccd9676eb979102b48ccd6ab6f31ce6f4e1cf420e'
          'cfc6f4840fc30eebd6223dfeed1aa95637c6d594386317885e2b2817e6e88b502'
          'd7d9896b01877c97791d0e5ca6e7d9982b59a7655710f343713e2bc2259624792'
          '795bdc9cef22b805c36d15102b1eda1d62f766b02579ef74fb4488faa91973a2a00';
      expect(hash.hex(), matcher);
    });

    test("with long r and p parameters", () {
      var hash = scrypt(
        "a test key".codeUnits,
        "some salt".codeUnits,
        N: 16,
        r: 28,
        p: 22,
        dklen: 128,
      );
      var matcher = '48a2b70cc60f0608775f6616167492381f1a6673c4422fe76f3197c8'
          '45d35844fee961ef7cf5783bb2b5a84883423e766be1224f2435bdc738245a0d025'
          '2a3626a73e1548f3807b4a8fe39b779deedf200deb593d078f2e98e989b90030ab3'
          '9938bf52fa291683fd8ebaa1abbfedee33a2df7b3cf1b000e5b8634097990c7ce4';
      expect(hash.hex(), matcher);
    });

    test("with random N, r, p", () {
      var hash = scrypt(
        "a test key".codeUnits,
        "some salt".codeUnits,
        N: 128,
        r: 81,
        p: 49,
        dklen: 120,
      );
      var matcher = '183944033aa4a4fc92c783b6d40236220a1985ddbed2e6b29abb5d382'
          'aecfac52e992d3eb779f7573c66f563d4365e8dae680ecdb59a017af70ed30f398a'
          'f4fd0a0cb3bf9c9dc04e3f177936249ac87d619ed41b6b05d2d6dfe95d32153338b'
          'c03c4b68fd46e13c9c0e7f7946ee6856cf068f1702e2fbd98';
      expect(hash.hex(), matcher);
    });

    test("with security", () {
      var hash = scrypt(
        [],
        [],
        security: ScryptSecurity.test,
      );
      var matcher =
          '5517696d05d1df94fb42f067d9fcdb14d9effe8ac37500957e1b6f1d383ea029'
          '61accf2409bba1ae87c94c6fc69f9b32393eea0b877eb7803c2f151a888acdb6';
      expect(hash.hex(), matcher);
    });

    test("with security overrides", () {
      var hash = scrypt(
        [],
        [],
        security: ScryptSecurity.test,
        r: 1,
      );
      var matcher =
          '77d6576238657b203b19ca42c18a0497f16b4844e3074ae8dfdffa3fede21442'
          'fcd0069ded0948f8326a753a0fc81f17e8d3e0fb2e0d3628cf35e20c38d18906';
      expect(hash.hex(), matcher);
    });
  });

  group('Scrypt Factory Tests', () {
    test("with security", () {
      var hash = Scrypt.fromSecurity(ScryptSecurity.test, salt: []);
      var matcher =
          '5517696d05d1df94fb42f067d9fcdb14d9effe8ac37500957e1b6f1d383ea029'
          '61accf2409bba1ae87c94c6fc69f9b32393eea0b877eb7803c2f151a888acdb6';
      expect(hash.convert([]).hex(), matcher);
    });

    test('throws if cost is less than 1', () {
      expect(
        () => Scrypt(cost: 0),
        throwsA(isA<StateError>().having(
            (e) => e.message, 'message', 'The cost must be at least 1')),
      );
    });

    test('throws if cost is greater than 2^24', () {
      expect(
        () => Scrypt(cost: 0x1000000),
        throwsA(isA<StateError>().having(
            (e) => e.message, 'message', 'The cost must be less than 2^24')),
      );
    });

    test('throws if cost is not a power of 2', () {
      expect(
        () => Scrypt(cost: 5),
        throwsA(isA<StateError>().having(
            (e) => e.message, 'message', 'The cost must be a power of 2')),
      );
    });

    test('throws if derivedKeyLength is less than 1', () {
      expect(
        () => Scrypt(cost: 2, derivedKeyLength: 0),
        throwsA(isA<StateError>().having((e) => e.message, 'message',
            'The derivedKeyLength must be at least 1')),
      );
    });

    test('throws if blockSize is less than 1', () {
      expect(
        () => Scrypt(cost: 2, blockSize: 0),
        throwsA(isA<StateError>().having(
            (e) => e.message, 'message', 'The blockSize must be at least 1')),
      );
    });

    test('throws if parallelism is less than 1', () {
      expect(
        () => Scrypt(cost: 2, parallelism: 0),
        throwsA(isA<StateError>().having(
            (e) => e.message, 'message', 'The parallelism must be at least 1')),
      );
    });

    test('throws if blockSize * parallelism is too big', () {
      expect(
        () => Scrypt(cost: 2, blockSize: 0x2000000, parallelism: 1),
        throwsA(isA<StateError>().having((e) => e.message, 'message',
            'The blockSize * parallelism is too big')),
      );
    });

    test('uses provided salt if not null', () {
      var salt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
      var scrypt = Scrypt(cost: 2, salt: salt);
      expect(scrypt.salt, equals(salt));
    });

    test('generates a random salt if salt is null', () {
      var scrypt = Scrypt(cost: 2);
      expect(scrypt.salt.length, 16);
    });

    test('creates an instance with valid parameters', () {
      var salt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
      var scrypt = Scrypt(
          cost: 2,
          salt: salt,
          blockSize: 8,
          parallelism: 1,
          derivedKeyLength: 64);
      expect(scrypt.salt, equals(salt));
      expect(scrypt.cost, equals(2));
      expect(scrypt.blockSize, equals(8));
      expect(scrypt.parallelism, equals(1));
      expect(scrypt.derivedKeyLength, equals(64));
    });
  });
}
