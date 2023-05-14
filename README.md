# hashlib

[![plugin version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dependencies](https://img.shields.io/badge/dependencies-zero-889)](https://github.com/dipu-bd/hashlib/blob/master/pubspec.yaml)
[![dart support](https://img.shields.io/badge/dart-%3e%3d%202.14.0-39f?logo=dart)](https://dart.dev/guides/whats-new#september-8-2021-214-release)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![popularity](https://img.shields.io/pub/popularity/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)

<!-- [![test](https://github.com/dipu-bd/hashlib/actions/workflows/test.yml/badge.svg)](https://github.com/dipu-bd/hashlib/actions/workflows/test.yml) -->

This library contains implementations of secure hash functions, checksum generators, and key derivation algorithms optimized for Dart.

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

### Other Hash Algorithms

| Algorithms | Available methods         | Source    |
| ---------- | ------------------------- | --------- |
| CRC        | `crc16`, `crc32`, `crc64` | Wikipedia |
| Alder32    | `alder32`                 | Wikipedia |

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

## Benchmarks

To obtain the following benchmarks, run this command:

```sh
dart compile exe ./benchmark/benchmark.dart && ./benchmark/benchmark.exe
```

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **158.25MB/s** | 120.80MB/s <br> `31% slower` | 69.00MB/s <br> `129% slower` | 79.41MB/s <br> `99% slower`   |
| HMAC(MD5)     | **159.98MB/s** | 121.65MB/s <br> `32% slower` | 69.45MB/s <br> `130% slower` | ➖                            |
| SHA-1         | **147.59MB/s** | 96.42MB/s <br> `53% slower`  | 41.19MB/s <br> `258% slower` | 53.58MB/s <br> `175% slower`  |
| HMAC(SHA-1)   | **149.01MB/s** | 96.20MB/s <br> `55% slower`  | ➖                           | ➖                            |
| SHA-224       | **98.60MB/s**  | 84.39MB/s <br> `17% slower`  | 20.12MB/s <br> `390% slower` | 21.03MB/s <br> `369% slower`  |
| SHA-256       | **97.51MB/s**  | 84.23MB/s <br> `16% slower`  | 20.22MB/s <br> `382% slower` | 20.77MB/s <br> `370% slower`  |
| HMAC(SHA-256) | **97.77MB/s**  | 83.36MB/s <br> `17% slower`  | ➖                           | ➖                            |
| SHA-384       | **156.34MB/s** | 49.44MB/s <br> `216% slower` | 17.51MB/s <br> `793% slower` | 5.12MB/s <br> `2955% slower`  |
| SHA-512       | **157.51MB/s** | 49.35MB/s <br> `219% slower` | 17.41MB/s <br> `805% slower` | 5.08MB/s <br> `2998% slower`  |
| SHA3-256      | **97.72MB/s**  | ➖                           | ➖                           | 3.13MB/s <br> `3019% slower`  |
| SHA3-512      | **153.92MB/s** | ➖                           | ➖                           | 1.66MB/s <br> `9174% slower`  |
| RIPEMD-128    | **200.03MB/s** | ➖                           | ➖                           | 45.51MB/s <br> `340% slower`  |
| RIPEMD-160    | **66.46MB/s**  | ➖                           | 31.73MB/s <br> `109% slower` | 26.87MB/s <br> `147% slower`  |
| RIPEMD-256    | **222.37MB/s** | ➖                           | ➖                           | 44.99MB/s <br> `394% slower`  |
| RIPEMD-320    | **66.47MB/s**  | ➖                           | ➖                           | 26.45MB/s <br> `151% slower`  |
| BLAKE-2s      | **142.38MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **163.08MB/s** | ➖                           | ➖                           | 12.02MB/s <br> `1256% slower` |
| Poly1305      | **354.80MB/s** | ➖                           | ➖                           | 152.52MB/s <br> `133% slower` |
| XXH32         | **493.59MB/s** | ➖                           | ➖                           | ➖                            |
| XXH64         | **501.26MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **102.48MB/s** | ➖                           | ➖                           | ➖                            |
| XXH128        | **103.29MB/s** | ➖                           | ➖                           | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **151.03MB/s** | 116.75MB/s <br> `29% slower` | 87.36MB/s <br> `73% slower`  | 76.49MB/s <br> `97% slower`   |
| HMAC(MD5)     | **115.39MB/s** | 93.47MB/s <br> `23% slower`  | 63.77MB/s <br> `81% slower`  | ➖                            |
| SHA-1         | **139.67MB/s** | 92.56MB/s <br> `51% slower`  | 45.23MB/s <br> `209% slower` | 50.75MB/s <br> `175% slower`  |
| HMAC(SHA-1)   | **92.06MB/s**  | 63.64MB/s <br> `45% slower`  | ➖                           | ➖                            |
| SHA-224       | **94.08MB/s**  | 79.64MB/s <br> `18% slower`  | 20.74MB/s <br> `354% slower` | 20.07MB/s <br> `369% slower`  |
| SHA-256       | **93.87MB/s**  | 79.67MB/s <br> `18% slower`  | 20.66MB/s <br> `354% slower` | 19.96MB/s <br> `370% slower`  |
| HMAC(SHA-256) | **61.69MB/s**  | 56.52MB/s <br> `9% slower`   | ➖                           | ➖                            |
| SHA-384       | **143.57MB/s** | 47.38MB/s <br> `203% slower` | 20.17MB/s <br> `612% slower` | 4.87MB/s <br> `2846% slower`  |
| SHA-512       | **144.20MB/s** | 46.81MB/s <br> `208% slower` | 20.64MB/s <br> `598% slower` | 4.87MB/s <br> `2860% slower`  |
| SHA3-256      | **92.60MB/s**  | ➖                           | ➖                           | 2.85MB/s <br> `3145% slower`  |
| SHA3-512      | **142.48MB/s** | ➖                           | ➖                           | 1.65MB/s <br> `8544% slower`  |
| RIPEMD-128    | **190.02MB/s** | ➖                           | ➖                           | 44.51MB/s <br> `327% slower`  |
| RIPEMD-160    | **65.02MB/s**  | ➖                           | 34.96MB/s <br> `86% slower`  | 26.57MB/s <br> `145% slower`  |
| RIPEMD-256    | **206.49MB/s** | ➖                           | ➖                           | 44.06MB/s <br> `369% slower`  |
| RIPEMD-320    | **64.46MB/s**  | ➖                           | ➖                           | 25.91MB/s <br> `149% slower`  |
| BLAKE-2s      | **136.29MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **150.38MB/s** | ➖                           | ➖                           | 11.48MB/s <br> `1209% slower` |
| Poly1305      | **279.10MB/s** | ➖                           | ➖                           | 149.49MB/s <br> `87% slower`  |
| XXH32         | **482.94MB/s** | ➖                           | ➖                           | ➖                            |
| XXH64         | **506.20MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **96.50MB/s**  | ➖                           | ➖                           | ➖                            |
| XXH128        | **96.85MB/s**  | ➖                           | ➖                           | ➖                            |

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`     | `crypto`                    | `hash`                      | `PointyCastle`                 |
| ------------- | ------------- | --------------------------- | --------------------------- | ------------------------------ |
| MD5           | **22.52MB/s** | 9.59MB/s <br> `135% slower` | 6.23MB/s <br> `262% slower` | 11.56MB/s <br> `95% slower`    |
| HMAC(MD5)     | **3.85MB/s**  | 3.66MB/s <br> `5% slower`   | 1.75MB/s <br> `121% slower` | ➖                             |
| SHA-1         | **16.94MB/s** | 8.34MB/s <br> `103% slower` | 4.23MB/s <br> `300% slower` | 7.39MB/s <br> `129% slower`    |
| HMAC(SHA-1)   | **2.43MB/s**  | 1.84MB/s <br> `32% slower`  | ➖                          | ➖                             |
| SHA-224       | **12.15MB/s** | 7.18MB/s <br> `69% slower`  | 2.36MB/s <br> `415% slower` | 3.10MB/s <br> `292% slower`    |
| SHA-256       | **12.09MB/s** | 7.17MB/s <br> `69% slower`  | 2.45MB/s <br> `393% slower` | 3.07MB/s <br> `295% slower`    |
| HMAC(SHA-256) | **1.60MB/s**  | 1.57MB/s <br> `2% slower`   | ➖                          | ➖                             |
| SHA-384       | **9.34MB/s**  | 2.90MB/s <br> `222% slower` | 1.27MB/s <br> `635% slower` | 380.63KB/s <br> `2355% slower` |
| SHA-512       | **9.36MB/s**  | 2.91MB/s <br> `221% slower` | 1.19MB/s <br> `686% slower` | 378.06KB/s <br> `2376% slower` |
| SHA3-256      | **11.95MB/s** | ➖                          | ➖                          | 219.64KB/s <br> `5343% slower` |
| SHA3-512      | **9.51MB/s**  | ➖                          | ➖                          | 219.20KB/s <br> `4238% slower` |
| RIPEMD-128    | **22.09MB/s** | ➖                          | ➖                          | 6.91MB/s <br> `220% slower`    |
| RIPEMD-160    | **8.67MB/s**  | ➖                          | 3.47MB/s <br> `150% slower` | 4.07MB/s <br> `113% slower`    |
| RIPEMD-256    | **23.23MB/s** | ➖                          | ➖                          | 6.71MB/s <br> `246% slower`    |
| RIPEMD-320    | **8.59MB/s**  | ➖                          | ➖                          | 3.88MB/s <br> `122% slower`    |
| BLAKE-2s      | **15.12MB/s** | ➖                          | ➖                          | ➖                             |
| BLAKE-2b      | **12.71MB/s** | ➖                          | ➖                          | 833.86KB/s <br> `1424% slower` |
| Poly1305      | **58.75MB/s** | ➖                          | ➖                          | 27.05MB/s <br> `117% slower`   |
| XXH32         | **87.41MB/s** | ➖                          | ➖                          | ➖                             |
| XXH64         | **67.40MB/s** | ➖                          | ➖                          | ➖                             |
| XXH3          | **8.56MB/s**  | ➖                          | ➖                          | ➖                             |
| XXH128        | **8.42MB/s**  | ➖                          | ➖                          | ➖                             |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.085 ms | 2.175 ms | 16.255 ms | 133.4 ms   | 2063.649 ms |
| argon2i    | 0.397 ms | 2.815 ms | 18.094 ms | 210.069 ms | 2465.087 ms |
| argon2d    | 0.368 ms | 2.523 ms | 17.282 ms | 205.491 ms | 2408.582 ms |
| argon2id   | 0.348 ms | 2.554 ms | 16.843 ms | 204.145 ms | 2435.409 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
