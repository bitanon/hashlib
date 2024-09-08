// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';
import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Blake2sHash functionality test', () {
    test('The digest size must be between 1 and 32', () {
      Blake2sHash(1);
      Blake2sHash(32);
      expect(() => Blake2sHash(0), throwsArgumentError);
      expect(() => Blake2sHash(33), throwsArgumentError);
      expect(() => Blake2sHash(64), throwsArgumentError);
    });
    test('The valid length of salt is 8 bytes ', () {
      Blake2sHash(16, salt: Uint8List(0));
      Blake2sHash(16, salt: Uint8List(8));
      expect(() => Blake2sHash(16, salt: Uint8List(1)), throwsArgumentError);
      expect(() => Blake2sHash(16, salt: Uint8List(9)), throwsArgumentError);
      expect(() => Blake2sHash(16, salt: Uint8List(16)), throwsArgumentError);
    });
    test('The valid length of personalization is 8 bytes ', () {
      Blake2sHash(16, aad: Uint8List(0));
      Blake2sHash(16, aad: Uint8List(8));
      expect(() => Blake2sHash(16, aad: Uint8List(1)), throwsArgumentError);
      expect(() => Blake2sHash(16, aad: Uint8List(9)), throwsArgumentError);
      expect(() => Blake2sHash(16, aad: Uint8List(16)), throwsArgumentError);
    });
    test('The key should not be greater than 32 bytes ', () {
      Blake2sHash(16, key: Uint8List(0));
      Blake2sHash(16, key: Uint8List(1));
      Blake2sHash(16, key: Uint8List(32));
      expect(() => Blake2sHash(16, key: Uint8List(33)), throwsArgumentError);
      expect(() => Blake2sHash(16, key: Uint8List(64)), throwsArgumentError);
    });
  });
  group('Blake2s funtionality test', () {
    test("Blake2s name", () {
      expect(Blake2s(8).name, 'BLAKE2s-64');
      expect(blake2s128.name, 'BLAKE2s-128');
      expect(blake2s160.name, 'BLAKE2s-160');
      expect(blake2s224.name, 'BLAKE2s-224');
      expect(blake2s256.name, 'BLAKE2s-256');
    });
    test("Blake2sMac name", () {
      final key = [1];
      expect(blake2s128.mac.name, 'BLAKE2s-128/MAC');
      expect(blake2s160.mac.name, 'BLAKE2s-160/MAC');
      expect(blake2s224.mac.name, 'BLAKE2s-224/MAC');
      expect(blake2s256.mac.name, 'BLAKE2s-256/MAC');
      expect(blake2s128.mac.by(key).name, 'BLAKE2s-128/MAC');
      expect(blake2s160.mac.by(key).name, 'BLAKE2s-160/MAC');
      expect(blake2s224.mac.by(key).name, 'BLAKE2s-224/MAC');
      expect(blake2s256.mac.by(key).name, 'BLAKE2s-256/MAC');
    });
    test('sink test', () {
      final input = List.generate(512, (i) => i & 0xFF);
      final output =
          "aeb5499d81f14cb10c2539411cbe3e71167293458543bfa4ca1f9584625fd4c6";
      final sink = blake2s256.createSink();
      expect(sink.closed, isFalse);
      for (int i = 0; i < 512; i += 48) {
        sink.add(input.skip(i).take(48).toList());
      }
      expect(sink.digest().hex(), equals(output));
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
      sink.reset();
      expect(sink.closed, isFalse);
      sink.add(input);
      sink.close();
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
    });
  });

  group('blake2s256 test', () {
    test('with empty string', () {
      expect(blake2s256.string("").hex(),
          "69217a3079908094e11121d042354a7c1f55b6482ca1a51e1b250dfd1ed0eef9");
    });
    test('with a', () {
      expect(blake2s256.string('a').hex(),
          "4a0d129873403037c2cd9b9048203687f6233fb6738956e0349bd4320fec3e90");
    });
    test('with abc', () {
      expect(blake2s256.string("abc").hex(),
          "508c5e8c327c14e2e1a72ba34eeb452f37458b209ed63a294d999b4c86675982");
    });
    test('with long string', () {
      expect(blake2s256.convert(List.generate(512, (i) => i & 0xFF)).hex(),
          "aeb5499d81f14cb10c2539411cbe3e71167293458543bfa4ca1f9584625fd4c6");
    });
    test('with very long string', () {
      expect(blake2s256.convert(List.generate(646154, (i) => i & 0xFF)).hex(),
          "8e13a3e326c071e9d9dabd66025e49d3f467767cd10b5e6e1df1de9354ea2af9");
    }, skip: true);
    test('with block size string', () {
      expect(blake2s256.convert(List.generate(64, (i) => i & 0xFF)).hex(),
          "56f34e8b96557e90c1f24b52d0c89d51086acf1b00f634cf1dde9233b8eaaa3e");
    });
    test('with block size + 1 string', () {
      expect(blake2s256.convert(List.generate(65, (i) => i & 0xFF)).hex(),
          "1b53ee94aaf34e4b159d48de352c7f0661d0a40edff95a0b1639b4090e974472");
    });
    test('with twice block size string', () {
      expect(blake2s256.convert(List.generate(128, (i) => i & 0xFF)).hex(),
          "1fa877de67259d19863a2a34bcc6962a2b25fcbf5cbecd7ede8f1fa36688a796");
    });
    test('with half block size string', () {
      expect(blake2s256.convert(List.generate(32, (i) => i & 0xFF)).hex(),
          "05825607d7fdf2d82ef4c3c8c2aea961ad98d60edff7d018983e21204c0d93d1");
    });

    test('with a secret', () {
      expect(blake2s256.mac.byString('secret').string("a").hex(),
          "6252d094f32c706b6fa11529126bdf2910c4dd7638bf866348808df63f62531d");
    });
    test('with empty string and a secret', () {
      expect(blake2s256.mac.byString('secret').string('').hex(),
          "864f60ce88fc1c80c7b3b4f0bb920255fb464484a9dc7346f1d0e4e190d358cd");
    });
  });

  group('blake2s128 test', () {
    test('with empty string', () {
      expect(blake2s128.string('').hex(), "64550d6ffe2c0a01a14aba1eade0200c");
    });
    test('with abc', () {
      expect(
          blake2s128.string('abc').hex(), "aa4938119b1dc7b87cbad0ffd200d0ae");
    });
    test('with empty string and a secret', () {
      expect(blake2s128.mac.byString('secret').string('').hex(),
          "5697f332469e36135bad2a52a79803be");
    });
    test('with abc and a secret', () {
      expect(blake2s128.mac.byString('secret').string('abc').hex(),
          "9af4e6ccbbfafb7c9dbc6088ca27f3da");
    });
  });

  group('blake2s160 test', () {
    test('with empty string', () {
      expect(blake2s160.string('').hex(),
          "354c9c33f735962418bdacb9479873429c34916f");
    });
    test('with abc', () {
      expect(blake2s160.string('abc').hex(),
          "5ae3b99be29b01834c3b508521ede60438f8de17");
    });
    test('with empty string and a secret', () {
      expect(blake2s160.mac.byString('secret').string('').hex(),
          "3bdb8b311ae9f0547671fef3933653996ee65f45");
    });
    test('with abc and a secret', () {
      expect(blake2s160.mac.byString('secret').string('abc').hex(),
          "1fda19951bd14742e8b3587b1f195f09975ff628");
    });
  });

  group('blake2s224 test', () {
    test('with empty string', () {
      expect(blake2s224.string('').hex(),
          "1fa1291e65248b37b3433475b2a0dd63d54a11ecc4e3e034e7bc1ef4");
    });
    test('with abc', () {
      expect(blake2s224.string('abc').hex(),
          "0b033fc226df7abde29f67a05d3dc62cf271ef3dfea4d387407fbd55");
    });
    test('with empty string and a secret', () {
      expect(blake2s224.mac.byString('secret').string('').hex(),
          "7a37923d75c9d7be6b8fb2946a23d2d7f46067637380f0e91ef8ad0c");
    });
    test('with abc and a secret', () {
      expect(blake2s224.mac.byString('secret').string('abc').hex(),
          "d19a652b914f52e1437a5273d74aee9aba8921bbde5656ebddc8ffa8");
    });
  });
}
