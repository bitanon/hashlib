// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'sha2_32.dart';
import 'sha2_64_native.dart' if (dart.library.js) 'sha2_64_web.dart';

class SHA224Hash extends SHA2of32bit {
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

class SHA256Hash extends SHA2of32bit {
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

class SHA384Hash extends SHA2of64bit {
  SHA384Hash()
      : super(
          hashLength: 384 >>> 3,
          seed: [
            0xCBBB9D5DC1059ED8, // a
            0x629A292A367CD507, // b
            0x9159015A3070DD17, // c
            0x152FECD8F70E5939, // d
            0x67332667FFC00B31, // e
            0x8EB44A8768581511, // f
            0xDB0C2E0D64F98FA7, // g
            0x47B5481DBEFA4FA4, // h
          ],
        );
}

class SHA512Hash extends SHA2of64bit {
  SHA512Hash()
      : super(
          hashLength: 512 >>> 3,
          seed: [
            0x6A09E667F3BCC908, // a
            0xBB67AE8584CAA73B, // b
            0x3C6EF372FE94F82B, // c
            0xA54FF53A5F1D36F1, // d
            0x510E527FADE682D1, // e
            0x9B05688C2B3E6C1F, // f
            0x1F83D9ABFB41BD6B, // g
            0x5BE0CD19137E2179, // h
          ],
        );
}

class SHA512t224Hash extends SHA2of64bit {
  SHA512t224Hash()
      : super(
          hashLength: 224 >>> 3,
          seed: [
            0x8C3D37C819544DA2, // a
            0x73E1996689DCD4D6, // b
            0x1DFAB7AE32FF9C82, // c
            0x679DD514582F9FCF, // d
            0x0F6D2B697BD44DA8, // e
            0x77E36F7304C48942, // f
            0x3F9D85A86A1D36C8, // g
            0x1112E6AD91D692A1, // h
          ],
        );
}

class SHA512t256Hash extends SHA2of64bit {
  SHA512t256Hash()
      : super(
          hashLength: 256 >>> 3,
          seed: [
            0x22312194FC2BF72C, // a
            0x9F555FA3C84C64C2, // b
            0x2393B86B6F53B151, // c
            0x963877195940EABD, // d
            0x96283EE2A88EFFE3, // e
            0xBE5E1E2553863992, // f
            0x2B0199FC2C85B8AA, // g
            0x0EB72DDC81C52CA2, // h
          ],
        );
}
