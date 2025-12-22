// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('bcrypt big cost', () {
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
}
