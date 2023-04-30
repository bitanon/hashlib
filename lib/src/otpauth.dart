// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
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

/// Represents an abstract class for implementing [One-Time Password (OTP)
/// authentication][rfc2289] methods in Dart.
///
/// This class provides a foundation for creating variable length OTP generation
/// algorithms. Subclasses must implement the [value] method to generate OTP
/// values based on a specific algorithm.
///
/// [rfc2289]: https://www.ietf.org/rfc/rfc2289.html
abstract class OTPAuth {
  /// The number of digits in the generated OTP
  final int digits;
  final String? label;
  final String? issuer;

  const OTPAuth(
    this.digits, {
    this.label,
    this.issuer,
  }) : assert(digits >= 4 && digits <= 15);

  /// Generates the OTP value
  int value();
}

/// An HMAC-based One-Time Password (HOTP) algorithm implementation derived
/// from [rfc4226].
///
/// [rfc4226]: https://www.ietf.org/rfc/rfc4226.html
class HOTP extends OTPAuth {
  final int _max;
  final HMAC mac;
  final List<int> counter;

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
    List<int> secret, {
    int digits = 6,
    required this.counter,
    BlockHashBase algo = sha1,
    String? label,
    String? issuer,
  })  : mac = HMAC(algo, secret),
        _max = _pow10[digits],
        super(
          digits,
          label: label,
          issuer: issuer,
        );

  /// The secret key
  List<int> get secret => mac.key;

  /// The algorithm name
  String get algorithm => mac.algo.name;

  @override
  int value() {
    var digest = mac.convert(counter).bytes;
    int offset = digest.last & 0xF;
    int dbc = ((digest[offset] & 0x7F) << 24) |
        ((digest[offset + 1] & 0xFF) << 16) |
        ((digest[offset + 2] & 0xFF) << 8) |
        (digest[offset + 3] & 0xFF);
    return dbc % _max;
  }
}

/// A Time-based One-Time Password (TOTP) algorithm implementation derived
/// from [rfc6238].
///
/// [rfc6238]: https://www.ietf.org/rfc/rfc6238.html
class TOTP extends HOTP {
  final int period;
  int _timeDelta = 0;
  final int _periodMS;
  final _controller = StreamController<int>.broadcast();

  /// Creates an instance of the [TOTP] class with the specified parameters.
  ///
  /// Parameters:
  /// - [secret] is the shared secret as a list of bytes for generating the OTP.
  /// - [digits] is the number of digits in the generated OTP (default is 6).
  /// - [period] is duration in seconds an OTP is valid for (default is 30).
  /// - [algo] is the block hash algorithm to use (default is [sha1]).
  /// - [label] is an optional string to identify the account or service the OTP
  ///   is associated with.
  /// - [issuer] is an optional string to specify the entity issuing the OTP.
  TOTP(
    List<int> secret, {
    int digits = 6,
    this.period = 30,
    String? label,
    String? issuer,
    BlockHashBase algo = sha1,
  })  : _periodMS = period * 1000,
        super(
          secret,
          algo: algo,
          digits: digits,
          label: label,
          issuer: issuer,
          counter: Uint8List(8),
        ) {
    // setup stream controller
    Timer? _timer;
    _controller.onCancel = () {
      _timer?.cancel();
    };
    _controller.onListen = () {
      int ms = DateTime.now().millisecondsSinceEpoch;
      int d = _periodMS - (ms + _timeDelta) % _periodMS;
      Future.delayed(Duration(milliseconds: d), () {
        if (!_controller.hasListener) return;
        _timer = Timer.periodic(Duration(seconds: period), (timer) {
          if (!_controller.hasListener) return;
          _controller.sink.add(value());
        });
        _controller.sink.add(value());
      });
      _controller.sink.add(value());
    };
  }

  /// A broadcast stream that reports new OTP on every [period] interval
  Stream<int> get stream => _controller.stream;

  @override
  int value() {
    int i, c;
    c = (DateTime.now().millisecondsSinceEpoch + _timeDelta) ~/ _periodMS;
    for (i = 7; i >= 0; --i, c >>>= 8) {
      counter[i] = c & 0xFF;
    }
    return super.value();
  }

  /// Adjust the internal clock with the parameter [delta] - the difference in
  /// milliseconds between the actual clock and the current system clock.
  void adjustClock(int delta) {
    _timeDelta = delta;
  }
}
