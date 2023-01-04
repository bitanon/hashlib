// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:benchmark/benchmark.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

void main() {
  group("SHA256 benchmark", () {
    group("A string of length 17", () {
      final input = List<int>.generate(17, (i) => i);
      benchmark('crypto.sha256()', () {
        crypto.sha256.convert(input).bytes;
      }, iterations: 777);
      benchmark('hashlib.sha256()', () {
        hashlib.sha256buffer(input);
      }, iterations: 777);
    });
    group("A string of length 1777", () {
      final input = List<int>.generate(1777, (i) => i);
      benchmark('crypto.sha256()', () {
        crypto.sha256.convert(input).bytes;
      }, iterations: 50);
      benchmark('hashlib.sha256()', () {
        hashlib.sha256buffer(input);
      }, iterations: 50);
    });
    group("A string of length 77k", () {
      final input = List<int>.generate(77 * 1000, (i) => i);
      benchmark('crypto.sha256()', () {
        crypto.sha256.convert(input).bytes;
      }, iterations: 1);
      benchmark('hashlib.sha256()', () {
        hashlib.sha256buffer(input);
      }, iterations: 1);
    });
  });
}
