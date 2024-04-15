// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/algorithms/poly1305.dart';
import 'package:hashlib/src/core/hash_digest.dart';

export 'package:hashlib/src/algorithms/poly1305.dart' show Poly1305;

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
/// random [keypair]. One [keypair] can only be used to authenticate only one
/// message. Authenticating multiple messages using the same [keypair] could
/// allow for forgeries.
///
/// Example usage:
/// ```
/// final keypair = randomBytes(32);
/// print('TAG(signed): ${poly1305auth(message, keypair)}');
/// ```
///
/// See also:
/// - [poly1305pair] to generate unsigned MACs.
/// - [The Poly1305 Algorithms][pdf], the original paper on the Poly1305.
/// - [RFC 8439 - ChaCha20 and Poly1305 for IETF Protocols][rfc8439].
///
/// [pdf]: https://cr.yp.to/mac/poly1305-20050329.pdf
/// [rfc8439]: https://www.ietf.org/rfc/rfc8439.html
@pragma('vm:prefer-inline')
HashDigest poly1305(List<int> message, List<int> keypair) =>
    Poly1305(keypair).convert(message);

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
/// - [poly1305] to generate signed MACs directly from a keypair.
/// - [The Poly1305 Algorithms][pdf], the original paper on the Poly1305.
/// - [RFC 8439 - ChaCha20 and Poly1305 for IETF Protocols][rfc8439].
///
/// [pdf]: https://cr.yp.to/mac/poly1305-20050329.pdf
/// [rfc8439]: https://www.ietf.org/rfc/rfc8439.html
@pragma('vm:prefer-inline')
HashDigest poly1305pair(
  List<int> message,
  List<int> r, [
  List<int>? s,
]) =>
    Poly1305.pair(r, s).convert(message);
