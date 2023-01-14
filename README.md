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

<!--
### Password Hashing / Key Derivation

| Algorithms    | Supported | Since |
| ------------- | :-------: | :---: |
| `argon2d`     |    ⌛     |       |
| `argon2i`     |    ⌛     |       |
| `argon2id`    |    ⌛     |       |
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

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | -------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **37.448 ms**  | 99.724 ms <br> `166% slower`  | 136.218 ms <br> `264% slower` | 90.014 ms <br> `140% slower`    | ➖                            |
| SHA-1         | **62.889 ms**  | 118.287 ms <br> `88% slower`  | 204.516 ms <br> `225% slower` | 137.185 ms <br> `118% slower`   | ➖                            |
| SHA-224       | **82.708 ms**  | 135.191 ms <br> `63% slower`  | 386.756 ms <br> `368% slower` | 317.11 ms <br> `283% slower`    | ➖                            |
| SHA-256       | **83.224 ms**  | 135.272 ms <br> `63% slower`  | 375.568 ms <br> `351% slower` | 315.419 ms <br> `279% slower`   | ➖                            |
| SHA-384       | **106.081 ms** | 339.157 ms <br> `220% slower` | 744.32 ms <br> `602% slower`  | 2625.653 ms <br> `2375% slower` | ➖                            |
| SHA-512       | **106.95 ms**  | 342.052 ms <br> `220% slower` | 714.804 ms <br> `568% slower` | 2637.157 ms <br> `2366% slower` | ➖                            |
| SHA-512/224   | **104.302 ms** | 335.923 ms <br> `222% slower` | ➖                            | 5195.99 ms <br> `4882% slower`  | ➖                            |
| SHA-512/256   | **104.356 ms** | 335.103 ms <br> `221% slower` | ➖                            | 5192.926 ms <br> `4876% slower` | ➖                            |
| SHA3-256      | **82.621 ms**  | ➖                            | ➖                            | 4396.641 ms <br> `5221% slower` | 407.845 ms <br> `394% slower` |
| SHA3-512      | **106.798 ms** | ➖                            | ➖                            | 4391.363 ms <br> `4012% slower` | 407.664 ms <br> `282% slower` |
| BLAKE-2s      | **65.554 ms**  | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **73.147 ms**  | ➖                            | ➖                            | 1143.823 ms <br> `1464% slower` | ➖                            |
| HMAC(MD5)     | **231.861 ms** | 267.041 ms <br> `15% slower`  | 509.741 ms <br> `120% slower` | ➖                              | ➖                            |
| HMAC(SHA-256) | **545.099 ms** | 622.546 ms <br> `14% slower`  | ➖                            | ➖                              | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **30.976 ms** | 42.134 ms <br> `36% slower`   | 54.537 ms <br> `76% slower`   | 60.695 ms <br> `96% slower`     | ➖                            |
| SHA-1         | **34.96 ms**  | 54.001 ms <br> `54% slower`   | 104.977 ms <br> `200% slower` | 91.316 ms <br> `161% slower`    | ➖                            |
| SHA-224       | **51.497 ms** | 61.656 ms <br> `20% slower`   | 240.458 ms <br> `367% slower` | 233.668 ms <br> `354% slower`   | ➖                            |
| SHA-256       | **51.947 ms** | 61.594 ms <br> `19% slower`   | 237.967 ms <br> `358% slower` | 232.312 ms <br> `347% slower`   | ➖                            |
| SHA-384       | **35.063 ms** | 107.759 ms <br> `207% slower` | 236.312 ms <br> `574% slower` | 1006.556 ms <br> `2771% slower` | ➖                            |
| SHA-512       | **34.557 ms** | 107.359 ms <br> `211% slower` | 234.373 ms <br> `578% slower` | 1011.268 ms <br> `2826% slower` | ➖                            |
| SHA-512/224   | **34.614 ms** | 107.133 ms <br> `210% slower` | ➖                            | 1130.86 ms <br> `3167% slower`  | ➖                            |
| SHA-512/256   | **34.513 ms** | 106.872 ms <br> `210% slower` | ➖                            | 1129.151 ms <br> `3172% slower` | ➖                            |
| SHA3-256      | **52.012 ms** | ➖                            | ➖                            | 1679.069 ms <br> `3128% slower` | 226.4 ms <br> `335% slower`   |
| SHA3-512      | **34.777 ms** | ➖                            | ➖                            | 2930.05 ms <br> `8325% slower`  | 336.198 ms <br> `867% slower` |
| BLAKE-2s      | **36.649 ms** | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **24.342 ms** | ➖                            | ➖                            | 412.321 ms <br> `1594% slower`  | ➖                            |
| HMAC(MD5)     | **40.465 ms** | 51.914 ms <br> `28% slower`   | 73.211 ms <br> `81% slower`   | ➖                              | ➖                            |
| HMAC(SHA-256) | **74.768 ms** | 87.488 ms <br> `17% slower`   | ➖                            | ➖                              | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **29.872 ms** | 40.633 ms <br> `36% slower`   | 70.021 ms <br> `134% slower`  | 57.744 ms <br> `93% slower`     | ➖                            |
| SHA-1         | **32.407 ms** | 52.164 ms <br> `61% slower`   | 118.789 ms <br> `267% slower` | 87.177 ms <br> `169% slower`    | ➖                            |
| SHA-224       | **48.625 ms** | 59.259 ms <br> `22% slower`   | 248.668 ms <br> `411% slower` | 226.517 ms <br> `366% slower`   | ➖                            |
| SHA-256       | **48.786 ms** | 59.439 ms <br> `22% slower`   | 249.149 ms <br> `411% slower` | 225.049 ms <br> `361% slower`   | ➖                            |
| SHA-384       | **30.729 ms** | 102.777 ms <br> `234% slower` | 282.807 ms <br> `820% slower` | 974.133 ms <br> `3070% slower`  | ➖                            |
| SHA-512       | **30.774 ms** | 102.945 ms <br> `235% slower` | 283.705 ms <br> `822% slower` | 973.638 ms <br> `3064% slower`  | ➖                            |
| SHA-512/224   | **30.771 ms** | 103.28 ms <br> `236% slower`  | ➖                            | 976.078 ms <br> `3072% slower`  | ➖                            |
| SHA-512/256   | **30.814 ms** | 102.666 ms <br> `233% slower` | ➖                            | 974.959 ms <br> `3064% slower`  | ➖                            |
| SHA3-256      | **48.575 ms** | ➖                            | ➖                            | 1535.807 ms <br> `3062% slower` | 213.54 ms <br> `340% slower`  |
| SHA3-512      | **30.971 ms** | ➖                            | ➖                            | 2893.653 ms <br> `9243% slower` | 333.166 ms <br> `976% slower` |
| BLAKE-2s      | **34.646 ms** | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **22.729 ms** | ➖                            | ➖                            | 395.993 ms <br> `1642% slower`  | ➖                            |
| HMAC(MD5)     | **30.067 ms** | 40.611 ms <br> `35% slower`   | 70.045 ms <br> `133% slower`  | ➖                              | ➖                            |
| HMAC(SHA-256) | **48.869 ms** | 59.274 ms <br> `21% slower`   | ➖                            | ➖                              | ➖                            |

> These benchmarks were done in _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_ on Windows 10
