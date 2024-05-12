// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import "dart:io";
import 'dart:math';

import 'package:hashlib/hashlib.dart';

import 'argon2.dart' as argon2;
import 'base.dart';
import 'blake2b.dart' as blake2b;
import 'blake2s.dart' as blake2s;
import 'hmac_md5.dart' as md5_hmac;
import 'hmac_sha1.dart' as sha1_hmac;
import 'hmac_sha256.dart' as sha256_hmac;
import 'md4.dart' as md4;
import 'md5.dart' as md5;
import 'poly1305.dart' as poly1305;
import 'ripemd128.dart' as ripemd128;
import 'ripemd160.dart' as ripemd160;
import 'ripemd256.dart' as ripemd256;
import 'ripemd320.dart' as ripemd320;
import 'scrypt.dart' as scrypt;
import 'sha1.dart' as sha1;
import 'sha224.dart' as sha224;
import 'sha256.dart' as sha256;
import 'sha384.dart' as sha384;
import 'sha3_256.dart' as sha3_256;
import 'sha3_512.dart' as sha3_512;
import 'sha512.dart' as sha512;
import 'sm3.dart' as sm3;
import 'xxhash.dart' as xxhash;

IOSink sink = stdout;
RandomAccessFile? raf;

void dump(message) {
  raf?.writeStringSync(message + '\n');
  stdout.writeln(message);
}

// ---------------------------------------------------------------------
// Hash function benchmarks
// ---------------------------------------------------------------------
void measureHashFunctions() {
  final conditions = [
    [5 << 20, 10],
    [1 << 10, 5000],
    [10, 100000],
  ];
  for (var condition in conditions) {
    var size = condition[0];
    var iter = condition[1];

    var algorithms = {
      "MD4": [
        md4.HashlibBenchmark(size, iter),
        md4.PointyCastleBenchmark(size, iter),
      ],
      "MD5": [
        md5.HashlibBenchmark(size, iter),
        md5.CryptoBenchmark(size, iter),
        md5.HashBenchmark(size, iter),
        md5.PointyCastleBenchmark(size, iter),
      ],
      "HMAC(MD5)": [
        md5_hmac.HashlibBenchmark(size, iter),
        md5_hmac.CryptoBenchmark(size, iter),
        md5_hmac.HashBenchmark(size, iter),
      ],
      "SHA-1": [
        sha1.HashlibBenchmark(size, iter),
        sha1.CryptoBenchmark(size, iter),
        sha1.PointyCastleBenchmark(size, iter),
        sha1.HashBenchmark(size, iter),
      ],
      "HMAC(SHA-1)": [
        sha1_hmac.HashlibBenchmark(size, iter),
        sha1_hmac.CryptoBenchmark(size, iter),
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
      "HMAC(SHA-256)": [
        sha256_hmac.HashlibBenchmark(size, iter),
        sha256_hmac.CryptoBenchmark(size, iter),
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
      "Poly1305": [
        poly1305.HashlibBenchmark(size, iter),
        poly1305.PointyCastleBenchmark(size, iter),
      ],
      "XXH32": [
        xxhash.XXH32Benchmark(size, iter, "hashlib"),
      ],
      "XXH64": [
        xxhash.XXH64Benchmark(size, iter, "hashlib"),
      ],
      "XXH3": [
        xxhash.XXH3Benchmark(size, iter, "hashlib"),
      ],
      "XXH128": [
        xxhash.XXH128Benchmark(size, iter, "hashlib"),
      ],
      "SM3": [
        sm3.HashlibBenchmark(size, iter),
        sm3.PointyCastleBenchmark(size, iter),
      ],
    };

    var nameFreq = {};
    for (var entry in algorithms.entries) {
      for (var benchmark in entry.value) {
        nameFreq[benchmark.name] ??= 0;
        nameFreq[benchmark.name]++;
      }
    }
    var names = nameFreq.keys.toList();
    names.sort((a, b) => nameFreq[b] - nameFreq[a]);
    var separator = names.map((e) => ('-' * (e.length + 4)));

    dump("With ${formatSize(size)} message ($iter iterations):");
    dump('');
    dump('| Algorithms | `${names.join('` | `')}` |');
    dump('|------------|${separator.join('|')}|');

    for (var entry in algorithms.entries) {
      var diff = <String, double>{};
      var rate = <String, String>{};
      for (var benchmark in entry.value.reversed) {
        var runtime = benchmark.measure();
        var hashRate = 1e6 * iter * size / runtime;
        diff[benchmark.name] = runtime;
        rate[benchmark.name] = formatSpeed(hashRate);
      }
      var me = entry.value.first;
      var mine = diff[me.name]!;
      var best = diff.values.fold(mine, min);

      var message = '| ${entry.key}     ';
      for (var name in names) {
        message += " | ";
        if (!diff.containsKey(name)) {
          // message += "    \u2796    ";
          continue;
        }
        var value = diff[name]!;
        if (value == best) {
          message += '**${rate[name]}**';
        } else {
          message += '${rate[name]}';
        }
        if (mine < value) {
          var p = formatDecimal(value / mine);
          message += ' <br> `${p}x slow`';
        } else if (mine > value) {
          var p = formatDecimal(mine / value);
          message += ' <br> `${p}x fast`';
        }
      }
      message += " |";
      dump(message);
    }
    dump('');
  }
}

// ---------------------------------------------------------------------
// Key Derivation Algorithm Benchmarks
// ---------------------------------------------------------------------
void measureKeyDerivation() {
  dump('Argon2 and scrypt benchmarks on different security parameters:');
  dump('');
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
  dump('| Algorithms | ${argon2Levels.map((e) => e.name).join(' | ')} |');
  dump('|------------|${separator.join('|')}|');
  for (var entry in algorithms.entries) {
    var algorithm = entry.key;
    var items = entry.value;
    var message = '| $algorithm   |';
    for (var item in items) {
      var runtime = item.measure();
      message += ' ${runtime / 1000} ms |';
    }
    dump(message);
  }
  dump('');
}

// ---------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------
void main(List<String> args) async {
  if (args.isNotEmpty) {
    try {
      stdout.writeln('Opening output file: ${args[0]}');
      raf = File(args[0]).openSync(mode: FileMode.writeOnly);
    } catch (err) {
      stderr.writeln(err);
    }
    stdout.writeln('----------------------------------------');
  }

  dump("# Benchmarks");
  dump('');
  dump("Libraries:");
  dump('');
  dump("- **Hashlib** : https://pub.dev/packages/hashlib");
  dump("- **Crypto** : https://pub.dev/packages/crypto");
  dump("- **PointyCastle** : https://pub.dev/packages/pointycastle");
  dump("- **Hash** : https://pub.dev/packages/hash");
  dump('');

  measureHashFunctions();
  measureKeyDerivation();

  var ram = '3200MHz';
  var processor = 'AMD Ryzen 7 5800X';
  dump('> All benchmarks are done on _${processor}_ processor '
      'and _${ram}_ RAM using compiled _exe_');

  raf?.flushSync();
  raf?.closeSync();
}
