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
import 'package:hashlib/src/codecs_base.dart';

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
| XXH64         | **503.64MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **105.12MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **161.28MB/s** | 121.66MB/s <br> `33% slower` | 69.32MB/s <br> `133% slower` | 81.18MB/s <br> `99% slower`   |
| SHA-1         | **148.14MB/s** | 96.11MB/s <br> `54% slower`  | 37.83MB/s <br> `292% slower` | 55.12MB/s <br> `169% slower`  |
| SHA-224       | **100.14MB/s** | 84.14MB/s <br> `19% slower`  | 19.79MB/s <br> `406% slower` | 21.66MB/s <br> `362% slower`  |
| SHA-256       | **100.55MB/s** | 84.38MB/s <br> `19% slower`  | 19.83MB/s <br> `407% slower` | 21.79MB/s <br> `361% slower`  |
| SHA-384       | **157.21MB/s** | 48.19MB/s <br> `226% slower` | 17.82MB/s <br> `782% slower` | 5.19MB/s <br> `2927% slower`  |
| SHA-512       | **157.13MB/s** | 48.30MB/s <br> `225% slower` | 17.93MB/s <br> `776% slower` | 5.19MB/s <br> `2929% slower`  |
| SHA3-256      | **99.89MB/s**  | ➖                           | ➖                           | 3.18MB/s <br> `3044% slower`  |
| SHA3-512      | **157.45MB/s** | ➖                           | ➖                           | 1.71MB/s <br> `9127% slower`  |
| BLAKE-2s      | **144.42MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **164.61MB/s** | ➖                           | ➖                           | 12.62MB/s <br> `1204% slower` |
| HMAC(MD5)     | **161.72MB/s** | 120.11MB/s <br> `35% slower` | 70.40MB/s <br> `130% slower` | ➖                            |
| HMAC(SHA-1)   | **147.08MB/s** | 95.05MB/s <br> `55% slower`  | ➖                           |                               |
| HMAC(SHA-256) | **100.12MB/s** | 83.03MB/s <br> `21% slower`  | ➖                           | ➖                            |
| Poly1305      | **402.19MB/s** | ➖                           | ➖                           | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **454.17MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **97.26MB/s**  | ➖                           | ➖                           | ➖                            |
| MD5           | **155.91MB/s** | 119.53MB/s <br> `30% slower` | 91.58MB/s <br> `70% slower`  | 79.03MB/s <br> `97% slower`   |
| SHA-1         | **140.87MB/s** | 93.64MB/s <br> `50% slower`  | 46.09MB/s <br> `206% slower` | 54.30MB/s <br> `159% slower`  |
| SHA-224       | **96.18MB/s**  | 81.33MB/s <br> `18% slower`  | 20.67MB/s <br> `365% slower` | 20.86MB/s <br> `361% slower`  |
| SHA-256       | **96.18MB/s**  | 81.39MB/s <br> `18% slower`  | 20.67MB/s <br> `365% slower` | 21.26MB/s <br> `352% slower`  |
| SHA-384       | **145.70MB/s** | 46.59MB/s <br> `213% slower` | 21.52MB/s <br> `577% slower` | 5.09MB/s <br> `2762% slower`  |
| SHA-512       | **143.40MB/s** | 46.40MB/s <br> `209% slower` | 21.62MB/s <br> `563% slower` | 5.07MB/s <br> `2729% slower`  |
| SHA3-256      | **96.15MB/s**  | ➖                           | ➖                           | 2.97MB/s <br> `3136% slower`  |
| SHA3-512      | **143.89MB/s** | ➖                           | ➖                           | 1.70MB/s <br> `8346% slower`  |
| BLAKE-2s      | **136.61MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **154.86MB/s** | ➖                           | ➖                           | 12.28MB/s <br> `1161% slower` |
| HMAC(MD5)     | **123.84MB/s** | 94.08MB/s <br> `32% slower`  | 68.14MB/s <br> `82% slower`  | ➖                            |
| HMAC(SHA-1)   | **92.13MB/s**  | 64.98MB/s <br> `42% slower`  | ➖                           | ➖                            |
| HMAC(SHA-256) | **67.95MB/s**  | 56.12MB/s <br> `21% slower`  | ➖                           | ➖                            |
| Poly1305      | **385.58MB/s** | ➖                           | ➖                           | ➖                            |

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                      | `PointyCastle`                 |
| ------------- | ------------- | ---------------------------- | --------------------------- | ------------------------------ |
| XXH64         | **67.44MB/s** | ➖                           | ➖                          | ➖                             |
| XXH3          | **8.53MB/s**  | ➖                           | ➖                          | ➖                             |
| MD5           | **23.28MB/s** | 10.14MB/s <br> `130% slower` | 7.36MB/s <br> `216% slower` | 11.44MB/s <br> `103% slower`   |
| SHA-1         | **16.89MB/s** | 8.59MB/s <br> `97% slower`   | 4.77MB/s <br> `254% slower` | 7.43MB/s <br> `127% slower`    |
| SHA-224       | **12.21MB/s** | 7.32MB/s <br> `67% slower`   | 2.61MB/s <br> `367% slower` | 3.11MB/s <br> `292% slower`    |
| SHA-256       | **12.27MB/s** | 7.21MB/s <br> `70% slower`   | 2.62MB/s <br> `368% slower` | 3.13MB/s <br> `292% slower`    |
| SHA-384       | **9.48MB/s**  | 2.90MB/s <br> `227% slower`  | 1.34MB/s <br> `610% slower` | 386.20KB/s <br> `2355% slower` |
| SHA-512       | **9.49MB/s**  | 2.89MB/s <br> `228% slower`  | 1.35MB/s <br> `601% slower` | 384.32KB/s <br> `2370% slower` |
| SHA3-256      | **12.35MB/s** | ➖                           | ➖                          | 228.76KB/s <br> `5301% slower` |
| SHA3-512      | **9.50MB/s**  | ➖                           | ➖                          | 228.29KB/s <br> `4061% slower` |
| BLAKE-2s      | **15.14MB/s** | ➖                           | ➖                          | ➖                             |
| BLAKE-2b      | **13.05MB/s** | ➖                           | ➖                          | 884.35KB/s <br> `1376% slower` |
| HMAC(MD5)     | **4.77MB/s**  | 3.75MB/s <br> `27% slower`   | 1.95MB/s <br> `144% slower` | ➖                             |
| HMAC(SHA-1)   | **2.46MB/s**  | 1.85MB/s <br> `33% slower`   | ➖                          | ➖                             |
| HMAC(SHA-256) | **1.93MB/s**  | 1.60MB/s <br> `21% slower`   | ➖                          | ➖                             |
| Poly1305      | **67.55MB/s** | ➖                           | ➖                          | ➖                             |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 1.77 ms  | 3.053 ms | 16.9 ms   | 132.935 ms | 1979.908 ms |
| argon2i    | 0.374 ms | 2.811 ms | 15.478 ms | 192.085 ms | 2346.343 ms |
| argon2d    | 0.385 ms | 2.66 ms  | 15.341 ms | 191.056 ms | 2328.332 ms |
| argon2id   | 0.349 ms | 2.426 ms | 15.989 ms | 186.398 ms | 2369.287 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
