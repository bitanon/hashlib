# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/librariesio/release/pub/hashlib?label=dependencies)](https://github.com/dipu-bd/hashlib/-/blob/master/pubspec.yaml)
[![Dart](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml)

This library contains RFC-compliant implementations of secure hash functions in pure Dart with zero-dependencies.

## Features

### Secure hash functions:

| Algorithms               | Supported | Since |
| ------------------------ | :-------: | :---: |
| `md5`                    |    ✔️     | 1.0.0 |
| `sha1`                   |    ✔️     | 1.0.0 |
| `sha224`                 |    ✔️     | 1.0.0 |
| `sha256`                 |    ✔️     | 1.0.0 |
| `sha384`                 |    ⌛     |       |
| `sha512`                 |    ⌛     |       |
| `sha512_224`             |    ⌛     |       |
| `sha512_256`             |    ⌛     |       |
| `blake2b`                |    ⌛     |       |
| `blake2s`                |    ⌛     |       |
| `blake3`                 |    ⌛     |       |
| `sha3_224` / `keccak224` |    ⌛     |       |
| `sha3_256` / `keccak256` |    ⌛     |       |
| `sha3_384` / `keccak384` |    ⌛     |       |
| `sha3_512` / `keccak512` |    ⌛     |       |
| `shake128` / `keccak256` |    ⌛     |       |
| `shake256` / `keccak512` |    ⌛     |       |

<!--
### Password hashing / Key derivation functions:

| Algorithms    | Supported | Since |
| ------------- | :-------: | :---: |
| `pbkdf2_hmac` |    ⌛     |       |
| `argon2i`     |    ⌛     |       |
| `argon2d`     |    ⌛     |       |
| `argon2id`    |    ⌛     |       |
| `bcrypt`      |    ⌛     |       |
| `scrypt`      |    ⌛     |       |
| `balloon`     |    ⌛     |       |

### Cyclic redundancy checks:

| Algorithms | Supported | Since |
| ---------- | :-------: | :---: |
| `cksum`    |    ⌛     |       |
| `crc16`    |    ⌛     |       |
| `crc32`    |    ⌛     |       |
| `crc64`    |    ⌛     |       |

### Checksums:

| Algorithms | Supported | Since |
| ---------- | :-------: | :---: |
| `bsd`      |    ⌛     |       |
| `sysv`     |    ⌛     |       |
| `alder32`  |    ⌛     |       |

### Other Cryptographic hash functions:

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

| Algorithms |    Hashlib |  Crypto | Difference |
| ---------- | ---------: | ------: | :--------: |
| MD5        | **355 us** |  726 us |     ➖     |
| SHA-1      | **469 us** |  874 us |     ➖     |
| SHA-224    | **726 us** | 1131 us |     ➖     |
| SHA-256    | **729 us** | 1126 us |     ➖     |

With string of length 1777 (50 times):

| Algorithms |    Hashlib |     Crypto | Difference |
| ---------- | ---------: | ---------: | :--------: |
| MD5        | **413 us** |     524 us |     ➖     |
| SHA-1      | **575 us** |     674 us |     ➖     |
| SHA-224    |     931 us | **920 us** |   -11 us   |
| SHA-256    |     930 us | **922 us** |   -8 us    |

With string of length 77000 (2 times):

| Algorithms |    Hashlib |      Crypto | Difference |
| ---------- | ---------: | ----------: | :--------: |
| MD5        | **709 us** |      863 us |     ➖     |
| SHA-1      | **996 us** |     1109 us |     ➖     |
| SHA-224    |    1595 us | **1533 us** |   -62 us   |
| SHA-256    |    1585 us | **1531 us** |   -54 us   |
