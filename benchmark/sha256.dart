// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:crypto/crypto.dart' as crypto;
import 'package:hash/hash.dart' as hash;
import 'package:hashlib/hashlib.dart' as hashlib;
import 'package:pointycastle/digests/sha256.dart' as pc;

import '_base.dart';

class HashlibBenchmark extends SyncBenchmark {
  final List<int> input;
  HashlibBenchmark(int size)
      : input = List.filled(size, 0x3f),
        super('hashlib', size);

  @override
  dynamic run() {
    return hashlib.sha256.convert(input).bytes;
  }
}

class CryptoBenchmark extends SyncBenchmark {
  final List<int> input;
  CryptoBenchmark(int size)
      : input = List.filled(size, 0x3f),
        super('crypto', size);

  @override
  dynamic run() {
    return crypto.sha256.convert(input).bytes;
  }
}

class HashBenchmark extends SyncBenchmark {
  final List<int> input;
  HashBenchmark(int size)
      : input = List.filled(size, 0x3f),
        super('hash', size);

  @override
  dynamic run() {
    return hash.SHA256().update(input).digest();
  }
}

class PointyCastleBenchmark extends SyncBenchmark {
  final Uint8List input;
  PointyCastleBenchmark(int size)
      : input = Uint8List.fromList(List.filled(size, 0x3f)),
        super('PointyCastle', size);

  @override
  dynamic run() {
    final d = pc.SHA256Digest();
    return d.process(input);
  }
}

void main() async {
  print('--------- SHA-256 ----------');
  for (int size in [5 << 20, 1 << 10, 10]) {
    print('---- message: ${formatSize(size)} ----');
    await HashlibBenchmark(size).measureDiff([
      CryptoBenchmark(size),
      HashBenchmark(size),
      PointyCastleBenchmark(size),
    ]);
    print('');
  }
}
