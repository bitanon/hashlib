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

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                      |
| ------------- | -------------- | ---------------------------- | ---------------------------- | --------------------------- |
| MD4           | **260.95MB/s** | 98.06MB/s <br> `2.66x slow`  |                              |                             |
| MD5           | **165.49MB/s** | 88.41MB/s <br> `1.87x slow`  | 137.71MB/s <br> `1.2x slow`  | 77.24MB/s <br> `2.14x slow` |
| HMAC(MD5)     | **159.15MB/s** |                              | 135.28MB/s <br> `1.18x slow` | 79.08MB/s <br> `2.01x slow` |
| SM3           | **84.25MB/s**  | 22.30MB/s <br> `3.78x slow`  |                              |                             |
| SHA-1         | **146.99MB/s** | 53.24MB/s <br> `2.76x slow`  | 102.99MB/s <br> `1.43x slow` | 44.74MB/s <br> `3.29x slow` |
| HMAC(SHA-1)   | **147.37MB/s** |                              | 102.43MB/s <br> `1.44x slow` |                             |
| SHA-224       | **98.53MB/s**  | 21.57MB/s <br> `4.57x slow`  | 89.08MB/s <br> `1.11x slow`  | 20.55MB/s <br> `4.79x slow` |
| SHA-256       | **98.58MB/s**  | 21.55MB/s <br> `4.57x slow`  | 89.21MB/s <br> `1.11x slow`  | 20.48MB/s <br> `4.81x slow` |
| HMAC(SHA-256) | **98.68MB/s**  |                              | 89.10MB/s <br> `1.11x slow`  |                             |
| SHA-384       | **156.57MB/s** | 5.48MB/s <br> `28.54x slow`  | 53.34MB/s <br> `2.94x slow`  | 18.15MB/s <br> `8.63x slow` |
| SHA-512       | **156.27MB/s** | 5.30MB/s <br> `29.45x slow`  | 53.25MB/s <br> `2.93x slow`  | 18.13MB/s <br> `8.62x slow` |
| SHA3-256      | **98.56MB/s**  | 3.24MB/s <br> `30.34x slow`  |                              |                             |
| SHA3-512      | **155.98MB/s** | 1.71MB/s <br> `91.08x slow`  |                              |                             |
| RIPEMD-128    | **207.04MB/s** | 45.51MB/s <br> `4.55x slow`  |                              |                             |
| RIPEMD-160    | **65.42MB/s**  | 27.69MB/s <br> `2.36x slow`  |                              | 33.79MB/s <br> `1.94x slow` |
| RIPEMD-256    | **223.38MB/s** | 45.38MB/s <br> `4.92x slow`  |                              |                             |
| RIPEMD-320    | **64.88MB/s**  | 27.04MB/s <br> `2.4x slow`   |                              |                             |
| BLAKE-2s      | **141.79MB/s** |                              |                              |                             |
| BLAKE-2b      | **163.03MB/s** | 12.21MB/s <br> `13.35x slow` |                              |                             |
| Poly1305      | **447.39MB/s** | 141.09MB/s <br> `3.17x slow` |                              |                             |
| XXH32         | **520.04MB/s** |                              |                              |                             |
| XXH64         | **539.56MB/s** |                              |                              |                             |
| XXH3          | **119.75MB/s** |                              |                              |                             |
| XXH128        | **119.03MB/s** |                              |                              |                             |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                      |
| ------------- | -------------- | ---------------------------- | ---------------------------- | --------------------------- |
| MD4           | **242.72MB/s** | 96.52MB/s <br> `2.51x slow`  |                              |                             |
| MD5           | **156.82MB/s** | 84.18MB/s <br> `1.86x slow`  | 129.30MB/s <br> `1.21x slow` | 99.80MB/s <br> `1.57x slow` |
| HMAC(MD5)     | **127.45MB/s** |                              | 107.01MB/s <br> `1.19x slow` | 74.70MB/s <br> `1.71x slow` |
| SM3           | **78.88MB/s**  | 20.90MB/s <br> `3.77x slow`  |                              |                             |
| SHA-1         | **137.49MB/s** | 50.40MB/s <br> `2.73x slow`  | 95.75MB/s <br> `1.44x slow`  | 48.46MB/s <br> `2.84x slow` |
| HMAC(SHA-1)   | **97.97MB/s**  |                              | 69.56MB/s <br> `1.41x slow`  |                             |
| SHA-224       | **91.17MB/s**  | 20.27MB/s <br> `4.5x slow`   | 83.17MB/s <br> `1.1x slow`   | 20.49MB/s <br> `4.45x slow` |
| SHA-256       | **91.06MB/s**  | 20.27MB/s <br> `4.49x slow`  | 83.12MB/s <br> `1.1x slow`   | 20.51MB/s <br> `4.44x slow` |
| HMAC(SHA-256) | **65.26MB/s**  |                              | 59.73MB/s <br> `1.09x slow`  |                             |
| SHA-384       | **135.47MB/s** | 4.91MB/s <br> `27.59x slow`  | 46.98MB/s <br> `2.88x slow`  | 19.74MB/s <br> `6.86x slow` |
| SHA-512       | **134.15MB/s** | 4.90MB/s <br> `27.32x slow`  | 46.75MB/s <br> `2.87x slow`  | 19.72MB/s <br> `6.8x slow`  |
| SHA3-256      | **89.06MB/s**  | 2.99MB/s <br> `29.73x slow`  |                              |                             |
| SHA3-512      | **134.18MB/s** | 1.60MB/s <br> `83.55x slow`  |                              |                             |
| RIPEMD-128    | **192.56MB/s** | 42.93MB/s <br> `4.49x slow`  |                              |                             |
| RIPEMD-160    | **60.60MB/s**  | 25.84MB/s <br> `2.34x slow`  |                              | 35.09MB/s <br> `1.73x slow` |
| RIPEMD-256    | **204MB/s**    | 42.50MB/s <br> `4.8x slow`   |                              |                             |
| RIPEMD-320    | **59.92MB/s**  | 25.14MB/s <br> `2.38x slow`  |                              |                             |
| BLAKE-2s      | **138.87MB/s** |                              |                              |                             |
| BLAKE-2b      | **158.64MB/s** | 12.01MB/s <br> `13.2x slow`  |                              |                             |
| Poly1305      | **425.11MB/s** | 140.06MB/s <br> `3.04x slow` |                              |                             |
| XXH32         | **494.65MB/s** |                              |                              |                             |
| XXH64         | **498.92MB/s** |                              |                              |                             |
| XXH3          | **111.20MB/s** |                              |                              |                             |
| XXH128        | **111.06MB/s** |                              |                              |                             |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | -------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **33.95MB/s**  | 16.83MB/s <br> `2.02x slow`   |                             |                            |
| MD5           | **29.82MB/s**  | 14.33MB/s <br> `2.08x slow`   | 14.92MB/s <br> `2x slow`    | 8.09MB/s <br> `3.69x slow` |
| HMAC(MD5)     | **5.41MB/s**   |                               | 4.58MB/s <br> `1.18x slow`  | 2.14MB/s <br> `2.52x slow` |
| SM3           | **12.11MB/s**  | 3.40MB/s <br> `3.56x slow`    |                             |                            |
| SHA-1         | **17.07MB/s**  | 7.71MB/s <br> `2.21x slow`    | 11.72MB/s <br> `1.46x slow` | 5.16MB/s <br> `3.31x slow` |
| HMAC(SHA-1)   | **2.68MB/s**   |                               | 2.10MB/s <br> `1.27x slow`  |                            |
| SHA-224       | **12.16MB/s**  | 3.23MB/s <br> `3.75x slow`    | 9.69MB/s <br> `1.25x slow`  | 2.68MB/s <br> `4.52x slow` |
| SHA-256       | **12.21MB/s**  | 3.24MB/s <br> `3.77x slow`    | 9.69MB/s <br> `1.26x slow`  | 2.72MB/s <br> `4.47x slow` |
| HMAC(SHA-256) | **1.87MB/s**   |                               | 1.76MB/s <br> `1.06x slow`  |                            |
| SHA-384       | **9.43MB/s**   | 430KB/s <br> `22.46x slow`    | 3.55MB/s <br> `2.65x slow`  | 1.41MB/s <br> `6.67x slow` |
| SHA-512       | **9.25MB/s**   | 429.68KB/s <br> `22.05x slow` | 3.53MB/s <br> `2.62x slow`  | 1.42MB/s <br> `6.49x slow` |
| SHA3-256      | **12.29MB/s**  | 233.73KB/s <br> `53.87x slow` |                             |                            |
| SHA3-512      | **9.35MB/s**   | 235.50KB/s <br> `40.66x slow` |                             |                            |
| RIPEMD-128    | **28.40MB/s**  | 7.29MB/s <br> `3.9x slow`     |                             |                            |
| RIPEMD-160    | **9.48MB/s**   | 4.16MB/s <br> `2.28x slow`    |                             | 4.21MB/s <br> `2.25x slow` |
| RIPEMD-256    | **28.74MB/s**  | 6.96MB/s <br> `4.13x slow`    |                             |                            |
| RIPEMD-320    | **9.29MB/s**   | 3.93MB/s <br> `2.36x slow`    |                             |                            |
| BLAKE-2s      | **18.71MB/s**  |                               |                             |                            |
| BLAKE-2b      | **15.09MB/s**  | 903.49KB/s <br> `17.11x slow` |                             |                            |
| Poly1305      | **64.56MB/s**  | 35.79MB/s <br> `1.8x slow`    |                             |                            |
| XXH32         | **100.48MB/s** |                               |                             |                            |
| XXH64         | **73.79MB/s**  |                               |                             |                            |
| XXH3          | **10.66MB/s**  |                               |                             |                            |
| XXH128        | **10.09MB/s**  |                               |                             |                            |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.057 ms | 1.507 ms | 10.907 ms | 87.509 ms  | 1412.755 ms |
| argon2i    | 0.395 ms | 2.761 ms | 17.238 ms | 200.692 ms | 2407.547 ms |
| argon2d    | 0.268 ms | 2.726 ms | 16.428 ms | 200.05 ms  | 2404.685 ms |
| argon2id   | 0.286 ms | 2.364 ms | 16.378 ms | 198.979 ms | 2433.166 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
