// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('bcrypt version 2y', () {
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
}
