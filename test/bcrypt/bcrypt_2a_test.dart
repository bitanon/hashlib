// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('bcrypt version 2a', () {
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
}
