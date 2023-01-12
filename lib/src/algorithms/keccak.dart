// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'keccak_64bit.dart' if (dart.library.js) 'keccak_32bit.dart';

class Keccak224Hash extends KeccakHash {
  Keccak224Hash()
      : super(
          stateSize: 224 >>> 3,
          paddingByte: 0x01,
        );
}

class Keccak256Hash extends KeccakHash {
  Keccak256Hash()
      : super(
          stateSize: 256 >>> 3,
          paddingByte: 0x01,
        );
}

class Keccak384Hash extends KeccakHash {
  Keccak384Hash()
      : super(
          stateSize: 384 >>> 3,
          paddingByte: 0x01,
        );
}

class Keccak512Hash extends KeccakHash {
  Keccak512Hash()
      : super(
          stateSize: 512 >>> 3,
          paddingByte: 0x01,
        );
}
