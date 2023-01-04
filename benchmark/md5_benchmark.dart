// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:benchmark/benchmark.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

void main() {
  group("MD5 benchmark", () {
    group("A string of length 7", () {
      final input = List<int>.generate(10, (i) => i);
      benchmark('crypto.md5()', () {
        crypto.md5.convert(input).bytes;
      }, iterations: 1000);
      benchmark('hashlib.md5()', () {
        hashlib.md5raw(input);
      }, iterations: 1000);
    });
    group("A string of length 777", () {
      final input = List<int>.generate(777, (i) => i);
      benchmark('crypto.md5()', () {
        crypto.md5.convert(input).bytes;
      }, iterations: 100);
      benchmark('hashlib.md5()', () {
        hashlib.md5raw(input);
      }, iterations: 100);
    });
    group("A string of length 77k", () {
      final input = List<int>.generate(77 * 1000, (i) => i);
      benchmark('crypto.md5()', () {
        crypto.md5.convert(input).bytes;
      }, iterations: 1);
      benchmark('hashlib.md5()', () {
        hashlib.md5raw(input);
      }, iterations: 1);
    });
  });
}
