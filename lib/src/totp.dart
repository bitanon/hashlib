// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:typed_data';

import 'package:hashlib/src/hotp.dart';
import 'package:hashlib/src/sha1.dart';

/// A Time-based One-Time Password (TOTP) algorithm implementation derived
/// from [rfc6238].
///
/// [rfc6238]: https://www.ietf.org/rfc/rfc6238.html
class TOTP extends HOTP {
  final Duration period;
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
    super.secret, {
    super.algo = sha1,
    super.digits = 6,
    super.label,
    super.issuer,
    this.period = const Duration(seconds: 30),
  })  : _periodMS = period.inMilliseconds,
        super(counter: Uint8List(8)) {
    // setup stream controller
    Timer? timer;
    _controller.onCancel = () {
      timer?.cancel();
    };
    _controller.onListen = () {
      int d = _periodMS - (currentTime % _periodMS);
      timer = Timer(Duration(milliseconds: d), () {
        timer = Timer.periodic(period, (_) {
          _controller.sink.add(value());
        });
        _controller.sink.add(value());
      });
      _controller.sink.add(value());
    };
  }

  /// A broadcast stream that reports new OTP value on every [period] interval
  Stream<int> get stream => _controller.stream;

  /// A broadcast stream that reports new OTP value as string on every [period]
  /// interval
  Stream<String> get streamString =>
      _controller.stream.map((e) => e.toString().padLeft(digits, '0'));

  /// The current time in milliseconds since EPOCH with adjusted delta shift
  int get currentTime => DateTime.now().millisecondsSinceEpoch + _timeDelta;

  @override
  int value() {
    int i, c;
    c = currentTime ~/ _periodMS;
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
