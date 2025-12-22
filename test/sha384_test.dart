// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

final tests = {
  "": "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c"
      "0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b",
  "a": "54a59b9f22b0b80880d8427e548b7c23abd873486e1f035dce"
      "9cd697e85175033caa88e6d57bc35efae0b5afd3145f31",
  "abc": "cb00753f45a35e8bb5a03d699ac65007272c32ab0eded1631a"
      "8b605a43ff5bed8086072ba1e7cc2358baeca134c825a7",
  "abcdbcdecdefdefgefghfghighijhijkijkljklmklmnlmnomnopnopq":
      "3391fdddfc8dc7393707a65b1b4709397cf8b1d162af05abfe"
          "8f450de5f36bc6b0455a8520bc4e6f5fe95b1fe3c8452b",
  "The quick brown fox jumps over the lazy dog":
      "ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c4940"
          "11e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1",
  "The quick brown fox jumps over the lazy cog":
      "098cea620b0978caa5f0befba6ddcf22764bea977e1c70b348"
          "3edfdf1de25f4b40d6cea3cadf00f809d422feb1f0161b",
  List.filled(512, "a").join():
      "e685ba7acf4eedd1742f2a97c845e7825982d840623525e491"
          "40680fdde0f2631e5fce9dfcfb42ba7b27c9eb35a62b87",
  List.filled(128, "a").join():
      "edb12730a366098b3b2beac75a3bef1b0969b15c48e2163c23"
          "d96994f8d1bef760c7e27f3c464d3829f56c0d53808b0b",
  List.filled(513, "a").join():
      "c3f1d47c5dad5c3b8cc1242da14220af7f9036acf98369be3c"
          "c102b069476a9b3e50b9a131756396c8c267dce06a35f0",
  List.filled(511, "a").join():
      "db100a1eed3842c61d73064b62543cd4531dafa8bfecf6f27d"
          "cfdebbaf60ea14563ea1b486e4f6b9a14fcb0dac05c5f2",
  // List.filled(1000000, "a").join():
  //     "9d0e1809716474cb086e834e310a4a1ced149e9c00f2485279"
  //         "72cec5704c2a5b07b8b3dc38ecc4ebae97ddd87f3d8985",
};

void main() {
  group('SHA384 test', () {
    test('with empty string', () {
      expect(sha384sum(""), tests[""]);
    });

    test('with single letter', () {
      expect(sha384sum("a"), tests["a"]);
    });

    test('with few letters', () {
      expect(sha384sum("abc"), tests["abc"]);
    });

    test('with string of length 511', () {
      var key = tests.keys.firstWhere((x) => x.length == 511);
      var value = tests[key]!;
      expect(sha384sum(key), value);
    });

    test('with known cases', () {
      tests.forEach((key, value) {
        expect(sha384sum(key), value);
      });
    });

    test('with stream', () async {
      for (final entry in tests.entries) {
        final stream = Stream.fromIterable(
                List.generate(1 + (entry.key.length >>> 3), (i) => i << 3))
            .map((e) => entry.key.substring(e, min(entry.key.length, e + 8)))
            .map((s) => s.codeUnits);
        final result = await sha384.bind(stream).first;
        expect(result.hex(), entry.value);
      }
    });
  });
}
