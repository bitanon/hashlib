import 'dart:math';

import 'base.dart';
import 'md5.dart' as md5;
import 'sha1.dart' as sha1;
import 'sha224.dart' as sha224;
import 'sha256.dart' as sha256;
import 'sha384.dart' as sha384;
import 'sha512.dart' as sha512;
import 'sha512_224.dart' as sha512224;
import 'sha512_256.dart' as sha512256;

void main(List<String> args) {
  final conditions = [
    [17, 1000],
    [1777, 50],
    [177000, 2],
  ];

  print('## Benchmarks');
  print('');
  print("Libraries:");
  print('');
  print("- **Hashlib** : https://pub.dev/packages/hashlib");
  print("- **Crypto** : https://pub.dev/packages/crypto");
  print("- **Hash** : https://pub.dev/packages/hash");
  print('');

  for (var condition in conditions) {
    var size = condition[0];
    var iter = condition[1];

    var algorithms = {
      "MD5": [
        md5.HashlibBenchmark(size, iter),
        md5.CryptoBenchmark(size, iter),
        md5.HashBenchmark(size, iter),
      ],
      "SHA-1": [
        sha1.HashlibBenchmark(size, iter),
        sha1.CryptoBenchmark(size, iter),
        sha1.HashBenchmark(size, iter),
      ],
      "SHA-224": [
        sha224.HashlibBenchmark(size, iter),
        sha224.CryptoBenchmark(size, iter),
        sha224.HashBenchmark(size, iter),
      ],
      "SHA-256": [
        sha256.HashlibBenchmark(size, iter),
        sha256.CryptoBenchmark(size, iter),
        sha256.HashBenchmark(size, iter),
      ],
      "SHA-384": [
        sha384.HashlibBenchmark(size, iter),
        sha384.CryptoBenchmark(size, iter),
        sha384.HashBenchmark(size, iter),
      ],
      "SHA-512": [
        sha512.HashlibBenchmark(size, iter),
        sha512.CryptoBenchmark(size, iter),
        sha512.HashBenchmark(size, iter),
      ],
      "SHA-512/224": [
        sha512224.HashlibBenchmark(size, iter),
        sha512224.CryptoBenchmark(size, iter),
      ],
      "SHA-512/256": [
        sha512256.HashlibBenchmark(size, iter),
        sha512256.CryptoBenchmark(size, iter),
      ],
    };

    var names = algorithms[algorithms.keys.first]!.map((e) => e.name);
    var separator = names.map((e) => ('-' * (e.length + 4)));

    print("With string of length $size ($iter iterations):");
    print('');
    print('| Algorithms | `${names.join('` | `')}` |');
    print('|------------|${separator.join('|')}|');

    for (var entry in algorithms.entries) {
      var me = entry.value.first;
      var diff = measureDiff(entry.value);
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
          message += '**$value us**';
        } else {
          message += '$value us';
        }
        if (value > mine) {
          var p = (100 * (value - mine) / mine).round();
          message += ' ($p% slower)';
        } else if (value < mine) {
          var p = (100 * (mine - value) / mine).round();
          message += ' ($p% faster)';
        }
      }
      message += " |";
      print(message);
    }

    print('');
  }
}
