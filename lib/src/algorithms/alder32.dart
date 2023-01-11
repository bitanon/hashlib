// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

const int _alder32Mod = 65521;

/// This implementation is derived from the [ZLIB Compressed Data Format
/// Specification version 3.3][rfc]
///
/// [rfc]: https://rfc-editor.org/rfc/rfc1950.html
class Alder32Hash extends HashDigestSink {
  int a = 1, b = 0;
  HashDigest? _digest;
  bool _closed = false;

  Alder32Hash() : super(hashLength: 4);

  @override
  bool get closed => _closed;

  @override
  void addSlice(List<int> chunk, int start, int end, [bool isLast = false]) {
    if (_closed) {
      throw StateError('The message-digest is already closed');
    }
    for (; start < end; start++) {
      a = (a + chunk[start]) % _alder32Mod;
      b = (b + a) % _alder32Mod;
    }
    if (isLast) digest();
  }

  @override
  HashDigest digest() {
    if (_closed) return _digest!;
    _closed = true;
    Uint8List bytes = Uint8List.fromList([b >> 8, b, a >> 8, a]);
    _digest = HashDigest(bytes);
    return _digest!;
  }
}
