// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/poly1305.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// A class for performing message authentication with the Poly1305 algorithm.
///
/// The class extends [MACHashBase] and provides an implementation of the
/// [createSink] method that returns an instance of [Poly1305Sink].
class Poly1305 extends MACHashBase {
  final List<int>? secret;

  /// Creates a new instance of [Poly1305].
  ///
  /// Parameters:
  /// - [key] is required and must contain exactly 16 bytes.
  /// - [secret] is optional and must contain exactly 16 bytes.
  ///
  /// Here, the [key] is a secret used to encode the message, and the [secret]
  /// is the authentication key used to sign it. The [secret] parameter is
  /// optional and if not provided, the final digest will not be signed.
  ///
  /// **Warning**:
  /// The algorithm is designed to ensure unforgeability of a message with a
  /// random ([key], [secret]). One ([key], [secret]) pair can only be used to
  /// authenticate only one message. Authenticating multiple messages using the
  /// same ([key], [secret]) could allow for forgeries.
  const Poly1305(List<int> key, [this.secret]) : super(key);

  /// Create a new instance of [Poly1305] with a 32-byte long keypair. The
  /// first 16-bytes will be used as a secret key to encode the message, and
  /// the last 16-bytes will be used as the authentication key to sign it.
  ///
  /// Parameters:
  /// - [keypair] is required and must contain exactly 32 bytes.
  ///
  /// **Warning**:
  /// The algorithm is designed to ensure unforgeability of a message with a
  /// random [keypair]. One [keypair] can only be used to authenticate only one
  /// message. Authenticating multiple messages using the same [keypair] could
  /// allow for forgeries.
  factory Poly1305.auth(List<int> keypair) {
    if (keypair.length != 32) {
      throw StateError('The keypair length must be 32 bytes');
    }
    return Poly1305(
      keypair.take(16).toList(),
      keypair.skip(16).toList(),
    );
  }

  @override
  final String name = 'Poly1305';

  @override
  Poly1305Sink createSink() => Poly1305Sink()..init(key, secret);
}

/// Computes the Poly1305 MAC (message authentication code) of the given
/// [message] using the given key pair ([r], [s]).
///
/// Parameters:
/// - [message] is a variable-length list of bytes
/// - [r] is required and must contain exactly 16 bytes.
/// - [s] is optional and must contain exactly 16 bytes.
///
/// **Warning**:
/// The algorithm is designed to ensure unforgeability of a message with a
/// random ([r], [s]). One ([r], [s]) pair can only be used to
/// authenticate only one message. Authenticating multiple messages using the
/// same ([r], [s]) could allow for forgeries.
///
/// Example usage:
/// ```
/// final r = randomBytes(16);
/// final s = randomBytes(16);
/// print('TAG(unsigned): ${poly1305(message, r)}');
/// print('TAG(signed): ${poly1305(message, r, s)}');
/// ```
///
/// See also:
/// - [poly1305auth] to generate signed MACs directly.
/// - [The Poly1305 Algorithms][pdf], the original paper on the Poly1305.
/// - [RFC 8439 - ChaCha20 and Poly1305 for IETF Protocols][rfc8439].
///
/// [pdf]: https://cr.yp.to/mac/poly1305-20050329.pdf
/// [rfc8439]: https://www.ietf.org/rfc/rfc8439.html
@pragma('vm:prefer-inline')
HashDigest poly1305(
  List<int> message,
  List<int> r, [
  List<int>? s,
]) =>
    (Poly1305Sink()
          ..init(r, s)
          ..add(message))
        .digest();

/// Computes the Poly1305 MAC (message authentication code) of the given
/// [message] using the given the 32-byte long [key] for authentication.
///
/// Parameters:
/// - [message] is a variable-length list of bytes
/// - [key] is required and must contain exactly 32 bytes.
///
/// **Warning**:
/// The algorithm is designed to ensure unforgeability of a message with a
/// random [key]. One [key] can only be used to authenticate only one
/// message. Authenticating multiple messages using the same [key] could
/// allow for forgeries.
///
/// Example usage:
/// ```
/// final keypair = randomBytes(32);
/// print('TAG(signed): ${poly1305auth(message, keypair)}');
/// ```
///
/// See also:
/// - [poly1305] to generate unsigned MACs.
/// - [The Poly1305 Algorithms][pdf], the original paper on the Poly1305.
/// - [RFC 8439 - ChaCha20 and Poly1305 for IETF Protocols][rfc8439].
///
/// [pdf]: https://cr.yp.to/mac/poly1305-20050329.pdf
/// [rfc8439]: https://www.ietf.org/rfc/rfc8439.html
@pragma('vm:prefer-inline')
HashDigest poly1305auth(List<int> message, List<int> key) =>
    Poly1305.auth(key).convert(message);
