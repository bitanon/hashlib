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
| `sha0`                   |    ⌛     |       |
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

<!--
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
  final md5 = hashlib.md5("Hello World");
  print('MD5[Hello World] => $md5');
}
```

<!-- ## Benchmarks

TBD -->
