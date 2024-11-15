// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

/// Permutation of 0..255 constructed from the digits of pi. It gives a
/// "random" nonlinear byte substitution operation.
const _pi = <int>[
  41, 46, 67, 201, 162, 216, 124, 1, 61, 54, 84, 161, 236, 240, 6, //
  19, 98, 167, 5, 243, 192, 199, 115, 140, 152, 147, 43, 217, 188,
  76, 130, 202, 30, 155, 87, 60, 253, 212, 224, 22, 103, 66, 111, 24,
  138, 23, 229, 18, 190, 78, 196, 214, 218, 158, 222, 73, 160, 251,
  245, 142, 187, 47, 238, 122, 169, 104, 121, 145, 21, 178, 7, 63,
  148, 194, 16, 137, 11, 34, 95, 33, 128, 127, 93, 154, 90, 144, 50,
  39, 53, 62, 204, 231, 191, 247, 151, 3, 255, 25, 48, 179, 72, 165,
  181, 209, 215, 94, 146, 42, 172, 86, 170, 198, 79, 184, 56, 210,
  150, 164, 125, 182, 118, 252, 107, 226, 156, 116, 4, 241, 69, 157,
  112, 89, 100, 113, 135, 32, 134, 91, 207, 101, 230, 45, 168, 2, 27,
  96, 37, 173, 174, 176, 185, 246, 28, 70, 97, 105, 52, 64, 126, 15,
  85, 71, 163, 35, 221, 81, 175, 58, 195, 92, 249, 206, 186, 197,
  234, 38, 44, 83, 13, 110, 133, 40, 132, 9, 211, 223, 205, 244, 65,
  129, 77, 82, 106, 220, 55, 200, 108, 193, 171, 250, 36, 225, 123,
  8, 12, 189, 177, 74, 120, 136, 149, 139, 227, 99, 232, 109, 233,
  203, 213, 254, 59, 0, 29, 57, 242, 239, 183, 14, 102, 88, 208, 228,
  166, 119, 114, 248, 235, 117, 75, 10, 49, 68, 80, 180, 143, 237,
  31, 26, 219, 153, 141, 51, 159, 17, 131, 20
];

const _padding = <List<int>>[
  [],
  [01],
  [02, 02],
  [03, 03, 03],
  [04, 04, 04, 04],
  [05, 05, 05, 05, 05],
  [06, 06, 06, 06, 06, 06],
  [07, 07, 07, 07, 07, 07, 07],
  [08, 08, 08, 08, 08, 08, 08, 08],
  [09, 09, 09, 09, 09, 09, 09, 09, 09],
  [10, 10, 10, 10, 10, 10, 10, 10, 10, 10],
  [11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11],
  [12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12, 12],
  [13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13, 13],
  [14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14, 14],
  [15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15, 15],
  [16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16, 16],
];

/// This implementation is derived from the RSA Laboratories'
/// [The MD2 Message-Digest Algorithm][rfc1319].
///
/// [rfc1319]: https://www.ietf.org/rfc/rfc1319.html
class MD2Hash extends BlockHashSink {
  final state = Uint8List(48);
  final checksum = Uint8List(16);

  @override
  final int hashLength;

  MD2Hash()
      : hashLength = 128 >>> 3,
        super(16);

  @override
  void reset() {
    state.fillRange(0, 16, 0);
    checksum.fillRange(0, 16, 0);
    super.reset();
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        $update(buffer);
        pos = 0;
      }
      buffer[pos] = chunk[start];
    }
    if (pos == blockLength) {
      $update(buffer);
      pos = 0;
    }
  }

  @override
  void $update(List<int> block, [int offset = 0, bool last = false]) {
    int i, j, t;
    for (i = 0; i < 16; i++) {
      state[16 + i] = block[i];
      state[32 + i] = block[i] ^ state[i];
    }
    t = 0;
    for (i = 0; i < 18; i++) {
      for (j = 0; j < 48; ++j) {
        t = state[j] ^= _pi[t];
      }
      t = (t + i) & 0xFF;
    }
    t = checksum[15];
    for (i = 0; i < 16; i++) {
      t = checksum[i] ^= _pi[block[i] ^ t];
    }
  }

  @override
  Uint8List $finalize() {
    // add padding
    $process(_padding[blockLength - pos], 0, blockLength - pos);

    // process checksum
    $update(checksum);

    // Convert the state to 8-bit byte array
    return state.sublist(0, hashLength);
  }
}
