// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

import 'poly1305_64bit.dart' if (dart.library.js) 'poly1305_32bit.dart';

/// A class for performing message authentication with the Poly1305 algorithm.
///
/// The class extends [MACHashBase] and provides an implementation of the
/// [createSink] method that returns an instance of [Poly1305Sink].
class Poly1305 extends MACHashBase {
  /// Create a new instance of [Poly1305] with a 16 or 32-byte long keypair.
  /// The first 16-bytes will be used as a secret key to encode the message,
  /// and the last 16-bytes will be used as the authentication key to sign it.
  ///
  /// Parameters:
  /// - [keypair] is required and must contain exactly 16 or 32 bytes.
  ///
  /// If [keypair] length is 16 bytes, the final digest will not be signed.
  ///
  /// **Warning**:
  /// The algorithm is designed to ensure unforgeability of a message with a
  /// random [keypair]. One [keypair] can only be used to authenticate only one
  /// message. Authenticating multiple messages using the same [keypair] could
  /// allow for forgeries.
  const Poly1305(List<int> keypair) : super(keypair);

  /// Creates a new instance of [Poly1305].
  ///
  /// Parameters:
  /// - [key] is required and must contain exactly 16 bytes.
  /// - [secret] is optional and must contain exactly 16 bytes.
  ///
  /// Here, the [key] is used to encode the message, and the [secret]
  /// is the authentication code used to sign it. The [secret] parameter is
  /// optional and if not provided, the final digest will not be signed.
  ///
  /// **Warning**:
  /// The algorithm is designed to ensure unforgeability of a message with a
  /// random ([key], [secret]). One ([key], [secret]) pair can only be used to
  /// authenticate only one message. Authenticating multiple messages using the
  /// same ([key], [secret]) could allow for forgeries.
  factory Poly1305.pair(List<int> key, [List<int>? secret]) {
    if (key.length != 16) {
      throw StateError('The key length must be 16 bytes');
    }
    if (secret == null) {
      return Poly1305(key);
    }
    if (secret.length != 16) {
      throw StateError('The secret length must be 16 bytes');
    }
    var pair = Uint8List(32);
    pair.setAll(0, key);
    pair.setAll(16, secret);
    return Poly1305(pair);
  }

  @override
  final String name = 'Poly1305';

  @override
  Poly1305Sink createSink() => Poly1305Sink()..init(key);
}
