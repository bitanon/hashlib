// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

import 'package:hashlib/src/algorithms/keccak/keccak.dart';
import 'package:hashlib/src/algorithms/md4.dart';
import 'package:hashlib/src/algorithms/sha2/sha2.dart';
import 'package:hashlib/src/algorithms/sm3.dart';
import 'package:hashlib/src/algorithms/xxh64/xxh64.dart';
import 'package:hashlib/src/core/hash_base.dart';

const int _mask32 = 0xFFFFFFFF;
const int _maxSafeNumber = 0x1FFFFFFFFFFFFF;

enum RandomGenerator {
  secure,
  system,
  keccak,
  sha256,
  md5,
  xxh64,
  sm3,
}

extension RandomGeneratorIterable on RandomGenerator {
  Iterable<int> build([int? seed]) {
    switch (this) {
      case RandomGenerator.keccak:
        return RandomGenerators.$keccakGenerateor(seed);
      case RandomGenerator.sha256:
        return RandomGenerators.$hashGenerateor(SHA256Hash(), seed);
      case RandomGenerator.md5:
        return RandomGenerators.$hashGenerateor(MD4Hash(), seed);
      case RandomGenerator.xxh64:
        return RandomGenerators.$hashGenerateor(XXHash64Sink(111), seed);
      case RandomGenerator.sm3:
        return RandomGenerators.$hashGenerateor(SM3Hash(), seed);
      case RandomGenerator.secure:
        return RandomGenerators.$secureGenerator();
      case RandomGenerator.system:
      default:
        return RandomGenerators.$systemGenerator(seed);
    }
  }
}

abstract class RandomGenerators {
  static int _seedCounter = 0x9BDC06A7;

  /// Generate a 64-bit random seed
  static int $generateSeed() {
    var now = DateTime.now();
    var code = now.microsecondsSinceEpoch;
    code -= _seedCounter++;
    if (code.bitLength & 1 == 1) {
      code *= ~code;
    }
    code ^= ~_seedCounter++ << 5;
    return code & _maxSafeNumber;
  }

  /// Generate a seed based on current time
  static void $seedList(TypedData data, int seed) {
    var list = Uint32List.view(data.buffer);
    var inp = [
      seed & _mask32,
      seed >>> 32,
      list.length,
      0xD5A79147,
      0x14292967 + list.length,
      0x59F111F1 ^ -seed.bitLength,
      0x106AA070 + seed,
      0x71374491 - seed,
      0x06CA6351 ^ seed,
      0x650A7354,
      0xF40E3585,
      0x766A0ABB ^ -seed,
      0x81C2C92E,
      0x92722C85,
      0x748F82EE ^ -list.length,
      0x78A5636F | -seed,
    ];

    int i, x;
    for (i = 0; i < 16 && i < list.length; ++i) {
      list[i] ^= inp[i];
    }
    for (x = seed; i < list.length; ++i) {
      list[i] ^= x = (x >>> (i & 15)) ^ seed;
      list[i] ^= list[i - 16];
      list[i] ^= -list[i - 7];
    }
    var list8 = Uint8List.view(data.buffer);
    for (i = list.lengthInBytes; i < list8.length; ++i) {
      list8[i] ^= seed >>> (i & 31);
    }
  }

  /// Returns a iterable of 32-bit integers backed by system's [Random].
  static Iterable<int> $secureGenerator() sync* {
    Random random;
    try {
      random = Random.secure();
    } catch (err) {
      random = Random($generateSeed());
    }
    while (true) {
      yield random.nextInt(_mask32);
    }
  }

  /// Returns a iterable of 32-bit integers backed by system's [Random].
  static Iterable<int> $systemGenerator([int? seed]) sync* {
    seed ??= $generateSeed();
    Random random = Random(seed);
    while (true) {
      yield random.nextInt(_mask32);
    }
  }

  /// Returns a iterable of 32-bit integers generated from the [KeccakHash].
  static Iterable<int> $keccakGenerateor([int? seed]) sync* {
    seed ??= $generateSeed();
    var sink = KeccakHash(stateSize: 64, paddingByte: 0);
    $seedList(sink.sbuffer, seed);
    while (true) {
      sink.$update();
      for (var x in sink.sbuffer) {
        yield x;
      }
    }
  }

  /// Returns a iterable of 32-bit integers generated from the [sink].
  static Iterable<int> $hashGenerateor(
    HashDigestSink sink, [
    int? seed,
  ]) sync* {
    seed ??= $generateSeed();
    var input = Uint8List(sink.hashLength);
    for (int i = 0;; i++) {
      if (i & 31 == 0) {
        $seedList(input, seed);
      }
      sink.add(input);
      var digest = sink.digest();
      sink.reset();
      for (var x in Uint32List.view(digest.buffer)) {
        yield x;
      }
      input = digest.bytes;
    }
  }
}
