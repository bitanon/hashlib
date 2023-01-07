import 'dart:math';

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
    [177000, 1],
  ];

  print('## Benchmarks');
  print('');
  print("Libraries:");
  print('');
  print("- **Hashlib** : https://pub.dev/packages/hashlib");
  print("- **Crypto** : https://pub.dev/packages/crypto");
  print('');

  for (var condition in conditions) {
    var size = condition[0];
    var iter = condition[1];

    var algorithms = {
      "MD5": [
        md5.HashlibBenchmark(size, iter),
        md5.CryptoBenchmark(size, iter),
      ],
      "SHA-1": [
        sha1.HashlibBenchmark(size, iter),
        sha1.CryptoBenchmark(size, iter),
      ],
      "SHA-224": [
        sha224.HashlibBenchmark(size, iter),
        sha224.CryptoBenchmark(size, iter),
      ],
      "SHA-256": [
        sha256.HashlibBenchmark(size, iter),
        sha256.CryptoBenchmark(size, iter),
      ],
      "SHA-384": [
        sha384.HashlibBenchmark(size, iter),
        sha384.CryptoBenchmark(size, iter),
      ],
      "SHA-512": [
        sha512.HashlibBenchmark(size, iter),
        sha512.CryptoBenchmark(size, iter),
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
    var separator = names.map((e) => ('-' * (e.length + 3)) + ':');

    print("With string of length $size ($iter times):");
    print('');
    print('| Algorithms | `${names.join('` | `')}` |  Comment  |');
    print('|------------|${separator.join('|')}|:---------:|');

    for (var entry in algorithms.entries) {
      var me = entry.value.first;
      var diff = me.measureDiff(entry.value);
      var mine = diff[me.name]!;
      var best = diff.values.fold(mine, min);
      var worst = diff.values.fold(mine, max);
      var message = '| ${entry.key}     ';
      for (var name in names) {
        message += " | ";
        if (!diff.containsKey(name)) {
          message += "    \u2796    ";
          continue;
        }
        var value = diff[name]!;
        if (value == best) {
          message += ' **$value us** ';
        } else {
          message += " $value us ";
        }
      }
      message += " | ";
      if (mine > best) {
        var p = (100 * (mine - best) / best).round();
        message += ' $p% slower ';
      } else if (mine < worst) {
        var p = (100 * (worst - mine) / worst).round();
        message += ' $p% faster ';
      } else {
        message += "    \u2796    ";
      }
      message += " |";
      print(message);
    }

    print('');
  }
}
