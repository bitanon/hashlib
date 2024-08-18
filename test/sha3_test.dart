// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';
import 'package:test/test.dart';

void main() {
  group('SHA3 test', () {
    test('name', () {
      expect(sha3_224.name, 'SHA3-224');
      expect(sha3_256.name, 'SHA3-256');
      expect(sha3_384.name, 'SHA3-384');
      expect(sha3_512.name, 'SHA3-512');
    });

    test('SHA3-224 with empty string', () {
      expect(sha3_224sum(""),
          "6b4e03423667dbb73b6e15454f0eb1abd4597f9a1b078e3f5b5a6bc7");
    });

    test('SHA3-384 with exact block size', () {
      final input =
          "e35780eb9799ad4c77535d4ddb683cf33ef367715327cf4c4a58ed9cbdcdd486"
          "f669f80189d549a9364fa82a51a52654ec721bb3aab95dceb4a86a6afa93826d"
          "b923517e928f33e3fba850d45660ef83b9876accafa2a9987a254b137c6e140a"
          "21691e1069413848";
      final output =
          "d1c0fa85c8d183beff99ad9d752b263e286b477f79f0710b0103170173978133"
          "44b99daf3bb7b1bc5e8d722bac85943a";
      expect(sha3_384.convert(fromHex(input)).hex(), output);
      final encoded = String.fromCharCodes(fromHex(input));
      expect(sha3_384sum(encoded), output);
    });

    test('SHA3-256 with short message', () {
      final input =
          "9f2fcc7c90de090d6b87cd7e9718c1ea6cb21118fc2d5de9f97e5db6ac1e9c10";
      final output =
          "2f1a5f7159e34ea19cddc70ebf9b81f1a66db40615d7ead3cc1f1b954d82a3af";
      expect(sha3_256.convert(fromHex(input)).hex(), output);
    });

    test('SHA3-512 with multi block size', () {
      final input =
          "3a3a819c48efde2ad914fbf00e18ab6bc4f14513ab27d0c178a188b61431e7f5"
          "623cb66b23346775d386b50e982c493adbbfc54b9a3cd383382336a1a0b2150a"
          "15358f336d03ae18f666c7573d55c4fd181c29e6ccfde63ea35f0adf5885cfc0"
          "a3d84a2b2e4dd24496db789e663170cef74798aa1bbcd4574ea0bba40489d764"
          "b2f83aadc66b148b4a0cd95246c127d5871c4f11418690a5ddf01246a0c80a43"
          "c70088b6183639dcfda4125bd113a8f49ee23ed306faac576c3fb0c1e256671d"
          "817fc2534a52f5b439f72e424de376f4c565cca82307dd9ef76da5b7c4eb7e08"
          "5172e328807c02d011ffbf33785378d79dc266f6a5be6bb0e4a92eceebaeb1";
      final output =
          "6e8b8bd195bdd560689af2348bdc74ab7cd05ed8b9a57711e9be71e9726fda45"
          "91fee12205edacaf82ffbbaf16dff9e702a708862080166c2ff6ba379bc7ffc2";
      expect(sha3_512.convert(fromHex(input)).hex(), output);
      final encoded = String.fromCharCodes(fromHex(input));
      expect(sha3_512sum(encoded), output);
    });

    test('SHA3-256 with "a"', () {
      final input = "a";
      final output =
          "80084bf2fba02475726feb2cab2d8215eab14bc6bdd8bfb2c8151257032ecd8b";
      expect(sha3_256sum(input), output);
    });

    test('SHA3-256 with "abc"', () {
      final input = "abc";
      final output =
          "3a985da74fe225b2045c172d6bd390bd855f086e3e9d525b46bfe24511431532";
      expect(sha3_256sum(input), output);
    });

    test('SHA3-256 with long arbitrary string', () {
      final input = "A quick brown fox jumps over the lazy dog";
      final output =
          "2baa15b5a204f74ae708d588793657a70cda2288a06e7e12c918cc3aedc5cd8d";
      expect(sha3_256sum(input), output);
    });
  });
}
