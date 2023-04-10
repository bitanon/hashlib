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

| Algorithms  | Available methods              | Source    |
| ----------- | ------------------------------ | --------- |
| MD5         | `md5`                          | RFC-1321  |
| SHA-1       | `sha1`                         | RFC-3174  |
| xxHash-32   | `XXHash32`,`xxh32`,`xxh32code` | Cyan4973  |
| xxHash-64   | `XXHash64`,`xxh64`,`xxh64code` | Cyan4973  |
| xxHash3-64  | `XXH3`,`xxh3`,`xxh3code`       | Cyan4973  |
| xxHash3-128 | `XXH128`,`xxh128`,`xxh128code` | Cyan4973  |
| CRC         | `crc16`,`crc32`,`crc64`        | Wikipedia |
| Alder32     | `alder32`                      | Wikipedia |

### Password / Key Derivation Algorithms

| Algorithm | Available methods                          | Source   |
| --------- | ------------------------------------------ | -------- |
| Argon2    | `Argon2`, `argon2d`, `argon2i`, `argon2id` | RFC-9106 |
| PBKDF2    | `PBKDF2`, `pbkdf2`                         | RFC-8081 |
| scrypt    | `scrypt`, `Scrypt`                         | RFC-7914 |

<!--
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

  // Example of hash code generations
  print('[XXH32] => ${xxh32code(text)}');
  print('[CRC32] => ${crc32code(text)}');
  print('[Alder32] => ${alder32code(text)}');
  print('[CRC16] => ${crc16code(text)}');
  print('');

  // Examples of Hash generation
  print('[CRC64] => ${crc64sum(text)}');
  print('[XXH64] => ${xxh64sum(text)}');
  print('[XXH3] => ${xxh3sum(text)}');
  print('[XXH128] => ${xxh128sum(text)}');
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
  print("[BLAKE-2b/*] => ${Blake2bMAC(32, pw).string(text)}");
  print("[BLAKE-2b/256] => ${blake2b256.mac(pw).string(text)}");
  print('');

  // Examples of PBKDF2 key derivation
  print("PBKDF2[HMAC[SHA-256]] => ${pbkdf2(pw, salt, 100)}");
  print("PBKDF2[HMAC[SHA-1]] => ${sha1.hmac(pw).pbkdf2(salt, 100)}");
  print("PBKDF2[HMAC[BLAKE-2b]] => ${blake2b256.pbkdf2(pw, salt, 100)}");
  print("PBKDF2[BLAKE-2b-MAC] => ${blake2b256.mac(pw).pbkdf2(salt, 100)}");
  print('');

  // Examples of scrypt key derivation
  print("[scrypt] => ${scrypt(pw, salt, N: 16, r: 8, p: 1, dklen: 32)}");
  print('');

  // Examples of Argon2 key derivation
  var security = Argon2Security.test;
  print("[Argon2i] => ${argon2i(pw, salt, security: security)}");
  print("[Argon2d] => ${argon2d(pw, salt, security: security)}");
  print("[Argon2id] => ${argon2id(pw, salt, security: security)}");
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
| XXH64         | **67.24MB/s** | ➖                           | ➖                          | ➖                             |
| XXH3          | **8.56MB/s**  | ➖                           | ➖                          | ➖                             |
| MD5           | **22.80MB/s** | 10.23MB/s <br> `123% slower` | 7.47MB/s <br> `205% slower` | 11.39MB/s <br> `100% slower`   |
| SHA-1         | **17.38MB/s** | 8.74MB/s <br> `99% slower`   | 4.76MB/s <br> `265% slower` | 7.37MB/s <br> `136% slower`    |
| SHA-224       | **12.30MB/s** | 7.24MB/s <br> `70% slower`   | 2.49MB/s <br> `395% slower` | 3.16MB/s <br> `289% slower`    |
| SHA-256       | **12.28MB/s** | 7.29MB/s <br> `68% slower`   | 2.62MB/s <br> `368% slower` | 3.18MB/s <br> `286% slower`    |
| SHA-384       | **9.44MB/s**  | 2.98MB/s <br> `216% slower`  | 1.28MB/s <br> `639% slower` | 397.37KB/s <br> `2276% slower` |
| SHA-512       | **9.36MB/s**  | 2.98MB/s <br> `214% slower`  | 1.34MB/s <br> `597% slower` | 396.35KB/s <br> `2262% slower` |
| SHA-512/224   | **9.57MB/s**  | 3.02MB/s <br> `217% slower`  | ➖                          | 201.40KB/s <br> `4652% slower` |
| SHA-512/256   | **9.54MB/s**  | 3.00MB/s <br> `218% slower`  | ➖                          | 201.98KB/s <br> `4623% slower` |
| SHA3-256      | **12.33MB/s** | ➖                           | ➖                          | 219.98KB/s <br> `5505% slower` |
| SHA3-512      | **9.36MB/s**  | ➖                           | ➖                          | 219.72KB/s <br> `4162% slower` |
| BLAKE-2s      | **14.83MB/s** | ➖                           | ➖                          | ➖                             |
| BLAKE-2b      | **12.63MB/s** | ➖                           | ➖                          | 813.14KB/s <br> `1453% slower` |
| HMAC(MD5)     | **4.67MB/s**  | 3.75MB/s <br> `24% slower`   | 1.95MB/s <br> `140% slower` | ➖                             |
| HMAC(SHA-256) | **1.89MB/s**  | 1.57MB/s <br> `20% slower`   | ➖                          | ➖                             |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **454.17MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **105.77MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **155.56MB/s** | 116.70MB/s <br> `33% slower` | 89.72MB/s <br> `73% slower`  | 79.40MB/s <br> `96% slower`   |
| SHA-1         | **146.49MB/s** | 94.75MB/s <br> `55% slower`  | 46.52MB/s <br> `215% slower` | 54.18MB/s <br> `170% slower`  |
| SHA-224       | **97.16MB/s**  | 78.68MB/s <br> `23% slower`  | 20.99MB/s <br> `363% slower` | 20.98MB/s <br> `363% slower`  |
| SHA-256       | **97.22MB/s**  | 78.19MB/s <br> `24% slower`  | 20.95MB/s <br> `364% slower` | 20.97MB/s <br> `364% slower`  |
| SHA-384       | **143.92MB/s** | 46.98MB/s <br> `206% slower` | 21.39MB/s <br> `573% slower` | 5.21MB/s <br> `2665% slower`  |
| SHA-512       | **148.22MB/s** | 47.41MB/s <br> `213% slower` | 21.50MB/s <br> `589% slower` | 5.21MB/s <br> `2745% slower`  |
| SHA-512/224   | **145.98MB/s** | 47.04MB/s <br> `210% slower` | ➖                           | 4.61MB/s <br> `3068% slower`  |
| SHA-512/256   | **144.80MB/s** | 47.35MB/s <br> `206% slower` | ➖                           | 4.61MB/s <br> `3042% slower`  |
| SHA3-256      | **96.78MB/s**  | ➖                           | ➖                           | 2.88MB/s <br> `3266% slower`  |
| SHA3-512      | **145.49MB/s** | ➖                           | ➖                           | 1.66MB/s <br> `8685% slower`  |
| BLAKE-2s      | **133.86MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **153.35MB/s** | ➖                           | ➖                           | 11.53MB/s <br> `1231% slower` |
| HMAC(MD5)     | **122.39MB/s** | 94.73MB/s <br> `29% slower`  | 67.13MB/s <br> `82% slower`  | ➖                            |
| HMAC(SHA-256) | **67.48MB/s**  | 55.64MB/s <br> `21% slower`  | ➖                           | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **484.62MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **116.98MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **161.57MB/s** | 123.35MB/s <br> `31% slower` | 69.18MB/s <br> `134% slower` | 83.05MB/s <br> `95% slower`   |
| SHA-1         | **153.49MB/s** | 97.47MB/s <br> `57% slower`  | 40.97MB/s <br> `275% slower` | 56.68MB/s <br> `171% slower`  |
| SHA-224       | **101.25MB/s** | 82.35MB/s <br> `23% slower`  | 20.11MB/s <br> `404% slower` | 21.55MB/s <br> `370% slower`  |
| SHA-256       | **101.56MB/s** | 82.32MB/s <br> `23% slower`  | 20.02MB/s <br> `407% slower` | 21.69MB/s <br> `368% slower`  |
| SHA-384       | **160.98MB/s** | 49.18MB/s <br> `227% slower` | 17.69MB/s <br> `810% slower` | 5.34MB/s <br> `2913% slower`  |
| SHA-512       | **162.20MB/s** | 49.22MB/s <br> `230% slower` | 17.68MB/s <br> `817% slower` | 5.34MB/s <br> `2938% slower`  |
| SHA-512/224   | **161.66MB/s** | 49.25MB/s <br> `228% slower` | ➖                           | 5.34MB/s <br> `2930% slower`  |
| SHA-512/256   | **161.52MB/s** | 49.16MB/s <br> `229% slower` | ➖                           | 5.35MB/s <br> `2921% slower`  |
| SHA3-256      | **101.83MB/s** | ➖                           | ➖                           | 3.15MB/s <br> `3129% slower`  |
| SHA3-512      | **160.89MB/s** | ➖                           | ➖                           | 1.67MB/s <br> `9543% slower`  |
| BLAKE-2s      | **141.52MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **162.45MB/s** | ➖                           | ➖                           | 12.14MB/s <br> `1238% slower` |
| HMAC(MD5)     | **162.09MB/s** | 123.68MB/s <br> `31% slower` | 69.42MB/s <br> `133% slower` | ➖                            |
| HMAC(SHA-256) | **101.54MB/s** | 82.08MB/s <br> `24% slower`  | ➖                           | ➖                            |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.378 ms | 2.62 ms  | 17.917 ms | 219.696 ms | 2504.115 ms |
| argon2d    | 0.334 ms | 2.747 ms | 19.035 ms | 239.565 ms | 2508.532 ms |
| argon2id   | 0.323 ms | 2.631 ms | 17.18 ms  | 214.449 ms | 2538.26 ms  |

SCRYPT benchmarks on different security parameters:

```
--------- Hashlib/SCRYPT ----------
hashlib/scrypt[n=1<<4,r=16,p=4]: 1.896 ms
hashlib/scrypt[n=1<<8,r=16,p=4]: 13.63 ms
hashlib/scrypt[n=1<<12,r=16,p=4]: 201.858 ms
hashlib/scrypt[n=1<<15,r=16,p=4]: 1585.825 ms
```

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
