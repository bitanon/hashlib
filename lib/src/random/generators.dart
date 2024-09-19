// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math' show Random;
import 'dart:typed_data';

import 'package:hashlib/src/algorithms/keccak/keccak.dart';
import 'package:hashlib/src/algorithms/md4.dart';
import 'package:hashlib/src/algorithms/sha2/sha2.dart';
import 'package:hashlib/src/algorithms/sm3.dart';
import 'package:hashlib/src/algorithms/xxh64/xxh64.dart';
import 'package:hashlib/src/core/hash_base.dart';

import 'generator_vm.dart' if (dart.library.js) 'generator_js.dart';
export 'generator_vm.dart' if (dart.library.js) 'generator_js.dart';

const int _mask32 = 0xFFFFFFFF;

typedef NextIntFunction = int Function();

/// Available Random Number Generators
enum RNG {
  secure,
  system,
  keccak,
  sha256,
  md5,
  xxh64,
  sm3;
}

extension RNGBuilder on RNG {
  /// Gets the function returning the next 32-bit integer by this RNG
  NextIntFunction build([int? seed]) {
    switch (this) {
      case RNG.keccak:
        return _keccakGenerateor(seed);
      case RNG.sha256:
        return _hashGenerateor(SHA256Hash(), seed);
      case RNG.md5:
        return _hashGenerateor(MD4Hash(), seed);
      case RNG.xxh64:
        return _hashGenerateor(XXHash64Sink(111), seed);
      case RNG.sm3:
        return _hashGenerateor(SM3Hash(), seed);
      case RNG.system:
        return _systemGenerator(seed);
      case RNG.secure:
      default:
        return _secureGenerator();
    }
  }
}

/// Expands the seed to fill the list
void $seedList(TypedData data, int seed) {
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
NextIntFunction _secureGenerator() {
  final random = secureRandom();
  return () => random.nextInt(_mask32);
}

/// Returns a iterable of 32-bit integers backed by system's [Random].
NextIntFunction _systemGenerator([int? seed]) {
  final random = Random(seed ?? $generateSeed());
  return () => random.nextInt(_mask32);
}

/// Returns a iterable of 32-bit integers generated from the [KeccakHash].
NextIntFunction _keccakGenerateor([int? seed]) {
  int l, p;
  var sink = KeccakHash(stateSize: 64, paddingByte: 0);
  $seedList(sink.sbuffer, seed ?? $generateSeed());
  p = l = sink.sbuffer.length;
  return () {
    if (p == l) {
      p = 0;
      sink.$update();
    }
    return sink.sbuffer[p++];
  };
}

/// Returns a iterable of 32-bit integers generated from the [sink].
NextIntFunction _hashGenerateor(
  HashDigestSink sink, [
  int? seed,
]) {
  int l, p;
  var input = Uint8List(64);
  var input32 = Uint32List(0);
  $seedList(input, seed ?? $generateSeed());
  l = p = sink.hashLength >>> 2;
  return () {
    if (p == l) {
      p = 0;
      sink.reset();
      sink.add(input);
      input = sink.$finalize();
      input32 = Uint32List.view(input.buffer);
    }
    return input32[p++];
  };
}
