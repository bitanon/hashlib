// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:pointycastle/api.dart';
import 'package:pointycastle/macs/poly1305.dart' as pc;

import '_base.dart';

Random random = Random();

final key = List.generate(16, (i) => random.nextInt(256));
final secret = List.generate(16, (i) => random.nextInt(256));

class HashlibBenchmark extends SyncBenchmark {
  final Uint8List input;
  final Uint8List keyData;
  HashlibBenchmark(int size)
      : input = Uint8List.fromList(List.filled(size, 0x3f)),
        keyData = Uint8List.fromList([...key, ...secret]),
        super('hashlib', size);

  @override
  dynamic run() {
    return hashlib.poly1305auth(input, keyData);
  }
}

class PointyCastleBenchmark extends SyncBenchmark {
  final Uint8List input;
  final Uint8List keyData;
  PointyCastleBenchmark(int size)
      : input = Uint8List.fromList(List.filled(size, 0x3f)),
        keyData = Uint8List.fromList([...key, ...secret]),
        super('PointyCastle', size);

  @override
  dynamic run() {
    final d = pc.Poly1305();
    d.init(KeyParameter(keyData));
    return d.process(input);
  }
}

void main() async {
  print('------- Poly1305 --------');
  for (int size in [5 << 20, 1 << 10, 10]) {
    print('---- message: ${formatSize(size)} ----');
    await HashlibBenchmark(size).measureDiff([
      PointyCastleBenchmark(size),
    ]);
    print('');
  }
}
