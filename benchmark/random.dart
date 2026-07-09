// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/random.dart';

import '_base.dart';

const int _maxInt = 0xFFFFFFFF;

class SystemRandomBenchmark extends SyncBenchmark {
  final random = HashlibRandom(RNG.system);
  SystemRandomBenchmark(int size) : super('system', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt();
    }
    return x;
  }
}

class SecureRandomBenchmark extends SyncBenchmark {
  final random = HashlibRandom(RNG.secure);
  SecureRandomBenchmark(int size) : super('secure', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt();
    }
    return x;
  }
}

class KeccakRandomBenchmark extends SyncBenchmark {
  final random = HashlibRandom(RNG.keccak);
  KeccakRandomBenchmark(int size) : super('keccak', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt();
    }
    return x;
  }
}

class SHA256RandomBenchmark extends SyncBenchmark {
  final random = HashlibRandom(RNG.sha256);
  SHA256RandomBenchmark(int size) : super('sha256', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt();
    }
    return x;
  }
}

class SM3RandomBenchmark extends SyncBenchmark {
  final random = HashlibRandom(RNG.sm3);
  SM3RandomBenchmark(int size) : super('sm3', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt();
    }
    return x;
  }
}

class XXH64RandomBenchmark extends SyncBenchmark {
  final random = HashlibRandom(RNG.xxh64);
  XXH64RandomBenchmark(int size) : super('xxh64', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt();
    }
    return x;
  }
}

class RandomBenchmark extends SyncBenchmark {
  final random = Random(56468882);
  RandomBenchmark(int size) : super('Random', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt(_maxInt);
    }
    return x;
  }
}

class SystemSecureRandomBenchmark extends SyncBenchmark {
  final random = Random.secure();
  SystemSecureRandomBenchmark(int size) : super('Random.secure', size);

  @override
  dynamic run() {
    int x = 0;
    for (int i = 0; i < size; ++i) {
      x = random.nextInt(_maxInt);
    }
    return x;
  }
}

void main() async {
  print('--------- Random ----------');
  for (int size in [5 << 20, 1 << 10, 10]) {
    print('---- size: ${formatSize(size)} ----');
    await RandomBenchmark(size).measureDiff([
      SystemSecureRandomBenchmark(size),
      SecureRandomBenchmark(size),
      SystemRandomBenchmark(size),
      KeccakRandomBenchmark(size),
      SM3RandomBenchmark(size),
      SHA256RandomBenchmark(size),
      XXH64RandomBenchmark(size),
    ]);
    print('');
  }
}
