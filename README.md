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

| Algorithm | Available methods                          | Source   |
| --------- | ------------------------------------------ | -------- |
| Argon2    | `Argon2`, `argon2d`, `argon2i`, `argon2id` | RFC-9106 |
| PBKDF2    | `PBKDF2`, `pbkdf2`, `#.pbkdf2`             | RFC-8081 |
| scrypt    | `scrypt`, `Scrypt`                         | RFC-7914 |

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
}
```

# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                 | `crypto`                    | `hash`                      |
| ------------- | ------------- | ------------------------------ | --------------------------- | --------------------------- |
| MD4           | **2.26 Gbps** | 1.01 Gbps <br> `2.23x slow`    |                             |                             |
| MD5           | **1.53 Gbps** | 870 Mbps <br> `1.76x slow`     | 1.4 Gbps <br> `1.09x slow`  | 928 Mbps <br> `1.65x slow`  |
| HMAC(MD5)     | **1.51 Gbps** |                                | 1.44 Gbps <br> `1.06x slow` | 934 Mbps <br> `1.62x slow`  |
| SHA-1         | **1.28 Gbps** | 524 Mbps <br> `2.45x slow`     | 1.14 Gbps <br> `1.12x slow` | 532 Mbps <br> `2.41x slow`  |
| HMAC(SHA-1)   | **1.28 Gbps** |                                | 1.16 Gbps <br> `1.11x slow` |                             |
| SHA-224       | **971 Mbps**  | 245 Mbps <br> `3.96x slow`     | 914 Mbps <br> `1.06x slow`  | 245 Mbps <br> `3.97x slow`  |
| SHA-256       | **1.03 Gbps** | 240 Mbps <br> `4.28x slow`     | 905 Mbps <br> `1.14x slow`  | 242 Mbps <br> `4.25x slow`  |
| HMAC(SHA-256) | **1.04 Gbps** |                                | 925 Mbps <br> `1.12x slow`  |                             |
| SHA-384       | **1.9 Gbps**  | 57.57 Mbps <br> `33.05x slow`  | 661 Mbps <br> `2.88x slow`  | 183 Mbps <br> `10.41x slow` |
| SHA-512       | **1.93 Gbps** | 58.29 Mbps <br> `33.13x slow`  | 663 Mbps <br> `2.91x slow`  | 185 Mbps <br> `10.43x slow` |
| SHA3-256      | **1.04 Gbps** | 32.59 Mbps <br> `31.86x slow`  |                             |                             |
| SHA3-512      | **1.92 Gbps** | 17.27 Mbps <br> `111.36x slow` |                             |                             |
| RIPEMD-128    | **1.29 Gbps** | 509 Mbps <br> `2.54x slow`     |                             |                             |
| RIPEMD-160    | **699 Mbps**  | 356 Mbps <br> `1.96x slow`     |                             | 375 Mbps <br> `1.86x slow`  |
| RIPEMD-256    | **1.42 Gbps** | 505 Mbps <br> `2.81x slow`     |                             |                             |
| RIPEMD-320    | **666 Mbps**  | 346 Mbps <br> `1.93x slow`     |                             |                             |
| BLAKE-2s      | **1.52 Gbps** |                                |                             |                             |
| BLAKE-2b      | **2.01 Gbps** | 162 Mbps <br> `12.41x slow`    |                             |                             |
| Poly1305      | **4.51 Gbps** | 1.52 Gbps <br> `2.97x slow`    |                             |                             |
| XXH32         | **5.42 Gbps** |                                |                             |                             |
| XXH64         | **5.85 Gbps** |                                |                             |                             |
| XXH3          | **1.4 Gbps**  |                                |                             |                             |
| XXH128        | **1.47 Gbps** |                                |                             |                             |
| SM3           | **886 Mbps**  | 253 Mbps <br> `3.51x slow`     |                             |                             |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                      |
| ------------- | ------------- | ----------------------------- | --------------------------- | --------------------------- |
| MD4           | **2.12 Gbps** | 965 Mbps <br> `2.19x slow`    |                             |                             |
| MD5           | **1.42 Gbps** | 828 Mbps <br> `1.71x slow`    | 1.3 Gbps <br> `1.09x slow`  | 1.03 Gbps <br> `1.37x slow` |
| HMAC(MD5)     | **1.16 Gbps** |                               | 1.09 Gbps <br> `1.07x slow` | 754 Mbps <br> `1.54x slow`  |
| SHA-1         | **1.18 Gbps** | 500 Mbps <br> `2.36x slow`    | 1.05 Gbps <br> `1.12x slow` | 554 Mbps <br> `2.13x slow`  |
| HMAC(SHA-1)   | **841 Mbps**  |                               | 768 Mbps <br> `1.09x slow`  |                             |
| SHA-224       | **955 Mbps**  | 229 Mbps <br> `4.16x slow`    | 835 Mbps <br> `1.14x slow`  | 239 Mbps <br> `4x slow`     |
| SHA-256       | **957 Mbps**  | 232 Mbps <br> `4.12x slow`    | 838 Mbps <br> `1.14x slow`  | 239 Mbps <br> `4x slow`     |
| HMAC(SHA-256) | **681 Mbps**  |                               | 606 Mbps <br> `1.12x slow`  |                             |
| SHA-384       | **1.58 Gbps** | 52.84 Mbps <br> `29.89x slow` | 590 Mbps <br> `2.68x slow`  | 167 Mbps <br> `9.43x slow`  |
| SHA-512       | **1.6 Gbps**  | 51.79 Mbps <br> `30.84x slow` | 588 Mbps <br> `2.72x slow`  | 168 Mbps <br> `9.53x slow`  |
| SHA3-256      | **956 Mbps**  | 30.62 Mbps <br> `31.23x slow` |                             |                             |
| SHA3-512      | **1.6 Gbps**  | 16.4 Mbps <br> `97.3x slow`   |                             |                             |
| RIPEMD-128    | **1.2 Gbps**  | 480 Mbps <br> `2.5x slow`     |                             |                             |
| RIPEMD-160    | **656 Mbps**  | 334 Mbps <br> `1.96x slow`    |                             | 376 Mbps <br> `1.75x slow`  |
| RIPEMD-256    | **1.33 Gbps** | 478 Mbps <br> `2.78x slow`    |                             |                             |
| RIPEMD-320    | **627 Mbps**  | 330 Mbps <br> `1.9x slow`     |                             |                             |
| BLAKE-2s      | **1.57 Gbps** |                               |                             |                             |
| BLAKE-2b      | **1.98 Gbps** | 160 Mbps <br> `12.36x slow`   |                             |                             |
| Poly1305      | **4.28 Gbps** | 1.5 Gbps <br> `2.85x slow`    |                             |                             |
| XXH32         | **4.94 Gbps** |                               |                             |                             |
| XXH64         | **5.44 Gbps** |                               |                             |                             |
| XXH3          | **1.32 Gbps** |                               |                             |                             |
| XXH128        | **1.32 Gbps** |                               |                             |                             |
| SM3           | **830 Mbps**  | 236 Mbps <br> `3.52x slow`    |                             |                             |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **334 Mbps**   | 185 Mbps <br> `1.81x slow`    |                              |                              |
| MD5           | **264 Mbps**   | 156 Mbps <br> `1.69x slow`    | 160 Mbps <br> `1.65x slow`   | 78.48 Mbps <br> `3.36x slow` |
| HMAC(MD5)     | **50.09 Mbps** |                               | 46.17 Mbps <br> `1.08x slow` | 21.6 Mbps <br> `2.32x slow`  |
| SHA-1         | **156 Mbps**   | 83.85 Mbps <br> `1.86x slow`  | 122 Mbps <br> `1.28x slow`   | 58.19 Mbps <br> `2.68x slow` |
| HMAC(SHA-1)   | **24.18 Mbps** |                               | 22.01 Mbps <br> `1.1x slow`  |                              |
| SHA-224       | **125 Mbps**   | 37.54 Mbps <br> `3.34x slow`  | 102 Mbps <br> `1.23x slow`   | 31.53 Mbps <br> `3.98x slow` |
| SHA-256       | **125 Mbps**   | 37.7 Mbps <br> `3.33x slow`   | 103 Mbps <br> `1.22x slow`   | 31.64 Mbps <br> `3.96x slow` |
| HMAC(SHA-256) | **19.5 Mbps**  |                               | 17.87 Mbps <br> `1.09x slow` |                              |
| SHA-384       | **107 Mbps**   | 4.55 Mbps <br> `23.63x slow`  | 44.43 Mbps <br> `2.42x slow` | 14.32 Mbps <br> `7.5x slow`  |
| SHA-512       | **107 Mbps**   | 4.46 Mbps <br> `24.01x slow`  | 44.1 Mbps <br> `2.43x slow`  | 14.58 Mbps <br> `7.35x slow` |
| SHA3-256      | **126 Mbps**   | 2.32 Mbps <br> `54.28x slow`  |                              |                              |
| SHA3-512      | **107 Mbps**   | 2.31 Mbps <br> `46.31x slow`  |                              |                              |
| RIPEMD-128    | **194 Mbps**   | 85.85 Mbps <br> `2.26x slow`  |                              |                              |
| RIPEMD-160    | **105 Mbps**   | 58.39 Mbps <br> `1.8x slow`   |                              | 45.19 Mbps <br> `2.32x slow` |
| RIPEMD-256    | **210 Mbps**   | 80.76 Mbps <br> `2.6x slow`   |                              |                              |
| RIPEMD-320    | **101 Mbps**   | 54.23 Mbps <br> `1.87x slow`  |                              |                              |
| BLAKE-2s      | **188 Mbps**   |                               |                              |                              |
| BLAKE-2b      | **153 Mbps**   | 11.09 Mbps <br> `13.76x slow` |                              |                              |
| Poly1305      | **733 Mbps**   | 438 Mbps <br> `1.67x slow`    |                              |                              |
| XXH32         | **1.1 Gbps**   |                               |                              |                              |
| XXH64         | **858 Mbps**   |                               |                              |                              |
| XXH3          | **109 Mbps**   |                               |                              |                              |
| XXH128        | **105 Mbps**   |                               |                              |                              |
| SM3           | **129 Mbps**   | 39.46 Mbps <br> `3.27x slow`  |                              |                              |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.048 ms | 1.123 ms | 8.501 ms  | 69.45 ms   | 1080.798 ms |
| argon2i    | 0.272 ms | 2.26 ms  | 15.143 ms | 193.404 ms | 2092.091 ms |
| argon2d    | 0.199 ms | 2.085 ms | 14.863 ms | 192.37 ms  | 2057.96 ms  |
| argon2id   | 0.212 ms | 2.127 ms | 15.0 ms   | 191.927 ms | 2071.661 ms |

> All benchmarks are done on 36GB _Apple M3 Pro_ using compiled _exe_
>
> Dart SDK version: 3.4.0 (stable) (Mon May 6 07:59:58 2024 -0700) on "macos_arm64"
