// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:hashlib/hashlib.dart';

void main() {
  final secret = Uint8List.fromList([
    0x1,
    0x2,
    0x3,
    0x4,
    0x5,
    0x6,
    0x7,
    0x8,
  ]);

  group('TOTP', () {
    test('algorithm name', () {
      expect(TOTP(secret).algorithm, 'SHA1');
      expect(TOTP(secret, algo: md5).algorithm, 'MD5');
    });

    test('secret, label and issuer values', () {
      var totp = TOTP(secret, label: 'test label', issuer: 'test issuer');
      expect(totp.secret, equals(secret));
      expect(totp.label, equals('test label'));
      expect(totp.issuer, equals('test issuer'));

      var totp2 = TOTP(secret);
      expect(totp2.secret, equals(secret));
      expect(totp2.label, null);
      expect(totp2.issuer, null);
    });

    test('should generate OTP of correct length', () {
      expect(TOTP(secret).valueString().length, equals(6));
    });

    test('number of digits must be at least 4', () {
      for (int i = 0; i < 20; ++i) {
        var cb = () => TOTP(secret, digits: i).valueString().length;
        if (i < 4 || i > 15) {
          expect(cb, throwsA((e) => e is AssertionError), reason: 'digits: $i');
        } else {
          expect(cb(), equals(i), reason: 'digits: $i');
        }
      }
    });

    test('should generate different OTPs over time', () {
      var totp = TOTP(secret);
      int time = 30000 - totp.currentTime % 30000;
      totp.adjustClock(time);
      int otp1 = totp.value();
      totp.adjustClock(time + 30000);
      int otp2 = totp.value();
      expect(otp1, isNot(equals(otp2)));
      totp.adjustClock(time + 1);
      int otp3 = totp.value();
      expect(otp1, equals(otp3));
      totp.adjustClock(time - 100);
      int otp4 = totp.value();
      expect(otp1, isNot(equals(otp4)));
    });

    test('should adjust the clock correctly', () {
      var totp1 = TOTP(secret);
      var totp2 = TOTP(secret);
      totp2.adjustClock(30030);

      int otp1 = totp1.value();
      int otp2 = totp2.value();

      expect(otp1, isNot(equals(otp2)));
    });

    test('stream should emit OTPs periodically', () async {
      int ms = 80;
      var totp = TOTP(secret, period: Duration(milliseconds: ms));
      totp.adjustClock(ms - totp.currentTime % ms);
      final otps = <int>[];
      var subscription = totp.stream.listen((otp) {
        otps.add(otp);
      });
      await Future.delayed(
        Duration(milliseconds: 3 * ms - 1),
        subscription.cancel,
      );
      expect(otps.length, 3);
      expect(otps[0], isNot(equals(otps[1])));
      expect(otps[0], isNot(equals(otps[2])));
      expect(otps[1], isNot(equals(otps[2])));
    });

    test('stream should emit OTP string periodically', () async {
      int ms = 80;
      var totp = TOTP(secret, period: Duration(milliseconds: ms));
      totp.adjustClock(ms - totp.currentTime % ms);
      final otps = <String>[];
      var subscription = totp.streamString.listen((otp) {
        otps.add(otp);
      });
      await Future.delayed(
        Duration(milliseconds: 3 * ms - 1),
        subscription.cancel,
      );
      expect(otps.length, 3);
      expect(otps[0], isNot(otps[1]));
      expect(otps[0], isNot(equals(otps[2])));
      expect(otps[1], isNot(equals(otps[2])));
    });
  });
}
