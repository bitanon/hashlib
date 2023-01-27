// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';

void main() async {
  var target = Duration(milliseconds: 100);
  var watch = Stopwatch()..start();
  var optimized = await Argon2Security.optimize(
    target,
    verbose: false,
  );
  print(watch.elapsedMilliseconds / target.inMilliseconds);
  watch.reset();
  print(argon2i(
    "password".codeUnits,
    "some salt".codeUnits,
    security: optimized,
  ));
  print(watch.elapsedMilliseconds);
}
