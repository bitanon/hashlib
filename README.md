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

| Algorithm   | Available methods                                                  |         Source          |
| ----------- | ------------------------------------------------------------------ | :---------------------: |
| MD5         | `md5`                                                              |        RFC-1321         |
| SHA-1       | `sha1`                                                             |        RFC-3174         |
| SHA-2       | `sha224`, `sha256`, `sha384`, `sha512`, `sha512t224`, `sha512t256` |        RFC-6234         |
| SHA-3       | `sha3_224`, `sha3_256`, `sha3_384`, `sha3_512`                     |        FIPS-202         |
| SHAKE-128   | `Shake128`, `shake128`, `shake128_128`, `shake128_256`             |        FIPS-202         |
| SHAKE-256   | `Shake256`, `shake256`, `shake256_256`, `shake256_512`             |        FIPS-202         |
| Keccak      | `keccak224`, `keccak256`, `keccak384`, `keccak512`                 |       Team Keccak       |
| Blake2b     | `blake2b160`, `blake2b256`, `blake2b384`, `blake2b512`             |        RFC-7693         |
| Blake2s     | `blake2s128`, `blake2s160`, `blake2s224`, `blake2s256`             |        RFC-7693         |
| xxHash-32   | `XXHash32`,`xxh32`,`xxh32code`                                     |        Cyan4973         |
| xxHash-64   | `XXHash64`,`xxh64`,`xxh64code`                                     |        Cyan4973         |
| xxHash3-64  | `XXH3`, `xxh3`, `xxh3code`                                         |        Cyan4973         |
| xxHash3-128 | `XXH128`, `xxh128`, `xxh128code`                                   |        Cyan4973         |
| RIPEMD      | `ripemd128`, `ripemd256`, `ripemd160`, `ripemd320`                 | ISO/IEC 10118-3:2018(E) |

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

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD5           | **170.53MB/s** | 81.35MB/s <br> `110% slower`  | 136.30MB/s <br> `25% slower` | 76.73MB/s <br> `122% slower` |
| HMAC(MD5)     | **159.58MB/s** | ➖                            | 136.15MB/s <br> `17% slower` | 76.89MB/s <br> `108% slower` |
| SHA-1         | **142.59MB/s** | 53.02MB/s <br> `169% slower`  | 102.50MB/s <br> `39% slower` | 43.61MB/s <br> `227% slower` |
| HMAC(SHA-1)   | **141.53MB/s** | ➖                            | 101.98MB/s <br> `39% slower` | ➖                           |
| SHA-224       | **95.10MB/s**  | 21.01MB/s <br> `352% slower`  | 87.38MB/s <br> `9% slower`   | 20.61MB/s <br> `361% slower` |
| SHA-256       | **94.87MB/s**  | 21.24MB/s <br> `346% slower`  | 87.11MB/s <br> `9% slower`   | 20.53MB/s <br> `362% slower` |
| HMAC(SHA-256) | **95.04MB/s**  | ➖                            | 87.26MB/s <br> `9% slower`   | ➖                           |
| SHA-384       | **151.95MB/s** | 4.94MB/s <br> `2974% slower`  | 53.19MB/s <br> `186% slower` | 17.97MB/s <br> `745% slower` |
| SHA-512       | **151.55MB/s** | 4.97MB/s <br> `2946% slower`  | 53.18MB/s <br> `185% slower` | 18.19MB/s <br> `733% slower` |
| SHA3-256      | **94.98MB/s**  | 3.21MB/s <br> `2859% slower`  | ➖                           | ➖                           |
| SHA3-512      | **151.83MB/s** | 1.70MB/s <br> `8831% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **209.75MB/s** | 43.57MB/s <br> `381% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **65.42MB/s**  | 28.20MB/s <br> `132% slower`  | ➖                           | 34.23MB/s <br> `91% slower`  |
| RIPEMD-256    | **224.79MB/s** | 43.14MB/s <br> `421% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **66.21MB/s**  | 27.56MB/s <br> `140% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **142.40MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **163.02MB/s** | 12.12MB/s <br> `1244% slower` | ➖                           | ➖                           |
| Poly1305      | **432.83MB/s** | 152.54MB/s <br> `184% slower` | ➖                           | ➖                           |
| XXH32         | **471.74MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **534.63MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **118.42MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **119.06MB/s** | ➖                            | ➖                           | ➖                           |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD5           | **161.58MB/s** | 80.23MB/s <br> `101% slower`  | 127.70MB/s <br> `27% slower` | 98.07MB/s <br> `65% slower`  |
| HMAC(MD5)     | **129.45MB/s** | ➖                            | 106.28MB/s <br> `22% slower` | 72.41MB/s <br> `79% slower`  |
| SHA-1         | **131.47MB/s** | 50.05MB/s <br> `163% slower`  | 96.13MB/s <br> `37% slower`  | 47.31MB/s <br> `178% slower` |
| HMAC(SHA-1)   | **98.25MB/s**  | ➖                            | 69.93MB/s <br> `40% slower`  | ➖                           |
| SHA-224       | **88.27MB/s**  | 19.99MB/s <br> `341% slower`  | 81.18MB/s <br> `9% slower`   | 20.52MB/s <br> `330% slower` |
| SHA-256       | **88.17MB/s**  | 19.93MB/s <br> `342% slower`  | 81.11MB/s <br> `9% slower`   | 20.62MB/s <br> `327% slower` |
| HMAC(SHA-256) | **63.57MB/s**  | ➖                            | 58.88MB/s <br> `8% slower`   | ➖                           |
| SHA-384       | **130.47MB/s** | 4.46MB/s <br> `2825% slower`  | 46.76MB/s <br> `179% slower` | 19.61MB/s <br> `565% slower` |
| SHA-512       | **130.27MB/s** | 4.44MB/s <br> `2834% slower`  | 46.79MB/s <br> `178% slower` | 19.69MB/s <br> `562% slower` |
| SHA3-256      | **88.18MB/s**  | 3MB/s <br> `2835% slower`     | ➖                           | ➖                           |
| SHA3-512      | **129.73MB/s** | 1.59MB/s <br> `8028% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **191.74MB/s** | 41.07MB/s <br> `367% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **60.40MB/s**  | 26.46MB/s <br> `128% slower`  | ➖                           | 35.69MB/s <br> `69% slower`  |
| RIPEMD-256    | **208.81MB/s** | 40.60MB/s <br> `414% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **60.47MB/s**  | 25.77MB/s <br> `135% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **138.66MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **157.75MB/s** | 11.89MB/s <br> `1227% slower` | ➖                           | ➖                           |
| Poly1305      | **407.20MB/s** | 148.72MB/s <br> `174% slower` | ➖                           | ➖                           |
| XXH32         | **449.71MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **484.08MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **111.51MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **111.04MB/s** | ➖                            | ➖                           | ➖                           |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                 | `crypto`                    | `hash`                      |
| ------------- | -------------- | ------------------------------ | --------------------------- | --------------------------- |
| MD5           | **28.34MB/s**  | 14.11MB/s <br> `101% slower`   | 14.84MB/s <br> `91% slower` | 8.08MB/s <br> `251% slower` |
| HMAC(MD5)     | **5.23MB/s**   | ➖                             | 4.47MB/s <br> `17% slower`  | 2.12MB/s <br> `146% slower` |
| SHA-1         | **16.28MB/s**  | 7.77MB/s <br> `110% slower`    | 11.52MB/s <br> `41% slower` | 5.03MB/s <br> `224% slower` |
| HMAC(SHA-1)   | **2.66MB/s**   | ➖                             | 2.05MB/s <br> `30% slower`  | ➖                          |
| SHA-224       | **11.98MB/s**  | 3.22MB/s <br> `272% slower`    | 9.58MB/s <br> `25% slower`  | 2.73MB/s <br> `339% slower` |
| SHA-256       | **11.94MB/s**  | 3.18MB/s <br> `275% slower`    | 9.65MB/s <br> `24% slower`  | 2.75MB/s <br> `334% slower` |
| HMAC(SHA-256) | **1.87MB/s**   | ➖                             | 1.72MB/s <br> `8% slower`   | ➖                          |
| SHA-384       | **9.34MB/s**   | 387.94KB/s <br> `2366% slower` | 3.53MB/s <br> `164% slower` | 1.41MB/s <br> `563% slower` |
| SHA-512       | **9.24MB/s**   | 387.41KB/s <br> `2345% slower` | 3.52MB/s <br> `162% slower` | 1.42MB/s <br> `550% slower` |
| SHA3-256      | **11.89MB/s**  | 228.04KB/s <br> `5241% slower` | ➖                          | ➖                          |
| SHA3-512      | **9.23MB/s**   | 228.99KB/s <br> `4029% slower` | ➖                          | ➖                          |
| RIPEMD-128    | **27.95MB/s**  | 7MB/s <br> `299% slower`       | ➖                          | ➖                          |
| RIPEMD-160    | **9.38MB/s**   | 4.28MB/s <br> `119% slower`    | ➖                          | 4.29MB/s <br> `118% slower` |
| RIPEMD-256    | **28.46MB/s**  | 6.73MB/s <br> `322% slower`    | ➖                          | ➖                          |
| RIPEMD-320    | **9.23MB/s**   | 4.06MB/s <br> `127% slower`    | ➖                          | ➖                          |
| BLAKE-2s      | **18.85MB/s**  | ➖                             | ➖                          | ➖                          |
| BLAKE-2b      | **14.82MB/s**  | 904.52KB/s <br> `1578% slower` | ➖                          | ➖                          |
| Poly1305      | **59.63MB/s**  | 36.50MB/s <br> `63% slower`    | ➖                          | ➖                          |
| XXH32         | **100.03MB/s** | ➖                             | ➖                          | ➖                          |
| XXH64         | **76.53MB/s**  | ➖                             | ➖                          | ➖                          |
| XXH3          | **10.48MB/s**  | ➖                             | ➖                          | ➖                          |
| XXH128        | **9.86MB/s**   | ➖                             | ➖                          | ➖                          |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.058 ms | 1.464 ms | 11.0 ms   | 90.375 ms  | 1410.816 ms |
| argon2i    | 0.385 ms | 2.473 ms | 17.017 ms | 208.533 ms | 2481.148 ms |
| argon2d    | 0.281 ms | 2.416 ms | 17.501 ms | 206.161 ms | 2454.029 ms |
| argon2id   | 0.285 ms | 2.442 ms | 17.356 ms | 205.749 ms | 2512.451 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
