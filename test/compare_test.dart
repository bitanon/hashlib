// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// ignore_for_file: library_annotations

@Tags(['vm-only'])

import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:hashlib/random.dart';
import 'package:pointycastle/digests/blake2b.dart' as pc_blake2b;
import 'package:pointycastle/digests/keccak.dart' as pc_keccak;
import 'package:pointycastle/digests/md4.dart' as pc_md4;
import 'package:pointycastle/digests/sha3.dart' as pc_sha3;
import 'package:pointycastle/digests/sm3.dart' as pc_sm3;
import 'package:test/test.dart';

void main() {
  group('blake2b512 comparison', () {
    test('with pointycastle', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = blake2b512.convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(digestSize: 64).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with key', () {
      final key = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = blake2b512.mac.by(key).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(digestSize: 64, key: key).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with salt', () {
      final salt = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(64, salt: salt).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(digestSize: 64, salt: salt).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with personalization', () {
      final personalization = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(
          64,
          aad: personalization,
        ).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(
            digestSize: 64,
            personalization: personalization,
          ).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with salt and personalization', () {
      final salt = randomBytes(16);
      final personalization = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(
          64,
          salt: salt,
          aad: personalization,
        ).convert(data).hex();
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(
            digestSize: 64,
            salt: salt,
            personalization: personalization,
          ).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });

    test('with pointycastle with key, salt and personalization', () {
      final key = randomBytes(16);
      final salt = randomBytes(16);
      final aad = randomBytes(16);
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final out1 = Blake2b(64).mac.by(key, salt: salt, aad: aad).hex(data);
        final out2 = toHex(
          pc_blake2b.Blake2bDigest(
            digestSize: 64,
            key: key,
            salt: salt,
            personalization: aad,
          ).process(data),
        );
        expect(out1, equals(out2), reason: 'size: $i');
      }
    });
  });

  group('HMAC comparison', () {
    test('with crypto for MD5', () {
      var key = "key";
      var msg = "The quick brown fox jumps over the lazy dog";
      var expected = "80070713463e7749b90c2dc24911e275";
      var actual = toHex(
        md5.hmac.byString(key).convert(msg.codeUnits).bytes,
      );
      var actual2 = toHex(
        crypto.Hmac(crypto.md5, key.codeUnits).convert(msg.codeUnits).bytes,
      );
      expect(actual2, expected, reason: "Key: $key | Message: $msg");
      expect(actual, expected, reason: "Key: $key | Message: $msg");
    });

    test('with crypto', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        final key = randomBytes(i & 0x7F);
        expect(
          toHex(sha1.hmac.by(key).convert(data).bytes),
          toHex(crypto.Hmac(crypto.sha1, key).convert(data).bytes),
          reason: 'Key: "${String.fromCharCodes(key)}" [${key.length}]\n'
              'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        final key = randomBytes(i & 0x7F);
        expect(
          toHex(sha384.hmac.by(key).convert(data).bytes),
          toHex(crypto.Hmac(crypto.sha384, key).convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });

  group('Keccak comparison', () {
    test('with keccak256', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        var pc = pc_keccak.KeccakDigest(256);
        var other = pc.process(Uint8List.fromList(data));
        expect(
          keccak256.convert(data).hex(),
          toHex(other),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('with sha3', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        var pc = pc_sha3.SHA3Digest(256);
        var other = pc.process(Uint8List.fromList(data));
        expect(
          sha3_256.convert(data).hex(),
          toHex(other),
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
    }, tags: 'vm-only');

    test('for a file sync', () async {
      var file = File('LICENSE');
      var hash = await crypto.md5.bind(file.openRead()).first;
      var hash2 = md5.fileSync(file);
      expect(hash2.hex(), toHex(hash.bytes));
    }, tags: 'vm-only');

    test('with crypto', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(md5.convert(data).bytes),
          toHex(crypto.md5.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        expect(
          toHex(md5.convert(data).bytes),
          toHex(crypto.md5.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });

  group('MD4 comparison', () {
    test('with pointy-castle', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(md4.convert(data).bytes),
          toHex(pc_md4.MD4Digest().process(data)),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('for a file sync', () {
      var file = File('LICENSE');
      var hash = pc_md4.MD4Digest().process(file.readAsBytesSync());
      var hash2 = md4.fileSync(file);
      expect(hash2.hex(), toHex(hash));
    }, tags: 'vm-only');
  });

  group('SM3 comparison', () {
    test('with pointy-castle', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          sm3.convert(data).hex(),
          toHex(pc_sm3.SM3Digest().process(data)),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('for a file sync', () {
      var file = File('LICENSE');
      var hash = pc_sm3.SM3Digest().process(file.readAsBytesSync());
      var hash2 = sm3.fileSync(file);
      expect(hash2.hex(), toHex(hash));
    }, tags: 'vm-only');
  });

  group('SHA1 comparison', () {
    test('against known implementations', () {
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha1.convert(data).bytes),
          toHex(crypto.sha1.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
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
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha224.convert(data).bytes),
          toHex(crypto.sha224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        expect(
          toHex(sha224.convert(data).bytes),
          toHex(crypto.sha224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });

    group('SHA-256 comparison', () {
      test('against known implementations', () {
        for (int i = 0; i < 100; ++i) {
          final data = randomBytes(i);
          expect(
            toHex(sha256.convert(data).bytes),
            toHex(crypto.sha256.convert(data).bytes),
            reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
          );
        }
      });

      test('run in parallel', () async {
        await Future.wait(List.generate(10, (i) => i).map((i) async {
          final data = randomBytes(i);
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
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha384.convert(data).bytes),
          toHex(crypto.sha384.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
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
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha512t224.convert(data).bytes),
          toHex(crypto.sha512224.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
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
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha512t256.convert(data).bytes),
          toHex(crypto.sha512256.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
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
      for (int i = 0; i < 100; ++i) {
        final data = randomBytes(i);
        expect(
          toHex(sha512.convert(data).bytes),
          toHex(crypto.sha512.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }
    });

    test('run in parallel', () async {
      await Future.wait(List.generate(10, (i) => i).map((i) async {
        final data = randomBytes(i);
        expect(
          toHex(sha512.convert(data).bytes),
          toHex(crypto.sha512.convert(data).bytes),
          reason: 'Message: "${String.fromCharCodes(data)}" [${data.length}]',
        );
      }));
    });
  });
}
