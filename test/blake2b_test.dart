// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Blake2b funtionality test', () {
    test("Blake2b name", () {
      expect(Blake2b(8).name, 'BLAKE2b-64');
      expect(blake2b160.name, 'BLAKE2b-160');
      expect(blake2b256.name, 'BLAKE2b-256');
      expect(blake2b384.name, 'BLAKE2b-384');
      expect(blake2b512.name, 'BLAKE2b-512');
    });
    test("Blake2bMac name", () {
      expect(blake2b160.mac.name, 'BLAKE2b-160/MAC');
      expect(blake2b256.mac.name, 'BLAKE2b-256/MAC');
      expect(blake2b384.mac.name, 'BLAKE2b-384/MAC');
      expect(blake2b512.mac.name, 'BLAKE2b-512/MAC');
      expect(blake2b160.mac.by([1]).name, 'BLAKE2b-160/MAC');
      expect(blake2b256.mac.by([1]).name, 'BLAKE2b-256/MAC');
      expect(blake2b384.mac.by([1]).name, 'BLAKE2b-384/MAC');
      expect(blake2b512.mac.by([1]).name, 'BLAKE2b-512/MAC');
      expect(blake2b512.mac.pbkdf2([2]).name, 'BLAKE2b-512/MAC/PBKDF2');
      expect(blake2b512.hmac.pbkdf2([2]).name, 'BLAKE2b-512/HMAC/PBKDF2');
    });
    test('The digest size must be between 1 and 64', () {
      Blake2b(1).createSink();
      Blake2b(64).createSink();
      expect(() => Blake2b(0).createSink(), throwsArgumentError);
      expect(() => Blake2b(65).createSink(), throwsArgumentError);
    });
    test('The valid length of salt is 16 bytes ', () {
      Blake2b(16, salt: Uint8List(0)).createSink();
      Blake2b(16, salt: Uint8List(16)).createSink();
      expect(
        () => Blake2b(16, salt: Uint8List(1)).convert([]),
        throwsArgumentError,
      );
      expect(
        () => Blake2b(16, salt: Uint8List(17)).convert([]),
        throwsArgumentError,
      );
    });
    test('The valid length of personalization is 16 bytes ', () {
      Blake2b(16, personalization: Uint8List(0)).createSink();
      Blake2b(16, personalization: Uint8List(16)).createSink();
      expect(
        () => Blake2b(16, personalization: Uint8List(1)).convert([]),
        throwsArgumentError,
      );
      expect(
        () => Blake2b(16, personalization: Uint8List(17)).convert([]),
        throwsArgumentError,
      );
    });
    test('The key should not be greater than 64 bytes ', () {
      Blake2b(16).mac.by(Uint8List(0)).createSink();
      Blake2b(16).mac.by(Uint8List(1)).createSink();
      Blake2b(16).mac.by(Uint8List(64)).createSink();
      expect(
        () => Blake2b(16).mac.by(Uint8List(65)).createSink(),
        throwsArgumentError,
      );
    });
    test('sink test', () {
      final input = List.generate(512, (i) => i & 0xFF);
      final output =
          "c59ab1095ca4579525338b6b74689ff234bc3fe9765fe26dfb04ddceaee0ab84"
          "dfd8967594cb261fcd88687f4454d80f718116c1b3c32f9f7e169357468cbe67";
      final sink = blake2b512.createSink();
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
    test('Blake2b config without any parameters', () {
      expect(blake2b256.config().string('abc').hex(),
          "bddd813c634239723171ef3fee98579b94964e3bb1cb3e427262c8c068d52319");
    });
    test('Blake2b config with salt', () {
      final salt = 'some  long  salt'.codeUnits;
      expect(blake2b256.config(salt: salt).string('a').hex(),
          "5f6b5bcc59698fbbe2d8ff7b3dd1b7c841cf4b1a8cec88e05c02bc97d12ad52b");
    });
  });

  group('blake2b512 test', () {
    test('with empty string', () {
      expect(
          blake2b512.string("").hex(),
          "786a02f742015903c6c6fd852552d272912f4740e15847618a86e217f71f5419"
          "d25e1031afee585313896444934eb04b903a685b1448b755d56f701afe9be2ce");
    });
    test('with a', () {
      expect(
          blake2b512.string('a').hex(),
          "333fcb4ee1aa7c115355ec66ceac917c8bfd815bf7587d325aec1864edd24e34"
          "d5abe2c6b1b5ee3face62fed78dbef802f2a85cb91d455a8f5249d330853cb3c");
    });
    test('with abc', () {
      expect(
          blake2b512.string("abc").hex(),
          "ba80a53f981c4d0d6a2797b69f12f6e94c212f14685ac4b74b12bb6fdbffa2d1"
          "7d87c5392aab792dc252d5de4533cc9518d38aa8dbf1925ab92386edd4009923");
    });
    test('with long string', () {
      expect(
          blake2b512.convert(List.generate(512, (i) => i & 0xFF)).hex(),
          "c59ab1095ca4579525338b6b74689ff234bc3fe9765fe26dfb04ddceaee0ab84"
          "dfd8967594cb261fcd88687f4454d80f718116c1b3c32f9f7e169357468cbe67");
    });
    test('with very long string', () {
      expect(
          blake2b512.convert(List.generate(646154, (i) => i & 0xFF)).hex(),
          "9ddaedc61db231a9dd3de20ea031d8f612f1d541179d3cd0bf90bf5a6740880c"
          "d5d4b42a5db783e04c278679e75f2047c6105441062d08175d4c2708ce2e74f3");
    }, skip: true);
    test('with block size string', () {
      expect(
          blake2b512.convert(List.generate(128, (i) => i & 0xFF)).hex(),
          "2319e3789c47e2daa5fe807f61bec2a1a6537fa03f19ff32e87eecbfd64b7e0e"
          "8ccff439ac333b040f19b0c4ddd11a61e24ac1fe0f10a039806c5dcc0da3d115");
    });
    test('with block size + 1 string', () {
      expect(
          blake2b512.convert(List.generate(129, (i) => i & 0xFF)).hex(),
          "f59711d44a031d5f97a9413c065d1e614c417ede998590325f49bad2fd444d3e"
          "4418be19aec4e11449ac1a57207898bc57d76a1bcf3566292c20c683a5c4648f");
    });
    test('with twice block size string', () {
      expect(
          blake2b512.convert(List.generate(256, (i) => i & 0xFF)).hex(),
          "1ecc896f34d3f9cac484c73f75f6a5fb58ee6784be41b35f46067b9c65c63a67"
          "94d3d744112c653f73dd7deb6666204c5a9bfa5b46081fc10fdbe7884fa5cbf8");
    });
    test('with half block size string', () {
      expect(
          blake2b512.convert(List.generate(64, (i) => i & 0xFF)).hex(),
          "2fc6e69fa26a89a5ed269092cb9b2a449a4409a7a44011eecad13d7c4b045660"
          "2d402fa5844f1a7a758136ce3d5d8d0e8b86921ffff4f692dd95bdc8e5ff0052");
    });

    test('with a secret', () {
      expect(
          blake2b512.mac.byString('secret').string("a").hex(),
          "4a1f6558272af9c63689a9383883671379cab5ff6a38b69643529bd27c5b61fe"
          "e24bc919c36d1bb3747630bf90d3459a453c2c3bb5775bbe0c15cc324222114c");
    });
    test('with empty string and a secret', () {
      expect(
          blake2b512.mac.byString('secret').string('').hex(),
          "865aca2ba0b9b941352e4680e14f543d1af37f7a3479304262a5da8c97468d9f"
          "e22636bae941d9c7b83b93efc36e82177606c72a1c00af48bb182c69d1f1abc3");
    });
  });

  group('blake2b256 test', () {
    test('with empty string', () {
      expect(blake2b256.string('').hex(),
          "0e5751c026e543b2e8ab2eb06099daa1d1e5df47778f7787faab45cdf12fe3a8");
    });
    test('with abc', () {
      expect(blake2b256.string('abc').hex(),
          "bddd813c634239723171ef3fee98579b94964e3bb1cb3e427262c8c068d52319");
    });
    test('with empty string and a secret', () {
      expect(blake2b256.mac.byString('secret').string('').hex(),
          "080989147a9b01f885f00d9b90cee0855cfb08aa68d57dc2c92333b2df70a5ea");
    });
    test('with abc and a secret', () {
      expect(blake2b256.mac.byString('secret').string('abc').hex(),
          "e23c35713e7249f369b7c6f60291c0af9d6ac0231d80f46e13b1313fe7f4a4d5");
    });
  });

  group('blake2b160 test', () {
    test('with empty string', () {
      expect(blake2b160.string('').hex(),
          "3345524abf6bbe1809449224b5972c41790b6cf2");
    });
    test('with abc', () {
      expect(blake2b160.string('abc').hex(),
          "384264f676f39536840523f284921cdc68b6846b");
    });
    test('with empty string and a secret', () {
      expect(blake2b160.mac.byString('secret').string('').hex(),
          "f8630ddf0a315edbc8977f2c52040e9cedb70a85");
    });
    test('with abc and a secret', () {
      expect(blake2b160.mac.byString('secret').string('abc').hex(),
          "0c3d973f5f44547f37c0c0c34ae8cd9015c324ef");
    });
  });

  group('blake2b384 test', () {
    test('with empty string', () {
      expect(
          blake2b384.string('').hex(),
          "b32811423377f52d7862286ee1a72ee540524380fda1724a"
          "6f25d7978c6fd3244a6caf0498812673c5e05ef583825100");
    });
    test('with abc', () {
      expect(
          blake2b384.string('abc').hex(),
          "6f56a82c8e7ef526dfe182eb5212f7db9df1317e57815dbd"
          "a46083fc30f54ee6c66ba83be64b302d7cba6ce15bb556f4");
    });
    test('with empty string and a secret', () {
      expect(
          blake2b384.mac.byString('secret').string('').hex(),
          "6f65d5a686d1eb9783f19bc3fe7dbd077d61714ceba63b2d"
          "11594faee11f98950c2c221379d98d397dfe04c697839472");
    });
    test('with abc and a secret', () {
      expect(
          blake2b384.mac.byString('secret').string('abc').hex(),
          "5dad40c5f4f12bde483498c651ce1f5e86e6f47454c953fb"
          "c953c74e34aba9541b689c2000e984c909278304af01c991");
    });
  });
}
