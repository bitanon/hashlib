// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hashlib/hashlib.dart' as hashlib;

import '_base.dart';

Random random = Random();

final key = List.generate(128, (i) => random.nextInt(256));

class HashlibBenchmark extends SyncBenchmark {
  final List<int> input;
  HashlibBenchmark(int size)
      : input = List.filled(size, 0x3f),
        super('hashlib', size);

  @override
  dynamic run() {
    return hashlib.HMAC(hashlib.sha256).by(key).convert(input).bytes;
  }
}

class CryptoBenchmark extends SyncBenchmark {
  final List<int> input;
  CryptoBenchmark(int size)
      : input = List.filled(size, 0x3f),
        super('crypto', size);

  @override
  dynamic run() {
    return crypto.Hmac(crypto.sha256, key).convert(input).bytes;
  }
}

void main() async {
  print('------- HMAC(SHA-256) --------');
  for (int size in [5 << 20, 1 << 10, 10]) {
    print('---- message: ${formatSize(size)} ----');
    await HashlibBenchmark(size).measureDiff([
      CryptoBenchmark(size),
    ]);
    print('');
  }
}
