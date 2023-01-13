# hashlib

[![build](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/dart.yml)
[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)

This library contains implementations of secure hash functions, checksum generators, and key derivation algorithms optimized for Dart.

## Features

### Secure Hash Functions

| Algorithm | Available Methods                                                   | Source      |
| --------- | ------------------------------------------------------------------- | ----------- |
| MD5       | `md5`                                                               | RFC-1321    |
| SHA-1     | `sha1`                                                              | RFC-3174    |
| SHA-2     | `sha224`,`sha256`,`sha384`,`sha512`, `sha512t224`, `sha512t256`     | RCC-6234    |
| SHA-3     | `sha3_224`,`sha3_256`,`sha3_384`,`sha3_512`, `shake128`, `shake256` | FIPS-202    |
| Keccak    | `keccak224`,`keccak256`,`keccak384`,`keccak512`                     | Team Keccak |
| Blake2b   | `blake2b160`,`blake2b256`,`blake2b384`, `blake2b512`                | RFC-7693    |
| Blake2s   | `blake2s128`,`blake2s160`,`blake2s224`,`blake2s256`                 | RFC-7693    |

<!--
| `blake3`     |   ⌛    |        |  ⌛  |        |
| `ripemd128` |    ⌛     |       |
| `ripemd160` |    ⌛     |       |
| `ripemd320` |    ⌛     |       |
| `whirlpool` |    ⌛     |       |
-->

### Message Authentication Code (MAC) Generators

| Algorithms | (Native | Since) | (Web | Since) |
| ---------- | :-----: | :----: | :--: | :----: |
| `hmac`     |   ✔️    | 1.0.0  |  ✔️  | 1.0.0  |

<!-- | `poly1305` |   ⌛    |        |  ⌛  |        | -->

### Checksums Algorithms

| Algorithms | Available Methods       |
| ---------- | ----------------------- | --------- |
| Alder32    | `alder32`               | Wikipedia |
| CRC        | `crc16`,`crc32`,`crc64` | Wikipedia |

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

```sh
dart run ./benchmark/benchmark.dart
```

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                         | `PointyCastle`                  | `sha3`                        |
| ------------- | -------------- | ----------------------------- | ------------------------------ | ------------------------------- | ----------------------------- |
| MD5           | **42.276 ms**  | 93.323 ms <br> `121% slower`  | 196.541 ms <br> `365% slower`  | 134.664 ms <br> `219% slower`   | ➖                            |
| SHA-1         | **70.194 ms**  | 108.909 ms <br> `55% slower`  | 257.306 ms <br> `267% slower`  | 149.935 ms <br> `114% slower`   | ➖                            |
| SHA-224       | **89.61 ms**   | 131.638 ms <br> `47% slower`  | 444.125 ms <br> `396% slower`  | 342.773 ms <br> `283% slower`   | ➖                            |
| SHA-256       | **89.447 ms**  | 131.85 ms <br> `47% slower`   | 445.699 ms <br> `398% slower`  | 347.406 ms <br> `288% slower`   | ➖                            |
| SHA-384       | **103.699 ms** | 289.271 ms <br> `179% slower` | 1062.919 ms <br> `925% slower` | 2342.641 ms <br> `2159% slower` | ➖                            |
| SHA-512       | **103.754 ms** | 290.572 ms <br> `180% slower` | 1066.844 ms <br> `928% slower` | 2344.139 ms <br> `2159% slower` | ➖                            |
| SHA-512/224   | **101.674 ms** | 286.771 ms <br> `182% slower` | ➖                             | 4501.391 ms <br> `4327% slower` | ➖                            |
| SHA-512/256   | **102.228 ms** | 286.739 ms <br> `180% slower` | ➖                             | 4498.623 ms <br> `4301% slower` | ➖                            |
| SHA3-256      | **89.147 ms**  | ➖                            | ➖                             | 4535.083 ms <br> `4987% slower` | 400.67 ms <br> `349% slower`  |
| SHA3-512      | **103.919 ms** | ➖                            | ➖                             | 4512.838 ms <br> `4243% slower` | 399.102 ms <br> `284% slower` |
| BLAKE-2s      | **61.892 ms**  | ➖                            | ➖                             | ➖                              | ➖                            |
| BLAKE-2b      | **62.643 ms**  | ➖                            | ➖                             | 1086.441 ms <br> `1634% slower` | ➖                            |
| HMAC(MD5)     | **223.08 ms**  | 258.091 ms <br> `16% slower`  | 696.94 ms <br> `212% slower`   | ➖                              | ➖                            |
| HMAC(SHA-256) | **585.78 ms**  | 654.331 ms <br> `12% slower`  | ➖                             | ➖                              | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ---------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **36.01 ms**  | 39.858 ms <br> `11% slower`  | 72.474 ms <br> `101% slower`  | 104.904 ms <br> `191% slower`   | ➖                            |
| SHA-1         | **43.245 ms** | 50.977 ms <br> `18% slower`  | 117.81 ms <br> `172% slower`  | 109.037 ms <br> `152% slower`   | ➖                            |
| SHA-224       | **58.281 ms** | 65.112 ms <br> `12% slower`  | 261.982 ms <br> `350% slower` | 261.985 ms <br> `350% slower`   | ➖                            |
| SHA-256       | **57.941 ms** | 65.011 ms <br> `12% slower`  | 259.712 ms <br> `348% slower` | 259.007 ms <br> `347% slower`   | ➖                            |
| SHA-384       | **32.632 ms** | 88.778 ms <br> `172% slower` | 353.296 ms <br> `983% slower` | 885.859 ms <br> `2615% slower`  | ➖                            |
| SHA-512       | **32.491 ms** | 89.023 ms <br> `174% slower` | 353.802 ms <br> `989% slower` | 884.92 ms <br> `2624% slower`   | ➖                            |
| SHA-512/224   | **32.363 ms** | 88.61 ms <br> `174% slower`  | ➖                            | 991.488 ms <br> `2964% slower`  | ➖                            |
| SHA-512/256   | **32.361 ms** | 88.525 ms <br> `174% slower` | ➖                            | 989.959 ms <br> `2959% slower`  | ➖                            |
| SHA3-256      | **57.67 ms**  | ➖                           | ➖                            | 1743.355 ms <br> `2923% slower` | 226.167 ms <br> `292% slower` |
| SHA3-512      | **32.586 ms** | ➖                           | ➖                            | 3041.517 ms <br> `9234% slower` | 334.749 ms <br> `927% slower` |
| BLAKE-2s      | **42.142 ms** | ➖                           | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **23.465 ms** | ➖                           | ➖                            | 380.297 ms <br> `1521% slower`  | ➖                            |
| HMAC(MD5)     | **45.388 ms** | 49.641 ms <br> `9% slower`   | 98.273 ms <br> `117% slower`  | ➖                              | ➖                            |
| HMAC(SHA-256) | **81.632 ms** | 92.378 ms <br> `13% slower`  | ➖                            | ➖                              | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                         | `PointyCastle`                   | `sha3`                         |
| ------------- | ------------- | ---------------------------- | ------------------------------ | -------------------------------- | ------------------------------ |
| MD5           | **35.057 ms** | 38.494 ms <br> `10% slower`  | 79.518 ms <br> `127% slower`   | 101.072 ms <br> `188% slower`    | ➖                             |
| SHA-1         | **41.346 ms** | 48.679 ms <br> `18% slower`  | 124.539 ms <br> `201% slower`  | 103.355 ms <br> `150% slower`    | ➖                             |
| SHA-224       | **53.93 ms**  | 62.588 ms <br> `16% slower`  | 260.972 ms <br> `384% slower`  | 251.336 ms <br> `366% slower`    | ➖                             |
| SHA-256       | **54.4 ms**   | 62.699 ms <br> `15% slower`  | 260.605 ms <br> `379% slower`  | 250.739 ms <br> `361% slower`    | ➖                             |
| SHA-384       | **28.829 ms** | 85.269 ms <br> `196% slower` | 352.308 ms <br> `1122% slower` | 861.306 ms <br> `2888% slower`   | ➖                             |
| SHA-512       | **28.842 ms** | 84.94 ms <br> `195% slower`  | 351.892 ms <br> `1120% slower` | 854.374 ms <br> `2862% slower`   | ➖                             |
| SHA-512/224   | **28.983 ms** | 85.248 ms <br> `194% slower` | ➖                             | 861.93 ms <br> `2874% slower`    | ➖                             |
| SHA-512/256   | **28.919 ms** | 85.894 ms <br> `197% slower` | ➖                             | 857.679 ms <br> `2866% slower`   | ➖                             |
| SHA3-256      | **54.634 ms** | ➖                           | ➖                             | 1617.128 ms <br> `2860% slower`  | 213.12 ms <br> `290% slower`   |
| SHA3-512      | **28.755 ms** | ➖                           | ➖                             | 3026.285 ms <br> `10424% slower` | 333.488 ms <br> `1060% slower` |
| BLAKE-2s      | **40.092 ms** | ➖                           | ➖                             | ➖                               | ➖                             |
| BLAKE-2b      | **22.359 ms** | ➖                           | ➖                             | 363.314 ms <br> `1525% slower`   | ➖                             |
| HMAC(MD5)     | **35.489 ms** | 38.657 ms <br> `9% slower`   | 82.969 ms <br> `134% slower`   | ➖                               | ➖                             |
| HMAC(SHA-256) | **54.019 ms** | 62.991 ms <br> `17% slower`  | ➖                             | ➖                               | ➖                             |

> These benchmarks were done in _Apple M1 Pro_
