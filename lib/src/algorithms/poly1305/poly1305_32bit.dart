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

  /// Creates a new instance to process 16-bytes blocks with 17-bytes buffer
  Poly1305Sink() : super(16, bufferLength: 17);

  @override
  final int hashLength = 16;

  @override
  bool get initialized => _initialized;

  @override
  void reset() {
    if (!_initialized) {
      throw StateError('The instance is not yet initialized with a key');
    }
    _n = BigInt.zero;
    _h = BigInt.zero;
    super.reset();
  }

  /// Initialize the Poly1305 with the secret and the authentication
  ///
  /// Parameters:
  /// - [keypair] : The keypair (`r`, `s`) - 16 or 32-bytes.
  @override
  void init(List<int> keypair) {
    if (keypair.length != 16 && keypair.length != 32) {
      throw StateError('The key length must be 16 or 32 bytes');
    }

    _initialized = true;
    var key = keypair is Uint8List ? keypair : Uint8List.fromList(keypair);

    int i;
    _r = BigInt.zero;
    for (i = 15; i >= 0; i--) {
      _r <<= 8;
      _r += BigInt.from(key[i] & _clamp[i]);
    }

    if (key.length == 32) {
      _s = BigInt.zero;
      for (i = 31; i >= 16; i--) {
        _s <<= 8;
        _s += BigInt.from(key[i]);
      }
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    if (!_initialized) {
      throw StateError('The instance is not yet initialized with a key');
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
      throw StateError('The instance is not yet initialized with a key');
    }

    if (pos > 0) {
      _n += BigInt.one << (pos << 3);
      $update();
    }

    _h += _s;

    var result = Uint32List.fromList([
      (_h % _m).toUnsigned(32).toInt(),
      ((_h >> 32) % _m).toUnsigned(32).toInt(),
      ((_h >> 64) % _m).toUnsigned(32).toInt(),
      ((_h >> 96) % _m).toUnsigned(32).toInt(),
    ]);
    return Uint8List.view(result.buffer);
  }
}
