// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';
import 'package:hashlib/src/core/utils.dart';

/// This implementation is derived from the [The Poly1305 Algorithms] described
/// in the [ChaCha20 and Poly1305 for IETF Protocols][rfc8439] document.
///
/// [rfc8439]: https://www.ietf.org/rfc/rfc8439.html
class Poly1305Sink extends BlockHashSink with MACSinkBase {
  bool _initialized = false;
  BigInt _r = BigInt.zero;
  BigInt _s = BigInt.zero;
  BigInt _a = BigInt.zero;
  final BigInt _p = BigInt.two.pow(130) - BigInt.from(5);
  final BigInt _m = BigInt.two.pow(128) - BigInt.one;

  @override
  final int hashLength = 16;

  /// Creates a new instance to process 16-bytes blocks with 17-bytes buffer
  Poly1305Sink() : super(16, bufferLength: 17);

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
    _r = BigInt.parse('0x' + toHex(key.reversed));
    _r &= BigInt.parse('0x0ffffffc0ffffffc0ffffffc0fffffff');
    if (secret != null) {
      _s = BigInt.parse('0x' + toHex(secret.reversed));
    }
  }

  @override
  void $process(List<int> chunk, int start, int end) {
    if (!_initialized) {
      throw StateError('The MAC instance is not initialized');
    }
    buffer[0] = 1;
    for (; start < end; start++, pos++) {
      if (pos == blockLength) {
        $update();
        pos = 0;
      }
      buffer[16 - pos] = chunk[start];
    }
    if (pos == blockLength) {
      $update();
      pos = 0;
    }
  }

  @override
  @pragma('vm:prefer-inline')
  void $update([List<int>? block, int offset = 0, bool last = false]) {
    var n = BigInt.parse('0x' + toHex(buffer));
    _a = ((_a + n) * _r) % _p;
  }

  @override
  Uint8List $finalize() {
    if (!_initialized) {
      throw StateError('The MAC instance is not initialized');
    }

    if (pos > 0) {
      buffer[16 - pos] = 1;
      for (pos++; pos <= 16; pos++) {
        buffer[16 - pos] = 0;
      }
      $update();
      pos = 0;
    }

    _a = (_a + _s) & _m;

    var bytes = Uint8List(16);
    bytes.setAll(0, fromHex(_a.toRadixString(16).padLeft(32, '0')).reversed);
    return bytes;
  }
}
