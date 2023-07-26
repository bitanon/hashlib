// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/mac_base.dart';

import 'poly1305_64bit.dart' if (dart.library.js) 'poly1305_32bit.dart';

export 'poly1305_64bit.dart' if (dart.library.js) 'poly1305_32bit.dart';

/// A class for performing message authentication with the Poly1305 algorithm.
///
/// The class extends [MACHashBase] and provides an implementation of the
/// [createSink] method that returns an instance of [Poly1305Sink].
class Poly1305 extends MACHashBase {
  Uint8List? _key;

  /// Creates a new instance of [Poly1305] which is not initialized yet.
  Poly1305();

  @override
  final String name = 'Poly1305';

  @override
  List<int>? get key => _key;

  @override
  Poly1305Sink createSink() {
    if (_key == null) {
      throw StateError('The instance is not initialized');
    }
    return Poly1305Sink(_key!);
  }

  /// Creates a new instance of [Poly1305].
  ///
  /// Parameters:
  /// - [r] is required and must contain either 16 or 32 bytes.
  ///   If key is 32 bytes, the last 16 bytes is used as [s].
  /// - [s] is optional and must contain exactly 16 bytes.
  ///   When this parameter is provided, the last 16-bytes of [r] is ignored.
  ///
  /// Here, the [r] is a secret used to encode the message, and the [s]
  /// is the authentication key used to sign it. The [s] parameter is
  /// optional and if not provided, the final digest will not be signed.
  ///
  /// **Warning**:
  /// The algorithm is designed to ensure unforgeability of a message with a
  /// random ([r], [s]). One ([r], [s]) pair can only be used to
  /// authenticate only one message. Authenticating multiple messages using the
  /// same ([r], [s]) could allow for forgeries.
  @override
  init(List<int> r, [List<int>? s]) {
    if (r.length != 16 && r.length != 32) {
      throw ArgumentError('Invalid length of secret key: r');
    }
    if (s != null && s.length != 16) {
      throw ArgumentError('Invalid length of authentication key: s');
    }
    _key = Uint8List(32);
    _key!.setAll(0, r);
    if (s != null) {
      _key!.setAll(16, s);
    }
  }
}
