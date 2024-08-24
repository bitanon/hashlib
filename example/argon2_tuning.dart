// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';

void main() {
  var target = Duration(milliseconds: 100);
  print('Target runtime: ${target.inMilliseconds}ms');

  var watch = Stopwatch()..start();
  var result = tuneArgon2Security(target);
  print('Tuning time: ${watch.elapsedMilliseconds / 1000} seconds');
  print("Result: m=${result.m} t=${result.t} p=${result.p}");

  watch.reset();
  argon2i(
    "password".codeUnits,
    "some salt".codeUnits,
    security: result,
  );
  var r = (watch.elapsedMilliseconds);
  print('Actual runtime: ${r}ms');
}

// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

/// Find the Argon2 parameters that can be used to encode password in
/// [desiredRuntime] time on the current device.
///
/// Parameters:
/// - [desiredRuntime] : The target runtime. Must be greater than 10ms.
/// - [maxMemoryAsPowerOf2] : The maxmimum memory as a power of 2. A value of 3
///   would mean memory of 2^3 = 8. Minimum value is 3. Default: 22.
/// - [saltLength] : The target salt length. Default: 16.
/// - [passwordLength] : The target password length. Default: 10.
/// - [hashLength] : The target hash length. Default: 32.
/// - [version] : The Argon2 version. Default: [Argon2Version.v13]
/// - [type] : The Argon2 type.  Default: [Argon2Type.argon2id]
/// - [testPerSample] : The number of test to run for the runtime calculation.
Argon2Security tuneArgon2Security(
  Duration desiredRuntime, {
  int hashLength = 32,
  int saltLength = 16,
  int passwordLength = 4,
  int maxMemoryAsPowerOf2 = 22,
  int testPerSample = 8,
  Argon2Type type = Argon2Type.argon2id,
  Argon2Version version = Argon2Version.v13,
}) {
  if (maxMemoryAsPowerOf2 < 3) {
    throw ArgumentError('Max memory as power of 2 must be at least 3');
  }

  final target = desiredRuntime.inMicroseconds;
  if (target < 10000) {
    throw ArgumentError('Duration should be at least 10ms');
  }

  final watch = Stopwatch()..start();
  final e = min(10000, (target * 0.01).round());

  int measure(int m, int p, int t) {
    var salt = Uint8List(saltLength);
    var password = Uint8List(passwordLength);
    int best = 0;
    for (int i = 0; i < testPerSample; ++i) {
      watch.reset();
      Argon2(
        type: type,
        version: version,
        hashLength: hashLength,
        salt: salt,
        memorySizeKB: m,
        parallelism: p,
        iterations: t,
      ).convert(password);
      int time = watch.elapsedMicroseconds;
      if (i == 0 || time < best) {
        best = time;
      }
    }
    return best;
  }

  int pow = 3;
  int memory = 8;
  int passes = 1;
  int lanes = 4;
  int time = 0;
  int prev = 0;

  // tune the memory
  for (; pow <= maxMemoryAsPowerOf2; pow++) {
    memory = 1 << pow;
    lanes = pow < 6 ? 1 << (pow - 3) : 4;
    time = measure(memory, lanes, passes);
    if (time + e > target) break;
    if (1000 * time < target) {
      pow += 7;
    } else if (100 * time < target) {
      pow += 3;
    } else if (50 * time < target) {
      pow += 2;
    } else if (10 * time < target) {
      pow++;
    }
    pow = min(pow, maxMemoryAsPowerOf2 - 1);
    prev = time;
  }
  if ((prev - target).abs() < (time - target).abs()) {
    time = prev;
    memory >>= 1;
    pow--;
  }

  // tune the passes
  if (time - e < target) {
    prev = time;
    for (passes++;; passes++) {
      time = measure(memory, lanes, passes);
      if (time + e > target) break;
      prev = time;
    }
    if ((prev - target).abs() < (time - target).abs()) {
      time = prev;
      passes--;
    }
  }

  return Argon2Security('optimized', m: memory, t: passes, p: lanes);
}
