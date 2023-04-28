// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/algorithms/registry.dart';
import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/mac_base.dart';
import 'package:hashlib/src/core/utils.dart';
import 'package:hashlib/src/hmac.dart';
import 'package:hashlib/src/sha1.dart';

class OTPAuth {
  final int digits;
  final MACHashBase mac;

  const OTPAuth(
    this.mac, {
    this.digits = 6,
  });

  /// Generate a string consisting of [digits], based on the [secret] and
  /// the [counter] parameter, using the HMAC([algo]).
  String generate(List<int> counter) {
    if (digits < 6) {
      throw StateError('Number of digits should be at least 6');
    }
    if (digits > 12) {
      throw StateError('Number of digits should be at most 12');
    }
    if (counter.length != 8) {
      throw StateError('The counter should be exactly 8 bytes');
    }
    var digest = mac.convert(counter).bytes;
    int offset = digest[19] & 0xF;
    int dbc = ((digest[offset] & 0x7f) << 24) |
        (digest[offset + 1] << 16) |
        (digest[offset + 2] << 8) |
        digest[offset + 3];
    String result = dbc.toString().padLeft(digits, '0');
    return result.substring(result.length - digits);
  }
}

class HOTP extends OTPAuth {
  HOTP(
    List<int> secret, {
    int digits = 6,
    BlockHashBase algo = sha1,
  }) : super(
          HMAC(algo, secret),
          digits: digits,
        );
}

class TOTP extends HOTP {
  final int period;
  final int initialTime;
  final int _timeDelta;
  final Uint8List _counter = Uint8List(8);

  @pragma('vm:prefer-inline')
  static int _unixNow() => DateTime.now().millisecondsSinceEpoch ~/ 1000;

  TOTP(
    List<int> secret, {
    int digits = 6,
    this.period = 30,
    int? currentTime,
    this.initialTime = 0,
    BlockHashBase algo = sha1,
  })  : _timeDelta = currentTime != null ? currentTime - _unixNow() : 0,
        super(
          secret,
          algo: algo,
          digits: digits,
        );

  @pragma('vm:prefer-inline')
  int get currentTime => _unixNow() + _timeDelta;

  @override
  String generate([List<int>? counter]) {
    if (counter == null) {
      int i, c;
      c = (currentTime - initialTime) ~/ period;
      for (i = 7; i >= 0; --i, c >>>= 8) {
        _counter[i] = c & 0xFF;
      }
      counter = _counter;
    }
    return super.generate(counter);
  }

  /// Create a [TOTP] instance from otpauth key URI
  factory TOTP.fromUri(String keyUri) {
    var uri = Uri.parse(keyUri);
    if (uri.scheme != 'otpauth') {
      throw ArgumentError('Invalid scheme: ${uri.scheme}. Expected: otpauth');
    }
    if (uri.host != 'totp') {
      throw ArgumentError('The URI is not a TOTP key');
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
    int period = int.parse(query['period'] ?? '30');
    return TOTP(
      secret,
      algo: algo,
      digits: digits,
      period: period,
    );
  }
}
