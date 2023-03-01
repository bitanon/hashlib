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
  print("[BLAKE-2b/256] => ${blake2b256.mac(pw).string(text)}");
  print("[BLAKE-2b/256] => ${Blake2bMAC(32, pw).string(text)}");
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
| XXH64         | **68.20MB/s** | ➖                           | ➖                          | ➖                             |
| XXH3          | **8.61MB/s**  | ➖                           | ➖                          | ➖                             |
| MD5           | **22.80MB/s** | 10.07MB/s <br> `127% slower` | 7.46MB/s <br> `205% slower` | 10.99MB/s <br> `107% slower`   |
| SHA-1         | **16.18MB/s** | 8.51MB/s <br> `90% slower`   | 4.69MB/s <br> `245% slower` | 7.27MB/s <br> `122% slower`    |
| SHA-224       | **12.05MB/s** | 7.41MB/s <br> `63% slower`   | 2.59MB/s <br> `365% slower` | 3.05MB/s <br> `295% slower`    |
| SHA-256       | **12.27MB/s** | 7.47MB/s <br> `64% slower`   | 2.63MB/s <br> `366% slower` | 3.06MB/s <br> `301% slower`    |
| SHA-384       | **9.31MB/s**  | 3.00MB/s <br> `210% slower`  | 1.37MB/s <br> `581% slower` | 386.43KB/s <br> `2309% slower` |
| SHA-512       | **9.33MB/s**  | 2.97MB/s <br> `214% slower`  | 1.38MB/s <br> `578% slower` | 383.06KB/s <br> `2336% slower` |
| SHA-512/224   | **9.34MB/s**  | 3.01MB/s <br> `211% slower`  | ➖                          | 194.97KB/s <br> `4692% slower` |
| SHA-512/256   | **9.27MB/s**  | 3.03MB/s <br> `206% slower`  | ➖                          | 194.85KB/s <br> `4656% slower` |
| SHA3-256      | **12.17MB/s** | ➖                           | ➖                          | 224.11KB/s <br> `5331% slower` |
| SHA3-512      | **9.25MB/s**  | ➖                           | ➖                          | 221.98KB/s <br> `4068% slower` |
| BLAKE-2s      | **14.86MB/s** | ➖                           | ➖                          | ➖                             |
| BLAKE-2b      | **12.60MB/s** | ➖                           | ➖                          | 845.22KB/s <br> `1391% slower` |
| HMAC(MD5)     | **4.78MB/s**  | 3.74MB/s <br> `28% slower`   | 1.96MB/s <br> `145% slower` | ➖                             |
| HMAC(SHA-256) | **1.87MB/s**  | 1.61MB/s <br> `16% slower`   | ➖                          | ➖                             |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **441.19MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **106.73MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **152.95MB/s** | 114.36MB/s <br> `34% slower` | 90.60MB/s <br> `69% slower`  | 78.31MB/s <br> `95% slower`   |
| SHA-1         | **140.83MB/s** | 92.62MB/s <br> `52% slower`  | 44.99MB/s <br> `213% slower` | 53.71MB/s <br> `162% slower`  |
| SHA-224       | **94.27MB/s**  | 78.74MB/s <br> `20% slower`  | 20.29MB/s <br> `365% slower` | 20.86MB/s <br> `352% slower`  |
| SHA-256       | **95.06MB/s**  | 78.81MB/s <br> `21% slower`  | 20.39MB/s <br> `366% slower` | 20.79MB/s <br> `357% slower`  |
| SHA-384       | **143.83MB/s** | 47.49MB/s <br> `203% slower` | 21.01MB/s <br> `584% slower` | 4.99MB/s <br> `2781% slower`  |
| SHA-512       | **145.61MB/s** | 47.38MB/s <br> `207% slower` | 20.86MB/s <br> `598% slower` | 4.97MB/s <br> `2831% slower`  |
| SHA-512/224   | **146.08MB/s** | 47.21MB/s <br> `209% slower` | ➖                           | 4.43MB/s <br> `3195% slower`  |
| SHA-512/256   | **148.26MB/s** | 47.00MB/s <br> `215% slower` | ➖                           | 4.44MB/s <br> `3243% slower`  |
| SHA3-256      | **95.72MB/s**  | ➖                           | ➖                           | 2.94MB/s <br> `3152% slower`  |
| SHA3-512      | **143.76MB/s** | ➖                           | ➖                           | 1.69MB/s <br> `8430% slower`  |
| BLAKE-2s      | **135.26MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **153.19MB/s** | ➖                           | ➖                           | 11.77MB/s <br> `1201% slower` |
| HMAC(MD5)     | **122.17MB/s** | 93.32MB/s <br> `31% slower`  | 67.87MB/s <br> `80% slower`  | ➖                            |
| HMAC(SHA-256) | **66.17MB/s**  | 55.79MB/s <br> `19% slower`  | ➖                           | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **478.46MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **118.07MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **160.08MB/s** | 119.61MB/s <br> `34% slower` | 69.30MB/s <br> `131% slower` | 82.72MB/s <br> `94% slower`   |
| SHA-1         | **152.65MB/s** | 95.88MB/s <br> `59% slower`  | 39.81MB/s <br> `283% slower` | 56.64MB/s <br> `170% slower`  |
| SHA-224       | **100.19MB/s** | 83.20MB/s <br> `20% slower`  | 19.47MB/s <br> `415% slower` | 21.54MB/s <br> `365% slower`  |
| SHA-256       | **100.34MB/s** | 84.02MB/s <br> `19% slower`  | 19.58MB/s <br> `412% slower` | 21.53MB/s <br> `366% slower`  |
| SHA-384       | **160.22MB/s** | 49.44MB/s <br> `224% slower` | 17.75MB/s <br> `803% slower` | 5.18MB/s <br> `2992% slower`  |
| SHA-512       | **160.45MB/s** | 49.45MB/s <br> `224% slower` | 17.63MB/s <br> `810% slower` | 5.18MB/s <br> `2995% slower`  |
| SHA-512/224   | **159.81MB/s** | 49.18MB/s <br> `225% slower` | ➖                           | 5.19MB/s <br> `2981% slower`  |
| SHA-512/256   | **158.64MB/s** | 49.02MB/s <br> `224% slower` | ➖                           | 5.11MB/s <br> `3005% slower`  |
| SHA3-256      | **100.69MB/s** | ➖                           | ➖                           | 3.20MB/s <br> `3043% slower`  |
| SHA3-512      | **160.69MB/s** | ➖                           | ➖                           | 1.71MB/s <br> `9308% slower`  |
| BLAKE-2s      | **143.60MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **164.93MB/s** | ➖                           | ➖                           | 12.42MB/s <br> `1228% slower` |
| HMAC(MD5)     | **159.29MB/s** | 120.42MB/s <br> `32% slower` | 68.40MB/s <br> `133% slower` | ➖                            |
| HMAC(SHA-256) | **100.23MB/s** | 83.31MB/s <br> `20% slower`  | ➖                           | ➖                            |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.383 ms | 2.528 ms | 16.574 ms | 206.296 ms | 2404.537 ms |
| argon2d    | 0.303 ms | 2.435 ms | 16.62 ms  | 201.536 ms | 2339.694 ms |
| argon2id   | 0.314 ms | 2.689 ms | 25.036 ms | 281.973 ms | 2383.14 ms  |

> These benchmarks were done in _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_ on Windows 10
