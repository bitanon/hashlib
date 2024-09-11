// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('bcrypt test', () {
    group('functionality test', () {
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

    group('version 2a', () {
      // http://cvsweb.openwall.com/cgi/cvsweb.cgi/Owl/packages/glibc/crypt_blowfish/wrapper.c?rev=HEAD
      test(r"$2a$06$DCq7YPn5Rq63x1Lad4cll.TV4S6ytwfsfvkgY8jIucDrjc8deX1s.", () {
        const password = r"";
        const encoded =
            r"$2a$06$DCq7YPn5Rq63x1Lad4cll.TV4S6ytwfsfvkgY8jIucDrjc8deX1s.";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      // https://stackoverflow.com/a/12761326/774398
      test(r"$2a$10$.TtQJ4Jr6isd4Hp.mVfZeuh6Gws4rOQ/vdBczhDx.19NFK0Y84Dle", () {
        const password = r"ππππππππ";
        const encoded =
            r"$2a$10$.TtQJ4Jr6isd4Hp.mVfZeuh6Gws4rOQ/vdBczhDx.19NFK0Y84Dle";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      // https://bitbucket.org/vadim/bcrypt.net/src/464c41416dc9/BCrypt.Net.Test/TestBCrypt.cs?fileviewer=file-view-default
      test(r"$2a$08$HqWuK6/Ng6sg9gQzbLrgb.Tl.ZHfXLhvt/SgVyWhQqgqcZ7ZuUtye", () {
        const password = r"";
        const encoded =
            r"$2a$08$HqWuK6/Ng6sg9gQzbLrgb.Tl.ZHfXLhvt/SgVyWhQqgqcZ7ZuUtye";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$06$m0CrhHm10qJ3lXRY.5zDGO3rS2KdeeWLuGmsfGlMfOxih58VYVfxe", () {
        const password = r"a";
        const encoded =
            r"$2a$06$m0CrhHm10qJ3lXRY.5zDGO3rS2KdeeWLuGmsfGlMfOxih58VYVfxe";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$06$If6bvum7DFjUnE9p2uDeDu0YHzrHM6tf.iqN8.yx.jNN1ILEf7h0i", () {
        const password = r"abc";
        const encoded =
            r"$2a$06$If6bvum7DFjUnE9p2uDeDu0YHzrHM6tf.iqN8.yx.jNN1ILEf7h0i";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhstC", () {
        const password = r"abcdefghijklmnopqrstuvwxyz";
        const encoded =
            r"$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhstC";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$06$fPIsBO8qRqkjj273rfaOI.HtSV9jLDpTbZn782DC6/t7qT67P6FfO", () {
        const password = r"~!@#$%^&*()      ~!@#$%^&*()PNBFRD";
        const encoded =
            r"$2a$06$fPIsBO8qRqkjj273rfaOI.HtSV9jLDpTbZn782DC6/t7qT67P6FfO";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      // https://github.com/pyca/bcrypt/blob/main/tests/test_bcrypt.py
      test(r"$2a$05$CCCCCCCCCCCCCCCCCCCCC.E5YPO9kmyuRGyh0XouQYb4YMJKvyOeW", () {
        var password = "U*U";
        var encoded =
            r"$2a$05$CCCCCCCCCCCCCCCCCCCCC.E5YPO9kmyuRGyh0XouQYb4YMJKvyOeW";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2a$05$CCCCCCCCCCCCCCCCCCCCC.VGOzA784oUp/Z0DY336zx7pLYAy0lwK", () {
        var password = "U*U*";
        var encoded =
            r"$2a$05$CCCCCCCCCCCCCCCCCCCCC.VGOzA784oUp/Z0DY336zx7pLYAy0lwK";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2a$05$XXXXXXXXXXXXXXXXXXXXXOAcXxm9kjPGEMsLznoKqmqw7tc8WCx4a", () {
        var password = "U*U*U";
        var encoded =
            r"$2a$05$XXXXXXXXXXXXXXXXXXXXXOAcXxm9kjPGEMsLznoKqmqw7tc8WCx4a";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2a$05$abcdefghijklmnopqrstuu5s2v8.iXieOjg/.AySBTTZIIVFJeBui", () {
        var password = "0123456789abcdefghijklmnopqrstuvwxyz"
            "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            "chars after 72 are ignored";
        var encoded =
            r"$2a$05$abcdefghijklmnopqrstuu5s2v8.iXieOjg/.AySBTTZIIVFJeBui";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2a$05$/OK.fbVrR/bpIqNJ5ianF.swQOIzjOiJ9GHEPuhEkvqrUyvWhEMx6", () {
        var password = "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
            "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
            "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
            "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
            "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
            "\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa\xaa"
            "chars after 72 are ignored as usual";
        var encoded =
            r"$2a$05$/OK.fbVrR/bpIqNJ5ianF.swQOIzjOiJ9GHEPuhEkvqrUyvWhEMx6";
        var output = bcrypt(password.codeUnits, encoded);
        expect(output, equals(encoded));
      });

      test(r"$2a$05$/OK.fbVrR/bpIqNJ5ianF.Sa7shbm4.OzKpvFnX1pQLmQW96oUlCq", () {
        var password = "\xa3";
        var encoded =
            r"$2a$05$/OK.fbVrR/bpIqNJ5ianF.Sa7shbm4.OzKpvFnX1pQLmQW96oUlCq";
        var output = bcrypt(password.codeUnits, encoded);
        expect(output, equals(encoded));
      });

      test(r"$2a$04$tecY.9ylRInW/rAAzXCXPOOlyYeCNzmNTzPDNSIFztFMKbvs/s5XG", () {
        var password =
            "g7\r\x01\xf3\xd4\xd0\xa9JB^\x18\x007P\xb2N\xc7\x1c\xee\x87&\x83C"
            "\x8b\xe8\x18\xc5>\x86\x14/\xd6\xcc\x1cJ\xde\xd7ix\xeb\xdeO\xef"
            "\xe1i\xac\xcb\x03\x96v1' \xd6@.m\xa5!\xa0\xef\xc0(";
        var encoded =
            r"$2a$04$tecY.9ylRInW/rAAzXCXPOOlyYeCNzmNTzPDNSIFztFMKbvs/s5XG";
        var output = bcrypt(password.codeUnits, encoded);
        expect(output, equals(encoded));
      });
    });

    group('version 2y', () {
      test(r"$2y$05$/OK.fbVrR/bpIqNJ5ianF.Sa7shbm4.OzKpvFnX1pQLmQW96oUlCq", () {
        var password = "\xa3";
        var encoded =
            r"$2y$05$/OK.fbVrR/bpIqNJ5ianF.Sa7shbm4.OzKpvFnX1pQLmQW96oUlCq";
        var output = bcrypt(password.codeUnits, encoded);
        expect(output, equals(encoded));
      });
      test(r"$2y$05$/OK.fbVrR/bpIqNJ5ianF.CE5elHaaO4EbggVDjb8P19RukzXSM3e", () {
        var password = "\xff\xff\xa3";
        var encoded =
            r"$2y$05$/OK.fbVrR/bpIqNJ5ianF.CE5elHaaO4EbggVDjb8P19RukzXSM3e";
        var output = bcrypt(password.codeUnits, encoded);
        expect(output, equals(encoded));
      });
    });

    // https://github.com/pyca/bcrypt/blob/main/tests/test_bcrypt.py
    group('version 2b', () {
      test(r"$2b$04$cVWp4XaNU8a4v1uMRum2SO026BWLIoQMD/TXg5uZV.0P.uO8m3YEm", () {
        var password = "Kk4DQuMMfZL9o";
        var encoded =
            r"$2b$04$cVWp4XaNU8a4v1uMRum2SO026BWLIoQMD/TXg5uZV.0P.uO8m3YEm";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$pQ7gRO7e6wx/936oXhNjrOUNOHL1D0h1N2IDbJZYs.1ppzSof6SPy", () {
        var password = "9IeRXmnGxMYbs";
        var encoded =
            r"$2b$04$pQ7gRO7e6wx/936oXhNjrOUNOHL1D0h1N2IDbJZYs.1ppzSof6SPy";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$SQe9knOzepOVKoYXo9xTteNYr6MBwVz4tpriJVe3PNgYufGIsgKcW", () {
        var password = "xVQVbwa1S0M8r";
        var encoded =
            r"$2b$04$SQe9knOzepOVKoYXo9xTteNYr6MBwVz4tpriJVe3PNgYufGIsgKcW";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$eH8zX.q5Q.j2hO1NkVYJQOM6KxntS/ow3.YzVmFrE4t//CoF4fvne", () {
        var password = "Zfgr26LWd22Za";
        var encoded =
            r"$2b$04$eH8zX.q5Q.j2hO1NkVYJQOM6KxntS/ow3.YzVmFrE4t//CoF4fvne";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$ahiTdwRXpUG2JLRcIznxc.s1.ydaPGD372bsGs8NqyYjLY1inG5n2", () {
        var password = "Tg4daC27epFBE";
        var encoded =
            r"$2b$04$ahiTdwRXpUG2JLRcIznxc.s1.ydaPGD372bsGs8NqyYjLY1inG5n2";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$nQn78dV0hGHf5wUBe0zOFu8n07ZbWWOKoGasZKRspZxtt.vBRNMIy", () {
        var password = "xhQPMmwh5ALzW";
        var encoded =
            r"$2b$04$nQn78dV0hGHf5wUBe0zOFu8n07ZbWWOKoGasZKRspZxtt.vBRNMIy";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$cvXudZ5ugTg95W.rOjMITuM1jC0piCl3zF5cmGhzCibHZrNHkmckG", () {
        var password = "59je8h5Gj71tg";
        var encoded =
            r"$2b$04$cvXudZ5ugTg95W.rOjMITuM1jC0piCl3zF5cmGhzCibHZrNHkmckG";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$YYjtiq4Uh88yUsExO0RNTuEJ.tZlsONac16A8OcLHleWFjVawfGvO", () {
        var password = "wT4fHJa2N9WSW";
        var encoded =
            r"$2b$04$YYjtiq4Uh88yUsExO0RNTuEJ.tZlsONac16A8OcLHleWFjVawfGvO";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$WLTjgY/pZSyqX/fbMbJzf.qxCeTMQOzgL.CimRjMHtMxd/VGKojMu", () {
        var password = "uSgFRnQdOgm4S";
        var encoded =
            r"$2b$04$WLTjgY/pZSyqX/fbMbJzf.qxCeTMQOzgL.CimRjMHtMxd/VGKojMu";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$2moPs/x/wnCfeQ5pCheMcuSJQ/KYjOZG780UjA/SiR.KsYWNrC7SG", () {
        var password = "tEPtJZXur16Vg";
        var encoded =
            r"$2b$04$2moPs/x/wnCfeQ5pCheMcuSJQ/KYjOZG780UjA/SiR.KsYWNrC7SG";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$HrEYC/AQ2HS77G78cQDZQ.r44WGcruKw03KHlnp71yVQEwpsi3xl2", () {
        var password = "vvho8C6nlVf9K";
        var encoded =
            r"$2b$04$HrEYC/AQ2HS77G78cQDZQ.r44WGcruKw03KHlnp71yVQEwpsi3xl2";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$vVYgSTfB8KVbmhbZE/k3R.ux9A0lJUM4CZwCkHI9fifke2.rTF7MG", () {
        var password = "5auCCY9by0Ruf";
        var encoded =
            r"$2b$04$vVYgSTfB8KVbmhbZE/k3R.ux9A0lJUM4CZwCkHI9fifke2.rTF7MG";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$JfoNrR8.doieoI8..F.C1OQgwE3uTeuardy6lw0AjALUzOARoyf2m", () {
        var password = "GtTkR6qn2QOZW";
        var encoded =
            r"$2b$04$JfoNrR8.doieoI8..F.C1OQgwE3uTeuardy6lw0AjALUzOARoyf2m";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$HP3I0PUs7KBEzMBNFw7o3O7f/uxaZU7aaDot1quHMgB2yrwBXsgyy", () {
        var password = "zKo8vdFSnjX0f";
        var encoded =
            r"$2b$04$HP3I0PUs7KBEzMBNFw7o3O7f/uxaZU7aaDot1quHMgB2yrwBXsgyy";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$xnFVhJsTzsFBTeP3PpgbMeMREb6rdKV9faW54Sx.yg9plf4jY8qT6", () {
        var password = "I9VfYlacJiwiK";
        var encoded =
            r"$2b$04$xnFVhJsTzsFBTeP3PpgbMeMREb6rdKV9faW54Sx.yg9plf4jY8qT6";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$WQp9.igoLqVr6Qk70mz6xuRxE0RttVXXdukpR9N54x17ecad34ZF6", () {
        var password = "VFPO7YXnHQbQO";
        var encoded =
            r"$2b$04$WQp9.igoLqVr6Qk70mz6xuRxE0RttVXXdukpR9N54x17ecad34ZF6";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$xgZtlonpAHSU/njOCdKztOPuPFzCNVpB4LGicO4/OGgHv.uKHkwsS", () {
        var password = "VDx5BdxfxstYk";
        var encoded =
            r"$2b$04$xgZtlonpAHSU/njOCdKztOPuPFzCNVpB4LGicO4/OGgHv.uKHkwsS";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$2Siw3Nv3Q/gTOIPetAyPr.GNj3aO0lb1E5E9UumYGKjP9BYqlNWJe", () {
        var password = "dEe6XfVGrrfSH";
        var encoded =
            r"$2b$04$2Siw3Nv3Q/gTOIPetAyPr.GNj3aO0lb1E5E9UumYGKjP9BYqlNWJe";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$7/Qj7Kd8BcSahPO4khB8me4ssDJCW3r4OGYqPF87jxtrSyPj5cS5m", () {
        var password = "cTT0EAFdwJiLn";
        var encoded =
            r"$2b$04$7/Qj7Kd8BcSahPO4khB8me4ssDJCW3r4OGYqPF87jxtrSyPj5cS5m";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$04$VvlCUKbTMjaxaYJ.k5juoecpG/7IzcH1AkmqKi.lIZMVIOLClWAk.", () {
        var password = "J8eHUDuxBB520";
        var encoded =
            r"$2b$04$VvlCUKbTMjaxaYJ.k5juoecpG/7IzcH1AkmqKi.lIZMVIOLClWAk.";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });

      test(r"$2b$10$keO.ZZs22YtygVF6BLfhGOI/JjshJYPp8DZsUtym6mJV2Eha2Hdd.", () {
        var password = [
          125, 62, 179, 254, 241, 139, 160, 230, 40, 162, 76, 122, 113, 195, //
          80, 127, 204, 200, 98, 123, 249, 20, 246, 246, 96, 129, 71, 53, 236,
          29, 135, 16, 191, 167, 225, 125, 73, 55, 32, 150, 223, 99, 242, 191,
          179, 86, 104, 223, 77, 136, 113, 247, 255, 27, 130, 126, 122, 19, 221,
          233, 132, 0, 221, 52
        ];
        var encoded =
            r"$2b$10$keO.ZZs22YtygVF6BLfhGOI/JjshJYPp8DZsUtym6mJV2Eha2Hdd.";
        var output = bcrypt(password, encoded);
        expect(output, equals(encoded));
      });
    });

    group('big cost', () {
      test(r"$2a$10$k1wbIrmNyFAPwPVPSVa/zecw2BCEnBwVS2GbrmgzxFUOqW9dk4TCW", () {
        const password = r"";
        const encoded =
            r"$2a$10$k1wbIrmNyFAPwPVPSVa/zecw2BCEnBwVS2GbrmgzxFUOqW9dk4TCW";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$12$k42ZFHFWqBp3vWli.nIn8uYyIkbvYRvodzbfbK18SSsY.CsIQPlxO", () {
        const password = r"";
        const encoded =
            r"$2a$12$k42ZFHFWqBp3vWli.nIn8uYyIkbvYRvodzbfbK18SSsY.CsIQPlxO";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$08$cfcvVd2aQ8CMvoMpP2EBfeodLEkkFJ9umNEfPD18.hUF62qqlC/V.", () {
        const password = r"a";
        const encoded =
            r"$2a$08$cfcvVd2aQ8CMvoMpP2EBfeodLEkkFJ9umNEfPD18.hUF62qqlC/V.";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$10$k87L/MF28Q673VKh8/cPi.SUl7MU/rWuSiIDDFayrKk/1tBsSQu4u", () {
        const password = r"a";
        const encoded =
            r"$2a$10$k87L/MF28Q673VKh8/cPi.SUl7MU/rWuSiIDDFayrKk/1tBsSQu4u";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$12$8NJH3LsPrANStV6XtBakCez0cKHXVxmvxIlcz785vxAIZrihHZpeS", () {
        const password = r"a";
        const encoded =
            r"$2a$12$8NJH3LsPrANStV6XtBakCez0cKHXVxmvxIlcz785vxAIZrihHZpeS";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$08$Ro0CUfOqk6cXEKf3dyaM7OhSCvnwM9s4wIX9JeLapehKK5YdLxKcm", () {
        const password = r"abc";
        const encoded =
            r"$2a$08$Ro0CUfOqk6cXEKf3dyaM7OhSCvnwM9s4wIX9JeLapehKK5YdLxKcm";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$10$WvvTPHKwdBJ3uk0Z37EMR.hLA2W6N9AEBhEgrAOljy2Ae5MtaSIUi", () {
        const password = r"abc";
        const encoded =
            r"$2a$10$WvvTPHKwdBJ3uk0Z37EMR.hLA2W6N9AEBhEgrAOljy2Ae5MtaSIUi";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$12$EXRkfkdmXn2gzds2SSitu.MW9.gAVqa9eLS1//RYtYCmB1eLHg.9q", () {
        const password = r"abc";
        const encoded =
            r"$2a$12$EXRkfkdmXn2gzds2SSitu.MW9.gAVqa9eLS1//RYtYCmB1eLHg.9q";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$08$aTsUwsyowQuzRrDqFflhgekJ8d9/7Z3GV3UcgvzQW3J5zMyrTvlz.", () {
        const password = r"abcdefghijklmnopqrstuvwxyz";
        const encoded =
            r"$2a$08$aTsUwsyowQuzRrDqFflhgekJ8d9/7Z3GV3UcgvzQW3J5zMyrTvlz.";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$10$fVH8e28OQRj9tqiDXs1e1uxpsjN0c7II7YPKXua2NAKYvM6iQk7dq", () {
        const password = r"abcdefghijklmnopqrstuvwxyz";
        const encoded =
            r"$2a$10$fVH8e28OQRj9tqiDXs1e1uxpsjN0c7II7YPKXua2NAKYvM6iQk7dq";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$12$D4G5f18o7aMMfwasBL7GpuQWuP3pkrZrOAnqP.bmezbMng.QwJ/pG", () {
        const password = r"abcdefghijklmnopqrstuvwxyz";
        const encoded =
            r"$2a$12$D4G5f18o7aMMfwasBL7GpuQWuP3pkrZrOAnqP.bmezbMng.QwJ/pG";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$08$Eq2r4G/76Wv39MzSX262huzPz612MZiYHVUJe/OcOql2jo4.9UxTW", () {
        const password = r"~!@#$%^&*()      ~!@#$%^&*()PNBFRD";
        const encoded =
            r"$2a$08$Eq2r4G/76Wv39MzSX262huzPz612MZiYHVUJe/OcOql2jo4.9UxTW";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$10$LgfYWkbzEvQ4JakH7rOvHe0y8pHKF9OaFgwUZ2q7W2FFZmZzJYlfS", () {
        const password = r"~!@#$%^&*()      ~!@#$%^&*()PNBFRD";
        const encoded =
            r"$2a$10$LgfYWkbzEvQ4JakH7rOvHe0y8pHKF9OaFgwUZ2q7W2FFZmZzJYlfS";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
      test(r"$2a$12$WApznUOJfkEGSmYRfnkrPOr466oFDCaj4b6HY3EXGvfxm43seyhgC", () {
        const password = r"~!@#$%^&*()      ~!@#$%^&*()PNBFRD";
        const encoded =
            r"$2a$12$WApznUOJfkEGSmYRfnkrPOr466oFDCaj4b6HY3EXGvfxm43seyhgC";
        var output = bcrypt(utf8.encode(password), encoded);
        expect(output, equals(encoded));
      });
    }, skip: true);
  });
}
