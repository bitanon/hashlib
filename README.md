# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![test](https://github.com/bitanon/hashlib/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/bitanon/hashlib/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/bitanon/hashlib/graph/badge.svg?token=ISIYJ8MNI0)](https://codecov.io/gh/bitanon/hashlib)
[![dart support](https://img.shields.io/badge/dart-%3e%3d%202.19.0-39f?logo=dart)](https://dart.dev/guides/whats-new#may-11-2022-2-17-release)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![Pub Monthly Downloads](https://img.shields.io/pub/dm/hashlib)](https://pub.dev/packages/hashlib/score)

This library contains implementations of secure hash functions, checksum generators, and key derivation algorithms optimized for Dart.

## Depencencies

There is only 1 dependency used by this package:

- [hashlib_codecs](https://pub.dev/packages/hashlib_codecs)

## Features

### Block Hash Algorithms

| Algorithm   | Available methods                                                  |        Source        |
| ----------- | ------------------------------------------------------------------ | :------------------: |
| MD2         | `md2` , `md2sum`                                                   |       RFC-1319       |
| MD4         | `md4`, `md4sum`                                                    |       RFC-1320       |
| MD5         | `md5` , `md5sum`                                                   |       RFC-1321       |
| SHA-1       | `sha1` , `sha1sum`                                                 |       RFC-3174       |
| SHA-2       | `sha224`, `sha256`, `sha384`, `sha512`, `sha512t224`, `sha512t256` |       RFC-6234       |
| SHA-3       | `sha3_224`, `sha3_256`, `sha3_384`, `sha3_512`                     |       FIPS-202       |
| SHAKE-128   | `Shake128`, `shake128`, `shake128_128`, `shake128_256`             |       FIPS-202       |
| SHAKE-256   | `Shake256`, `shake256`, `shake256_256`, `shake256_512`             |       FIPS-202       |
| Keccak      | `keccak224`, `keccak256`, `keccak384`, `keccak512`                 |     Team Keccak      |
| Blake2b     | `blake2b160`, `blake2b256`, `blake2b384`, `blake2b512`             |       RFC-7693       |
| Blake2s     | `blake2s128`, `blake2s160`, `blake2s224`, `blake2s256`             |       RFC-7693       |
| xxHash-32   | `XXHash32`,`xxh32`,`xxh32code`                                     |       Cyan4973       |
| xxHash-64   | `XXHash64`,`xxh64`,`xxh64code`                                     |       Cyan4973       |
| xxHash3-64  | `XXH3`, `xxh3`, `xxh3code`                                         |       Cyan4973       |
| xxHash3-128 | `XXH128`, `xxh128`, `xxh128code`                                   |       Cyan4973       |
| RIPEMD      | `ripemd128`, `ripemd256`, `ripemd160`, `ripemd320`                 | ISO/IEC 10118-3:2018 |
| SM3         | `sm3` , `sm3sum`                                                   |   GB/T 32905-2016    |

### Password / Key Derivation Algorithms

| Algorithm | Available methods                                                | Source   |
| --------- | ---------------------------------------------------------------- | -------- |
| Argon2    | `Argon2`, `argon2d`, `argon2i`, `argon2id`, `argon2Verify`       | RFC-9106 |
| PBKDF2    | `PBKDF2`, `pbkdf2`, `#.pbkdf2`                                   | RFC-8081 |
| scrypt    | `Scrypt`, `scrypt`,                                              | RFC-7914 |
| bcrypt    | `Bcrypt`, `bcrypt`, `bcryptSalt`, `bcryptVerify`, `bcryptDigest` |          |

### Message Authentication Code (MAC) Generators

| Algorithms | Available methods                      | Source   |
| ---------- | -------------------------------------- | -------- |
| HMAC       | `HMAC`, `#.hmac`                       | RFC-2104 |
| Poly1305   | `Poly1305`, `poly1305`, `poly1305auth` | RFC-8439 |

### OTP generation for 2FA

| Algorithms | Available methods | Source   |
| ---------- | ----------------- | -------- |
| HOTP       | `HOTP`            | RFC-4226 |
| TOTP       | `TOTP`            | RFC-6238 |

### Other Hash Algorithms

| Algorithms | Available methods         | Source    |
| ---------- | ------------------------- | --------- |
| CRC        | `crc16`, `crc32`, `crc64` | Wikipedia |
| Alder32    | `alder32`                 | Wikipedia |

### Random Algorithm

#### Random number generators

Accessible through `HashlibRandom`:

- secure
- system
- keccak
- sha256
- md5
- xxh64
- sm3

#### UUID generators

Accessible through `uuid`

- v1
- v3
- v4
- v5
- v6
- v7
- v8

<!-- ## Demo

A demo application is available in Google Play Store featuring the capabilities of this package.

<a href='https://play.google.com/store/apps/details?id=io.bitanon.hashlib_demo&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' width="192px" /></a>

<a href='https://play.google.com/store/apps/details?id=io.bitanon.hashlib_demo&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt="demo app preview" src="https://raw.githubusercontent.com/bitanon/hashlib_demo/master/images/demo.gif" height="640px"/></a> -->

## Getting Started

The following import will give you access to all of the algorithms in this package.

```dart
import 'package:hashlib/hashlib.dart' as hashlib;
```

Check the [API Reference](https://pub.dev/documentation/hashlib/latest/) for details.

## Usage

Examples can be found inside the `example` folder.

### Hashilb Example

```dart
import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';

void main() {
  var text = "Happy Hashing!";
  print("text => $text");

  final key = "password";
  final salt = "some salt";
  print("key => $key");
  print("salt => $salt");
  print('');

  final pw = key.codeUnits;
  final iv = salt.codeUnits;

  // Example of hash-code generations
  print('XXH32 => ${xxh32code(text)}');
  print('CRC32 => ${crc32code(text)}');
  print('Alder32 => ${alder32code(text)}');
  print('CRC16 => ${crc16code(text)}');
  print('');

  // Examples of Hash generation
  print('CRC64 => ${crc64sum(text)}');
  print('XXH64 => ${xxh64sum(text)}');
  print('XXH3 => ${xxh3sum(text)}');
  print('XXH128 => ${xxh128sum(text)}');
  print('MD2 => ${md2.string(text)}');
  print('MD4 => ${md4.string(text)}');
  print('MD5 => ${md5.string(text)}');
  print('SHA-1 => ${sha1.string(text)}');
  print('SHA-224 => ${sha224.string(text)}');
  print('SHA-256 => ${sha256.string(text)}');
  print('SHA-384 => ${sha384.string(text)}');
  print('SHA-512 => ${sha512.string(text)}');
  print('SHA-512/224 => ${sha512t224.string(text)}');
  print('SHA-512/256 => ${sha512t256.string(text)}');
  print('SHA3-224 => ${sha3_224.string(text)}');
  print('SHA3-256 => ${sha3_256.string(text)}');
  print('SHA3-384 => ${sha3_384.string(text)}');
  print('SHA3-512 => ${sha3_512.string(text)}');
  print('Keccak-224 => ${keccak224.string(text)}');
  print('Keccak-256 => ${keccak256.string(text)}');
  print('Keccak-384 => ${keccak384.string(text)}');
  print('Keccak-512 => ${keccak512.string(text)}');
  print('SHAKE-128 => ${shake128.of(20).string(text)}');
  print('SHAKE-256 => ${shake256.of(20).string(text)}');
  print('BLAKE2s-256 => ${blake2s256.string(text)}');
  print('BLAKE2b-512 => ${blake2b512.string(text)}');
  print('SM3] => ${sm3.string(text)}');
  print('');

  // Examples of MAC generations
  print('HMAC/MD5 => ${md5.hmac.by(pw).string(text)}');
  print('HMAC/SHA1 => ${sha1.hmac.byString(text)}');
  print('HMAC/SHA256 => ${sha256.hmac.byString(key).string(text)}');
  print('HMAC/SHA3-256 => ${HMAC(sha3_256).by(pw).string(text)}');
  print("HMAC/BLAKE2b-256 => ${blake2b512.hmac.by(pw).string(text)}");
  print("BLAKE-2b-MAC/256 => ${blake2b256.mac.by(pw).string(text)}");
  print("BLAKE-2b-MAC/224 => ${Blake2b(28).mac.by(pw).string(text)}");
  print('');

  // Examples of OTP generation
  int nw = DateTime.now().millisecondsSinceEpoch ~/ 30000;
  var counter = fromHex(nw.toRadixString(16).padLeft(16, '0'));
  print('TOTP[time=$nw] => ${TOTP(iv).value()}');
  print('HOTP[counter=$nw] => ${HOTP(iv, counter: counter).value()}');
  print('');
}
```

### Key Generation Example

```dart
import 'package:hashlib/hashlib.dart';

void main() {
  final key = "password";
  final salt = "some salt";
  print("key => $key");
  print("salt => $salt");
  print('');

  final pw = key.codeUnits;
  final iv = salt.codeUnits;

  // Examples of Argon2 key derivation
  final argon2Test = Argon2Security.test;
  print("[Argon2i] => ${argon2i(pw, iv, security: argon2Test)}");
  print("[Argon2d] => ${argon2d(pw, iv, security: argon2Test)}");
  print("[Argon2id] => ${argon2id(pw, iv, security: argon2Test)}");

  // Examples of scrypt key derivation
  final scryptLittle = ScryptSecurity.little;
  print("[scrypt] => ${scrypt(pw, iv, security: scryptLittle, dklen: 24)}");
  print('');

  // Examples of bcrypt key derivation
  final bcryptLittle = BcryptSecurity.little;
  print("[bcrypt] => ${bcrypt(pw, bcryptSalt(security: bcryptLittle))}");
  print('');

  // Examples of PBKDF2 key derivation
  print("SHA256/HMAC/PBKDF2 => ${pbkdf2(pw, iv).hex()}");
  print("BLAKE2b-256/HMAC/PBKDF2 => ${blake2b256.pbkdf2(iv).hex(pw)}");
  print("BLAKE2b-256/MAC/PBKDF2 => ${blake2b256.mac.pbkdf2(iv).hex(pw)}");
  print("SHA1/HMAC/PBKDF2 => ${sha1.pbkdf2(iv, iterations: 100).hex(pw)}");
  print('');
}
```

### Random Example

```dart
import 'package:hashlib/codecs.dart';
import 'package:hashlib/random.dart';

void main() {
  print('UUID Generation:');
  print('UUIDv1: ${uuid.v1()}');
  print('UUIDv3: ${uuid.v3()}');
  print('UUIDv4: ${uuid.v4()}');
  print('UUIDv5: ${uuid.v5()}');
  print('UUIDv6: ${uuid.v6()}');
  print('UUIDv7: ${uuid.v7()}');
  print('UUIDv8: ${uuid.v8()}');
  print('');

  print('Random Generation:');
  print(randomNumbers(4));
  print(toHex(randomBytes(16)));
  print(randomString(32, lower: true, whitelist: '_'.codeUnits));
  print('');
}
```

# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

<hr/>

With 5MB message (10 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                 | `crypto`                    | `hash`                     |
| ------------- | ------------- | ------------------------------ | --------------------------- | -------------------------- |
| MD4           | **1.64 Gbps** | 352 Mbps <br> `4.66x slow`     |                             |                            |
| MD5           | **1.45 Gbps** | 347 Mbps <br> `4.18x slow`     | 1.01 Gbps <br> `1.44x slow` | 651 Mbps <br> `2.23x slow` |
| HMAC(MD5)     | **1.33 Gbps** |                                | 991 Mbps <br> `1.34x slow`  | 653 Mbps <br> `2.04x slow` |
| SHA-1         | **1.27 Gbps** | 248 Mbps <br> `5.13x slow`     | 794 Mbps <br> `1.61x slow`  | 388 Mbps <br> `3.28x slow` |
| HMAC(SHA-1)   | **1.28 Gbps** |                                | 793 Mbps <br> `1.61x slow`  |                            |
| SHA-224       | **856 Mbps**  | 152 Mbps <br> `5.65x slow`     | 685 Mbps <br> `1.25x slow`  | 198 Mbps <br> `4.32x slow` |
| SHA-256       | **859 Mbps**  | 151 Mbps <br> `5.67x slow`     | 686 Mbps <br> `1.25x slow`  | 198 Mbps <br> `4.35x slow` |
| HMAC(SHA-256) | **858 Mbps**  |                                | 688 Mbps <br> `1.25x slow`  |                            |
| SHA-384       | **1.36 Gbps** | 17.35 Mbps <br> `78.24x slow`  | 466 Mbps <br> `2.91x slow`  | 162 Mbps <br> `8.37x slow` |
| SHA-512       | **1.36 Gbps** | 17.59 Mbps <br> `77.15x slow`  | 470 Mbps <br> `2.89x slow`  | 160 Mbps <br> `8.46x slow` |
| SHA3-224      | **857 Mbps**  | 14.97 Mbps <br> `57.25x slow`  |                             |                            |
| SHA3-256      | **857 Mbps**  | 14.17 Mbps <br> `60.48x slow`  |                             |                            |
| SHA3-384      | **1.36 Gbps** | 10.85 Mbps <br> `125.22x slow` |                             |                            |
| SHA3-512      | **1.37 Gbps** | 7.49 Mbps <br> `182.3x slow`   |                             |                            |
| RIPEMD-128    | **1.79 Gbps** | 247 Mbps <br> `7.24x slow`     |                             |                            |
| RIPEMD-160    | **698 Mbps**  | 174 Mbps <br> `4x slow`        |                             | 290 Mbps <br> `2.41x slow` |
| RIPEMD-256    | **2 Gbps**    | 218 Mbps <br> `9.16x slow`     |                             |                            |
| RIPEMD-320    | **684 Mbps**  | 161 Mbps <br> `4.26x slow`     |                             |                            |
| BLAKE-2s      | **1.49 Gbps** |                                |                             |                            |
| BLAKE-2b      | **1.53 Gbps** | 71.06 Mbps <br> `21.6x slow`   |                             |                            |
| Poly1305      | **3.79 Gbps** | 362 Mbps <br> `10.48x slow`    |                             |                            |
| XXH32         | **4.5 Gbps**  |                                |                             |                            |
| XXH64         | **2.42 Gbps** |                                |                             |                            |
| XXH3          | **976 Mbps**  |                                |                             |                            |
| XXH128        | **1.03 Gbps** |                                |                             |                            |
| SM3           | **751 Mbps**  | 135 Mbps <br> `5.57x slow`     |                             |                            |

<hr/>

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                 | `crypto`                   | `hash`                     |
| ------------- | ------------- | ------------------------------ | -------------------------- | -------------------------- |
| MD4           | **1.54 Gbps** | 576 Mbps <br> `2.67x slow`     |                            |                            |
| MD5           | **1.37 Gbps** | 514 Mbps <br> `2.66x slow`     | 916 Mbps <br> `1.49x slow` | 643 Mbps <br> `2.12x slow` |
| HMAC(MD5)     | **1 Gbps**    |                                | 735 Mbps <br> `1.36x slow` | 482 Mbps <br> `2.08x slow` |
| SHA-1         | **1.16 Gbps** | 348 Mbps <br> `3.33x slow`     | 714 Mbps <br> `1.62x slow` | 371 Mbps <br> `3.12x slow` |
| HMAC(SHA-1)   | **784 Mbps**  |                                | 505 Mbps <br> `1.55x slow` |                            |
| SHA-224       | **780 Mbps**  | 177 Mbps <br> `4.41x slow`     | 616 Mbps <br> `1.27x slow` | 187 Mbps <br> `4.18x slow` |
| SHA-256       | **784 Mbps**  | 175 Mbps <br> `4.48x slow`     | 615 Mbps <br> `1.27x slow` | 187 Mbps <br> `4.19x slow` |
| HMAC(SHA-256) | **549 Mbps**  |                                | 433 Mbps <br> `1.27x slow` |                            |
| SHA-384       | **1.13 Gbps** | 26.94 Mbps <br> `42.01x slow`  | 402 Mbps <br> `2.82x slow` | 169 Mbps <br> `6.71x slow` |
| SHA-512       | **1.13 Gbps** | 27.88 Mbps <br> `40.48x slow`  | 402 Mbps <br> `2.81x slow` | 170 Mbps <br> `6.64x slow` |
| SHA3-224      | **782 Mbps**  | 20.34 Mbps <br> `38.46x slow`  |                            |                            |
| SHA3-256      | **783 Mbps**  | 20.55 Mbps <br> `38.11x slow`  |                            |                            |
| SHA3-384      | **1.13 Gbps** | 16.25 Mbps <br> `69.21x slow`  |                            |                            |
| SHA3-512      | **1.13 Gbps** | 10.89 Mbps <br> `103.51x slow` |                            |                            |
| RIPEMD-128    | **1.62 Gbps** | 334 Mbps <br> `4.87x slow`     |                            |                            |
| RIPEMD-160    | **642 Mbps**  | 207 Mbps <br> `3.1x slow`      |                            | 280 Mbps <br> `2.29x slow` |
| RIPEMD-256    | **1.81 Gbps** | 339 Mbps <br> `5.34x slow`     |                            |                            |
| RIPEMD-320    | **636 Mbps**  | 198 Mbps <br> `3.22x slow`     |                            |                            |
| BLAKE-2s      | **1.43 Gbps** |                                |                            |                            |
| BLAKE-2b      | **1.47 Gbps** | 95.76 Mbps <br> `15.38x slow`  |                            |                            |
| Poly1305      | **3.33 Gbps** | 768 Mbps <br> `4.33x slow`     |                            |                            |
| XXH32         | **4.12 Gbps** |                                |                            |                            |
| XXH64         | **2.27 Gbps** |                                |                            |                            |
| XXH3          | **784 Mbps**  |                                |                            |                            |
| XXH128        | **825 Mbps**  |                                |                            |                            |
| SM3           | **698 Mbps**  | 163 Mbps <br> `4.28x slow`     |                            |                            |

<hr/>

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                       |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **210 Mbps**   | 101 Mbps <br> `2.09x slow`   |                              |                              |
| MD5           | **177 Mbps**   | 89.19 Mbps <br> `1.98x slow` | 92.89 Mbps <br> `1.9x slow`  | 52.25 Mbps <br> `3.38x slow` |
| HMAC(MD5)     | **36.18 Mbps** |                              | 31.69 Mbps <br> `1.14x slow` | 14.23 Mbps <br> `2.54x slow` |
| SHA-1         | **120 Mbps**   | 49.47 Mbps <br> `2.42x slow` | 69.51 Mbps <br> `1.72x slow` | 34.29 Mbps <br> `3.49x slow` |
| HMAC(SHA-1)   | **19.64 Mbps** |                              | 14.71 Mbps <br> `1.34x slow` |                              |
| SHA-224       | **88.2 Mbps**  | 26.95 Mbps <br> `3.27x slow` | 58.57 Mbps <br> `1.51x slow` | 21.69 Mbps <br> `4.07x slow` |
| SHA-256       | **88.39 Mbps** | 27.12 Mbps <br> `3.26x slow` | 60.75 Mbps <br> `1.45x slow` | 22.48 Mbps <br> `3.93x slow` |
| HMAC(SHA-256) | **14.35 Mbps** |                              | 12.45 Mbps <br> `1.15x slow` |                              |
| SHA-384       | **65.18 Mbps** | 2.33 Mbps <br> `27.95x slow` | 26.99 Mbps <br> `2.42x slow` | 11.16 Mbps <br> `5.84x slow` |
| SHA-512       | **64.21 Mbps** | 2.35 Mbps <br> `27.3x slow`  | 26.59 Mbps <br> `2.41x slow` | 11.39 Mbps <br> `5.64x slow` |
| SHA3-224      | **88.02 Mbps** | 1.57 Mbps <br> `55.89x slow` |                              |                              |
| SHA3-256      | **89.16 Mbps** | 1.56 Mbps <br> `57.23x slow` |                              |                              |
| SHA3-384      | **64.5 Mbps**  | 1.57 Mbps <br> `41.07x slow` |                              |                              |
| SHA3-512      | **63.11 Mbps** | 1.57 Mbps <br> `40.2x slow`  |                              |                              |
| RIPEMD-128    | **177 Mbps**   | 58.35 Mbps <br> `3.03x slow` |                              |                              |
| RIPEMD-160    | **86.81 Mbps** | 33.18 Mbps <br> `2.62x slow` |                              | 32.16 Mbps <br> `2.7x slow`  |
| RIPEMD-256    | **180 Mbps**   | 53.17 Mbps <br> `3.39x slow` |                              |                              |
| RIPEMD-320    | **85.18 Mbps** | 30.48 Mbps <br> `2.79x slow` |                              |                              |
| BLAKE-2s      | **152 Mbps**   |                              |                              |                              |
| BLAKE-2b      | **120 Mbps**   | 6.89 Mbps <br> `17.44x slow` |                              |                              |
| Poly1305      | **269 Mbps**   | 167 Mbps <br> `1.61x slow`   |                              |                              |
| XXH32         | **413 Mbps**   |                              |                              |                              |
| XXH64         | **332 Mbps**   |                              |                              |                              |
| XXH3          | **32.94 Mbps** |                              |                              |                              |
| XXH128        | **33.16 Mbps** |                              |                              |                              |
| SM3           | **93.33 Mbps** | 24.81 Mbps <br> `3.76x slow` |                              |                              |

<hr/>

Key derivator algorithm benchmarks on different security parameters:

| Algorithms | little   | moderate  | good       | strong      |
| ---------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 1.092 ms | 11.899 ms | 69.138 ms  | 2100.983 ms |
| bcrypt     | 1.803 ms | 14.474 ms | 226.341 ms | 1811.425 ms |
| pbkdf2     | 0.668 ms | 16.363 ms | 267.526 ms | 3211.098 ms |
| argon2i    | 2.359 ms | 17.448 ms | 205.518 ms | 2375.301 ms |
| argon2d    | 2.272 ms | 16.064 ms | 201.827 ms | 2374.41 ms  |
| argon2id   | 2.306 ms | 16.38 ms  | 199.66 ms  | 2376.102 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.7.0 (stable) (Wed Feb 5 04:53:58 2025 -0800) on "windows_x64"
