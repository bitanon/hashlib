// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:test/test.dart';

void main() {
  group('scrypt test', () {
    test("with empty password and empty salt and r=1", () {
      var hash = hashlib.scrypt(
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
      var hash = hashlib.scrypt(
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
      var hash = hashlib.scrypt(
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
      var hash = hashlib.scrypt(
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
      var hash = hashlib.scrypt(
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
      var hash = hashlib.scrypt(
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

    test("with 'password' and 'NaCl' salt", () {
      var hash = hashlib.scrypt(
        "password".codeUnits,
        "NaCl".codeUnits,
        N: 1024,
        r: 8,
        p: 16,
        dklen: 64,
      );
      var matcher =
          'fdbabe1c9d3472007856e7190d01e9fe7c6ad7cbc8237830e77376634b373162'
          '2eaf30d92e22a3886ff109279d9830dac727afb94a83ee6d8360cbdfa2cc0640';
      expect(hash.hex(), matcher);
    });
  });
}
