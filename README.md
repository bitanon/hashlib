# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dart support](https://img.shields.io/badge/dart-%3e%3d%202.14.0-39f?logo=dart)](https://dart.dev/guides/whats-new#september-8-2021-214-release)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)

<!-- [![test](https://github.com/bitanon/hashlib/actions/workflows/test.yml/badge.svg)](https://github.com/bitanon/hashlib/actions/workflows/test.yml) -->

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
| Argon2    | `Argon2`, `argon2d`, `argon2i`, `argon2id`, `argon2verify`       | RFC-9106 |
| PBKDF2    | `PBKDF2`, `pbkdf2`, `#.pbkdf2`                                   | RFC-8081 |
| scrypt    | `Scrypt`, `scrypt`,                                              | RFC-7914 |
| bcrypt    | `Bcrypt`, `bcrypt`, `bcryptSalt`, `bcryptVerify`, `bcryptDigest` |          |

### Message Authentication Code (MAC) Generators

| Algorithms | Available methods                      | Source   |
| ---------- | -------------------------------------- | -------- |
| HMAC       | `HMAC`, `#.hmac`                       | RFC-2104 |
| Poly1305   | `Poly1305`, `poly1305`, `poly1305pair` | RFC-8439 |

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
import 'package:hashlib/hashlib.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';

void main() {
  var text = "Happy Hashing!";
  var key = "password";
  var pw = key.codeUnits;
  var salt = "some salt".codeUnits;
  print("text => $text");
  print("key => $key");
  print("salt => ${toHex(salt)}");
  print('');

  // Example of hash code generations
  print('[XXH32] => ${xxh32code(text)}');
  print('[CRC32] => ${crc32code(text)}');
  print('[Alder32] => ${alder32code(text)}');
  print('[CRC16] => ${crc16code(text)}');
  print('');

  // Examples of Hash generation
  print('[CRC64] => ${crc64sum(text)}');
  print('[XXH64] => ${xxh64sum(text)}');
  print('[XXH3] => ${xxh3sum(text)}');
  print('[XXH128] => ${xxh128sum(text)}');
  print('[MD4] => ${md4.string(text)}');
  print('[MD5] => ${md5.string(text)}');
  print('[SHA-1] => ${sha1.string(text)}');
  print('[SHA-224] => ${sha224.string(text)}');
  print('[SHA-256] => ${sha256.string(text)}');
  print('[SHA-384] => ${sha384.string(text)}');
  print('[SHA-512] => ${sha512.string(text)}');
  print('[SHA-512/224] => ${sha512t224.string(text)}');
  print('[SHA-512/256] => ${sha512t256.string(text)}');
  print('[SHA3-224] => ${sha3_224.string(text)}');
  print('[SHA3-256] => ${sha3_256.string(text)}');
  print('[SHA3-384] => ${sha3_384.string(text)}');
  print('[SHA3-512] => ${sha3_512.string(text)}');
  print('[Keccak-224] => ${keccak224.string(text)}');
  print('[Keccak-256] => ${keccak256.string(text)}');
  print('[Keccak-384] => ${keccak384.string(text)}');
  print('[Keccak-512] => ${keccak512.string(text)}');
  print('[SHAKE-128] => ${shake128.of(20).string(text)}');
  print('[SHAKE-256] => ${shake256.of(20).string(text)}');
  print('[BLAKE-2s/256] => ${blake2s256.string(text)}');
  print('[BLAKE-2b/512] => ${blake2b512.string(text)}');
  print('[SM3] => ${sm3.string(text)}');
  print('');

  // Examples of MAC generations
  print('HMAC[MD5] => ${md5.hmac(pw).string(text)}');
  print('HMAC[SHA1] => ${sha1.hmacBy(key).string(text)}');
  print('HMAC[SHA256] => ${sha256.hmacBy(key).string(text)}');
  print('HMAC[SHA3-256] => ${HMAC(sha3_256, pw).string(text)}');
  print("[BLAKE-2b/224] => ${Blake2bMAC(28, pw).string(text)}");
  print("[BLAKE-2b/256] => ${blake2b256.mac(pw).string(text)}");
  print('');

  // Examples of PBKDF2 key derivation
  print("PBKDF2[HMAC[SHA256]] => ${pbkdf2(pw, salt, 100)}");
  print("PBKDF2[HMAC[SHA1]] => ${sha1.hmac(pw).pbkdf2(salt, 100)}");
  print("PBKDF2[BLAKE2b-256-MAC] => ${blake2b256.mac(pw).pbkdf2(salt, 100)}");
  print("PBKDF2[HMAC[BLAKE-2b-256]] => ${blake2b256.pbkdf2(pw, salt, 100)}");
  print('');

  // Examples of OTP generation
  int nw = DateTime.now().millisecondsSinceEpoch ~/ 30000;
  var counter = fromHex(nw.toRadixString(16).padLeft(16, '0'));
  print('TOTP[time=$nw] => ${TOTP(salt).value()}');
  print('HOTP[counter=$nw] => ${HOTP(salt, counter: counter).value()}');
  print('');

  // Examples of Argon2 key derivation
  var argon2Test = Argon2Security.test;
  print("[Argon2i] => ${argon2i(pw, salt, security: argon2Test)}");
  print("[Argon2d] => ${argon2d(pw, salt, security: argon2Test)}");
  print("[Argon2id] => ${argon2id(pw, salt, security: argon2Test)}");

  // Examples of scrypt key derivation
  var scryptLittle = ScryptSecurity.little;
  print("[scrypt] => ${scrypt(pw, salt, security: scryptLittle, dklen: 24)}");
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

With 5MB message (10 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **2.07 Gbps** | 828 Mbps <br> `2.5x slow`     |                             |                            |
| MD5           | **1.41 Gbps** | 724 Mbps <br> `1.95x slow`    | 1.13 Gbps <br> `1.25x slow` | 627 Mbps <br> `2.26x slow` |
| HMAC(MD5)     | **1.3 Gbps**  |                               | 1.12 Gbps <br> `1.16x slow` | 625 Mbps <br> `2.08x slow` |
| SHA-1         | **1.21 Gbps** | 456 Mbps <br> `2.65x slow`    | 849 Mbps <br> `1.42x slow`  | 362 Mbps <br> `3.34x slow` |
| HMAC(SHA-1)   | **1.21 Gbps** |                               | 844 Mbps <br> `1.43x slow`  |                            |
| SHA-224       | **810 Mbps**  | 176 Mbps <br> `4.6x slow`     | 723 Mbps <br> `1.12x slow`  | 170 Mbps <br> `4.76x slow` |
| SHA-256       | **809 Mbps**  | 179 Mbps <br> `4.52x slow`    | 724 Mbps <br> `1.12x slow`  | 170 Mbps <br> `4.77x slow` |
| HMAC(SHA-256) | **813 Mbps**  |                               | 708 Mbps <br> `1.15x slow`  |                            |
| SHA-384       | **1.27 Gbps** | 44.66 Mbps <br> `28.36x slow` | 445 Mbps <br> `2.85x slow`  | 150 Mbps <br> `8.43x slow` |
| SHA-512       | **1.26 Gbps** | 45.17 Mbps <br> `27.94x slow` | 445 Mbps <br> `2.84x slow`  | 151 Mbps <br> `8.38x slow` |
| SHA3-256      | **812 Mbps**  | 26.32 Mbps <br> `30.86x slow` |                             |                            |
| SHA3-512      | **1.27 Gbps** | 13.91 Mbps <br> `91.63x slow` |                             |                            |
| RIPEMD-128    | **1.77 Gbps** | 368 Mbps <br> `4.8x slow`     |                             |                            |
| RIPEMD-160    | **551 Mbps**  | 234 Mbps <br> `2.35x slow`    |                             | 276 Mbps <br> `2x slow`    |
| RIPEMD-256    | **1.9 Gbps**  | 370 Mbps <br> `5.14x slow`    |                             |                            |
| RIPEMD-320    | **552 Mbps**  | 231 Mbps <br> `2.39x slow`    |                             |                            |
| BLAKE-2s      | **1.2 Gbps**  |                               |                             |                            |
| BLAKE-2b      | **1.37 Gbps** | 105 Mbps <br> `13.06x slow`   |                             |                            |
| Poly1305      | **3.83 Gbps** | 1.26 Gbps <br> `3.03x slow`   |                             |                            |
| XXH32         | **4.48 Gbps** |                               |                             |                            |
| XXH64         | **4.42 Gbps** |                               |                             |                            |
| XXH3          | **1.02 Gbps** |                               |                             |                            |
| XXH128        | **1.02 Gbps** |                               |                             |                            |
| SM3           | **706 Mbps**  | 188 Mbps <br> `3.76x slow`    |                             |                            |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **1.95 Gbps** | 794 Mbps <br> `2.45x slow`    |                             |                            |
| MD5           | **1.35 Gbps** | 691 Mbps <br> `1.95x slow`    | 1.04 Gbps <br> `1.29x slow` | 835 Mbps <br> `1.62x slow` |
| HMAC(MD5)     | **1.07 Gbps** |                               | 882 Mbps <br> `1.21x slow`  | 624 Mbps <br> `1.71x slow` |
| SHA-1         | **1.13 Gbps** | 429 Mbps <br> `2.62x slow`    | 790 Mbps <br> `1.43x slow`  | 407 Mbps <br> `2.76x slow` |
| HMAC(SHA-1)   | **830 Mbps**  |                               | 570 Mbps <br> `1.46x slow`  |                            |
| SHA-224       | **751 Mbps**  | 169 Mbps <br> `4.45x slow`    | 672 Mbps <br> `1.12x slow`  | 173 Mbps <br> `4.35x slow` |
| SHA-256       | **749 Mbps**  | 169 Mbps <br> `4.43x slow`    | 674 Mbps <br> `1.11x slow`  | 173 Mbps <br> `4.34x slow` |
| HMAC(SHA-256) | **541 Mbps**  |                               | 486 Mbps <br> `1.11x slow`  |                            |
| SHA-384       | **1.11 Gbps** | 41.31 Mbps <br> `26.78x slow` | 394 Mbps <br> `2.81x slow`  | 168 Mbps <br> `6.59x slow` |
| SHA-512       | **1.11 Gbps** | 40.96 Mbps <br> `27.07x slow` | 394 Mbps <br> `2.82x slow`  | 168 Mbps <br> `6.61x slow` |
| SHA3-256      | **752 Mbps**  | 24.86 Mbps <br> `30.26x slow` |                             |                            |
| SHA3-512      | **1.11 Gbps** | 13.32 Mbps <br> `83.25x slow` |                             |                            |
| RIPEMD-128    | **1.64 Gbps** | 350 Mbps <br> `4.68x slow`    |                             |                            |
| RIPEMD-160    | **516 Mbps**  | 220 Mbps <br> `2.34x slow`    |                             | 297 Mbps <br> `1.74x slow` |
| RIPEMD-256    | **1.75 Gbps** | 350 Mbps <br> `5x slow`       |                             |                            |
| RIPEMD-320    | **518 Mbps**  | 218 Mbps <br> `2.37x slow`    |                             |                            |
| BLAKE-2s      | **1.18 Gbps** |                               |                             |                            |
| BLAKE-2b      | **1.33 Gbps** | 103 Mbps <br> `12.9x slow`    |                             |                            |
| Poly1305      | **3.57 Gbps** | 1.26 Gbps <br> `2.84x slow`   |                             |                            |
| XXH32         | **4.23 Gbps** |                               |                             |                            |
| XXH64         | **4.19 Gbps** |                               |                             |                            |
| XXH3          | **956 Mbps**  |                               |                             |                            |
| XXH128        | **949 Mbps**  |                               |                             |                            |
| SM3           | **659 Mbps**  | 176 Mbps <br> `3.73x slow`    |                             |                            |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                       |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **273 Mbps**   | 135 Mbps <br> `2.02x slow`   |                              |                              |
| MD5           | **246 Mbps**   | 118 Mbps <br> `2.08x slow`   | 125 Mbps <br> `1.97x slow`   | 69.2 Mbps <br> `3.55x slow`  |
| HMAC(MD5)     | **44.45 Mbps** |                              | 38.39 Mbps <br> `1.16x slow` | 18.19 Mbps <br> `2.44x slow` |
| SHA-1         | **144 Mbps**   | 66.9 Mbps <br> `2.15x slow`  | 98.88 Mbps <br> `1.45x slow` | 43.49 Mbps <br> `3.31x slow` |
| HMAC(SHA-1)   | **22.92 Mbps** |                              | 17.47 Mbps <br> `1.31x slow` |                              |
| SHA-224       | **103 Mbps**   | 27.22 Mbps <br> `3.8x slow`  | 80.2 Mbps <br> `1.29x slow`  | 22.93 Mbps <br> `4.51x slow` |
| SHA-256       | **103 Mbps**   | 27.14 Mbps <br> `3.79x slow` | 80.67 Mbps <br> `1.27x slow` | 23.12 Mbps <br> `4.45x slow` |
| HMAC(SHA-256) | **15.92 Mbps** |                              | 14.53 Mbps <br> `1.1x slow`  |                              |
| SHA-384       | **80.46 Mbps** | 3.5 Mbps <br> `23.01x slow`  | 30.22 Mbps <br> `2.66x slow` | 12.08 Mbps <br> `6.66x slow` |
| SHA-512       | **80.02 Mbps** | 3.48 Mbps <br> `22.98x slow` | 29.82 Mbps <br> `2.68x slow` | 12.12 Mbps <br> `6.6x slow`  |
| SHA3-256      | **103 Mbps**   | 1.88 Mbps <br> `54.75x slow` |                              |                              |
| SHA3-512      | **80.01 Mbps** | 1.88 Mbps <br> `42.63x slow` |                              |                              |
| RIPEMD-128    | **234 Mbps**   | 58.97 Mbps <br> `3.96x slow` |                              |                              |
| RIPEMD-160    | **80.04 Mbps** | 35.41 Mbps <br> `2.26x slow` |                              | 36.04 Mbps <br> `2.22x slow` |
| RIPEMD-256    | **243 Mbps**   | 57.34 Mbps <br> `4.23x slow` |                              |                              |
| RIPEMD-320    | **79.08 Mbps** | 33.59 Mbps <br> `2.35x slow` |                              |                              |
| BLAKE-2s      | **159 Mbps**   |                              |                              |                              |
| BLAKE-2b      | **125 Mbps**   | 7.61 Mbps <br> `16.38x slow` |                              |                              |
| Poly1305      | **508 Mbps**   | 318 Mbps <br> `1.6x slow`    |                              |                              |
| XXH32         | **837 Mbps**   |                              |                              |                              |
| XXH64         | **643 Mbps**   |                              |                              |                              |
| XXH3          | **87.49 Mbps** |                              |                              |                              |
| XXH128        | **83.2 Mbps**  |                              |                              |                              |
| SM3           | **98.76 Mbps** | 28.65 Mbps <br> `3.45x slow` |                              |                              |

Key derivator algorithm benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.056 ms | 1.564 ms | 11.017 ms | 92.747 ms  | 1375.198 ms |
| bcrypt     | 0.184 ms | 2.165 ms | 16.617 ms | 262.765 ms | 2101.005 ms |
| argon2i    | 0.333 ms | 3.034 ms | 16.871 ms | 205.397 ms | 2602.407 ms |
| argon2d    | 0.289 ms | 2.351 ms | 16.702 ms | 207.512 ms | 2650.916 ms |
| argon2id   | 0.284 ms | 2.354 ms | 16.642 ms | 209.787 ms | 2574.973 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
