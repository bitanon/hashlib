# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/badge/dependencies-zero-889)](https://github.com/dipu-bd/hashlib/blob/master/pubspec.yaml)
[![dart support](https://img.shields.io/badge/dart-%3e%3d%202.14.0-39f?logo=dart)](https://dart.dev/guides/whats-new#september-8-2021-214-release)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![test](https://github.com/dipu-bd/hashlib/actions/workflows/test.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/test.yml)

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
| `blake3`     |   ⌛    |        |
| `ripemd128` |    ⌛     |       |
| `ripemd160` |    ⌛     |       |
| `ripemd320` |    ⌛     |       |
| `whirlpool` |    ⌛     |       |
-->

### Password Hashing / Key Derivation

| Algorithm | Available Methods                | Source   |
| --------- | -------------------------------- | -------- |
| Argon2    | `argon2d`, `argon2i`, `argon2id` | RFC-9106 |

<!--
| `pbkdf2_hmac` |    ⌛     |       |
| `bcrypt`      |    ⌛     |       |
| `scrypt`      |    ⌛     |       |
| `balloon`     |    ⌛     |       |
-->

### Message Authentication Code (MAC) generators

| Algorithms | Available Methods | Source   |
| ---------- | ----------------- | -------- |
| HMAC       | `hmac`            | RFC-2104 |

<!-- | `poly1305` |   ⌛    |        |  ⌛  |        | -->

### Checksum Algorithms

| Algorithms | Available Methods       | Source    |
| ---------- | ----------------------- | --------- |
| Alder32    | `alder32`               | Wikipedia |
| CRC        | `crc16`,`crc32`,`crc64` | Wikipedia |

## Getting Started

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
  var text = "Happy Hashing!";
  print('[CRC32] $text => ${crc32code(text)}');
  print('[CRC64] $text => ${crc64code(text)}');
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
  print('[BLAKE-2b/512] $text => ${blake2b512.string(text)}');
  print('');

  // Example of HMAC generation
  var key = "secret";
  print('HMAC[MD5] $text => ${md5.hmacBy(key).string(text)}');
  print('HMAC[SHA-1] $text => ${sha1.hmacBy(key).string(text)}');
  print('HMAC[SHA-256] $text => ${sha256.hmacBy(key).string(text)}');
  print('');

  // Example of Argon2 Password Hashing
  print("Argon2id encoded: ${argon2id(
    "password".codeUnits,
    "some salt".codeUnits,
    security: Argon2Security.small,
    hashLength: 16,
  ).encoded()}");
}
```

## Benchmarks

To obtain the following benchmarks, run this command:

```sh
dart compile exe ./benchmark/benchmark.dart && ./benchmark/benchmark.exe
```

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | -------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **35.353 ms**  | 99.184 ms <br> `181% slower`  | 132.232 ms <br> `274% slower` | 84.348 ms <br> `139% slower`    | ➖                            |
| SHA-1         | **60.984 ms**  | 115.06 ms <br> `89% slower`   | 204.618 ms <br> `236% slower` | 132.707 ms <br> `118% slower`   | ➖                            |
| SHA-224       | **82.921 ms**  | 137.013 ms <br> `65% slower`  | 376.467 ms <br> `354% slower` | 317.903 ms <br> `283% slower`   | ➖                            |
| SHA-256       | **82.724 ms**  | 135.03 ms <br> `63% slower`   | 375.416 ms <br> `354% slower` | 318.855 ms <br> `285% slower`   | ➖                            |
| SHA-384       | **103.835 ms** | 344.046 ms <br> `231% slower` | 722.537 ms <br> `596% slower` | 2601.015 ms <br> `2405% slower` | ➖                            |
| SHA-512       | **103.755 ms** | 346.637 ms <br> `234% slower` | 713.643 ms <br> `588% slower` | 2627.374 ms <br> `2432% slower` | ➖                            |
| SHA-512/224   | **102.017 ms** | 342.321 ms <br> `236% slower` | ➖                            | 5106.248 ms <br> `4905% slower` | ➖                            |
| SHA-512/256   | **102.386 ms** | 341.22 ms <br> `233% slower`  | ➖                            | 5096.226 ms <br> `4877% slower` | ➖                            |
| SHA3-256      | **82.077 ms**  | ➖                            | ➖                            | 4472.259 ms <br> `5349% slower` | 408.232 ms <br> `397% slower` |
| SHA3-512      | **103.6 ms**   | ➖                            | ➖                            | 4481.2 ms <br> `4225% slower`   | 408.795 ms <br> `295% slower` |
| BLAKE-2s      | **62.667 ms**  | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **81.948 ms**  | ➖                            | ➖                            | 1144.464 ms <br> `1297% slower` | ➖                            |
| HMAC(MD5)     | **213.07 ms**  | 266.102 ms <br> `25% slower`  | 498.219 ms <br> `134% slower` | ➖                              | ➖                            |
| HMAC(SHA-256) | **535.764 ms** | 624.437 ms <br> `17% slower`  | ➖                            | ➖                              | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **31.268 ms** | 41.928 ms <br> `34% slower`   | 52.334 ms <br> `67% slower`   | 60.301 ms <br> `93% slower`     | ➖                            |
| SHA-1         | **36.819 ms** | 53.565 ms <br> `45% slower`   | 105.095 ms <br> `185% slower` | 89.969 ms <br> `144% slower`    | ➖                            |
| SHA-224       | **52.821 ms** | 63.124 ms <br> `20% slower`   | 238.791 ms <br> `352% slower` | 237.553 ms <br> `350% slower`   | ➖                            |
| SHA-256       | **52.85 ms**  | 62.812 ms <br> `19% slower`   | 238.127 ms <br> `351% slower` | 236.949 ms <br> `348% slower`   | ➖                            |
| SHA-384       | **34.541 ms** | 107.518 ms <br> `211% slower` | 257.815 ms <br> `646% slower` | 1000.244 ms <br> `2796% slower` | ➖                            |
| SHA-512       | **33.865 ms** | 107.616 ms <br> `218% slower` | 233.219 ms <br> `589% slower` | 999.335 ms <br> `2851% slower`  | ➖                            |
| SHA-512/224   | **33.684 ms** | 109.742 ms <br> `226% slower` | ➖                            | 1123.899 ms <br> `3237% slower` | ➖                            |
| SHA-512/256   | **34.84 ms**  | 109.424 ms <br> `214% slower` | ➖                            | 1143.562 ms <br> `3182% slower` | ➖                            |
| SHA3-256      | **54.081 ms** | ➖                            | ➖                            | 1721.936 ms <br> `3084% slower` | 230.092 ms <br> `325% slower` |
| SHA3-512      | **34.698 ms** | ➖                            | ➖                            | 3002.732 ms <br> `8554% slower` | 337.325 ms <br> `872% slower` |
| BLAKE-2s      | **36.763 ms** | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **25.799 ms** | ➖                            | ➖                            | 409.533 ms <br> `1487% slower`  | ➖                            |
| HMAC(MD5)     | **40.644 ms** | 53.016 ms <br> `30% slower`   | 70.384 ms <br> `73% slower`   | ➖                              | ➖                            |
| HMAC(SHA-256) | **74.654 ms** | 91.42 ms <br> `22% slower`    | ➖                            | ➖                              | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **30.376 ms** | 40.509 ms <br> `33% slower`   | 69.67 ms <br> `129% slower`   | 57.96 ms <br> `91% slower`      | ➖                            |
| SHA-1         | **33.523 ms** | 51.793 ms <br> `54% slower`   | 120.908 ms <br> `261% slower` | 86.113 ms <br> `157% slower`    | ➖                            |
| SHA-224       | **50.253 ms** | 60.678 ms <br> `21% slower`   | 249.619 ms <br> `397% slower` | 230.563 ms <br> `359% slower`   | ➖                            |
| SHA-256       | **50.344 ms** | 60.738 ms <br> `21% slower`   | 249.453 ms <br> `395% slower` | 229.371 ms <br> `356% slower`   | ➖                            |
| SHA-384       | **31.777 ms** | 103.155 ms <br> `225% slower` | 280.01 ms <br> `781% slower`  | 968.057 ms <br> `2946% slower`  | ➖                            |
| SHA-512       | **31.718 ms** | 103.332 ms <br> `226% slower` | 279.144 ms <br> `780% slower` | 969.389 ms <br> `2956% slower`  | ➖                            |
| SHA-512/224   | **31.656 ms** | 102.954 ms <br> `225% slower` | ➖                            | 970.759 ms <br> `2967% slower`  | ➖                            |
| SHA-512/256   | **32.011 ms** | 103.348 ms <br> `223% slower` | ➖                            | 968.022 ms <br> `2924% slower`  | ➖                            |
| SHA3-256      | **50.22 ms**  | ➖                            | ➖                            | 1560.669 ms <br> `3008% slower` | 212.792 ms <br> `324% slower` |
| SHA3-512      | **31.7 ms**   | ➖                            | ➖                            | 2932.904 ms <br> `9152% slower` | 334.856 ms <br> `956% slower` |
| BLAKE-2s      | **34.788 ms** | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **23.761 ms** | ➖                            | ➖                            | 393.928 ms <br> `1558% slower`  | ➖                            |
| HMAC(MD5)     | **31.094 ms** | 42.317 ms <br> `36% slower`   | 69.942 ms <br> `125% slower`  | ➖                              | ➖                            |
| HMAC(SHA-256) | **50.258 ms** | 62.296 ms <br> `24% slower`   | ➖                            | ➖                              | ➖                            |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | small    | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.708 ms | 4.391 ms | 26.042 ms | 253.649 ms | 2820.983 ms |
| argon2d    | 0.319 ms | 3.112 ms | 28.06 ms  | 247.545 ms | 2791.431 ms |
| argon2id   | 0.324 ms | 3.167 ms | 20.008 ms | 250.295 ms | 2837.003 ms |

> These benchmarks were done in _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_ on Windows 10
