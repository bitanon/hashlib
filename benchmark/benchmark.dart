// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:hashlib/hashlib.dart';

import 'argon2.dart' as argon2;
import 'base.dart';
import 'blake2b.dart' as blake2b;
import 'blake2s.dart' as blake2s;
import 'hmac_md5.dart' as md5_hmac;
import 'hmac_sha1.dart' as sha1_hmac;
import 'hmac_sha256.dart' as sha256_hmac;
import 'md5.dart' as md5;
import 'poly1305.dart' as poly1305;
import 'sha1.dart' as sha1;
import 'sha224.dart' as sha224;
import 'sha256.dart' as sha256;
import 'sha384.dart' as sha384;
import 'sha3_256.dart' as sha3_256;
import 'sha3_512.dart' as sha3_512;
import 'sha512.dart' as sha512;
import 'xxhash.dart' as xxhash;
import 'scrypt.dart' as scrypt;
import 'ripemd128.dart' as ripemd128;
import 'ripemd160.dart' as ripemd160;
import 'ripemd256.dart' as ripemd256;
import 'ripemd320.dart' as ripemd320;

// ---------------------------------------------------------------------
// Hash function benchmarks
// ---------------------------------------------------------------------
void measureHashFunctions() {
  final conditions = [
    [500000, 10],
    [1000, 5000],
    [10, 100000],
  ];
  for (var condition in conditions) {
    var size = condition[0];
    var iter = condition[1];

    var algorithms = {
      "XXH64": [
        xxhash.XXH64Benchmark(size, iter, "hashlib"),
      ],
      "XXH3": [
        xxhash.XXH3Benchmark(size, iter, "hashlib"),
      ],
      "MD5": [
        md5.HashlibBenchmark(size, iter),
        md5.CryptoBenchmark(size, iter),
        md5.HashBenchmark(size, iter),
        md5.PointyCastleBenchmark(size, iter),
      ],
      "SHA-1": [
        sha1.HashlibBenchmark(size, iter),
        sha1.CryptoBenchmark(size, iter),
        sha1.PointyCastleBenchmark(size, iter),
        sha1.HashBenchmark(size, iter),
      ],
      "SHA-224": [
        sha224.HashlibBenchmark(size, iter),
        sha224.CryptoBenchmark(size, iter),
        sha224.HashBenchmark(size, iter),
        sha224.PointyCastleBenchmark(size, iter),
      ],
      "SHA-256": [
        sha256.HashlibBenchmark(size, iter),
        sha256.CryptoBenchmark(size, iter),
        sha256.HashBenchmark(size, iter),
        sha256.PointyCastleBenchmark(size, iter),
      ],
      "SHA-384": [
        sha384.HashlibBenchmark(size, iter),
        sha384.CryptoBenchmark(size, iter),
        sha384.HashBenchmark(size, iter),
        sha384.PointyCastleBenchmark(size, iter),
      ],
      "SHA-512": [
        sha512.HashlibBenchmark(size, iter),
        sha512.CryptoBenchmark(size, iter),
        sha512.HashBenchmark(size, iter),
        sha512.PointyCastleBenchmark(size, iter),
      ],
      "SHA3-256": [
        sha3_256.HashlibBenchmark(size, iter),
        sha3_256.PointyCastleBenchmark(size, iter),
      ],
      "SHA3-512": [
        sha3_512.HashlibBenchmark(size, iter),
        sha3_512.PointyCastleBenchmark(size, iter),
      ],
      "RIPEMD-128": [
        ripemd128.HashlibBenchmark(size, iter),
        ripemd128.PointyCastleBenchmark(size, iter),
      ],
      "RIPEMD-160": [
        ripemd160.HashlibBenchmark(size, iter),
        ripemd160.HashBenchmark(size, iter),
        ripemd160.PointyCastleBenchmark(size, iter),
      ],
      "RIPEMD-256": [
        ripemd256.HashlibBenchmark(size, iter),
        ripemd256.PointyCastleBenchmark(size, iter),
      ],
      "RIPEMD-320": [
        ripemd320.HashlibBenchmark(size, iter),
        ripemd320.PointyCastleBenchmark(size, iter),
      ],
      "BLAKE-2s": [
        blake2s.HashlibBenchmark(size, iter),
      ],
      "BLAKE-2b": [
        blake2b.HashlibBenchmark(size, iter),
        blake2b.PointyCastleBenchmark(size, iter),
      ],
      "HMAC(MD5)": [
        md5_hmac.HashlibBenchmark(size, iter),
        md5_hmac.CryptoBenchmark(size, iter),
        md5_hmac.HashBenchmark(size, iter),
      ],
      "HMAC(SHA-1)": [
        sha1_hmac.HashlibBenchmark(size, iter),
        sha1_hmac.CryptoBenchmark(size, iter),
      ],
      "HMAC(SHA-256)": [
        sha256_hmac.HashlibBenchmark(size, iter),
        sha256_hmac.CryptoBenchmark(size, iter),
      ],
      "Poly1305": [
        poly1305.HashlibBenchmark(size, iter),
        poly1305.PointyCastleBenchmark(size, iter),
      ],
    };

    var names = algorithms.entries.fold<Set<String>>(
      Set<String>.identity(),
      (p, v) => p..addAll(v.value.map((b) => b.name)),
    );
    var separator = names.map((e) => ('-' * (e.length + 4)));

    print("With string of length $size ($iter iterations):");
    print('');
    print('| Algorithms | `${names.join('` | `')}` |');
    print('|------------|${separator.join('|')}|');

    for (var entry in algorithms.entries) {
      var diff = <String, int>{};
      var rate = <String, String>{};
      for (var benchmark in entry.value.reversed) {
        var runtime = benchmark.measure();
        var hashRate = 1e6 * iter * size / runtime;
        diff[benchmark.name] = runtime.round();
        rate[benchmark.name] = formatSize(hashRate) + '/s';
      }
      var me = entry.value.first;
      var mine = diff[me.name]!;
      var best = diff.values.fold(mine, min);

      var message = '| ${entry.key}     ';
      for (var name in names) {
        message += " | ";
        if (!diff.containsKey(name)) {
          message += "    \u2796    ";
          continue;
        }
        var value = diff[name]!;
        if (value == best) {
          message += '**${rate[name]}**';
        } else {
          message += '${rate[name]}';
        }
        if (value > mine) {
          var p = (100 * (value - mine) / mine).round();
          message += ' <br> `$p% slower`';
        } else if (value < mine) {
          var p = (100 * (mine - value) / mine).round();
          message += ' <br> `$p% faster`';
        }
      }
      message += " |";
      print(message);
    }
    print('');
  }
}

// ---------------------------------------------------------------------
// Key Derivation Algorithm Benchmarks
// ---------------------------------------------------------------------
void measureKeyDerivation() {
  print('Argon2 and scrypt benchmarks on different security parameters:');
  print('');
  var argon2Levels = [
    Argon2Security.test,
    Argon2Security.little,
    Argon2Security.moderate,
    Argon2Security.good,
    Argon2Security.strong,
  ];
  var scryptLevels = [
    ScryptSecurity.test,
    ScryptSecurity.little,
    ScryptSecurity.moderate,
    ScryptSecurity.good,
    ScryptSecurity.strong,
  ];
  var algorithms = {
    'scrypt': scryptLevels.map((e) => scrypt.HashlibBenchmark(e)),
    'argon2i': argon2Levels.map((e) => argon2.HashlibArgon2iBenchmark(e)),
    'argon2d': argon2Levels.map((e) => argon2.HashlibArgon2dBenchmark(e)),
    'argon2id': argon2Levels.map((e) => argon2.HashlibArgon2idBenchmark(e)),
  };

  var names = argon2Levels.map((e) => e.name);
  var separator = names.map((e) => ('-' * (e.length + 2)));
  print('| Algorithms | ${argon2Levels.map((e) => e.name).join(' | ')} |');
  print('|------------|${separator.join('|')}|');
  for (var entry in algorithms.entries) {
    var algorithm = entry.key;
    var items = entry.value;
    var message = '| $algorithm   |';
    for (var item in items) {
      var runtime = item.measure();
      message += ' ${runtime / 1000} ms |';
    }
    print(message);
  }
  print('');
}

// ---------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------
void main(List<String> args) {
  print("# Benchmarks");
  print('');
  print("Libraries:");
  print('');
  print("- **Hashlib** : https://pub.dev/packages/hashlib");
  print("- **Crypto** : https://pub.dev/packages/crypto");
  print("- **PointyCastle** : https://pub.dev/packages/pointycastle");
  print("- **Hash** : https://pub.dev/packages/hash");
  print('');

  measureHashFunctions();
  measureKeyDerivation();

  var ram = '3200MHz';
  var processor = 'AMD Ryzen 7 5800X';
  print('> All benchmarks are done on _${processor}_ processor '
      'and _${ram}_ RAM using compiled _exe_');
}
