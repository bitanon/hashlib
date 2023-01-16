import 'dart:io';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:sha3/sha3.dart' as sha3;
import 'package:pointycastle/digests/blake2b.dart' as pc;
import 'package:test/test.dart';

void main() {
  group('blake2b512 comparison', () {
    test('with pointycastle', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        final b = pc.Blake2bDigest(digestSize: 64);
        expect(
          toHex(blake2b512.convert(data).bytes),
          toHex(b.process(Uint8List.fromList(data))),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('with pointycastle with key', () {
      final key = List<int>.filled(16, 99);
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        final b = pc.Blake2bDigest(
          digestSize: 64,
          key: Uint8List.fromList(key),
        );
        expect(
          toHex(Blake2b(key: key).convert(data).bytes),
          toHex(b.process(Uint8List.fromList(data))),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('with pointycastle with salt', () {
      final salt = List<int>.filled(16, 99);
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        final b = pc.Blake2bDigest(
          digestSize: 64,
          salt: Uint8List.fromList(salt),
        );
        expect(
          toHex(Blake2b(salt: salt).convert(data).bytes),
          toHex(b.process(Uint8List.fromList(data))),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('with pointycastle with personalization', () {
      final salt = List<int>.filled(16, 99);
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        final b = pc.Blake2bDigest(
          digestSize: 64,
          personalization: Uint8List.fromList(salt),
        );
        expect(
          toHex(Blake2b(personalization: salt).convert(data).bytes),
          toHex(b.process(Uint8List.fromList(data))),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });
  });

  group('HMAC comparison', () {
    test('with crypto for MD5', () {
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

    test('with crypto', () {
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

  group('Keccak comparison', () {
    test('with sha3', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        var other = sha3.SHA3(256, sha3.KECCAK_PADDING, 256);
        other.update(data);
        expect(
          keccak256.convert(data).hex(),
          toHex(other.digest()),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('SHA3-256 with existing library', () {
      final input = "A quick brown fox jumps over the lazy dog";
      final output =
          "2baa15b5a204f74ae708d588793657a70cda2288a06e7e12c918cc3aedc5cd8d";
      var lib = sha3.SHA3(256, sha3.SHA3_PADDING, 256);
      lib.update(toBytes(input));
      expect(toHex(lib.digest()), output);
    });

    test('against known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        var other = sha3.SHA3(256, sha3.SHA3_PADDING, 256);
        other.update(data);
        expect(
          sha3_256.convert(data).hex(),
          toHex(other.digest()),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });
  });

  group('MD5 comparison', () {
    test('for a file async', () async {
      var file = File('LICENSE');
      var hash = await crypto.md5.bind(file.openRead()).first;
      var hash2 = await md5.file(file);
      expect(hash2.hex(), toHex(hash.bytes));
    }, tags: 'skip-js');

    test('for a file sync', () async {
      var file = File('LICENSE');
      var hash = await crypto.md5.bind(file.openRead()).first;
      var hash2 = md5.fileSync(file);
      expect(hash2.hex(), toHex(hash.bytes));
    }, tags: 'skip-js');

    test('with crypto', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(md5.convert(data).bytes),
          toHex(crypto.md5.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(md5.convert(data).bytes),
          toHex(crypto.md5.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });

  group('SHA1 comparison', () {
    test('against known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha1.convert(data).bytes),
          toHex(crypto.sha1.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha1.convert(data).bytes),
          toHex(crypto.sha1.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });

  group('SHA-224 comparison', () {
    test('against known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha224.convert(data).bytes),
          toHex(crypto.sha224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha224.convert(data).bytes),
          toHex(crypto.sha224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });

    group('SHA-256 comparison', () {
      test('against known implementations', () {
        for (int i = 0; i < 1000; ++i) {
          final data = List<int>.filled(i, 97);
          expect(
            toHex(sha256.convert(data).bytes),
            toHex(crypto.sha256.convert(data).bytes),
            reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
          );
        }
      });

      test('run in parallel', () async {
        await Future.wait(List.generate(10, (i) => i).map((i) async {
          final data = List<int>.filled(i, 97);
          expect(
            toHex(sha256.convert(data).bytes),
            toHex(crypto.sha256.convert(data).bytes),
            reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
          );
        }));
      });
    });
  });

  group('SHA-384 comparison', () {
    test('against known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha384.convert(data).bytes),
          toHex(crypto.sha384.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha384.convert(data).bytes),
          toHex(crypto.sha384.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });

  group('SHA-512/224 comparison', () {
    test('with known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha512t224.convert(data).bytes),
          toHex(crypto.sha512224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha512t224.convert(data).bytes),
          toHex(crypto.sha512224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });

  group('SHA-512/256 comparison', () {
    test('with known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha512t256.convert(data).bytes),
          toHex(crypto.sha512256.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha512t256.convert(data).bytes),
          toHex(crypto.sha512256.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });

  group('SHA-512 comparison', () {
    test('with known implementations', () {
      for (int i = 0; i < 1000; ++i) {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha512.convert(data).bytes),
          toHex(crypto.sha512.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = List<int>.filled(i, 97);
        expect(
          toHex(sha512.convert(data).bytes),
          toHex(crypto.sha512.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });
}
