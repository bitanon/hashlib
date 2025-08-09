// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';

const int _adler32Mod = 65521;

/// This implementation is derived from the [ ZLIB Compressed Data Format
/// Specification version 3.3 ][rfc]
///
/// [rfc]: https://www.ietf.org/rfc/rfc1950.html
class Adler32Hash extends HashDigestSink {
  int a = 1, b = 0;

  Adler32Hash();

  @override
  final int hashLength = 4;

  @override
  void reset() {
    a = 1;
    b = 0;
    super.reset();
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    for (; start < end; start++) {
      a = (a + chunk[start]) % _adler32Mod;
      b = (b + a) % _adler32Mod;
    }
  }

  @override
  Uint8List $finalize() {
    return Uint8List.fromList([
      b >>> 8,
      b,
      a >>> 8,
      a,
    ]);
  }
}
