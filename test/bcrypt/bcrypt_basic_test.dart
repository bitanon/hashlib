// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('bcrypt functionality', () {
    test("name", () {
      expect(Bcrypt(cost: 10).name, r'Bcrypt/2b');
      expect(Bcrypt(cost: 10, version: BcryptVersion.$2a).name, r'Bcrypt/2a');
      expect(Bcrypt(cost: 10, version: BcryptVersion.$2x).name, r'Bcrypt/2x');
      expect(Bcrypt(cost: 10, version: BcryptVersion.$2y).name, r'Bcrypt/2y');
      expect(Bcrypt(cost: 10, version: BcryptVersion.$2b).name, r'Bcrypt/2b');
    });

    // http://openwall.info/wiki/john/sample-hashes
    test("bcrypt", () {
      const password = r"password";
      const salt = r"$2a$05$bvIG6Nmid91Mu9RcmmWZfO";
      const encoded =
          r"$2a$05$bvIG6Nmid91Mu9RcmmWZfO5HJIMCT8riNW0hEp8f6/FuA2/mHZFpe";
      var output = bcrypt(utf8.encode(password), salt);
      expect(output, equals(encoded));
    });

    test("bcryptVerify", () {
      const password = r"password";
      const encoded =
          r"$2a$05$bvIG6Nmid91Mu9RcmmWZfO5HJIMCT8riNW0hEp8f6/FuA2/mHZFpe";
      expect(bcryptVerify(encoded, password.codeUnits), true);
    });

    test("bcryptSalt", () {
      final salt = bcryptSalt(nb: 5, version: BcryptVersion.$2a);
      expect(salt.length, 29);
      expect(salt, startsWith(r"$2a$05$"));
    });

    test("bcryptSalt with security", () {
      final salt = bcryptSalt(security: BcryptSecurity.strong);
      expect(salt.length, 29);
      expect(salt, startsWith(r"$2b$15$"));
    });

    test("bcryptSalt with security overrides", () {
      final salt = bcryptSalt(security: BcryptSecurity.strong, nb: 10);
      expect(salt.length, 29);
      expect(salt, startsWith(r"$2b$10$"));
    });

    test("bcryptDigest", () {
      var password = "password".codeUnits;
      var salt = fromBase64(
        "bvIG6Nmid91Mu9RcmmWZfO",
        codec: Base64Codec.bcrypt,
      );
      var result = fromBase64(
        '5HJIMCT8riNW0hEp8f6/FuA2/mHZFpe',
        codec: Base64Codec.bcrypt,
      );
      const encoded =
          r"$2a$05$bvIG6Nmid91Mu9RcmmWZfO5HJIMCT8riNW0hEp8f6/FuA2/mHZFpe";
      final output = bcryptDigest(
        password,
        nb: 5,
        salt: salt,
        version: BcryptVersion.$2a,
      );
      expect(output.bytes, equals(result));
      expect(output.encoded(), equals(encoded));
      expect(output.toString(), equals(encoded));
    });
    test("bcryptDigest with security", () {
      var password = "password".codeUnits;
      var salt = fromBase64(
        "bvIG6Nmid91Mu9RcmmWZfO",
        codec: Base64Codec.bcrypt,
      );
      var result = fromBase64(
        '5HJIMCT8riNW0hEp8f6/FuA2/mHZFpe',
        codec: Base64Codec.bcrypt,
      );
      final output = bcryptDigest(
        password,
        salt: salt,
        version: BcryptVersion.$2a,
        security: BcryptSecurity.little,
      );
      expect(output.bytes, equals(result));
    });
    test("Bcrypt instance with security", () {
      var password = "password".codeUnits;
      var salt = fromBase64(
        "bvIG6Nmid91Mu9RcmmWZfO",
        codec: Base64Codec.bcrypt,
      );
      var result = fromBase64(
        '5HJIMCT8riNW0hEp8f6/FuA2/mHZFpe',
        codec: Base64Codec.bcrypt,
      );
      final output = Bcrypt.fromSecurity(
        BcryptSecurity.little,
        salt: salt,
        version: BcryptVersion.$2a,
      ).convert(password);
      expect(output.bytes, equals(result));
    });
    test("The cost must be at least 0", () {
      BcryptContext(cost: 0);
      expect(() => BcryptContext(cost: -10), throwsArgumentError);
      expect(() => BcryptContext(cost: -1), throwsArgumentError);
    });
    test("The cost must be at most 31", () {
      BcryptContext(cost: 31);
      expect(() => BcryptContext(cost: 32), throwsArgumentError);
      expect(() => BcryptContext(cost: 100), throwsArgumentError);
    });
    test("The salt must be exactly 16-bytes", () {
      BcryptContext(cost: 4, salt: List.filled(16, 0));
      expect(
        () => BcryptContext(cost: 4, salt: []),
        throwsArgumentError,
      );
      expect(
        () => BcryptContext(cost: 4, salt: List.filled(15, 0)),
        throwsArgumentError,
      );
      expect(
        () => BcryptContext(cost: 4, salt: List.filled(17, 0)),
        throwsArgumentError,
      );
    });
    test("Bcrypt from encoded", () {
      Bcrypt.fromEncoded(fromCrypt(r"$2a$05$bvIG6Nmid91Mu9RcmmWZfO"));
    });
    test("Bcrypt from encoded with invalid version", () {
      expect(
        () => Bcrypt.fromEncoded(fromCrypt(r"$2c$05$bvIG6Nmid91Mu9RcmmWZfO")),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Invalid version',
          ),
        ),
      );
    });
    test("Bcrypt from encoded with invalid cost", () {
      expect(
        () => Bcrypt.fromEncoded(fromCrypt(r"$2x$bvIG6Nmid91Mu9RcmmWZfO")),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Invalid cost',
          ),
        ),
      );
      expect(
        () => Bcrypt.fromEncoded(fromCrypt(r"$2y$32$bvIG6Nmid91Mu9RcmmWZfO")),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'The cost must be at most 31',
          ),
        ),
      );
      expect(
        () => Bcrypt.fromEncoded(fromCrypt(r"$2y$-1$bvIG6Nmid91Mu9RcmmWZfO")),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'The cost must be at least 0',
          ),
        ),
      );
    });
    test("Bcrypt from encoded with invalid salt", () {
      expect(
        () => Bcrypt.fromEncoded(fromCrypt(r"$2b$05$bvIG6Nmid91Mu9RcmmWZf")),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Invalid hash',
          ),
        ),
      );
      expect(
        () => Bcrypt.fromEncoded(fromCrypt(r"$2b$05$bvIG6Nmid91Mu9RcmmWZf0")),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Invalid length',
          ),
        ),
      );
      expect(
        () => Bcrypt.fromEncoded(fromCrypt(
            r"$2b$05$DCq7YPn5Rq63x1Lad4cll.TV4S6ytwfsfvkgY8jIucDrjc8deX1")),
        throwsA(
          isA<FormatException>().having(
            (e) => e.message,
            'message',
            'Invalid hash',
          ),
        ),
      );
      Bcrypt.fromEncoded(fromCrypt(
        r"$2a$06$DCq7YPn5Rq63x1Lad4cll.TV4S6ytwfsfvkgY8jIucDrjc8deX1s1",
      ));
    });
  });
}
