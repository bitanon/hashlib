import 'dart:math';

import 'md5.dart' as md5;
import 'sha1.dart' as sha1;
import 'sha224.dart' as sha224;
import 'sha256.dart' as sha256;

void main(List<String> args) {
  final conditions = [
    [17, 1000],
    [1777, 50],
    [77000, 2],
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
    };

    var names = algorithms[algorithms.keys.first]!.map((e) => e.name);
    var separator = names.map((e) => ('-' * (e.length + 1)) + ':');

    print("With string of length $size ($iter times):");
    print('');
    print('| Algorithms | ${names.join(' | ')} | Difference |');
    print('|------------|${separator.join('|')}|:----------:|');

    for (var entry in algorithms.entries) {
      var me = entry.value.first;
      var diff = me.measureDiff(entry.value);
      var mine = diff[me.name]!;
      var best = diff.values.fold(mine, min);
      var message = '| ${entry.key}';
      for (var name in names) {
        var value = diff[name]!;
        message += " | ";
        if (value == best) {
          message += '**$value us**';
        } else {
          message += "$value us";
        }
      }
      message += " | ";
      if (mine == best) {
        message += '     \u2796     ';
      } else {
        message += '${best - mine} us';
      }
      message += " |";
      print(message);
    }

    print('');
  }
}
