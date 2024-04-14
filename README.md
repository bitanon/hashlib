# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dart support](https://img.shields.io/badge/dart-%3e%3d%202.14.0-39f?logo=dart)](https://dart.dev/guides/whats-new#september-8-2021-214-release)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)

<!-- [![test](https://github.com/bitanon/hashlib/actions/workflows/test.yml/badge.svg)](https://github.com/bitanon/hashlib/actions/workflows/test.yml) -->

This library contains implementations of secure hash functions, checksum generators, and key derivation algorithms optimized for Dart.

> Checkout the [hashlib_codecs](https://pub.dev/packages/hashlib_codecs) that is being used by this package to encode and decode bytes.

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

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **174.11MB/s** | 143.99MB/s <br> `21% slower` | 80.43MB/s <br> `116% slower` | 87.90MB/s <br> `98% slower`   |
| HMAC(MD5)     | **172.75MB/s** | 140.49MB/s <br> `23% slower` | 79.53MB/s <br> `117% slower` | ➖                            |
| SHA-1         | **153.75MB/s** | 108.64MB/s <br> `42% slower` | 45.37MB/s <br> `239% slower` | 55.91MB/s <br> `175% slower`  |
| HMAC(SHA-1)   | **153.63MB/s** | 106.20MB/s <br> `45% slower` | ➖                           | ➖                            |
| SHA-224       | **102.70MB/s** | 93.48MB/s <br> `10% slower`  | 21.72MB/s <br> `373% slower` | 22.20MB/s <br> `363% slower`  |
| SHA-256       | **102.90MB/s** | 93.52MB/s <br> `10% slower`  | 21.72MB/s <br> `374% slower` | 22.43MB/s <br> `359% slower`  |
| HMAC(SHA-256) | **102.74MB/s** | 93.22MB/s <br> `10% slower`  | ➖                           | ➖                            |
| SHA-384       | **164.65MB/s** | 54.65MB/s <br> `201% slower` | 18.71MB/s <br> `780% slower` | 5.07MB/s <br> `3150% slower`  |
| SHA-512       | **164.56MB/s** | 54.62MB/s <br> `201% slower` | 19.07MB/s <br> `763% slower` | 5.20MB/s <br> `3065% slower`  |
| SHA3-256      | **102.93MB/s** | ➖                           | ➖                           | 3.31MB/s <br> `3009% slower`  |
| SHA3-512      | **164.45MB/s** | ➖                           | ➖                           | 1.76MB/s <br> `9238% slower`  |
| RIPEMD-128    | **220.20MB/s** | ➖                           | ➖                           | 45.66MB/s <br> `382% slower`  |
| RIPEMD-160    | **69.18MB/s**  | ➖                           | 35.07MB/s <br> `97% slower`  | 28.70MB/s <br> `141% slower`  |
| RIPEMD-256    | **237.84MB/s** | ➖                           | ➖                           | 44.92MB/s <br> `429% slower`  |
| RIPEMD-320    | **69.01MB/s**  | ➖                           | ➖                           | 28.29MB/s <br> `144% slower`  |
| BLAKE-2s      | **149.47MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **170.34MB/s** | ➖                           | ➖                           | 12.93MB/s <br> `1218% slower` |
| Poly1305      | **425.28MB/s** | ➖                           | ➖                           | 160.07MB/s <br> `166% slower` |
| XXH32         | **545.26MB/s** | ➖                           | ➖                           | ➖                            |
| XXH64         | **540.75MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **124.28MB/s** | ➖                           | ➖                           | ➖                            |
| XXH128        | **125.25MB/s** | ➖                           | ➖                           | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **173.02MB/s** | 139.81MB/s <br> `24% slower` | 107.34MB/s <br> `61% slower` | 84.78MB/s <br> `104% slower`  |
| HMAC(MD5)     | **137.62MB/s** | 114.52MB/s <br> `20% slower` | 79.88MB/s <br> `72% slower`  | ➖                            |
| SHA-1         | **141.82MB/s** | 106.40MB/s <br> `33% slower` | 52.16MB/s <br> `172% slower` | 54.26MB/s <br> `161% slower`  |
| HMAC(SHA-1)   | **101.76MB/s** | 74.43MB/s <br> `37% slower`  | ➖                           | ➖                            |
| SHA-224       | **98.85MB/s**  | 90.34MB/s <br> `9% slower`   | 22.61MB/s <br> `337% slower` | 21.64MB/s <br> `357% slower`  |
| SHA-256       | **98.12MB/s**  | 90.34MB/s <br> `9% slower`   | 22.64MB/s <br> `333% slower` | 21.77MB/s <br> `351% slower`  |
| HMAC(SHA-256) | **69.03MB/s**  | 63.06MB/s <br> `9% slower`   | ➖                           | ➖                            |
| SHA-384       | **152.64MB/s** | 52.18MB/s <br> `192% slower` | 22.93MB/s <br> `566% slower` | 5.11MB/s <br> `2890% slower`  |
| SHA-512       | **151.24MB/s** | 52.18MB/s <br> `190% slower` | 22.62MB/s <br> `569% slower` | 5.11MB/s <br> `2861% slower`  |
| SHA3-256      | **98.23MB/s**  | ➖                           | ➖                           | 3.11MB/s <br> `3054% slower`  |
| SHA3-512      | **151.52MB/s** | ➖                           | ➖                           | 1.79MB/s <br> `8377% slower`  |
| RIPEMD-128    | **211.29MB/s** | ➖                           | ➖                           | 44.55MB/s <br> `374% slower`  |
| RIPEMD-160    | **66.85MB/s**  | ➖                           | 37.83MB/s <br> `77% slower`  | 27.78MB/s <br> `141% slower`  |
| RIPEMD-256    | **224.34MB/s** | ➖                           | ➖                           | 43.38MB/s <br> `417% slower`  |
| RIPEMD-320    | **67.03MB/s**  | ➖                           | ➖                           | 27.39MB/s <br> `145% slower`  |
| BLAKE-2s      | **144.01MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **163.75MB/s** | ➖                           | ➖                           | 12.47MB/s <br> `1213% slower` |
| Poly1305      | **397.65MB/s** | ➖                           | ➖                           | 154.36MB/s <br> `158% slower` |
| XXH32         | **506.25MB/s** | ➖                           | ➖                           | ➖                            |
| XXH64         | **509.56MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **117.56MB/s** | ➖                           | ➖                           | ➖                            |
| XXH128        | **118.76MB/s** | ➖                           | ➖                           | ➖                            |

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`     | `crypto`                    | `hash`                      | `PointyCastle`                 |
| ------------- | ------------- | --------------------------- | --------------------------- | ------------------------------ |
| MD5           | **30.58MB/s** | 15.67MB/s <br> `95% slower` | 8.53MB/s <br> `259% slower` | 15.01MB/s <br> `104% slower`   |
| HMAC(MD5)     | **5.52MB/s**  | 4.79MB/s <br> `15% slower`  | 2.24MB/s <br> `146% slower` | ➖                             |
| SHA-1         | **18.29MB/s** | 12.38MB/s <br> `48% slower` | 5.37MB/s <br> `240% slower` | 8.27MB/s <br> `121% slower`    |
| HMAC(SHA-1)   | **2.84MB/s**  | 2.26MB/s <br> `26% slower`  | ➖                          | ➖                             |
| SHA-224       | **12.84MB/s** | 10.27MB/s <br> `25% slower` | 2.85MB/s <br> `351% slower` | 3.35MB/s <br> `284% slower`    |
| SHA-256       | **12.69MB/s** | 10.24MB/s <br> `24% slower` | 2.90MB/s <br> `338% slower` | 3.42MB/s <br> `272% slower`    |
| HMAC(SHA-256) | **1.99MB/s**  | 1.86MB/s <br> `7% slower`   | ➖                          | ➖                             |
| SHA-384       | **9.92MB/s**  | 3.68MB/s <br> `170% slower` | 1.49MB/s <br> `566% slower` | 392.98KB/s <br> `2424% slower` |
| SHA-512       | **9.88MB/s**  | 3.65MB/s <br> `171% slower` | 1.50MB/s <br> `558% slower` | 394.32KB/s <br> `2405% slower` |
| SHA3-256      | **12.81MB/s** | ➖                          | ➖                          | 241.30KB/s <br> `5210% slower` |
| SHA3-512      | **9.87MB/s**  | ➖                          | ➖                          | 241.88KB/s <br> `3981% slower` |
| RIPEMD-128    | **30.10MB/s** | ➖                          | ➖                          | 7.45MB/s <br> `304% slower`    |
| RIPEMD-160    | **10.05MB/s** | ➖                          | 4.45MB/s <br> `126% slower` | 4.38MB/s <br> `129% slower`    |
| RIPEMD-256    | **29.99MB/s** | ➖                          | ➖                          | 7.08MB/s <br> `324% slower`    |
| RIPEMD-320    | **9.90MB/s**  | ➖                          | ➖                          | 4.17MB/s <br> `137% slower`    |
| BLAKE-2s      | **20.02MB/s** | ➖                          | ➖                          | ➖                             |
| BLAKE-2b      | **15.73MB/s** | ➖                          | ➖                          | 935.11KB/s <br> `1582% slower` |
| Poly1305      | **64.28MB/s** | ➖                          | ➖                          | 39.51MB/s <br> `63% slower`    |
| XXH32         | **94.21MB/s** | ➖                          | ➖                          | ➖                             |
| XXH64         | **76.44MB/s** | ➖                          | ➖                          | ➖                             |
| XXH3          | **11.31MB/s** | ➖                          | ➖                          | ➖                             |
| XXH128        | **10.92MB/s** | ➖                          | ➖                          | ➖                             |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.057 ms | 1.459 ms | 10.938 ms | 88.672 ms  | 1391.994 ms |
| argon2i    | 0.358 ms | 2.763 ms | 16.825 ms | 203.519 ms | 2412.874 ms |
| argon2d    | 0.276 ms | 2.355 ms | 16.496 ms | 200.327 ms | 2398.527 ms |
| argon2id   | 0.308 ms | 2.382 ms | 16.928 ms | 200.221 ms | 2415.853 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
