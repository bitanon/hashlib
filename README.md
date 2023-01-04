# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/librariesio/release/pub/hashlib?label=dependencies)](https://github.com/dipu-bd/hashlib/-/blob/master/pubspec.yaml)
[![Dart](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml)

This library contains some implementation of popular hashing algorithms in pure Dart inspired by Python's [hashlib](https://docs.python.org/3/library/hashlib.html) interface.

## Features

| Algorithms    | Supported | Since |
| ------------- | :-------: | :---: |
| `md5`         |    ✔️     | 1.0.0 |
| `sha1`        |    ⌛     |       |
| `sha224`      |    ⌛     |       |
| `sha256`      |    ⌛     |       |
| `sha384`      |    ⌛     |       |
| `sha512`      |    ⌛     |       |
| `blake2b`     |    ⌛     |       |
| `blake2s`     |    ⌛     |       |
| `sha3_224`    |    ⌛     |       |
| `sha3_256`    |    ⌛     |       |
| `sha3_384`    |    ⌛     |       |
| `sha3_512`    |    ⌛     |       |
| `shake_128`   |    ⌛     |       |
| `shake_256`   |    ⌛     |       |
| `pbkdf2_hmac` |    ⌛     |       |

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
