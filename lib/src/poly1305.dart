// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/poly1305.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/mac_base.dart';

/// A class for performing message authentication with the Poly1305 algorithm.
/// This implementation is derived from the [The Poly1305 Algorithms] described
/// in the [ChaCha20 and Poly1305 for IETF Protocols][rfc8439] document.
///
/// [rfc8439]: https://www.ietf.org/rfc/rfc8439.html
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
  /// **Warning**:
  /// The algorithm is designed to ensure unforgeability of a message with a
  /// random ([key], [secret]). One ([key], [secret]) pair can only be used to
  /// authenticate only one message. Authenticating multiple messages using the
  /// same key could allow for forgeries. Therefore, it is important to use a
  /// new key for each message.
  const Poly1305(List<int> key, [this.secret]) : super(key);

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
/// random ([r], [s]). One ([r], [s]) pair can only be used to authenticate only
/// one message. Authenticating multiple messages using the same key could allow
/// for forgeries. Therefore, it is important to use a new key for each message.
///
/// Example usage:
/// ```
/// final random = Random.secure();
/// final message = utf8.encode('Hello, world!');
/// final r = List.generate(16, (_) => random.nextInt(256));
/// final s = List.generate(16, (_) => random.nextInt(256));
/// final mac = poly1305(message, r, s);
/// print('TAG: ${mac}');
/// ```
///
/// See also:
/// * [Poly1305], to compute the Poly1305 MAC more conveniently.
/// * [The Poly1305 Algorithms][pdf], the original paper on the Poly1305.
/// * [RFC 8439 - ChaCha20 and Poly1305 for IETF Protocols][rfc8439].
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
