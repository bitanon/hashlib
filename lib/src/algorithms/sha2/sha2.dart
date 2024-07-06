// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'sha2_1024_64bit.dart' if (dart.library.js) 'sha2_1024_32bit.dart';
import 'sha2_512.dart';

class SHA224Hash extends SHA2of512 {
  SHA224Hash()
      : super(
          hashLength: 224 >>> 3,
          seed: [
            0xC1059ED8, // a
            0x367CD507, // b
            0x3070DD17, // c
            0xF70E5939, // d
            0xFFC00B31, // e
            0x68581511, // f
            0x64F98FA7, // g
            0xBEFA4FA4, // h
          ],
        );
}

class SHA256Hash extends SHA2of512 {
  SHA256Hash()
      : super(
          hashLength: 256 >>> 3,
          seed: [
            0x6A09E667, // a
            0xBB67AE85, // b
            0x3C6EF372, // c
            0xA54FF53A, // d
            0x510E527F, // e
            0x9B05688C, // f
            0x1F83D9AB, // g
            0x5BE0CD19, // h
          ],
        );
}

class SHA384Hash extends SHA2of1024 {
  SHA384Hash()
      : super(
          hashLength: 384 >>> 3,
          seed: [
            0xCBBB9D5D, 0xC1059ED8, // a
            0x629A292A, 0x367CD507, // b
            0x9159015A, 0x3070DD17, // c
            0x152FECD8, 0xF70E5939, // d
            0x67332667, 0xFFC00B31, // e
            0x8EB44A87, 0x68581511, // f
            0xDB0C2E0D, 0x64F98FA7, // g
            0x47B5481D, 0xBEFA4FA4, // h
          ],
        );
}

class SHA512Hash extends SHA2of1024 {
  SHA512Hash()
      : super(
          hashLength: 512 >>> 3,
          seed: [
            0x6A09E667, 0xF3BCC908, // a
            0xBB67AE85, 0x84CAA73B, // b
            0x3C6EF372, 0xFE94F82B, // c
            0xA54FF53A, 0x5F1D36F1, // d
            0x510E527F, 0xADE682D1, // e
            0x9B05688C, 0x2B3E6C1F, // f
            0x1F83D9AB, 0xFB41BD6B, // g
            0x5BE0CD19, 0x137E2179, // h
          ],
        );
}

class SHA512t224Hash extends SHA2of1024 {
  SHA512t224Hash()
      : super(
          hashLength: 224 >>> 3,
          seed: [
            0x8C3D37C8, 0x19544DA2, // a
            0x73E19966, 0x89DCD4D6, // b
            0x1DFAB7AE, 0x32FF9C82, // c
            0x679DD514, 0x582F9FCF, // d
            0x0F6D2B69, 0x7BD44DA8, // e
            0x77E36F73, 0x04C48942, // f
            0x3F9D85A8, 0x6A1D36C8, // g
            0x1112E6AD, 0x91D692A1, // h
          ],
        );
}

class SHA512t256Hash extends SHA2of1024 {
  SHA512t256Hash()
      : super(
          hashLength: 256 >>> 3,
          seed: [
            0x22312194, 0xFC2BF72C, // a
            0x9F555FA3, 0xC84C64C2, // b
            0x2393B86B, 0x6F53B151, // c
            0x96387719, 0x5940EABD, // d
            0x96283EE2, 0xA88EFFE3, // e
            0xBE5E1E25, 0x53863992, // f
            0x2B0199FC, 0x2C85B8AA, // g
            0x0EB72DDC, 0x81C52CA2, // h
          ],
        );
}
