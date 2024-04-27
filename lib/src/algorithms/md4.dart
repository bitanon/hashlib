// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';

const int _mask32 = 0xFFFFFFFF;

const _iv = <int>[
  0x67452301, // a
  0xEFCDAB89, // b
  0x98BADCFE, // c
  0x10325476, // d
];

/// Shift constants
const _rc = <int>[
  03, 07, 11, 19, 03, 07, 11, 19, 03, 07, 11, 19, 03, 07, 11, 19, //
  03, 05, 09, 13, 03, 05, 09, 13, 03, 05, 09, 13, 03, 05, 09, 13, //
  03, 09, 11, 15, 03, 09, 11, 15, 03, 09, 11, 15, 03, 09, 11, 15,
];

/// This implementation is derived from the RSA Data Security, Inc.
/// [MD4 Message-Digest Algorithm][rfc1320].
///
/// [rfc1320]: https://www.ietf.org/rfc/rfc1320.html
class MD4Hash extends BlockHashSink {
  final Uint32List state;

  @override
  final int hashLength;

  MD4Hash()
      : state = Uint32List.fromList(_iv),
        hashLength = 128 >>> 3,
        super(512 >>> 3);

  @override
  void reset() {
    super.reset();
    state.setAll(0, _iv);
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    messageLength += end - start;
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        $update();
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
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    int a, b, c, d, e, f, g, h, t;
    var x = sbuffer;

    a = state[0];
    b = state[1];
    c = state[2];
    d = state[3];

    for (int i = 0; i < 16; i++) {
      e = (b & c) | ((~b & _mask32) & d);
      f = i;
      t = d;
      d = c;
      c = b;
      g = (a + e + x[f]) & _mask32;
      h = _rc[i];
      b = ((g << h) & _mask32) | (g >>> (32 - h));
      a = t;
    }

    for (int i = 16; i < 32; i++) {
      e = (b & c) | (b & d) | (c & d);
      f = ((i >> 2) & 3) + ((i & 3) << 2);
      t = d;
      d = c;
      c = b;
      g = (a + e + 0x5a827999 + x[f]) & _mask32;
      h = _rc[i];
      b = ((g << h) & _mask32) | (g >>> (32 - h));
      a = t;
    }

    for (int i = 32; i < 48; i++) {
      e = b ^ c ^ d;
      f = ((i & 1) << 3) |
          (((i >> 1) & 1) << 2) |
          (((i >> 2) & 1) << 1) |
          ((i >> 3) & 1);
      t = d;
      d = c;
      c = b;
      g = (a + e + 0x6ed9eba1 + x[f]) & _mask32;
      h = _rc[i];
      b = ((g << h) & _mask32) | (g >>> (32 - h));
      a = t;
    }

    state[0] += a;
    state[1] += b;
    state[2] += c;
    state[3] += d;
  }

  @override
  Uint8List $finalize() {
    // Adding the signature byte
    buffer[pos++] = 0x80;

    // If no more space left in buffer for the message length
    if (pos > 56) {
      for (; pos < 64; pos++) {
        buffer[pos] = 0;
      }
      $update();
      pos = 0;
    }

    // Fill remaining buffer to put the message length at the end
    for (; pos < 56; pos++) {
      buffer[pos] = 0;
    }

    // Append original message length in bits to message
    bdata.setUint32(56, messageLengthInBits, Endian.little);
    bdata.setUint32(60, messageLengthInBits >>> 32, Endian.little);

    // Update with the final block
    $update();

    // Convert the state to 8-bit byte array
    return state.buffer.asUint8List().sublist(0, hashLength);
  }
}
