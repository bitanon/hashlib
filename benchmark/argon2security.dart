// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';

void main() async {
  var watch = Stopwatch()..start();
  var optimized = await Argon2Security.optimize(
    Duration(milliseconds: 5000),
  );
  print(watch.elapsed.inSeconds);
  watch.reset();
  print(argon2i(
    "password".codeUnits,
    "some salt".codeUnits,
    security: optimized,
  ));
  print(watch.elapsedMilliseconds);
}
