// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';

void main() async {
  var target = Duration(milliseconds: 100);
  print('Target runtime: ${target.inMilliseconds}ms');

  var watch = Stopwatch()..start();
  var optimized = await tuneArgon2Security(
    target,
    verbose: false,
  );
  print('Tuning time: ${watch.elapsedMilliseconds / 1000} seconds');

  watch.reset();
  var h = argon2i(
    "password".codeUnits,
    "some salt".codeUnits,
    security: optimized,
  );
  print('Sample hash: $h');
  print('Actual runtime: ${watch.elapsedMilliseconds}ms');
}
