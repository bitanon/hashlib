// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:typed_data';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/hotp.dart';
import 'package:hashlib/src/sha1.dart';

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
    Timer? timer;
    _controller.onCancel = () {
      timer?.cancel();
    };
    _controller.onListen = () {
      int d = _periodMS - (currentTime % _periodMS);
      Future.delayed(Duration(milliseconds: d), () {
        if (!_controller.hasListener) return;
        timer = Timer.periodic(Duration(seconds: period), (timer) {
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
