// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';

const List<int> _clamp = <int>[
  0xff, 0xff, 0xff, 0x0f, 0xfc, 0xff, 0xff, 0x0f, //
  0xfc, 0xff, 0xff, 0x0f, 0xfc, 0xff, 0xff, 0x0f,
];

/// This implementation is derived from the [The Poly1305 Algorithms] described
/// in the [ChaCha20 and Poly1305 for IETF Protocols][rfc8439] document.
///
/// [rfc8439]: https://www.ietf.org/rfc/rfc8439.html
class Poly1305Sink extends BlockHashSink with MACSinkBase {
  bool _initialized = false;
  BigInt _n = BigInt.zero;
  BigInt _r = BigInt.zero;
  BigInt _s = BigInt.zero;
  BigInt _h = BigInt.zero;
  final BigInt _m = BigInt.two.pow(128);
  final BigInt _p = BigInt.two.pow(130) - BigInt.from(5);

  @override
  final int hashLength = 16;

  /// Creates a new instance to process 16-bytes blocks with 17-bytes buffer
  Poly1305Sink() : super(16, bufferLength: 17);

  @override
  void reset() {
    super.reset();
    _n = BigInt.zero;
    _h = BigInt.zero;
  }

  /// Initialize the Poly1305 with the secret and the authentication
  ///
  /// Parameters:
  /// - [key] : The secret key `r` - a little-endian 16-byte integer
  /// - [secret] : The authentication key `s` - a little-endian 16-byte integer
  @override
  void init(List<int> key, [List<int>? secret]) {
    if (key.length != blockLength) {
      throw StateError('The key length must be 16 bytes');
    }
    if (secret != null && secret.length != 16) {
      throw StateError('The secret length must be 16 bytes');
    }
    _initialized = true;

    int i;
    _r = BigInt.zero;
    for (i = 15; i >= 0; i--) {
      _r <<= 8;
      _r += BigInt.from(key[i] & _clamp[i]);
    }

    if (secret != null) {
      _s = BigInt.zero;
      for (i = 15; i >= 0; i--) {
        _s <<= 8;
        _s += BigInt.from(secret[i]);
      }
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    if (!_initialized) {
      throw StateError('The MAC instance is not initialized');
    }
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        _n += BigInt.one << 128;
        $update();
        _n = BigInt.zero;
        pos = 0;
      }
      _n += BigInt.from(chunk[start]) << (pos << 3);
    }
    if (pos == blockLength) {
      _n += BigInt.one << 128;
      $update();
      _n = BigInt.zero;
      pos = 0;
    }
  }

  @override
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    _h = ((_h + _n) * _r) % _p;
  }

  @override
  Uint8List $finalize() {
    if (!_initialized) {
      throw StateError('The MAC instance is not initialized');
    }

    if (pos > 0) {
      _n += BigInt.one << (pos << 3);
      $update();
    }

    _h += _s;

    return Uint32List.fromList([
      (_h % _m).toUnsigned(32).toInt(),
      ((_h >> 32) % _m).toUnsigned(32).toInt(),
      ((_h >> 64) % _m).toUnsigned(32).toInt(),
      ((_h >> 96) % _m).toUnsigned(32).toInt(),
    ]).buffer.asUint8List();
  }
}
