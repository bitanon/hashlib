# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/librariesio/release/pub/hashlib?label=dependencies)](https://github.com/dipu-bd/hashlib/-/blob/master/pubspec.yaml)
[![Dart](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml)

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
| `sha3_224`   |   ✔️    | 1.0.0  |  ⌛  |        |
| `sha3_256`   |   ✔️    | 1.0.0  |  ⌛  |        |
| `sha3_384`   |   ✔️    | 1.0.0  |  ⌛  |        |
| `sha3_512`   |   ✔️    | 1.0.0  |  ⌛  |        |
| `shake128`   |   ✔️    | 1.0.0  |  ⌛  |        |
| `shake256`   |   ✔️    | 1.0.0  |  ⌛  |        |

<!--
| `keccak_224` |   ⌛    |        |  ⌛  |        |
| `keccak_256` |   ⌛    |        |  ⌛  |        |
| `keccak_384` |   ⌛    |        |  ⌛  |        |
| `keccak_512` |   ⌛    |        |  ⌛  |        |
| `blake2b`    |   ⌛    |        |  ⌛  |        |
| `blake2s`    |   ⌛    |        |  ⌛  |        |
| `blake3`     |   ⌛    |        |  ⌛  |        |
-->

### MAC generation

| Algorithms | (Native | Since) | (Web | Since) |
| ---------- | :-----: | :----: | :--: | :----: |
| `hmac`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |

<!-- | `poly1305` |   ⌛    |        |  ⌛  |        | -->

<!--
### Password hashing / Key derivation

| Algorithms    | Supported | Since |
| ------------- | :-------: | :---: |
| `pbkdf2_hmac` |    ⌛     |       |
| `argon2i`     |    ⌛     |       |
| `argon2d`     |    ⌛     |       |
| `argon2id`    |    ⌛     |       |
| `bcrypt`      |    ⌛     |       |
| `scrypt`      |    ⌛     |       |
| `balloon`     |    ⌛     |       |

### Cyclic redundancy checks

| Algorithms | Supported | Since |
| ---------- | :-------: | :---: |
| `cksum`    |    ⌛     |       |
| `crc16`    |    ⌛     |       |
| `crc32`    |    ⌛     |       |
| `crc64`    |    ⌛     |       |

### Checksums

| Algorithms | Supported | Since |
| ---------- | :-------: | :---: |
| `bsd`      |    ⌛     |       |
| `sysv`     |    ⌛     |       |
| `alder32`  |    ⌛     |       |

### Other Cryptographic hash functions

| Algorithms  | Supported | Since |
| ----------- | :-------: | :---: |
| `ripemd128` |    ⌛     |       |
| `ripemd160` |    ⌛     |       |
| `ripemd320` |    ⌛     |       |
| `whirlpool` |    ⌛     |       |
-->

## Getting started

The following import will give you access to all of the algorithms in this package.

```dart
import 'package:hashlib/hashlib.dart' as hashlib;
```

## Usage

Check the API Documentation for usage instruction. Examples can be found inside the `example` folder.

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
  print('[SHA-512/224] $text => ${sha512sum224(text)}');
  print('[SHA-512/256] $text => ${sha512sum256(text)}');
  print('[SHA3-224] $text => ${sha3_224sum(text)}');
  print('[SHA3-256] $text => ${sha3_256sum(text)}');
  print('[SHA3-384] $text => ${sha3_384sum(text)}');
  print('[SHA3-512] $text => ${sha3_512sum(text)}');
  print('[SHAKE-128] $text => ${shake128sum(text, 20)}');
  print('[SHAKE-256] $text => ${shake256sum(text, 20)}');
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
  print('HMAC[SHAKE-128] $text => ${Shake128(20).hmacBy(key).string(text)}');
  print('HMAC[SHAKE-256] $text => ${Shake256(20).hmacBy(key).string(text)}');
  print('');
}

```

## Benchmarks

To obtain the following benchmarks, run this command:

```
dart run ./benchmark/benchmark.dart`
```

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                 | `hash`                   |
| ------------- | -------------- | ------------------------ | ------------------------ |
| MD5           | **49.872 ms**  | 96.585 ms (94% slower)   | 133.627 ms (168% slower) |
| SHA-1         | **55.413 ms**  | 113.73 ms (105% slower)  | 208.398 ms (276% slower) |
| SHA-224       | **76.584 ms**  | 131.464 ms (72% slower)  | 383.59 ms (401% slower)  |
| SHA-256       | **76.331 ms**  | 130.14 ms (70% slower)   | 377.257 ms (394% slower) |
| SHA-384       | **96.624 ms**  | 337.329 ms (249% slower) | 712.231 ms (637% slower) |
| SHA-512       | **98.094 ms**  | 340.59 ms (247% slower)  | 711.801 ms (626% slower) |
| SHA-512/224   | **95.396 ms**  | 336.718 ms (253% slower) | ➖                       |
| SHA-512/256   | **95.147 ms**  | 336.471 ms (254% slower) | ➖                       |
| SHA3-256      | **76.245 ms**  | ➖                       | ➖                       |
| SHA3-512      | **97.575 ms**  | ➖                       | ➖                       |
| HMAC(MD5)     | **215.372 ms** | 262.821 ms (22% slower)  | 496.958 ms (131% slower) |
| HMAC(SHA-256) | **526.317 ms** | 615.802 ms (17% slower)  | ➖                       |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   |
| ------------- | ------------- | ------------------------ | ------------------------ |
| MD5           | **25.666 ms** | 41.487 ms (62% slower)   | 52.934 ms (106% slower)  |
| SHA-1         | **35.505 ms** | 53.241 ms (50% slower)   | 106.547 ms (200% slower) |
| SHA-224       | **51.645 ms** | 61.916 ms (20% slower)   | 246.322 ms (377% slower) |
| SHA-256       | **51.465 ms** | 61.645 ms (20% slower)   | 247.0 ms (380% slower)   |
| SHA-384       | **33.152 ms** | 107.364 ms (224% slower) | 244.713 ms (638% slower) |
| SHA-512       | **33.155 ms** | 108.873 ms (228% slower) | 243.685 ms (635% slower) |
| SHA-512/224   | **33.7 ms**   | 107.789 ms (220% slower) | ➖                       |
| SHA-512/256   | **33.279 ms** | 107.725 ms (224% slower) | ➖                       |
| SHA3-256      | **52.581 ms** | ➖                       | ➖                       |
| SHA3-512      | **33.386 ms** | ➖                       | ➖                       |
| HMAC(MD5)     | **33.959 ms** | 52.367 ms (54% slower)   | 72.017 ms (112% slower)  |
| HMAC(SHA-256) | **73.651 ms** | 88.246 ms (20% slower)   | ➖                       |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   |
| ------------- | ------------- | ------------------------ | ------------------------ |
| MD5           | **23.303 ms** | 40.572 ms (74% slower)   | 71.2 ms (206% slower)    |
| SHA-1         | **33.312 ms** | 52.087 ms (56% slower)   | 122.694 ms (268% slower) |
| SHA-224       | **49.265 ms** | 59.883 ms (22% slower)   | 258.147 ms (424% slower) |
| SHA-256       | **49.127 ms** | 60.73 ms (24% slower)    | 256.179 ms (421% slower) |
| SHA-384       | **30.112 ms** | 103.022 ms (242% slower) | 296.293 ms (884% slower) |
| SHA-512       | **30.251 ms** | 103.282 ms (241% slower) | 296.745 ms (881% slower) |
| SHA-512/224   | **30.178 ms** | 103.572 ms (243% slower) | ➖                       |
| SHA-512/256   | **30.104 ms** | 103.083 ms (242% slower) | ➖                       |
| SHA3-256      | **49.518 ms** | ➖                       | ➖                       |
| SHA3-512      | **30.412 ms** | ➖                       | ➖                       |
| HMAC(MD5)     | **23.756 ms** | 43.359 ms (83% slower)   | 68.846 ms (190% slower)  |
| HMAC(SHA-256) | **50.049 ms** | 60.212 ms (20% slower)   | ➖                       |
