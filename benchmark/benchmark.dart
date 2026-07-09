// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import "dart:io";

import 'package:hashlib/hashlib.dart';

import '_base.dart';
import 'argon2.dart' as argon2;
import 'bcrypt.dart' as bcrypt;
import 'blake2b.dart' as blake2b;
import 'blake2s.dart' as blake2s;
import 'hmac_md5.dart' as md5_hmac;
import 'hmac_sha1.dart' as sha1_hmac;
import 'hmac_sha256.dart' as sha256_hmac;
import 'md4.dart' as md4;
import 'pbkdf2.dart' as pbkdf2;
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
import 'sha3_224.dart' as sha3_224;
import 'sha3_256.dart' as sha3_256;
import 'sha3_384.dart' as sha3_384;
import 'sha3_512.dart' as sha3_512;
import 'sha512.dart' as sha512;
import 'sm3.dart' as sm3;
import 'xxhash.dart' as xxhash;

IOSink sink = stdout;
RandomAccessFile? raf;

void dump(String message) {
  raf?.writeStringSync('$message\n');
  stdout.writeln(message);
}

// ---------------------------------------------------------------------
// Hash function benchmarks
// ---------------------------------------------------------------------

/// Every hash, HMAC and checksum group for a message of [size] bytes. In each
/// group hashlib is listed first, so it is the baseline in a cell.
Map<String, List<Benchmark>> buildHashFunctions(int size) {
  return {
    "MD4": [
      md4.HashlibBenchmark(size),
      md4.PointyCastleBenchmark(size),
    ],
    "MD5": [
      md5.HashlibBenchmark(size),
      md5.CryptoBenchmark(size),
      md5.HashBenchmark(size),
      md5.PointyCastleBenchmark(size),
    ],
    "HMAC(MD5)": [
      md5_hmac.HashlibBenchmark(size),
      md5_hmac.CryptoBenchmark(size),
      md5_hmac.HashBenchmark(size),
    ],
    "SHA-1": [
      sha1.HashlibBenchmark(size),
      sha1.CryptoBenchmark(size),
      sha1.PointyCastleBenchmark(size),
      sha1.HashBenchmark(size),
    ],
    "HMAC(SHA-1)": [
      sha1_hmac.HashlibBenchmark(size),
      sha1_hmac.CryptoBenchmark(size),
    ],
    "SHA-224": [
      sha224.HashlibBenchmark(size),
      sha224.CryptoBenchmark(size),
      sha224.HashBenchmark(size),
      sha224.PointyCastleBenchmark(size),
    ],
    "SHA-256": [
      sha256.HashlibBenchmark(size),
      sha256.CryptoBenchmark(size),
      sha256.HashBenchmark(size),
      sha256.PointyCastleBenchmark(size),
    ],
    "HMAC(SHA-256)": [
      sha256_hmac.HashlibBenchmark(size),
      sha256_hmac.CryptoBenchmark(size),
    ],
    "SHA-384": [
      sha384.HashlibBenchmark(size),
      sha384.CryptoBenchmark(size),
      sha384.HashBenchmark(size),
      sha384.PointyCastleBenchmark(size),
    ],
    "SHA-512": [
      sha512.HashlibBenchmark(size),
      sha512.CryptoBenchmark(size),
      sha512.HashBenchmark(size),
      sha512.PointyCastleBenchmark(size),
    ],
    "SHA3-224": [
      sha3_224.HashlibBenchmark(size),
      sha3_224.PointyCastleBenchmark(size),
    ],
    "SHA3-256": [
      sha3_256.HashlibBenchmark(size),
      sha3_256.PointyCastleBenchmark(size),
    ],
    "SHA3-384": [
      sha3_384.HashlibBenchmark(size),
      sha3_384.PointyCastleBenchmark(size),
    ],
    "SHA3-512": [
      sha3_512.HashlibBenchmark(size),
      sha3_512.PointyCastleBenchmark(size),
    ],
    "RIPEMD-128": [
      ripemd128.HashlibBenchmark(size),
      ripemd128.PointyCastleBenchmark(size),
    ],
    "RIPEMD-160": [
      ripemd160.HashlibBenchmark(size),
      ripemd160.HashBenchmark(size),
      ripemd160.PointyCastleBenchmark(size),
    ],
    "RIPEMD-256": [
      ripemd256.HashlibBenchmark(size),
      ripemd256.PointyCastleBenchmark(size),
    ],
    "RIPEMD-320": [
      ripemd320.HashlibBenchmark(size),
      ripemd320.PointyCastleBenchmark(size),
    ],
    "BLAKE-2s": [
      blake2s.HashlibBenchmark(size),
    ],
    "BLAKE-2b": [
      blake2b.HashlibBenchmark(size),
      blake2b.PointyCastleBenchmark(size),
    ],
    "Poly1305": [
      poly1305.HashlibBenchmark(size),
      poly1305.PointyCastleBenchmark(size),
    ],
    "XXH32": [
      xxhash.XXH32Benchmark(size, "hashlib"),
    ],
    "XXH64": [
      xxhash.XXH64Benchmark(size, "hashlib"),
    ],
    "XXH3": [
      xxhash.XXH3Benchmark(size, "hashlib"),
    ],
    "XXH128": [
      xxhash.XXH128Benchmark(size, "hashlib"),
    ],
    "SM3": [
      sm3.HashlibBenchmark(size),
      sm3.PointyCastleBenchmark(size),
    ],
  };
}

// The message sizes used for the hash tables.
final messageSizes = [5 << 20, 1 << 10, 10];
String sizeHeader(int size) => '${formatSize(size)} message';

// ---------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------

/// A fixed-[width] block-character bar for [speed] relative to [best], used to
/// give each benchmark cell a proportional visual next to its number. A nonzero
/// speed always fills at least one block so it stays visible.
String buildBar(double speed, double best, [int width = 16]) {
  var filled = best <= 0 ? 0 : (speed / best * width).round();
  if (filled < 1) filled = 1;
  if (filled > width) filled = width;
  var full = '█' * filled + '░' * (width - filled);
  return '<code>$full</code>';
}

/// Renders one benchmark cell: a proportional bar, the speed, a medal when it
/// is the fastest ([best]) at this size, and for non-[baseline] rows, the speed
/// ratio against hashlib's [mine].
String formatCell(Measurement result, double best, double mine, bool baseline) {
  var icon = '';

  var speed = result.speedString;
  if (result.speed == best) {
    icon = '&#127775;';
    speed = '<b>$speed</b>';
  }

  var compare = '';
  if (!baseline) {
    if (mine > result.speed) {
      icon = '&#128315;'; // slow
      compare = formatDecimal(mine / result.speed);
    } else if (mine < result.speed) {
      icon = '&#128314;'; // fast
      compare = formatDecimal(result.speed / mine);
    }
    if (compare.isNotEmpty) {
      compare += 'x';
    }
  }

  var line1 = buildBar(result.speed, best);
  var line2 = '<small>$speed $icon$compare</small>'.trim();
  return '$line1 <br> $line2';
}

/// Prints one HTML comparison table. Rows are `(algorithm, library)` pairs -
/// the algorithm name spans its libraries with `rowspan` - with one data column
/// per entry in [columns], built by [build] for that column index. hashlib is
/// listed first in each row group and is the baseline for the ratios.
Future<void> measureTable(
  List<String> columns,
  Map<String, List<Benchmark>> Function(int column) build,
) async {
  var maps = [for (var i = 0; i < columns.length; i++) build(i)];

  dump('<table>');
  dump('<thead>');
  dump('  <tr>');
  dump('    <th>Algorithm</th>');
  dump('    <th>Library</th>');
  for (final col in columns) {
    dump('    <th>$col</th>');
  }
  dump('  </tr>');
  dump('</thead>');
  dump('<tbody>');

  for (var name in maps.first.keys) {
    // measure every (library, column) and find the fastest library per column
    var results = <List<Measurement>>[];
    var best = <double>[];
    for (var map in maps) {
      var row = <Measurement>[];
      var top = 0.0;
      for (var benchmark in map[name]!) {
        var result = await measure(benchmark);
        row.add(result);
        if (result.speed > top) top = result.speed;
      }
      results.add(row);
      best.add(top);
    }

    // one row per library; the algorithm name spans them via rowspan
    var libraries = maps.first[name]!;
    for (var li = 0; li < libraries.length; li++) {
      dump('  <tr>');
      if (li == 0) {
        var span = libraries.length > 1 ? ' rowspan="${libraries.length}"' : '';
        dump('    <td$span>$name</td>');
      }
      dump('    <td>${libraries[li].name}</td>');
      for (var ci = 0; ci < maps.length; ci++) {
        var mine = results[ci].first.speed;
        var cell = formatCell(results[ci][li], best[ci], mine, li == 0);
        dump('    <td>$cell</td>');
      }
      dump('  </tr>');
    }
  }
  dump('</tbody>');
  dump('</table>');
}

Future<void> measureHashFunctions() async {
  dump('### Hash Functions');
  dump('');
  await measureTable(
    [for (var size in messageSizes) sizeHeader(size)],
    (i) => buildHashFunctions(messageSizes[i]),
  );
  dump('');
}

// ---------------------------------------------------------------------
// Key Derivation Algorithm Benchmarks
// ---------------------------------------------------------------------

/// Renders the key-derivator table. Rows are algorithms and columns are the
/// security levels; each cell shows the average runtime for that level. No bar
/// or ratio is drawn: security levels are deliberate cost tiers and should not
/// be judged by runtime alone.
Future<void> measureKeyDerivation() async {
  dump('### Key Derivators');
  dump('');

  var argon2Levels = {
    'little': Argon2Security.little,
    'moderate': Argon2Security.moderate,
    'good': Argon2Security.good,
    'strong': Argon2Security.strong,
  };
  var scryptLevels = {
    'little': ScryptSecurity.little,
    'moderate': ScryptSecurity.moderate,
    'good': ScryptSecurity.good,
    'strong': ScryptSecurity.strong,
  };
  var bcryptLevels = {
    'little': BcryptSecurity.little,
    'moderate': BcryptSecurity.moderate,
    'good': BcryptSecurity.good,
    'strong': BcryptSecurity.strong,
  };
  var pbkdf2Levels = {
    'little': PBKDF2Security.little,
    'moderate': PBKDF2Security.moderate,
    'good': PBKDF2Security.good,
    'strong': PBKDF2Security.strong,
  };
  var algorithms = {
    'scrypt':
        scryptLevels.map((k, s) => MapEntry(k, scrypt.HashlibBenchmark(s))),
    'bcrypt':
        bcryptLevels.map((k, s) => MapEntry(k, bcrypt.HashlibBenchmark(s))),
    'pbkdf2':
        pbkdf2Levels.map((k, s) => MapEntry(k, pbkdf2.HashlibBenchmark(s))),
    'argon2i': argon2Levels
        .map((k, s) => MapEntry(k, argon2.HashlibArgon2iBenchmark(s))),
    'argon2d': argon2Levels
        .map((k, s) => MapEntry(k, argon2.HashlibArgon2dBenchmark(s))),
    'argon2id': argon2Levels
        .map((k, s) => MapEntry(k, argon2.HashlibArgon2idBenchmark(s))),
  };

  var names = ['little', 'moderate', 'good', 'strong'];

  dump('<table>');
  dump('<thead>');
  dump('  <tr>');
  dump('    <th>Algorithm</th>');
  for (final name in names) {
    dump('    <th>$name</th>');
  }
  dump('  </tr>');
  dump('</thead>');
  dump('<tbody>');
  for (var entry in algorithms.entries) {
    var instances = entry.value;
    var times = <String, double>{};
    for (var name in names) {
      var item = instances[name];
      if (item != null) {
        times[name] = (await measure(item)).runtimeMillis;
      }
    }
    dump('  <tr>');
    dump('    <td>${entry.key}</td>');
    for (var name in names) {
      var ms = times[name];
      if (ms == null) {
        dump('    <td></td>');
        continue;
      }
      dump('    <td>${formatDecimal(ms)} ms</td>');
    }
    dump('  </tr>');
  }
  dump('</tbody>');
  dump('</table>');
  dump('');
}

// ---------------------------------------------------------------------
// Main
// ---------------------------------------------------------------------

void dumpHeaders() {
  dump("## Benchmarks");
  dump('');
  dump("### Libraries");
  dump('');
  dump("- **Hashlib** : https://pub.dev/packages/hashlib");
  dump("- **Crypto** : https://pub.dev/packages/crypto");
  dump("- **PointyCastle** : https://pub.dev/packages/pointycastle");
  dump("- **Hash** : https://pub.dev/packages/hash");
  dump('');
}

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

  dumpHeaders();
  raf?.flushSync();

  await measureHashFunctions();
  raf?.flushSync();

  await measureKeyDerivation();
  raf?.flushSync();

  raf?.closeSync();
}
