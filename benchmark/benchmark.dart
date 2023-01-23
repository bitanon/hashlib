import 'dart:math';

import 'package:hashlib/hashlib.dart';

import 'blake2b.dart' as blake2b;
import 'blake2s.dart' as blake2s;
import 'md5.dart' as md5;
import 'md5_hmac.dart' as md5_hmac;
import 'sha1.dart' as sha1;
import 'sha224.dart' as sha224;
import 'sha256.dart' as sha256;
import 'sha256_hmac.dart' as sha256_hmac;
import 'sha384.dart' as sha384;
import 'sha3_256.dart' as sha3_256;
import 'sha3_512.dart' as sha3_512;
import 'sha512.dart' as sha512;
import 'sha512_224.dart' as sha512t224;
import 'sha512_256.dart' as sha512t256;
import 'argon2.dart' as argon2;

void main(List<String> args) {
  final conditions = [
    [10, 100000],
    [1000, 5000],
    [500000, 10],
  ];

  print("# Benchmarks");
  print('');
  print("Libraries:");
  print('');
  print("- **Hashlib** : https://pub.dev/packages/hashlib");
  print("- **Crypto** : https://pub.dev/packages/crypto");
  print("- **PointyCastle** : https://pub.dev/packages/pointycastle");
  print("- **Hash** : https://pub.dev/packages/hash");
  print("- **Sha3** : https://pub.dev/packages/sha3");
  print('');

  for (var condition in conditions) {
    var size = condition[0];
    var iter = condition[1];

    var algorithms = {
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
      "SHA-512/224": [
        sha512t224.HashlibBenchmark(size, iter),
        sha512t224.CryptoBenchmark(size, iter),
        sha512t224.PointyCastleBenchmark(size, iter),
      ],
      "SHA-512/256": [
        sha512t256.HashlibBenchmark(size, iter),
        sha512t256.CryptoBenchmark(size, iter),
        sha512t256.PointyCastleBenchmark(size, iter),
      ],
      "SHA3-256": [
        sha3_256.HashlibBenchmark(size, iter),
        sha3_256.Sha3Benchmark(size, iter),
        sha3_256.PointyCastleBenchmark(size, iter),
      ],
      "SHA3-512": [
        sha3_512.HashlibBenchmark(size, iter),
        sha3_512.Sha3Benchmark(size, iter),
        sha3_512.PointyCastleBenchmark(size, iter),
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
      "HMAC(SHA-256)": [
        sha256_hmac.HashlibBenchmark(size, iter),
        sha256_hmac.CryptoBenchmark(size, iter),
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
      for (var benchmark in entry.value.reversed) {
        diff[benchmark.name] = benchmark.measure().round();
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
          message += '**${value / 1000} ms**';
        } else {
          message += '${value / 1000} ms';
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

  print('Argon2 benchmarks on different security parameters:');
  print('');
  var argon2Levels = [
    Argon2Security.test,
    Argon2Security.small,
    Argon2Security.moderate,
    Argon2Security.good,
    Argon2Security.strong,
  ];

  var stopwatch = Stopwatch()..start();
  var names = argon2Levels.map((e) => e.name);
  var separator = names.map((e) => ('-' * (e.length + 2)));
  print('| Algorithms | ${argon2Levels.map((e) => e.name).join(' | ')} |');
  print('|------------|${separator.join('|')}|');
  {
    var message = '| argon2i    |';
    for (var level in argon2Levels) {
      stopwatch.reset();
      argon2.Argon2iBenchmark(level).run();
      message += ' ${stopwatch.elapsedMicroseconds / 1000} ms |';
    }
    print(message);
  }
  {
    var message = '| argon2d    |';
    for (var level in argon2Levels) {
      stopwatch.reset();
      argon2.Argon2dBenchmark(level).run();
      message += ' ${stopwatch.elapsedMicroseconds / 1000} ms |';
    }
    print(message);
  }
  {
    var message = '| argon2id   |';
    for (var level in argon2Levels) {
      stopwatch.reset();
      argon2.Argon2idBenchmark(level).run();
      message += ' ${stopwatch.elapsedMicroseconds / 1000} ms |';
    }
    print(message);
  }
  print('');
}
