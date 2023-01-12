# hashlib

[![build](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml)
[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)

This library contains implementations of secure hash functions, checksum generators, and key derivation algorithms optimized for Dart.

## Features

### Secure hash functions

| Algorithms   | (Native | Since) | (Web | Since) |
| ------------ | :-----: | :----: | :--: | :----: |
| `md5`        |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha1`       |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha224`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha256`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha384`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha512`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha512_224` |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha512_256` |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha3_224`   |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `sha3_256`   |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `sha3_384`   |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `sha3_512`   |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `shake128`   |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `shake256`   |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `keccak224`  |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `keccak256`  |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `keccak384`  |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `keccak512`  |   ✔️    | 1.0.0  |  ✔️  | 1.1.0  |
| `blake2s`    |   ✔️    | 1.3.0  |  ✔️  | 1.3.0  |
| `blake2b`    |   ✔️    | 1.3.0  |  ➖  |   ➖   |

<!--
| `blake3`     |   ⌛    |        |  ⌛  |        |
| `ripemd128` |    ⌛     |       |
| `ripemd160` |    ⌛     |       |
| `ripemd320` |    ⌛     |       |
| `whirlpool` |    ⌛     |       |
-->

### Message Authentication Code generators

| Algorithms | (Native | Since) | (Web | Since) |
| ---------- | :-----: | :----: | :--: | :----: |
| `hmac`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |

<!-- | `poly1305` |   ⌛    |        |  ⌛  |        | -->

### Checksums algorithms

| Algorithms | Supported | Since |
| ---------- | :-------: | :---: |
| `alder32`  |    ✔️     | 1.2.0 |
| `crc16`    |    ✔️     | 1.2.0 |
| `crc32`    |    ✔️     | 1.2.0 |
| `crc64`    |    ✔️     | 1.2.0 |

<!--
### Password hashing / Key derivation

| Algorithms    | Supported | Since |
| ------------- | :-------: | :---: |
| `pbkdf2_hmac` |    ⌛     |       |
| `argon2d`     |    ⌛     |       |
| `argon2i`     |    ⌛     |       |
| `argon2id`    |    ⌛     |       |
| `bcrypt`      |    ⌛     |       |
| `scrypt`      |    ⌛     |       |
| `balloon`     |    ⌛     |       |
-->

## Getting started

The following import will give you access to all of the algorithms in this package.

```dart
import 'package:hashlib/hashlib.dart' as hashlib;
```

Check the [API Reference](https://pub.dev/documentation/hashlib/latest/) for details.

## Usage

Examples can be found inside the `example` folder.

```dart
import 'package:hashlib/hashlib.dart';

void main() {
  // Examples of Hash generation
  final text = "Happy Hashing!";
  print('[MD5] $text => ${md5sum(text)}');
  print('[SHA-1] $text => ${sha1sum(text)}');
  print('[SHA-224] $text => ${sha224sum(text)}');
  print('[SHA-256] $text => ${sha256sum(text)}');
  print('[SHA-384] $text => ${sha384sum(text)}');
  print('[SHA-512] $text => ${sha512sum(text)}');
  print('[SHA-512/224] $text => ${sha512t224sum(text)}');
  print('[SHA-512/256] $text => ${sha512t256sum(text)}');
  print('[SHA3-224] $text => ${sha3_224sum(text)}');
  print('[SHA3-256] $text => ${sha3_256sum(text)}');
  print('[SHA3-384] $text => ${sha3_384sum(text)}');
  print('[SHA3-512] $text => ${sha3_512sum(text)}');
  print('[Keccak-224] $text => ${keccak224sum(text)}');
  print('[Keccak-256] $text => ${keccak256sum(text)}');
  print('[Keccak-384] $text => ${keccak384sum(text)}');
  print('[Keccak-512] $text => ${keccak512sum(text)}');
  print('[SHAKE-128] $text => ${shake128sum(text, 20)}');
  print('[SHAKE-256] $text => ${shake256sum(text, 20)}');
  print('[BLAKE-2s/256] $text => ${blake2s256.string(text)}');
  print('[BLAKE-2b/256] $text => ${blake2b256.string(text)}');
  print('');

  // Example of HMAC generation
  final key = "secret";
  print('HMAC[MD5] $text => ${md5.hmacBy(key).string(text)}');
  print('HMAC[SHA-1] $text => ${sha1.hmacBy(key).string(text)}');
  print('HMAC[SHA-224] $text => ${sha224.hmacBy(key).string(text)}');
  print('HMAC[SHA-256] $text => ${sha256.hmacBy(key).string(text)}');
  print('HMAC[SHA-384] $text => ${sha384.hmacBy(key).string(text)}');
  print('HMAC[SHA-512] $text => ${sha512.hmacBy(key).string(text)}');
  print('HMAC[SHA-512/224] $text => ${sha512t224.hmacBy(key).string(text)}');
  print('HMAC[SHA-512/256] $text => ${sha512t256.hmacBy(key).string(text)}');
  print('HMAC[SHA3-224] $text => ${sha3_224.hmacBy(key).string(text)}');
  print('HMAC[SHA3-256] $text => ${sha3_256.hmacBy(key).string(text)}');
  print('HMAC[SHA3-384] $text => ${sha3_384.hmacBy(key).string(text)}');
  print('HMAC[SHA3-512] $text => ${sha3_512.hmacBy(key).string(text)}');
  print('HMAC[Keccak-224] $text => ${keccak224.hmacBy(key).string(text)}');
  print('HMAC[Keccak-256] $text => ${keccak256.hmacBy(key).string(text)}');
  print('HMAC[Keccak-384] $text => ${keccak384.hmacBy(key).string(text)}');
  print('HMAC[Keccak-512] $text => ${keccak512.hmacBy(key).string(text)}');
  print('HMAC[SHAKE-128] $text => ${shake128.of(20).hmacBy(key).string(text)}');
  print('HMAC[SHAKE-256] $text => ${shake256.of(20).hmacBy(key).string(text)}');
  print('[BLAKE-2s/256] $text => ${Blake2s(key.codeUnits, 256).string(text)}');
  print('[BLAKE-2b/256] $text => ${Blake2b(key.codeUnits, 256).string(text)}');
  print('');
}
```

## Benchmarks

To obtain the following benchmarks, run this command:

```
dart run ./benchmark/benchmark.dart`
```

> These benchmarks were done in _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_ on Windows 10

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | -------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **50.931 ms**  | 101.212 ms <br> `99% slower`  | 133.758 ms <br> `163% slower` | 88.288 ms <br> `73% slower`     | ➖                            |
| SHA-1         | **53.747 ms**  | 115.271 ms <br> `114% slower` | 211.951 ms <br> `294% slower` | 137.231 ms <br> `155% slower`   | ➖                            |
| SHA-224       | **76.389 ms**  | 134.22 ms <br> `76% slower`   | 387.053 ms <br> `407% slower` | 321.229 ms <br> `321% slower`   | ➖                            |
| SHA-256       | **76.828 ms**  | 135.425 ms <br> `76% slower`  | 379.707 ms <br> `394% slower` | 319.343 ms <br> `316% slower`   | ➖                            |
| SHA-384       | **96.529 ms**  | 334.873 ms <br> `247% slower` | 718.278 ms <br> `644% slower` | 2597.044 ms <br> `2590% slower` | ➖                            |
| SHA-512       | **98.675 ms**  | 338.345 ms <br> `243% slower` | 726.788 ms <br> `637% slower` | 2618.119 ms <br> `2553% slower` | ➖                            |
| SHA-512/224   | **97.361 ms**  | 329.735 ms <br> `239% slower` | ➖                            | 5096.644 ms <br> `5135% slower` | ➖                            |
| SHA-512/256   | **96.537 ms**  | 334.794 ms <br> `247% slower` | ➖                            | 5038.997 ms <br> `5120% slower` | ➖                            |
| SHA3-256      | **77.401 ms**  | ➖                            | ➖                            | 4452.906 ms <br> `5653% slower` | 434.21 ms <br> `461% slower`  |
| SHA3-512      | **97.807 ms**  | ➖                            | ➖                            | 4492.233 ms <br> `4493% slower` | 429.818 ms <br> `339% slower` |
| HMAC(MD5)     | **206.854 ms** | 263.488 ms <br> `27% slower`  | 508.613 ms <br> `146% slower` | ➖                              | ➖                            |
| HMAC(SHA-256) | **515.705 ms** | 632.506 ms <br> `23% slower`  | ➖                            | ➖                              | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **26.035 ms** | 42.218 ms <br> `62% slower`   | 54.553 ms <br> `110% slower`  | 60.076 ms <br> `131% slower`    | ➖                            |
| SHA-1         | **35.23 ms**  | 52.975 ms <br> `50% slower`   | 105.127 ms <br> `198% slower` | 91.053 ms <br> `158% slower`    | ➖                            |
| SHA-224       | **53.851 ms** | 64.94 ms <br> `21% slower`    | 249.092 ms <br> `363% slower` | 243.794 ms <br> `353% slower`   | ➖                            |
| SHA-256       | **53.426 ms** | 63.715 ms <br> `19% slower`   | 248.188 ms <br> `365% slower` | 242.431 ms <br> `354% slower`   | ➖                            |
| SHA-384       | **35.019 ms** | 106.083 ms <br> `203% slower` | 239.521 ms <br> `584% slower` | 990.296 ms <br> `2728% slower`  | ➖                            |
| SHA-512       | **34.532 ms** | 105.82 ms <br> `206% slower`  | 236.418 ms <br> `585% slower` | 993.274 ms <br> `2776% slower`  | ➖                            |
| SHA-512/224   | **34.895 ms** | 105.861 ms <br> `203% slower` | ➖                            | 1108.072 ms <br> `3075% slower` | ➖                            |
| SHA-512/256   | **34.694 ms** | 106.124 ms <br> `206% slower` | ➖                            | 1111.653 ms <br> `3104% slower` | ➖                            |
| SHA3-256      | **53.227 ms** | ➖                            | ➖                            | 1724.218 ms <br> `3139% slower` | 232.79 ms <br> `337% slower`  |
| SHA3-512      | **35.456 ms** | ➖                            | ➖                            | 2980.181 ms <br> `8305% slower` | 350.984 ms <br> `890% slower` |
| HMAC(MD5)     | **32.946 ms** | 54.731 ms <br> `66% slower`   | 73.506 ms <br> `123% slower`  | ➖                              | ➖                            |
| HMAC(SHA-256) | **75.485 ms** | 91.716 ms <br> `22% slower`   | ➖                            | ➖                              | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **24.426 ms** | 41.096 ms <br> `68% slower`   | 69.952 ms <br> `186% slower`  | 57.881 ms <br> `137% slower`    | ➖                            |
| SHA-1         | **33.924 ms** | 52.011 ms <br> `53% slower`   | 120.991 ms <br> `257% slower` | 87.333 ms <br> `157% slower`    | ➖                            |
| SHA-224       | **50.227 ms** | 61.098 ms <br> `22% slower`   | 260.411 ms <br> `418% slower` | 234.297 ms <br> `366% slower`   | ➖                            |
| SHA-256       | **50.354 ms** | 61.608 ms <br> `22% slower`   | 254.885 ms <br> `406% slower` | 233.129 ms <br> `363% slower`   | ➖                            |
| SHA-384       | **31.181 ms** | 101.861 ms <br> `227% slower` | 280.735 ms <br> `800% slower` | 972.907 ms <br> `3020% slower`  | ➖                            |
| SHA-512       | **31.34 ms**  | 103.349 ms <br> `230% slower` | 279.512 ms <br> `792% slower` | 949.03 ms <br> `2928% slower`   | ➖                            |
| SHA-512/224   | **31.817 ms** | 102.973 ms <br> `224% slower` | ➖                            | 954.928 ms <br> `2901% slower`  | ➖                            |
| SHA-512/256   | **31.462 ms** | 103.699 ms <br> `230% slower` | ➖                            | 970.079 ms <br> `2983% slower`  | ➖                            |
| SHA3-256      | **50.011 ms** | ➖                            | ➖                            | 1554.648 ms <br> `3009% slower` | 216.966 ms <br> `334% slower` |
| SHA3-512      | **31.264 ms** | ➖                            | ➖                            | 2939.351 ms <br> `9302% slower` | 343.434 ms <br> `998% slower` |
| HMAC(MD5)     | **24.111 ms** | 42.385 ms <br> `76% slower`   | 70.695 ms <br> `193% slower`  | ➖                              | ➖                            |
| HMAC(SHA-256) | **50.42 ms**  | 62.647 ms <br> `24% slower`   | ➖                            | ➖                              | ➖                            |
