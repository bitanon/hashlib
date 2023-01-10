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
| `keccak224`  |   ✔️    | 1.0.0  |  ⌛  |        |
| `keccak256`  |   ✔️    | 1.0.0  |  ⌛  |        |
| `keccak384`  |   ✔️    | 1.0.0  |  ⌛  |        |
| `keccak512`  |   ✔️    | 1.0.0  |  ⌛  |        |

<!--
| `blake2b`    |   ⌛    |        |  ⌛  |        |
| `blake2s`    |   ⌛    |        |  ⌛  |        |
| `blake3`     |   ⌛    |        |  ⌛  |        |
-->

### Message Authentication Code generators

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

> These benchmarks were done in _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_ on Windows 10

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib 🔥
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                 | `hash`                   | `sha3`                   |
| ------------- | -------------- | ------------------------ | ------------------------ | ------------------------ |
| MD5           | **50.107 ms**  | 101.123 ms (102% slower) | 139.001 ms (177% slower) | ➖                       |
| SHA-1         | **55.785 ms**  | 116.463 ms (109% slower) | 208.638 ms (274% slower) | ➖                       |
| SHA-224       | **75.704 ms**  | 133.182 ms (76% slower)  | 387.721 ms (412% slower) | ➖                       |
| SHA-256       | **76.607 ms**  | 130.455 ms (70% slower)  | 381.222 ms (398% slower) | ➖                       |
| SHA-384       | **96.676 ms**  | 341.488 ms (253% slower) | 752.712 ms (679% slower) | ➖                       |
| SHA-512       | **97.046 ms**  | 342.706 ms (253% slower) | 719.218 ms (641% slower) | ➖                       |
| SHA-512/224   | **95.339 ms**  | 338.656 ms (255% slower) | ➖                       | ➖                       |
| SHA-512/256   | **95.722 ms**  | 338.353 ms (253% slower) | ➖                       | ➖                       |
| SHA3-256      | **75.395 ms**  | ➖                       | ➖                       | 411.966 ms (446% slower) |
| SHA3-512      | **96.882 ms**  | ➖                       | ➖                       | 411.606 ms (325% slower) |
| HMAC(MD5)     | **202.898 ms** | 261.717 ms (29% slower)  | 532.516 ms (162% slower) | ➖                       |
| HMAC(SHA-256) | **516.24 ms**  | 628.502 ms (22% slower)  | ➖                       | ➖                       |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   | `sha3`                   |
| ------------- | ------------- | ------------------------ | ------------------------ | ------------------------ |
| MD5           | **25.26 ms**  | 43.516 ms (72% slower)   | 56.735 ms (125% slower)  | ➖                       |
| SHA-1         | **34.681 ms** | 53.712 ms (55% slower)   | 107.652 ms (210% slower) | ➖                       |
| SHA-224       | **50.969 ms** | 63.217 ms (24% slower)   | 240.234 ms (371% slower) | ➖                       |
| SHA-256       | **51.111 ms** | 63.143 ms (24% slower)   | 242.054 ms (374% slower) | ➖                       |
| SHA-384       | **32.82 ms**  | 108.715 ms (231% slower) | 237.763 ms (624% slower) | ➖                       |
| SHA-512       | **32.79 ms**  | 108.357 ms (230% slower) | 243.2 ms (642% slower)   | ➖                       |
| SHA-512/224   | **32.647 ms** | 108.18 ms (231% slower)  | ➖                       | ➖                       |
| SHA-512/256   | **32.125 ms** | 107.816 ms (236% slower) | ➖                       | ➖                       |
| SHA3-256      | **50.881 ms** | ➖                       | ➖                       | 225.934 ms (344% slower) |
| SHA3-512      | **32.802 ms** | ➖                       | ➖                       | 337.521 ms (929% slower) |
| HMAC(MD5)     | **32.492 ms** | 52.861 ms (63% slower)   | 74.494 ms (129% slower)  | ➖                       |
| HMAC(SHA-256) | **72.161 ms** | 88.789 ms (23% slower)   | ➖                       | ➖                       |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   | `sha3`                    |
| ------------- | ------------- | ------------------------ | ------------------------ | ------------------------- |
| MD5           | **23.129 ms** | 40.817 ms (76% slower)   | 73.305 ms (217% slower)  | ➖                        |
| SHA-1         | **33.571 ms** | 51.972 ms (55% slower)   | 121.203 ms (261% slower) | ➖                        |
| SHA-224       | **48.692 ms** | 61.124 ms (26% slower)   | 251.237 ms (416% slower) | ➖                        |
| SHA-256       | **48.675 ms** | 61.115 ms (26% slower)   | 251.095 ms (416% slower) | ➖                        |
| SHA-384       | **29.876 ms** | 103.421 ms (246% slower) | 296.226 ms (892% slower) | ➖                        |
| SHA-512       | **29.865 ms** | 103.333 ms (246% slower) | 296.272 ms (892% slower) | ➖                        |
| SHA-512/224   | **29.926 ms** | 103.765 ms (247% slower) | ➖                       | ➖                        |
| SHA-512/256   | **29.923 ms** | 103.48 ms (246% slower)  | ➖                       | ➖                        |
| SHA3-256      | **48.624 ms** | ➖                       | ➖                       | 212.428 ms (337% slower)  |
| SHA3-512      | **30.132 ms** | ➖                       | ➖                       | 334.513 ms (1010% slower) |
| HMAC(MD5)     | **23.125 ms** | 40.56 ms (75% slower)    | 70.362 ms (204% slower)  | ➖                        |
| HMAC(SHA-256) | **48.835 ms** | 61.045 ms (25% slower)   | ➖                       | ➖                        |
