// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'keccak_64bit.dart' if (dart.library.js) 'keccak_32bit.dart';

export 'keccak_64bit.dart' if (dart.library.js) 'keccak_32bit.dart';

/// Implementation of Keccak-224 that generates a 224-bit hash.
class Keccak224Hash extends KeccakHash {
  Keccak224Hash()
      : super(
          stateSize: 224 >>> 3,
          paddingByte: 0x01,
        );
}

/// Implementation of Keccak-256 that generates a 256-bit hash.
class Keccak256Hash extends KeccakHash {
  Keccak256Hash()
      : super(
          stateSize: 256 >>> 3,
          paddingByte: 0x01,
        );
}

/// Implementation of Keccak-384 that generates a 384-bit hash.
class Keccak384Hash extends KeccakHash {
  Keccak384Hash()
      : super(
          stateSize: 384 >>> 3,
          paddingByte: 0x01,
        );
}

/// Implementation of Keccak-512 that generates a 512-bit hash.
class Keccak512Hash extends KeccakHash {
  Keccak512Hash()
      : super(
          stateSize: 512 >>> 3,
          paddingByte: 0x01,
        );
}
