// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';
import 'package:test/test.dart';

const cases = [
  // Raw Poly1305
  // onetimeauth.c from nacl-20110221
  [
    "eea6a7251c1e72916d11c2cb214d3c25" "2539121d8e234e652d651fa4c8cff880",
    "8e993b9f48681273c29650ba32fc76ce48332ea7164d96a4476fb8c531a1186a"
        "c0dfc17c98dce87b4da7f011ec48c97271d2c20f9b928fe2270d6fb863d51738"
        "b48eeee314a7cc8ab932164548e526ae90224368517acfeabd6bb3732bc0e9da"
        "99832b61ca01b6de56244a9e88d5f9b37973f622a43d14a6599b1f654cb45a74e355a5",
    "f3ffc7703f9400e52a7dfb4b3d3305d9"
  ],
  // Specific test cases generated from test-poly1305aes from poly1305aes-20050218 that
  // expose Java unsigned integer problems
  [
    "01bcb20bfc8b6e03609ddd09f44b060f" "95cc0e44d0b79a8856afcae1bec4fe3c",
    "66f75c0e0c7a40658629e3392f7f8e3349a02191ffd49f39879a8d9d1d0e23ea3caa4d240bd2ab8a8c4a6bb8d3288d9de4b793f05e97646dd4d98055de"
        "fc3e0677d956b4c62664bac15962ab15d93ccbbc03aafdbde779162ed93b55361f0f8acaa41d50ef5175927fe79ea316186516eef15001cd04d3524a55"
        "e4fa3c5ca479d3aaa8a897c21807f721b6270ffc68b6889d81a116799f6aaa35d8e04c7a7dd5e6da2519e8759f54e906696f5772fee093283bcef7b930"
        "aed50323bcbc8c820c67422c1e16bdc022a9c0277c9d95fef0ea4ee11e2b27276da811523c5acb80154989f8a67ee9e3fa30b73b0c1c34bf46e3464d97"
        "7cd7fcd0ac3b82721080bb0d9b982ee2c77feee983d7ba35da88ce86955002940652ab63bc56fb16f994da2b01d74356509d7d1b6d7956b0e5a557757b"
        "d1ced2eef8650bc5b6d426108c1518abcbd0befb6a0d5fd57a3e2dbf31458eab63df66613653d4beae73f5c40eb438fbcfdcf4a4ba46320184b9ca0da4"
        "dfae77de7ccc910356caea3243f33a3c81b064b3b7cedc7435c223f664227215715980e6e0bb570d459ba80d7512dbe458c8f0f3f52d659b6e8eef19ee"
        "71aea2ced85c7a42ffca6522a62db49a2a46eff72bd7f7e0883acd087183f0627f3537a4d558754ed63358e8182bee196735b361dc9bd64d5e34e1074a"
        "855655d2974cc6fa1653754cf40f561d8c7dc526aab2908ec2d2b977cde1a1fb1071e32f40e049ea20f30368ba1592b4fe57fb51595d23acbdace324cd"
        "d78060a17187c662368854e915402d9b52fb21e984663e41c26a109437e162cfaf071b53f77e50000a5388ff183b82ce7a1af476c416d7d204157b3633"
        "b2f4ec077b699b032816997e37bceded8d4a04976fd7d0c0b029f290794c3be504c5242287ea2f831f11ed5690d92775cd6e863d7731fd4da687ebfb13"
        "df4c41dc0fb8",
    "ae345d555eb04d6947bb95c0965237e2"
  ],
  [
    "cd07fd0ef8c0be0afcbdb30af4af0009" "76fb3635a2dc92a1f768163ab12f2187",
    "f05204a74f0f88a7fa1a95b84ec3d8ffb36fcdc7723ea65dfe7cd464e86e0abf6b9d51"
        "db3220cfd8496ad6e6d36ebee8d990f9ce0d3bb7f72b7ab5b3ab0a73240d11efe77"
        "2c857021ae859db4933cdde4387b471d2ce700fef4b81087f8f47c307881fd83017a"
        "fcd15b8d21edf9b704677f46df97b07e5b83f87c8abd90af9b1d0f9e2710e8ebd0d4"
        "d1c6a055abea861f42368bed94d9373e909c1d3715b221c16bc524c55c31ec3eab20"
        "4850bb2474a84f9917038eff9d921130951391b5c54f09b5e1de833ea2cd7d3b3067"
        "40abb7096d1e173da83427da2adddd3631eda30b54dbf487f2b082e8646f07d6e0a8"
        "7e97522ca38d4ace4954bf3db6dd3a93b06fa18eb56856627ed6cffcd7ae26374554"
        "ca18ab8905f26331d323fe10e6e70624c7bc07a70f06ecd804b48f8f7e75e910165e"
        "1beb554f1f0ec7949c9c8d429a206b4d5c0653102249b6098e6b45fac2a07ff0220b"
        "0b8ae8f4c6bcc0c813a7cd141fa8b398b42575fc395747c5a0257ac41d6c1f434cfb"
        "f5dfe8349f5347ef6b60e611f5d6c3cbc20ca2555274d1934325824cef4809da293e"
        "a13f181929e2af025bbd1c9abdc3af93afd4c50a2854ade3887f4d2c8c225168052c"
        "16e74d76d2dd3e9467a2c5b8e15c06ffbffa42b8536384139f07e195a8c9f70f514f3"
        "1dca4eb2cf262c0dcbde53654b6250a29efe21d54e83c80e005a1cad36d5934ff01c3"
        "2e4bc5fe06d03064ff4a268517df4a94c759289f323734318cfa5d859d4ce9c16e63"
        "d02dff0896976f521607638535d2ee8dd3312e1ddc80a55d34fe829ab954c1ebd54d"
        "929954770f1be9d32b4c05003c5c9e97943b6431e2afe820b1e967b19843e5985a13"
        "1b1100517cdc363799104af91e2cf3f53cb8fd003653a6dd8a31a3f9d566a7124b0f"
        "fe9695bcb87c482eb60106f88198f766a40bc0f4873c23653c5f9e7a8e446f770beb"
        "8034cf01d21028ba15ccee21a8db918c4829d61c88bfa927bc5def831501796c5b40"
        "1a60a6b1b433c9fb905c8cd40412fffee81ab",
    "045be28cc52009f506bdbfabedacf0b4"
  ],
  // Test case from JIRA issue BJA-620
  [
    "ffffffffffffffffffffffffffffffff" "ffffffffffffffffffffffffffffffff",
    "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffffff"
        "ffffffffffffffffffffffffffffff",
    "c80cb43844f387946e5aa6085bdf67da"
  ],
];

void main() {
  group('Poly1305 test', () {
    test('the RFC sample', () {
      var r = fromHex("85d6be7857556d337f4452fe42d506a8");
      var s = fromHex("0103808afb0db2fd4abff6af4149f51b");
      var m = "Cryptographic Forum Research Group".codeUnits;
      var actual = "a8061dc1305136c6c22b8baf0c0127a9";
      expect(poly1305.pair(r, s).convert(m).hex(), actual);
    });

    test("example from NACL", () {
      var key = [
        0xee, 0xa6, 0xa7, 0x25, 0x1c, 0x1e, 0x72, 0x91, //
        0x6d, 0x11, 0xc2, 0xcb, 0x21, 0x4d, 0x3c, 0x25,
        0x25, 0x39, 0x12, 0x1d, 0x8e, 0x23, 0x4e, 0x65,
        0x2d, 0x65, 0x1f, 0xa4, 0xc8, 0xcf, 0xf8, 0x80,
      ];
      var msg = [
        0x8e, 0x99, 0x3b, 0x9f, 0x48, 0x68, 0x12, 0x73, //
        0xc2, 0x96, 0x50, 0xba, 0x32, 0xfc, 0x76, 0xce,
        0x48, 0x33, 0x2e, 0xa7, 0x16, 0x4d, 0x96, 0xa4,
        0x47, 0x6f, 0xb8, 0xc5, 0x31, 0xa1, 0x18, 0x6a,
        0xc0, 0xdf, 0xc1, 0x7c, 0x98, 0xdc, 0xe8, 0x7b,
        0x4d, 0xa7, 0xf0, 0x11, 0xec, 0x48, 0xc9, 0x72,
        0x71, 0xd2, 0xc2, 0x0f, 0x9b, 0x92, 0x8f, 0xe2,
        0x27, 0x0d, 0x6f, 0xb8, 0x63, 0xd5, 0x17, 0x38,
        0xb4, 0x8e, 0xee, 0xe3, 0x14, 0xa7, 0xcc, 0x8a,
        0xb9, 0x32, 0x16, 0x45, 0x48, 0xe5, 0x26, 0xae,
        0x90, 0x22, 0x43, 0x68, 0x51, 0x7a, 0xcf, 0xea,
        0xbd, 0x6b, 0xb3, 0x73, 0x2b, 0xc0, 0xe9, 0xda,
        0x99, 0x83, 0x2b, 0x61, 0xca, 0x01, 0xb6, 0xde,
        0x56, 0x24, 0x4a, 0x9e, 0x88, 0xd5, 0xf9, 0xb3,
        0x79, 0x73, 0xf6, 0x22, 0xa4, 0x3d, 0x14, 0xa6,
        0x59, 0x9b, 0x1f, 0x65, 0x4c, 0xb4, 0x5a, 0x74,
        0xe3, 0x55, 0xa5
      ];
      var mac = [
        0xf3, 0xff, 0xc7, 0x70, 0x3f, 0x94, 0x00, 0xe5, //
        0x2a, 0x7d, 0xfb, 0x4b, 0x3d, 0x33, 0x05, 0xd9
      ];
      var res = poly1305auth(msg, key);
      expect(res.bytes, equals(mac));
    });

    test("NACL example with wrap key", () {
      var key = [
        0x02, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      ];
      var msg = [
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, //
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff
      ];
      var mac = [
        0x03, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, //
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
      ];
      var res = poly1305auth(msg, key);
      expect(res.bytes, equals(mac));
    });

    test("example from poly1305-donna", () {
      var key = List.generate(32, (i) => (i + 221) & 0xFF);
      var msg = List.generate(73, (i) => (i + 121) & 0xFF);
      var mac = [
        0xdd, 0xb9, 0xda, 0x7d, 0xdd, 0x5e, 0x52, 0x79, //
        0x27, 0x30, 0xed, 0x5c, 0xda, 0x5f, 0x90, 0xa4
      ];
      var res = poly1305auth(msg, key);
      expect(res.bytes, mac);
    });

    test('key = strings of zeros', () {
      var m = "Cryptographic Forum Research Group".codeUnits;
      var key = List.filled(32, 0);
      var actual = List.filled(16, 0);
      expect(poly1305auth(m, key).bytes, equals(actual));
    });

    test('random key, empty message', () {
      var m = <int>[];
      var key = fromHex(
        'c90e3dd155bcd5dfc5ac9a73eed584e6652bd6b403cdafd31bed3427442d29a9',
      );
      var actual = "652bd6b403cdafd31bed3427442d29a9";
      expect(poly1305auth(m, key).hex(), actual);
    });

    test('random key, single message', () {
      var m = "0".codeUnits;
      var key = fromHex(
        'b90e3dd1e5bc6cdfc5ac9a73eed584e6652bd3b409acdafd31bed3427442dae1',
      );
      var actual = "1aa7542dcbfafa4e04e7808ab84a989f";
      expect(poly1305auth(m, key).hex(), actual);
    });

    test("buffered update", () {
      var key = [
        0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, //
        0xff, 0xfe, 0xfd, 0xfc, 0xfb, 0xfa, 0xf9,
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
        0xff, 0xff, 0xff, 0xff, 0xff, 0xff, 0xff,
        0x00, 0x00, 0x00, 0x00
      ];
      var mac = [
        0xc6, 0x9d, 0xc3, 0xb9, 0x75, 0xee, 0x5f, 0x6b, //
        0x28, 0x99, 0x57, 0x94, 0x41, 0x27, 0xd7, 0x5e,
      ];

      var sink = Poly1305().by(key).createSink();
      for (int i = 0; i < 256; i++) {
        var mac = poly1305
            .pair(
              List.generate(16, (j) => i),
              List.generate(16, (j) => 0xFF),
            )
            .convert(List.generate(i, (j) => i));
        sink.add(mac.bytes);
      }
      expect(sink.digest().bytes, equals(mac));
    });

    test("from bc-java test cases", () {
      for (final x in cases) {
        var mac = poly1305auth(
          fromHex(x[1]),
          fromHex(x[0]),
        );
        expect(mac.hex(), x[2]);
      }
    });

    test('pair with invalid key length', () {
      var s = Uint8List(16);
      expect(() => poly1305.pair([], s).convert([100]), throwsStateError);
      expect(() => poly1305.pair([10], s).convert([100]), throwsStateError);
      expect(() => poly1305.pair(Uint8List(32), s).convert([100]),
          throwsStateError);
      expect(() => poly1305.pair(Uint8List(20), s).convert([100]),
          throwsStateError);
    });

    test('pair with invalid secret length', () {
      var r = Uint8List(16);
      expect(() => poly1305.pair(r, []).convert([100]), throwsStateError);
      expect(() => poly1305.pair(r, [10]).convert([100]), throwsStateError);
      expect(() => poly1305.pair(r, Uint8List(20)).convert([100]),
          throwsStateError);
    });

    test('pair with secret = null and 16 bit key', () {
      var r = fromHex("85d6be7857556d337f4452fe42d506a8");
      var m = "Cryptographic Forum Research Group".codeUnits;
      var out1 = poly1305.pair(r).convert(m).hex();
      var out2 = poly1305auth(m, r).hex();
      expect(out1, equals(out2));
    });

    test('pair with secret = null and 32 bit key', () {
      var r = fromHex(
        "85d6be7857556d337f4452fe42d506a8"
        "0103808afb0db2fd4abff6af4149f51b",
      );
      var m = "Cryptographic Forum Research Group".codeUnits;
      var out1 = poly1305.pair(r).convert(m).hex();
      var out2 = poly1305auth(m, r).hex();
      expect(out1, equals(out2));
    });

    test('sink test', () {
      final key = fromHex(cases[2][0]);
      final msg = fromHex(cases[2][1]);
      final output = cases[2][2];

      final sink = Poly1305Sink(key);
      expect(sink.closed, isFalse);
      for (int i = 0; i < msg.length; i += 7) {
        sink.add(msg.skip(i).take(7).toList());
      }
      expect(sink.digest().hex(), equals(output));
      expect(sink.closed, isTrue);
      expect(() => sink.add(msg), throwsStateError);
      expect(sink.digest().hex(), equals(output));

      sink.reset();
      expect(sink.closed, isFalse);

      sink.add(msg);
      sink.close();
      expect(sink.closed, isTrue);
      expect(sink.digest().hex(), equals(output));
    });

    test("The key length must be either 16 or 32 bytes", () {
      for (int i = 0; i < 64; ++i) {
        final key = Uint8List(i);
        if (i == 16 || i == 32) {
          Poly1305Sink(key);
        } else {
          expect(() => Poly1305Sink(key), throwsA(isA<ArgumentError>()));
        }
      }
    });
  });
}
