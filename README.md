# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/librariesio/release/pub/hashlib?label=dependencies)](https://github.com/dipu-bd/hashlib/-/blob/master/pubspec.yaml)
[![Dart](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml)

This library contains RFC-compliant implementations of secure hash functions in pure Dart with zero-dependencies.

## Features

### Secure hash functions

| Algorithms   | (Native | Since) | (Web | Since) |
| ------------ | :-----: | :----: | :--: | :----: |
| `md5`        |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha1`       |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha224`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha256`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |
| `sha384`     |   ✔️    | 1.0.0  |  ⌛  |        |
| `sha512`     |   ✔️    | 1.0.0  |  ⌛  |        |
| `sha512_224` |   ✔️    | 1.0.0  |  ⌛  |        |
| `sha512_256` |   ✔️    | 1.0.0  |  ⌛  |        |

<!--
| `sha3_224` / `keccak224` |    ⌛     |       |
| `sha3_256` / `keccak256` |    ⌛     |       |
| `sha3_384` / `keccak384` |    ⌛     |       |
| `sha3_512` / `keccak512` |    ⌛     |       |
| `shake128` / `keccak256` |    ⌛     |       |
| `shake256` / `keccak512` |    ⌛     |       |
| `blake2b`                |    ⌛     |       |
| `blake2s`                |    ⌛     |       |
| `blake3`                 |    ⌛     |       |

### MAC generation

| Algorithms | Supported | Since |
| ---------- | :-------: | :---: |
| `hmac`     |    ⌛     |       |
| `poly1305` |    ⌛     |       |

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
- **Hash** : https://pub.dev/packages/hash

With string of length 17 (1000 iterations):

| Algorithms  | `hashlib`  | `crypto`              | `hash`                |
| ----------- | ---------- | --------------------- | --------------------- |
| MD5         | **346 us** | 758 us (119% slower)  | 902 us (161% slower)  |
| SHA-1       | **497 us** | 912 us (84% slower)   | 1443 us (190% slower) |
| SHA-224     | **756 us** | 1178 us (56% slower)  | 1345 us (78% slower)  |
| SHA-256     | **757 us** | 1158 us (53% slower)  | 1370 us (81% slower)  |
| SHA-384     | **739 us** | 1701 us (130% slower) | 3613 us (389% slower) |
| SHA-512     | **749 us** | 1715 us (129% slower) | 3668 us (390% slower) |
| SHA-512/224 | **755 us** | 1681 us (123% slower) | ➖                    |
| SHA-512/256 | **782 us** | 1710 us (119% slower) | ➖                    |

With string of length 1777 (50 iterations):

| Algorithms  | `hashlib`  | `crypto`            | `hash`                |
| ----------- | ---------- | ------------------- | --------------------- |
| MD5         | **284 us** | 534 us (88% slower) | 752 us (165% slower)  |
| SHA-1       | **465 us** | 684 us (47% slower) | 1402 us (202% slower) |
| SHA-224     | **816 us** | 923 us (13% slower) | 1257 us (54% slower)  |
| SHA-256     | **816 us** | 923 us (13% slower) | 1254 us (54% slower)  |
| SHA-384     | **376 us** | 722 us (92% slower) | 2115 us (463% slower) |
| SHA-512     | **378 us** | 735 us (94% slower) | 2141 us (466% slower) |
| SHA-512/224 | **381 us** | 735 us (93% slower) | ➖                    |
| SHA-512/256 | **377 us** | 725 us (92% slower) | ➖                    |

With string of length 177000 (2 iterations):

| Algorithms  | `hashlib`   | `crypto`             | `hash`                |
| ----------- | ----------- | -------------------- | --------------------- |
| MD5         | **1104 us** | 2016 us (83% slower) | 4529 us (310% slower) |
| SHA-1       | **1830 us** | 2585 us (41% slower) | 6913 us (278% slower) |
| SHA-224     | **3206 us** | 3523 us (10% slower) | 6306 us (97% slower)  |
| SHA-256     | **3199 us** | 3524 us (10% slower) | 6324 us (98% slower)  |
| SHA-384     | **1290 us** | 2446 us (90% slower) | 9042 us (601% slower) |
| SHA-512     | **1289 us** | 2458 us (91% slower) | 9038 us (601% slower) |
| SHA-512/224 | **1288 us** | 2463 us (91% slower) | ➖                    |
| SHA-512/256 | **1289 us** | 2447 us (90% slower) | ➖                    |
