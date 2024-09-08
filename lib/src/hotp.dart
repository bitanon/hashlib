// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';
import 'package:hashlib/src/core/otpauth.dart';
import 'package:hashlib/src/hmac.dart';
import 'package:hashlib/src/sha1.dart';

// power of 10 upto max safe integer in javascript
const _pow10 = [
  1,
  10,
  100,
  1000,
  10000,
  100000,
  1000000,
  10000000,
  100000000,
  1000000000,
  10000000000,
  100000000000,
  1000000000000,
  10000000000000,
  100000000000000,
  1000000000000000,
];

/// An HMAC-based One-Time Password (HOTP) algorithm implementation derived
/// from [rfc4226].
///
/// [rfc4226]: https://www.ietf.org/rfc/rfc4226.html
class HOTP extends OTPAuth {
  final int _max;

  /// The underlying MAC algorithm
  final MACHash algo;

  /// The secret key
  final List<int> secret;

  /// The counter value
  final List<int> counter;

  /// The algorithm name
  String get name => algo.name;

  /// Creates an instance of the [HOTP] class with the specified parameters.
  ///
  /// Parameters:
  /// - [secret] is the shared secret as a list of bytes for generating the OTP.
  /// - [digits] is the number of digits in the generated OTP (default is 6).
  /// - [counter] is the counter value used in the HOTP algorithm (required).
  /// - [algo] is the block hash algorithm to use (default is [sha1]).
  /// - [label] is an optional string to identify the account or service the OTP
  ///   is associated with.
  /// - [issuer] is an optional string to specify the entity issuing the OTP.
  HOTP(
    this.secret, {
    int digits = 6,
    required this.counter,
    BlockHashBase algo = sha1,
    String? label,
    String? issuer,
  })  : assert(digits <= 15),
        algo = HMAC(algo).by(secret),
        _max = _pow10[digits],
        super(
          digits,
          label: label,
          issuer: issuer,
        );

  @override
  int value() {
    var digest = algo.convert(counter).bytes;
    int offset = digest.last & 0xF;
    int dbc = ((digest[offset] & 0x7F) << 24) |
        ((digest[offset + 1] & 0xFF) << 16) |
        ((digest[offset + 2] & 0xFF) << 8) |
        (digest[offset + 3] & 0xFF);
    return dbc % _max;
  }
}
