// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:test/test.dart';

void main() {
  group('Poly1305 test', () {
    test('the RFC sample', () {
      var r = fromHex("85d6be7857556d337f4452fe42d506a8");
      var s = fromHex("0103808afb0db2fd4abff6af4149f51b");
      var m = fromHex("43727970746f6772617068696320466f72756"
          "d2052657365617263682047726f7570");
      var actual = "a8061dc1305136c6c22b8baf0c0127a9";
      expect(poly1305(m, r, s).hex(), actual);
    });
  });
}
