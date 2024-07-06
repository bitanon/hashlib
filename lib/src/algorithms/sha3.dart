// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'keccak/keccak.dart';

class SHA3d224Hash extends KeccakHash {
  SHA3d224Hash()
      : super(
          stateSize: 224 >>> 3,
          paddingByte: 0x06,
        );
}

class SHA3d256Hash extends KeccakHash {
  SHA3d256Hash()
      : super(
          stateSize: 256 >>> 3,
          paddingByte: 0x06,
        );
}

class SHA3d384Hash extends KeccakHash {
  SHA3d384Hash()
      : super(
          stateSize: 384 >>> 3,
          paddingByte: 0x06,
        );
}

class SHA3d512Hash extends KeccakHash {
  SHA3d512Hash()
      : super(
          stateSize: 512 >>> 3,
          paddingByte: 0x06,
        );
}
