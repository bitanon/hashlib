# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/badge/dependencies-zero-889)](https://github.com/dipu-bd/hashlib/blob/master/pubspec.yaml)
[![dart support](https://img.shields.io/badge/dart-%3e%3d%202.14.0-39f?logo=dart)](https://dart.dev/guides/whats-new#september-8-2021-214-release)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![test](https://github.com/dipu-bd/hashlib/actions/workflows/test.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/test.yml)

This library contains implementations of secure hash functions, checksum generators, and key derivation algorithms optimized for Dart.

## Features

### Secure Hash Algorithms

| Algorithm | Available methods                                                  | Source      |
| --------- | ------------------------------------------------------------------ | ----------- |
| SHA-2     | `sha224`, `sha256`, `sha384`, `sha512`, `sha512t224`, `sha512t256` | RCC-6234    |
| SHA-3     | `sha3_224`, `sha3_256`, `sha3_384`, `sha3_512`                     | FIPS-202    |
| SHAKE     | `Shake128`, `Shake256`, `shake128`, `shake256`                     | FIPS-202    |
| Keccak    | `keccak224`, `keccak256`, `keccak384`, `keccak512`                 | Team Keccak |
| Blake2b   | `blake2b160`, `blake2b256`, `blake2b384`, `blake2b512`             | RFC-7693    |
| Blake2s   | `blake2s128`, `blake2s160`, `blake2s224`, `blake2s256`             | RFC-7693    |

<!--
| `blake3`     |   ⌛    |        |
| `ripemd128` |    ⌛     |       |
| `ripemd160` |    ⌛     |       |
| `ripemd320` |    ⌛     |       |
| `whirlpool` |    ⌛     |       |
-->

### Non-Cryptographic Hash Algorithms

| Algorithms | Available methods              | Source    |
| ---------- | ------------------------------ | --------- |
| CRC        | `crc16`,`crc32`,`crc64`        | Wikipedia |
| Alder32    | `alder32`                      | Wikipedia |
| xxHash32   | `XXHash32`,`xxh32`,`xxh32code` | Cyan4973  |
| xxHash64   | `XXHash64`,`xxh64`,`xxh64code` | Cyan4973  |
| XXH3-64    | `XXH3`,`xxh3`,`xxh3code`       | Cyan4973  |
| XXH3-128   | `XXH128`,`xxh128`,`xxh128code` | Cyan4973  |
| MD5        | `md5`                          | RFC-1321  |
| SHA-1      | `sha1`                         | RFC-3174  |

### Password / Key Derivation Algorithms

| Algorithm | Available methods                          | Source   |
| --------- | ------------------------------------------ | -------- |
| Argon2    | `Argon2`, `argon2d`, `argon2i`, `argon2id` | RFC-9106 |
| PBKDF2    | `PBKDF2`                                   | RFC-8081 |

<!--
| `scrypt`      |    ⌛     |       |
| `bcrypt`      |    ⌛     |       |
| `balloon`     |    ⌛     |       |
-->

### Message Authentication Code (MAC) Generators

| Algorithms | Available methods | Source   |
| ---------- | ----------------- | -------- |
| HMAC       | `HMAC`            | RFC-2104 |

<!-- | `poly1305` |   ⌛    |        |  ⌛  |        | -->

## Getting Started

The following import will give you access to all of the algorithms in this package.

```dart
import 'package:hashlib/hashlib.dart' as hashlib;
```

Check the [API Reference](https://pub.dev/documentation/hashlib/latest/) for details.

## Usage

Examples can be found inside the `example` folder.

```dart
import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';

void main() {
  var text = "Happy Hashing!";
  var key = "password";
  var pw = key.codeUnits;
  var salt = "some salt".codeUnits;
  print("text => $text");
  print("key => $key");
  print("salt => ${toHex(salt)}");
  print('');

  // Examples of Hash generation
  print('[MD5] => ${md5.string(text)}');
  print('[SHA-1] => ${sha1.string(text)}');
  print('[SHA-224] => ${sha224.string(text)}');
  print('[SHA-256] => ${sha256.string(text)}');
  print('[SHA-384] => ${sha384.string(text)}');
  print('[SHA-512] => ${sha512.string(text)}');
  print('[SHA-512/224] => ${sha512t224.string(text)}');
  print('[SHA-512/256] => ${sha512t256.string(text)}');
  print('[SHA3-224] => ${sha3_224.string(text)}');
  print('[SHA3-256] => ${sha3_256.string(text)}');
  print('[SHA3-384] => ${sha3_384.string(text)}');
  print('[SHA3-512] => ${sha3_512.string(text)}');
  print('[Keccak-224] => ${keccak224.string(text)}');
  print('[Keccak-256] => ${keccak256.string(text)}');
  print('[Keccak-384] => ${keccak384.string(text)}');
  print('[Keccak-512] => ${keccak512.string(text)}');
  print('[SHAKE-128] => ${shake128.of(20).string(text)}');
  print('[SHAKE-256] => ${shake256.of(20).string(text)}');
  print('[BLAKE-2s/256] => ${blake2s256.string(text)}');
  print('[BLAKE-2b/512] => ${blake2b512.string(text)}');
  print('');

  // Examples of MAC generations
  print('HMAC[MD5] => ${md5.hmac(pw).string(text)}');
  print('HMAC[MD5] => ${md5.hmacBy(key, utf8).string(text)}');
  print('HMAC[MD5] => ${md5.hmacBy(key).string(text)}');
  print('HMAC[MD5] => ${HMAC(md5, pw).string(text)}');
  print("[BLAKE-2b/256] => ${blake2b256.mac(pw).string(text)}");
  print("[BLAKE-2b/256] => ${Blake2bMAC(256, pw).string(text)}");
  print('');

  // Examples of PBKDF2 key derivation
  print("PBKDF2[HMAC[SHA-256]] => ${sha256.pbkdf2(pw, salt, 100)}");
  print("PBKDF2[HMAC[SHA-256]] => ${sha256.hmac(pw).pbkdf2(salt, 100)}");
  print("PBKDF2[BLAKE-2b-MAC] => ${blake2b256.mac(pw).pbkdf2(salt, 100)}");
  print("PBKDF2[HMAC[BLAKE-2b]] => ${blake2b256.pbkdf2(pw, salt, 100)}");
  print("PBKDF2[HMAC[BLAKE-2b]] => ${blake2b256.hmac(pw).pbkdf2(salt, 100)}");
  print('');

  // Examples of Argon2 key derivation
  var security = Argon2Security.test;
  print("[Argon2i] => ${argon2i(pw, salt, security: security)}");
  print("[Argon2d] => ${argon2d(pw, salt, security: security)}");
  print("[Argon2id] => ${argon2id(pw, salt, security: security)}");
  print('');

  // Example of checksum code generators
  print('[CRC16] => ${crc16code(text)}');
  print('[CRC32] => ${crc32code(text)}');
  print('[CRC64] => ${crc64code(text)}');
  print('[Alder32] => ${alder32code(text)}');
}
```

## Benchmarks

To obtain the following benchmarks, run this command:

```sh
dart compile exe ./benchmark/benchmark.dart && ./benchmark/benchmark.exe
```

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                      | `PointyCastle`                 |
| ------------- | ------------- | ---------------------------- | --------------------------- | ------------------------------ |
| MD5           | **22.64MB/s** | 10.37MB/s <br> `118% slower` | 7.54MB/s <br> `200% slower` | 11.75MB/s <br> `93% slower`    |
| SHA-1         | **17.33MB/s** | 8.89MB/s <br> `95% slower`   | 4.64MB/s <br> `274% slower` | 7.52MB/s <br> `130% slower`    |
| SHA-224       | **12.29MB/s** | 7.58MB/s <br> `62% slower`   | 2.58MB/s <br> `376% slower` | 3.18MB/s <br> `286% slower`    |
| SHA-256       | **12.28MB/s** | 7.62MB/s <br> `61% slower`   | 2.62MB/s <br> `368% slower` | 3.16MB/s <br> `289% slower`    |
| SHA-384       | **9.41MB/s**  | 2.97MB/s <br> `217% slower`  | 1.39MB/s <br> `578% slower` | 389.50KB/s <br> `2315% slower` |
| SHA-512       | **9.20MB/s**  | 2.95MB/s <br> `212% slower`  | 1.40MB/s <br> `559% slower` | 385.56KB/s <br> `2286% slower` |
| SHA-512/224   | **9.47MB/s**  | 2.98MB/s <br> `218% slower`  | ➖                          | 196.49KB/s <br> `4720% slower` |
| SHA-512/256   | **9.51MB/s**  | 2.97MB/s <br> `220% slower`  | ➖                          | 197.54KB/s <br> `4716% slower` |
| SHA3-256      | **12.27MB/s** | ➖                           | ➖                          | 227.95KB/s <br> `5281% slower` |
| SHA3-512      | **9.31MB/s**  | ➖                           | ➖                          | 227.62KB/s <br> `3989% slower` |
| BLAKE-2s      | **14.88MB/s** | ➖                           | ➖                          | ➖                             |
| BLAKE-2b      | **12.72MB/s** | ➖                           | ➖                          | 884.45KB/s <br> `1338% slower` |
| HMAC(MD5)     | **4.74MB/s**  | 3.82MB/s <br> `24% slower`   | 1.98MB/s <br> `139% slower` | ➖                             |
| HMAC(SHA-256) | **1.92MB/s**  | 1.63MB/s <br> `18% slower`   | ➖                          | ➖                             |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **155.39MB/s** | 118.59MB/s <br> `31% slower` | 92.36MB/s <br> `68% slower`  | 84.19MB/s <br> `85% slower`   |
| SHA-1         | **141.87MB/s** | 94.39MB/s <br> `50% slower`  | 45.58MB/s <br> `211% slower` | 54.72MB/s <br> `159% slower`  |
| SHA-224       | **96.06MB/s**  | 80.13MB/s <br> `20% slower`  | 20.38MB/s <br> `371% slower` | 21.11MB/s <br> `355% slower`  |
| SHA-256       | **95.30MB/s**  | 80.39MB/s <br> `19% slower`  | 20.41MB/s <br> `367% slower` | 21.12MB/s <br> `351% slower`  |
| SHA-384       | **143.51MB/s** | 46.34MB/s <br> `210% slower` | 21.34MB/s <br> `572% slower` | 5.07MB/s <br> `2732% slower`  |
| SHA-512       | **143.47MB/s** | 46.22MB/s <br> `210% slower` | 21.25MB/s <br> `575% slower` | 5.06MB/s <br> `2735% slower`  |
| SHA-512/224   | **143.87MB/s** | 46.25MB/s <br> `211% slower` | ➖                           | 4.50MB/s <br> `3100% slower`  |
| SHA-512/256   | **144.70MB/s** | 46.22MB/s <br> `213% slower` | ➖                           | 4.51MB/s <br> `3111% slower`  |
| SHA3-256      | **94.64MB/s**  | ➖                           | ➖                           | 2.99MB/s <br> `3062% slower`  |
| SHA3-512      | **143.73MB/s** | ➖                           | ➖                           | 1.72MB/s <br> `8267% slower`  |
| BLAKE-2s      | **135.45MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **151.32MB/s** | ➖                           | ➖                           | 12.02MB/s <br> `1159% slower` |
| HMAC(MD5)     | **123.20MB/s** | 95.25MB/s <br> `29% slower`  | 68.99MB/s <br> `79% slower`  | ➖                            |
| HMAC(SHA-256) | **67.64MB/s**  | 55.26MB/s <br> `22% slower`  | ➖                           | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **162.62MB/s** | 122.16MB/s <br> `33% slower` | 70.30MB/s <br> `131% slower` | 88.19MB/s <br> `84% slower`   |
| SHA-1         | **149.97MB/s** | 97.22MB/s <br> `54% slower`  | 40.51MB/s <br> `270% slower` | 57.24MB/s <br> `162% slower`  |
| SHA-224       | **99.95MB/s**  | 83.00MB/s <br> `20% slower`  | 19.60MB/s <br> `410% slower` | 21.79MB/s <br> `359% slower`  |
| SHA-256       | **100.06MB/s** | 82.93MB/s <br> `21% slower`  | 19.56MB/s <br> `412% slower` | 21.71MB/s <br> `361% slower`  |
| SHA-384       | **158.29MB/s** | 48.43MB/s <br> `227% slower` | 17.87MB/s <br> `786% slower` | 5.23MB/s <br> `2925% slower`  |
| SHA-512       | **157.14MB/s** | 48.27MB/s <br> `226% slower` | 17.81MB/s <br> `782% slower` | 5.23MB/s <br> `2903% slower`  |
| SHA-512/224   | **157.10MB/s** | 48.36MB/s <br> `225% slower` | ➖                           | 5.23MB/s <br> `2903% slower`  |
| SHA-512/256   | **157.10MB/s** | 48.35MB/s <br> `225% slower` | ➖                           | 5.22MB/s <br> `2910% slower`  |
| SHA3-256      | **99.90MB/s**  | ➖                           | ➖                           | 3.27MB/s <br> `2951% slower`  |
| SHA3-512      | **157.13MB/s** | ➖                           | ➖                           | 1.73MB/s <br> `8957% slower`  |
| BLAKE-2s      | **143.93MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **162.24MB/s** | ➖                           | ➖                           | 12.44MB/s <br> `1204% slower` |
| HMAC(MD5)     | **162.44MB/s** | 119.82MB/s <br> `36% slower` | 70.17MB/s <br> `131% slower` | ➖                            |
| HMAC(SHA-256) | **100.09MB/s** | 81.99MB/s <br> `22% slower`  | ➖                           | ➖                            |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.383 ms | 2.528 ms | 16.574 ms | 206.296 ms | 2404.537 ms |
| argon2d    | 0.303 ms | 2.435 ms | 16.62 ms  | 201.536 ms | 2339.694 ms |
| argon2id   | 0.314 ms | 2.689 ms | 25.036 ms | 281.973 ms | 2383.14 ms  |

> These benchmarks were done in _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_ on Windows 10
