# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/librariesio/release/pub/hashlib?label=dependencies)](https://github.com/dipu-bd/hashlib/-/blob/master/pubspec.yaml)
[![Dart](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml)

This library contains RFC-compliant implementations of secure hash functions in pure Dart with zero-dependencies.

## Features

### Secure hash functions

| Algorithms               | Supported | Since |
| ------------------------ | :-------: | :---: |
| `md5`                    |    ✔️     | 1.0.0 |
| `sha1`                   |    ✔️     | 1.0.0 |
| `sha224`                 |    ✔️     | 1.0.0 |
| `sha256`                 |    ✔️     | 1.0.0 |
| `sha384`                 |    ✔️     | 1.0.0 |
| `sha512`                 |    ✔️     | 1.0.0 |
| `sha512_224`             |    ✔️     | 1.0.0 |
| `sha512_256`             |    ✔️     | 1.0.0 |
| `sha3_224` / `keccak224` |    ⌛     |       |
| `sha3_256` / `keccak256` |    ⌛     |       |
| `sha3_384` / `keccak384` |    ⌛     |       |
| `sha3_512` / `keccak512` |    ⌛     |       |
| `shake128` / `keccak256` |    ⌛     |       |
| `shake256` / `keccak512` |    ⌛     |       |
| `blake2b`                |    ⌛     |       |
| `blake2s`                |    ⌛     |       |
| `blake3`                 |    ⌛     |       |

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
import 'package:hashlib/hashlib.dart' as hashlib;

void main() {
  final text = "Happy Hashing!";
  print('[MD5] $text => ${hashlib.md5sum(text)}');
  print('[SHA-1] $text => ${hashlib.sha1sum(text)}');
  print('[SHA-224] $text => ${hashlib.sha224sum(text)}');
  print('[SHA-256] $text => ${hashlib.sha256sum(text)}');
  print('[SHA-384] $text => ${hashlib.sha384sum(text)}');
  print('[SHA-512] $text => ${hashlib.sha512sum(text)}');
  print('[SHA-512/224] $text => ${hashlib.sha512224sum(text)}');
  print('[SHA-512/256] $text => ${hashlib.sha512256sum(text)}');
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

With string of length 17 (1000 times):

| Algorithms  |  `hashlib` | `crypto` |  Comment   |
| ----------- | ---------: | -------: | :--------: |
| MD5         | **369 us** |   764 us | 52% faster |
| SHA-1       | **489 us** |   915 us | 47% faster |
| SHA-224     | **764 us** |  1167 us | 35% faster |
| SHA-256     | **786 us** |  1155 us | 32% faster |
| SHA-384     | **758 us** |  1719 us | 56% faster |
| SHA-512     | **765 us** |  1710 us | 55% faster |
| SHA-512/224 | **741 us** |  1685 us | 56% faster |
| SHA-512/256 | **756 us** |  1690 us | 55% faster |

With string of length 1777 (50 times):

| Algorithms  |  `hashlib` |   `crypto` |  Comment   |
| ----------- | ---------: | ---------: | :--------: |
| MD5         | **428 us** |     541 us | 21% faster |
| SHA-1       | **594 us** |     686 us | 13% faster |
| SHA-224     |     965 us | **923 us** | 5% slower  |
| SHA-256     |     965 us | **922 us** | 5% slower  |
| SHA-384     | **505 us** |     727 us | 31% faster |
| SHA-512     | **505 us** |     732 us | 31% faster |
| SHA-512/224 | **516 us** |     737 us | 30% faster |
| SHA-512/256 | **516 us** |     741 us | 30% faster |

With string of length 177000 (1 times):

| Algorithms  |   `hashlib` |    `crypto` |  Comment   |
| ----------- | ----------: | ----------: | :--------: |
| MD5         |  **840 us** |     1010 us | 17% faster |
| SHA-1       | **1177 us** |     1320 us | 11% faster |
| SHA-224     |     1914 us | **1826 us** | 5% slower  |
| SHA-256     |     1909 us | **1773 us** | 8% slower  |
| SHA-384     |  **929 us** |     1278 us | 27% faster |
| SHA-512     |  **942 us** |     1234 us | 24% faster |
| SHA-512/224 |  **933 us** |     1237 us | 25% faster |
| SHA-512/256 |  **947 us** |     1236 us | 23% faster |
