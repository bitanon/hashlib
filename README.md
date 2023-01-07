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

| Algorithms  |    Hashlib |  Crypto | Difference |
| ----------- | ---------: | ------: | :--------: |
| MD5         | **366 us** |  755 us |     ➖     |
| SHA-1       | **483 us** |  910 us |     ➖     |
| SHA-224     | **751 us** | 1192 us |     ➖     |
| SHA-256     | **757 us** | 1167 us |     ➖     |
| SHA-384     | **764 us** | 1697 us |     ➖     |
| SHA-512     | **759 us** | 1750 us |     ➖     |
| SHA-512/224 | **744 us** | 1699 us |     ➖     |
| SHA-512/256 | **763 us** | 1689 us |     ➖     |

With string of length 1777 (50 times):

| Algorithms  |    Hashlib |     Crypto | Difference |
| ----------- | ---------: | ---------: | :--------: |
| MD5         | **434 us** |     550 us |     ➖     |
| SHA-1       | **604 us** |     690 us |     ➖     |
| SHA-224     |     930 us | **923 us** |    7 us    |
| SHA-256     |     933 us | **925 us** |    8 us    |
| SHA-384     | **512 us** |     742 us |     ➖     |
| SHA-512     | **512 us** |     742 us |     ➖     |
| SHA-512/224 | **513 us** |     739 us |     ➖     |
| SHA-512/256 | **516 us** |     740 us |     ➖     |

With string of length 77000 (2 times):

| Algorithms  |     Hashlib |      Crypto | Difference |
| ----------- | ----------: | ----------: | :--------: |
| MD5         |  **733 us** |      910 us |     ➖     |
| SHA-1       | **1032 us** |     1130 us |     ➖     |
| SHA-224     |     1598 us | **1523 us** |   75 us    |
| SHA-256     |     1575 us | **1540 us** |   35 us    |
| SHA-384     |  **814 us** |     1097 us |     ➖     |
| SHA-512     |  **811 us** |     1132 us |     ➖     |
| SHA-512/224 |  **817 us** |     1118 us |     ➖     |
| SHA-512/256 |  **821 us** |     1102 us |     ➖     |
