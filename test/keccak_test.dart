// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/keccak/keccak.dart';
import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Keccak test', () {
    test('The state size assertion', () {
      KeccakHash(stateSize: 0, paddingByte: 0);
      KeccakHash(stateSize: 50, paddingByte: 0);
      KeccakHash(stateSize: 99, paddingByte: 0);
      expect(
        () => KeccakHash(stateSize: -1, paddingByte: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => KeccakHash(stateSize: 100, paddingByte: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => KeccakHash(stateSize: 101, paddingByte: 0),
        throwsA(isA<AssertionError>()),
      );
      expect(
        () => KeccakHash(stateSize: 150, paddingByte: 0),
        throwsA(isA<AssertionError>()),
      );
    });

    test('Keccak-224 with empty string', () {
      expect(keccak224sum(""),
          "f71837502ba8e10837bdd8d365adb85591895602fc552b48b7390abd");
    });
    test('Keccak-256 with empty string', () {
      expect(keccak256sum(""),
          "c5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470");
    });
    test('Keccak-384 with empty string', () {
      expect(
          keccak384sum(""),
          "2c23146a63a29acf99e73b88f8c24eaa7dc60aa771780ccc006afbfa8fe2479b2"
          "dd2b21362337441ac12b515911957ff");
    });
    test('Keccak-512 with empty string', () {
      expect(
          keccak512sum(""),
          "0eab42de4c3ceb9235fc91acffe746b29c29a8c366b7c60e4e67c466f36a4304c0"
          "0fa9caf9d87976ba469bcbe06713b435f091ef2769fb160cdab33d3670680e");
    });

    test('Keccak-224 with "abc"', () {
      final input = "abc";
      final output = "c30411768506ebe1c2871b1ee2e87d38df342317300a9b97a95ec6a8";
      expect(keccak224sum(input), output);
    });
    test('Keccak-256 with "abc"', () {
      final input = "abc";
      final output =
          "4e03657aea45a94fc7d47ba826c8d667c0d1e6e33a64a036ec44f58fa12d6c45";
      expect(keccak256sum(input), output);
    });
    test('Keccak-384 with "abc"', () {
      final input = "abc";
      final output = "f7df1165f033337be098e7d288ad6a2f74409d7a60b49c3664221"
          "8de161b1f99f8c681e4afaf31a34db29fb763e3c28e";
      expect(keccak384sum(input), output);
    });
    test('Keccak-512 with "abc"', () {
      final input = "abc";
      final output =
          "18587dc2ea106b9a1563e32b3312421ca164c7f1f07bc922a9c83d77cea3a1e5"
          "d0c69910739025372dc14ac9642629379540c17e2a65b19d77aa511a9d00bb96";
      expect(keccak512sum(input), output);
    });
  });
}
