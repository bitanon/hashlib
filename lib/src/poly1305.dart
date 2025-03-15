// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/algorithms/poly1305/poly1305_sink.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/mac_base.dart';

export 'algorithms/poly1305/poly1305_sink.dart' show Poly1305Sink;

class _Poly1305 extends MACHash<Poly1305Sink> {
  const _Poly1305();

  @override
  final String name = 'Poly1305';

  /// Create a new instance of [_Poly1305] with a 16 or 32-byte long keypair.
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
  /// random key. Authenticating multiple messages using the same key could
  /// allow for forgeries.
  ///
  /// See also:
  /// - [_Poly1305.pair] to input key(`r`) and secret(`s`) pair separately.
  @override
  MACHashBase<Poly1305Sink> by(List<int> keypair) =>
      Poly1305(keypair is Uint8List ? keypair : Uint8List.fromList(keypair));

  /// Creates a new instance of [_Poly1305].
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
  /// random key. Authenticating multiple messages using the same key could
  /// allow for forgeries.
  ///
  /// See also:
  /// - [_Poly1305.by] to input key(`r`) and secret(`s`) pair together.
  MACHashBase<Poly1305Sink> pair(List<int> key, [List<int>? secret]) {
    if (secret == null) {
      return by(key);
    }
    if (key.length != 16) {
      throw StateError('The key length must be 16 bytes');
    }
    if (secret.length != 16) {
      throw StateError('The secret length must be 16 bytes');
    }
    var pair = Uint8List(32);
    pair.setAll(0, key);
    pair.setAll(16, secret);
    return Poly1305(pair);
  }
}

/// The Poly1305 MAC (message authentication code) generator for an input
/// message using either 16 or 32-byte long authentication key.
const poly1305 = _Poly1305();

/// Poly1305 MAC generator with a custom 16 or 32-byte long keypair.
class Poly1305 extends HashBase<Poly1305Sink> with MACHashBase<Poly1305Sink> {
  final Uint8List keypair;

  @override
  final String name = 'Poly1305';

  /// Create a new instance of Poly1305 MAC with a 16 or 32-byte long keypair.
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
  /// random key. Authenticating multiple messages using the same key could
  /// allow for forgeries.
  ///
  /// See also:
  /// - [_Poly1305.pair] to input key(`r`) and secret(`s`) pair separately.
  const Poly1305(this.keypair);

  @override
  Poly1305Sink createSink() => Poly1305Sink(keypair);
}

/// Computes the Poly1305 MAC (message authentication code) of the given
/// [message] using the given the 16 or 32-byte long [keypair] for authentication.
///
/// Parameters:
/// - [message] is a variable-length list of bytes
/// - [keypair] is required and must contain exactly 16 or 32 bytes.
///
/// If [keypair] length is 16 bytes, the final digest will not be signed.
///
/// **Warning**:
/// The algorithm is designed to ensure unforgeability of a message with a
/// random key. Authenticating multiple messages using the same key could
/// allow for forgeries.
///
/// Example usage:
/// ```
/// final keypair = randomBytes(32);
/// print('TAG(signed): ${poly1305auth(message, keypair)}');
/// ```
@pragma('vm:prefer-inline')
HashDigest poly1305auth(List<int> message, List<int> keypair) =>
    poly1305.by(keypair).convert(message);
