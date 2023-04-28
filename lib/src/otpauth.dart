// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/src/_registry.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:hashlib/src/hmac.dart';
import 'package:hashlib/src/sha1.dart';

abstract class OTPAuth {
  /// The number of digits in the generated OTP
  final int digits;

  const OTPAuth(this.digits);

  /// Generates the next OTP
  int next();

  /// Create an instance from otpauth key URI
  factory OTPAuth.parse(String keyUri) {
    var uri = Uri.parse(keyUri);
    if (uri.scheme != 'otpauth') {
      throw ArgumentError('Invalid scheme: ${uri.scheme}. Expected: otpauth');
    }

    var query = uri.queryParameters;
    if (!query.containsKey('secret')) {
      throw ArgumentError('The secret parameter is not present');
    }
    var secret = fromBase32(query['secret']!);

    var algorithm = query['algorithm'] ?? 'SHA1';
    BlockHashBase? algo = findAlgorithm(algorithm);
    if (algo == null) {
      throw ArgumentError('No such algorithm found: $algorithm');
    }

    int digits = int.parse(query['digits'] ?? '6');
    if (digits < 6 || digits > 12) {
      throw StateError('Number of digits should be between 6 to 12');
    }

    switch (uri.host.toLowerCase()) {
      case 'totp':
        int period = int.parse(query['period'] ?? '30');
        return TOTP(
          secret,
          algo: algo,
          digits: digits,
          period: period,
        );
      case 'hotp':
        if (!query.containsKey('counter')) {
          throw ArgumentError('The counter parameter is not present');
        }
        var counter = Uint8List(8);
        int c = int.parse(query['counter']!);
        for (int i = 7; i >= 0; --i, c >>>= 8) {
          counter[i] = c & 0xFF;
        }
        return HOTP(
          secret,
          digits: 6,
          counter: counter,
          algo: algo,
        );
      default:
        throw ArgumentError('Unknown type: ${uri.host}');
    }
  }
}

class RandomOTP extends OTPAuth {
  final Random _random;
  late final int _max;

  RandomOTP({
    Random? random,
    int digits = 6,
  })  : _random = random ?? Random.secure(),
        super(digits) {
    if (digits < 6) {
      throw StateError('Number of digits should be at least 6');
    }
    if (digits > 12) {
      throw StateError('Number of digits should be at most 12');
    }
    // power of 10
    int i, m;
    m = 1;
    for (i = 0; i < digits; ++i) {
      m *= 10;
    }
    _max = m;
  }

  @override
  int next() {
    return _random.nextInt(_max);
  }
}

class HOTP extends OTPAuth {
  final HMAC mac;
  final List<int> counter;
  late final int _max;

  HOTP(
    List<int> secret, {
    int digits = 6,
    required this.counter,
    BlockHashBase algo = sha1,
  })  : mac = HMAC(algo, secret),
        super(digits) {
    if (digits < 6) {
      throw StateError('Number of digits should be at least 6');
    }
    if (digits > 12) {
      throw StateError('Number of digits should be at most 12');
    }
    // power of 10
    int i, m;
    m = 1;
    for (i = 0; i < digits; ++i) {
      m *= 10;
    }
    _max = m;
  }

  @override
  int next() {
    var digest = mac.convert(counter).bytes;
    int offset = digest[19] & 0xF;
    int dbc = ((digest[offset] & 0x7f) << 24) |
        (digest[offset + 1] << 16) |
        (digest[offset + 2] << 8) |
        digest[offset + 3];
    return dbc % _max;
  }
}

class TOTP extends HOTP {
  final int period;
  final int startTime;
  final _controller = StreamController<int>.broadcast();

  int _timeDelta = 0;

  TOTP(
    List<int> secret, {
    int digits = 6,
    this.period = 30,
    int? currentTime,
    this.startTime = 0,
    BlockHashBase algo = sha1,
  }) : super(
          secret,
          algo: algo,
          digits: digits,
          counter: Uint8List(8),
        ) {
    _setupController();
    if (currentTime != null) {
      adjustClock(currentTime);
    }
  }

  /// The current OTP value
  int get current => next();

  /// Gets a broadcast stream that report new OTPs
  Stream<int> get stream => _controller.stream;

  @override
  int next() {
    int i, c;
    c = (_unixNow() + _timeDelta - startTime) ~/ period;
    for (i = 7; i >= 0; --i, c >>>= 8) {
      counter[i] = c & 0xFF;
    }
    return super.next();
  }

  @pragma('vm:prefer-inline')
  static int _unixNow() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  /// Parameter [currentTime] is the current unix timestamp in second
  void adjustClock(int currentTime) {
    _timeDelta = currentTime - _unixNow();
  }

  void _setupController() {
    Timer? _timer;
    _controller.onCancel = () {
      _timer?.cancel();
    };
    _controller.onListen = () {
      _controller.sink.add(next());
      int t = (_unixNow() + _timeDelta - startTime);
      Future.delayed(Duration(seconds: period - (t % period)), () {
        if (!_controller.hasListener) return;
        _controller.sink.add(next());
        _timer = Timer.periodic(Duration(seconds: period), (timer) {
          if (!_controller.hasListener) return;
          _controller.sink.add(next());
        });
      });
    };
  }
}
