# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![test](https://github.com/bitanon/hashlib/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/bitanon/hashlib/actions/workflows/test.yml)
[![codecov](https://codecov.io/gh/bitanon/hashlib/graph/badge.svg?token=ISIYJ8MNI0)](https://codecov.io/gh/bitanon/hashlib)
[![dart support](https://img.shields.io/badge/dart-%3e%3d%202.14.0-39f?logo=dart)](https://dart.dev/guides/whats-new#september-8-2021-214-release)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)

This library contains implementations of secure hash functions, checksum generators, and key derivation algorithms optimized for Dart.

## Depencencies

There is only 1 dependency used by this package:

- [hashlib_codecs](https://pub.dev/packages/hashlib_codecs)

## Features

### Block Hash Algorithms

| Algorithm   | Available methods                                                  |        Source        |
| ----------- | ------------------------------------------------------------------ | :------------------: |
| MD4         | `md4`                                                              |       RFC-1320       |
| MD5         | `md5`                                                              |       RFC-1321       |
| SHA-1       | `sha1`                                                             |       RFC-3174       |
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
| SM3         | `sm3`                                                              |   GB/T 32905-2016    |

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

### Random Number Generation

Available generators:

- secure
- system
- keccak
- sha256
- md5
- xxh64
- sm3

## Demo

A demo application is available in Google Play Store featuring the capabilities of this package.

<a href='https://play.google.com/store/apps/details?id=io.bitanon.hashlib_demo&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png' width="192px" /></a>

<a href='https://play.google.com/store/apps/details?id=io.bitanon.hashlib_demo&pcampaignid=pcampaignidMKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt="demo app preview" src="https://raw.githubusercontent.com/bitanon/hashlib_demo/master/images/demo.gif" height="640px"/></a>

## Getting Started

The following import will give you access to all of the algorithms in this package.

```dart
import 'package:hashlib/hashlib.dart' as hashlib;
```

Check the [API Reference](https://pub.dev/documentation/hashlib/latest/) for details.

## Usage

Examples can be found inside the `example` folder.

```dart
import 'package:hashlib/codecs.dart';
import 'package:hashlib/hashlib.dart';

void main() {
  var text = "Happy Hashing!";
  var key = "password";
  var pw = key.codeUnits;
  var iv = "some salt".codeUnits;
  print("text => $text");
  print("key => $key");
  print("salt => ${toHex(iv)}");
  print('');

  // Example of hash code generations
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

  // Examples of PBKDF2 key derivation
  print("SHA256/HMAC/PBKDF2 => ${pbkdf2(pw, iv).hex()}");
  print("BLAKE2b-256/HMAC/PBKDF2 => ${blake2b256.pbkdf2(iv).hex(pw)}");
  print("BLAKE2b-256/MAC/PBKDF2 => ${blake2b256.mac.pbkdf2(iv).hex(pw)}");
  print("SHA1/HMAC/PBKDF2 => ${sha1.pbkdf2(iv, iterations: 100).hex(pw)}");
  print('');

  // Examples of OTP generation
  int nw = DateTime.now().millisecondsSinceEpoch ~/ 30000;
  var counter = fromHex(nw.toRadixString(16).padLeft(16, '0'));
  print('TOTP[time=$nw] => ${TOTP(iv).value()}');
  print('HOTP[counter=$nw] => ${HOTP(iv, counter: counter).value()}');
  print('');

  // Examples of Argon2 key derivation
  var argon2Test = Argon2Security.test;
  print("[Argon2i] => ${argon2i(pw, iv, security: argon2Test)}");
  print("[Argon2d] => ${argon2d(pw, iv, security: argon2Test)}");
  print("[Argon2id] => ${argon2id(pw, iv, security: argon2Test)}");

  // Examples of scrypt key derivation
  var scryptLittle = ScryptSecurity.little;
  print("[scrypt] => ${scrypt(pw, iv, security: scryptLittle, dklen: 24)}");
  print('');

  // Examples of bcrypt key derivation
  var bcryptLittle = BcryptSecurity.little;
  print("[bcrypt] => ${bcrypt(pw, bcryptSalt(security: bcryptLittle))}");
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

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **1.59 Gbps** | 836 Mbps <br> `1.9x slow`     |                             |                            |
| MD5           | **1.42 Gbps** | 728 Mbps <br> `1.95x slow`    | 1.15 Gbps <br> `1.23x slow` | 617 Mbps <br> `2.3x slow`  |
| HMAC(MD5)     | **1.37 Gbps** |                               | 1.13 Gbps <br> `1.21x slow` | 615 Mbps <br> `2.23x slow` |
| SHA-1         | **1.25 Gbps** | 439 Mbps <br> `2.84x slow`    | 861 Mbps <br> `1.45x slow`  | 351 Mbps <br> `3.55x slow` |
| HMAC(SHA-1)   | **1.25 Gbps** |                               | 858 Mbps <br> `1.46x slow`  |                            |
| SHA-224       | **823 Mbps**  | 179 Mbps <br> `4.59x slow`    | 744 Mbps <br> `1.11x slow`  | 172 Mbps <br> `4.78x slow` |
| SHA-256       | **827 Mbps**  | 181 Mbps <br> `4.57x slow`    | 746 Mbps <br> `1.11x slow`  | 172 Mbps <br> `4.79x slow` |
| HMAC(SHA-256) | **819 Mbps**  |                               | 740 Mbps <br> `1.11x slow`  |                            |
| SHA-384       | **1.32 Gbps** | 46.07 Mbps <br> `28.59x slow` | 445 Mbps <br> `2.96x slow`  | 151 Mbps <br> `8.74x slow` |
| SHA-512       | **1.32 Gbps** | 44.17 Mbps <br> `29.77x slow` | 443 Mbps <br> `2.97x slow`  | 150 Mbps <br> `8.74x slow` |
| SHA3-224      | **823 Mbps**  | 27.88 Mbps <br> `29.52x slow` |                             |                            |
| SHA3-256      | **826 Mbps**  | 26.6 Mbps <br> `31.06x slow`  |                             |                            |
| SHA3-384      | **1.31 Gbps** | 20.37 Mbps <br> `64.17x slow` |                             |                            |
| SHA3-512      | **1.31 Gbps** | 13.97 Mbps <br> `93.79x slow` |                             |                            |
| RIPEMD-128    | **1.77 Gbps** | 378 Mbps <br> `4.69x slow`    |                             |                            |
| RIPEMD-160    | **559 Mbps**  | 239 Mbps <br> `2.34x slow`    |                             | 281 Mbps <br> `1.99x slow` |
| RIPEMD-256    | **1.91 Gbps** | 373 Mbps <br> `5.11x slow`    |                             |                            |
| RIPEMD-320    | **543 Mbps**  | 237 Mbps <br> `2.29x slow`    |                             |                            |
| BLAKE-2s      | **1.2 Gbps**  |                               |                             |                            |
| BLAKE-2b      | **1.38 Gbps** | 105 Mbps <br> `13.12x slow`   |                             |                            |
| Poly1305      | **2.2 Gbps**  | 1.24 Gbps <br> `1.77x slow`   |                             |                            |
| XXH32         | **3.84 Gbps** |                               |                             |                            |
| XXH64         | **2.63 Gbps** |                               |                             |                            |
| XXH3          | **987 Mbps**  |                               |                             |                            |
| XXH128        | **985 Mbps**  |                               |                             |                            |
| SM3           | **637 Mbps**  | 185 Mbps <br> `3.44x slow`    |                             |                            |

<hr/>

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **1.51 Gbps** | 795 Mbps <br> `1.9x slow`     |                             |                            |
| MD5           | **1.34 Gbps** | 684 Mbps <br> `1.96x slow`    | 1.08 Gbps <br> `1.24x slow` | 804 Mbps <br> `1.67x slow` |
| HMAC(MD5)     | **1.01 Gbps** |                               | 886 Mbps <br> `1.14x slow`  | 608 Mbps <br> `1.66x slow` |
| SHA-1         | **1.16 Gbps** | 416 Mbps <br> `2.79x slow`    | 809 Mbps <br> `1.44x slow`  | 395 Mbps <br> `2.93x slow` |
| HMAC(SHA-1)   | **773 Mbps**  |                               | 578 Mbps <br> `1.34x slow`  |                            |
| SHA-224       | **763 Mbps**  | 170 Mbps <br> `4.49x slow`    | 694 Mbps <br> `1.1x slow`   | 174 Mbps <br> `4.39x slow` |
| SHA-256       | **763 Mbps**  | 170 Mbps <br> `4.49x slow`    | 692 Mbps <br> `1.1x slow`   | 174 Mbps <br> `4.38x slow` |
| HMAC(SHA-256) | **519 Mbps**  |                               | 500 Mbps <br> `1.04x slow`  |                            |
| SHA-384       | **1.14 Gbps** | 40.79 Mbps <br> `27.98x slow` | 391 Mbps <br> `2.92x slow`  | 165 Mbps <br> `6.92x slow` |
| SHA-512       | **1.14 Gbps** | 40.88 Mbps <br> `27.87x slow` | 391 Mbps <br> `2.92x slow`  | 166 Mbps <br> `6.87x slow` |
| SHA3-224      | **767 Mbps**  | 25.06 Mbps <br> `30.59x slow` |                             |                            |
| SHA3-256      | **767 Mbps**  | 25.03 Mbps <br> `30.66x slow` |                             |                            |
| SHA3-384      | **1.14 Gbps** | 20.05 Mbps <br> `56.82x slow` |                             |                            |
| SHA3-512      | **1.14 Gbps** | 13.41 Mbps <br> `85.04x slow` |                             |                            |
| RIPEMD-128    | **1.63 Gbps** | 359 Mbps <br> `4.56x slow`    |                             |                            |
| RIPEMD-160    | **535 Mbps**  | 229 Mbps <br> `2.34x slow`    |                             | 286 Mbps <br> `1.87x slow` |
| RIPEMD-256    | **1.77 Gbps** | 356 Mbps <br> `4.96x slow`    |                             |                            |
| RIPEMD-320    | **509 Mbps**  | 224 Mbps <br> `2.28x slow`    |                             |                            |
| BLAKE-2s      | **1.18 Gbps** |                               |                             |                            |
| BLAKE-2b      | **1.34 Gbps** | 104 Mbps <br> `12.91x slow`   |                             |                            |
| Poly1305      | **2.12 Gbps** | 1.23 Gbps <br> `1.72x slow`   |                             |                            |
| XXH32         | **4.12 Gbps** |                               |                             |                            |
| XXH64         | **2.54 Gbps** |                               |                             |                            |
| XXH3          | **918 Mbps**  |                               |                             |                            |
| XXH128        | **925 Mbps**  |                               |                             |                            |
| SM3           | **599 Mbps**  | 174 Mbps <br> `3.43x slow`    |                             |                            |

<hr/>

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                         | `hash`                       |
| ------------- | -------------- | ---------------------------- | -------------------------------- | ---------------------------- |
| MD4           | **261 Mbps**   | 138 Mbps <br> `1.89x slow`   |                                  |                              |
| MD5           | **242 Mbps**   | 118 Mbps <br> `2.05x slow`   | 125 Mbps <br> `1.94x slow`       | 66.64 Mbps <br> `3.63x slow` |
| HMAC(MD5)     | 35.22 Mbps     |                              | **38.21 Mbps** <br> `1.08x fast` | 17.63 Mbps <br> `2x slow`    |
| SHA-1         | **152 Mbps**   | 64.91 Mbps <br> `2.34x slow` | 97.82 Mbps <br> `1.55x slow`     | 42.4 Mbps <br> `3.58x slow`  |
| HMAC(SHA-1)   | **19.18 Mbps** |                              | 17.66 Mbps <br> `1.09x slow`     |                              |
| SHA-224       | **107 Mbps**   | 27.04 Mbps <br> `3.97x slow` | 81.07 Mbps <br> `1.32x slow`     | 22.87 Mbps <br> `4.7x slow`  |
| SHA-256       | **107 Mbps**   | 26.91 Mbps <br> `3.98x slow` | 82.72 Mbps <br> `1.3x slow`      | 23.14 Mbps <br> `4.63x slow` |
| HMAC(SHA-256) | 13.54 Mbps     |                              | **14.94 Mbps** <br> `1.1x fast`  |                              |
| SHA-384       | **81.51 Mbps** | 3.49 Mbps <br> `23.36x slow` | 29.83 Mbps <br> `2.73x slow`     | 11.84 Mbps <br> `6.89x slow` |
| SHA-512       | **81 Mbps**    | 3.52 Mbps <br> `23.02x slow` | 29.68 Mbps <br> `2.73x slow`     | 11.94 Mbps <br> `6.78x slow` |
| SHA3-224      | **107 Mbps**   | 1.9 Mbps <br> `56.53x slow`  |                                  |                              |
| SHA3-256      | **107 Mbps**   | 1.9 Mbps <br> `56.4x slow`   |                                  |                              |
| SHA3-384      | **80.78 Mbps** | 1.9 Mbps <br> `42.47x slow`  |                                  |                              |
| SHA3-512      | **81.33 Mbps** | 1.9 Mbps <br> `42.87x slow`  |                                  |                              |
| RIPEMD-128    | **233 Mbps**   | 60.55 Mbps <br> `3.85x slow` |                                  |                              |
| RIPEMD-160    | **80.32 Mbps** | 36.69 Mbps <br> `2.19x slow` |                                  | 34.53 Mbps <br> `2.33x slow` |
| RIPEMD-256    | **238 Mbps**   | 58.04 Mbps <br> `4.1x slow`  |                                  |                              |
| RIPEMD-320    | **76.66 Mbps** | 34.48 Mbps <br> `2.22x slow` |                                  |                              |
| BLAKE-2s      | **168 Mbps**   |                              |                                  |                              |
| BLAKE-2b      | **140 Mbps**   | 7.71 Mbps <br> `18.21x slow` |                                  |                              |
| Poly1305      | **572 Mbps**   | 308 Mbps <br> `1.86x slow`   |                                  |                              |
| XXH32         | **840 Mbps**   |                              |                                  |                              |
| XXH64         | **656 Mbps**   |                              |                                  |                              |
| XXH3          | **82.46 Mbps** |                              |                                  |                              |
| XXH128        | **83.76 Mbps** |                              |                                  |                              |
| SM3           | **101 Mbps**   | 28.19 Mbps <br> `3.57x slow` |                                  |                              |

<hr/>

Key derivator algorithm benchmarks on different security parameters:

| Algorithms | little   | moderate  | good       | strong      |
| ---------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 1.589 ms | 16.688 ms | 91.663 ms  | 2937.545 ms |
| bcrypt     | 2.24 ms  | 17.077 ms | 273.729 ms | 2155.139 ms |
| pbkdf2     | 0.849 ms | 17.091 ms | 283.537 ms | 3419.39 ms  |
| argon2i    | 3.914 ms | 16.474 ms | 215.783 ms | 2598.387 ms |
| argon2d    | 2.981 ms | 16.98 ms  | 207.425 ms | 2563.844 ms |
| argon2id   | 2.311 ms | 16.491 ms | 205.25 ms  | 2576.335 ms |

<hr/>

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
