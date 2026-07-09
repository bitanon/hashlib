# hashlib

[![package version](https://img.shields.io/pub/v/hashlib?label=pub)](https://pub.dev/packages/hashlib)
[![dart support](https://img.shields.io/badge/dart-%3E%3D%202.19.0-0175C2?logo=dart&logoColor=white)](https://dart.dev/guides/whats-new)
[![likes](https://img.shields.io/pub/likes/hashlib?logo=dart)](https://pub.dev/packages/hashlib/score)
[![pub points](https://img.shields.io/pub/points/hashlib?logo=dart&color=teal)](https://pub.dev/packages/hashlib/score)
[![codecov](https://codecov.io/gh/bitanon/hashlib/branch/master/graph/badge.svg?token=PYVMZWSQNU)](https://codecov.io/gh/bitanon/hashlib)
[![Test](https://github.com/bitanon/hashlib/actions/workflows/test.yml/badge.svg?branch=master)](https://github.com/bitanon/hashlib/actions/workflows/test.yml)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/bitanon/hashlib)

A pure-Dart library of secure hash functions, checksums, MACs, key-derivation
functions, OTP generators, and secure random — a broad, fast, dependency-light
toolbox that runs everywhere Dart does.

`hashlib` is the middle layer of a three-package family:

[![convertlib](https://img.shields.io/badge/convertlib-informational?style=for-the-badge&logo=dart)](https://pub.dev/packages/convertlib) &rarr; [![hashlib](https://img.shields.io/badge/hashlib-success?style=for-the-badge&logo=dart)](https://pub.dev/packages/hashlib) &rarr; [![cipherlib](https://img.shields.io/badge/cipherlib-blue?style=for-the-badge&logo=dart)](https://pub.dev/packages/cipherlib)

It builds on `convertlib` for hex, Base32/Base64, and UTF-8 conversion, and
that is its only runtime dependency.

## Highlights

- **Runs on every platform**: pure Dart with no native code or FFI, so the same
  library works everywhere Dart does — the VM, Flutter (Android, iOS, Windows,
  macOS, Linux), and the web (dart2js and dart2wasm).
- **Batteries included**: over a dozen hash families (MD, SHA-1, SHA-2, SHA-3,
  SHAKE, Keccak, BLAKE2, RIPEMD, SM3, xxHash), checksums (CRC, Adler-32), MACs
  (HMAC, Poly1305), password KDFs (Argon2, scrypt, bcrypt, PBKDF2), TOTP/HOTP,
  and RNG/UUID generators.
- **One-shot or streaming**: hash a `String` or byte buffer in a single call,
  or feed data incrementally through a reusable sink for large or chunked input.
- **Password-grade KDFs**: Argon2id, scrypt, bcrypt, and PBKDF2 with named
  `security` presets that make the cost/latency trade-off explicit.
- **Fast**: consistently outruns `crypto`, `PointyCastle`, and `hash`, see the
  [benchmarks](#benchmarks) below.
- **Codecs and secure random built in**: companion `codecs` and `random`
  libraries ship in the same package.

## Install

```yaml
dependencies:
  hashlib: ^2.4.2
```

or run `dart pub add hashlib`. A single import exposes every algorithm:

```dart
import 'package:hashlib/hashlib.dart';
```

Two companion libraries pair well with it — `codecs` for hex/Base/UTF-8
conversion (re-exported from `convertlib`) and `random` for secure random bytes,
numbers, and UUIDs:

```dart
import 'package:hashlib/codecs.dart'; // toHex, fromHex, toBase64, toUtf8
import 'package:hashlib/random.dart'; // randomBytes, uuid, HashlibRandom
```

Full API reference:
[hashlib library](https://pub.dev/documentation/hashlib/latest/).

## Quickstart

Compute a digest of a string in one call, and derive an HMAC from any hash by
attaching a key:

```dart
import 'package:hashlib/hashlib.dart';

void main() {
  final text = 'Happy Hashing!';

  // One-shot hex digest
  print(sha256.string(text));

  // Keyed HMAC-SHA256
  print(sha256.hmac.byString('password').string(text));
}
```

## Supported algorithms

### Block hash algorithms

| Algorithm   | Available methods                                                  |         Source         |
| ----------- | ------------------------------------------------------------------ | :--------------------: |
| MD2         | `md2`, `md2sum`                                                    |       [RFC-1319]       |
| MD4         | `md4`, `md4sum`                                                    |       [RFC-1320]       |
| MD5         | `md5`, `md5sum`                                                    |       [RFC-1321]       |
| SHA-1       | `sha1`, `sha1sum`                                                  |       [RFC-3174]       |
| SHA-2       | `sha224`, `sha256`, `sha384`, `sha512`, `sha512t224`, `sha512t256` |       [RFC-6234]       |
| SHA-3       | `sha3_224`, `sha3_256`, `sha3_384`, `sha3_512`                     |       [FIPS-202]       |
| SHAKE-128   | `Shake128`, `shake128`, `shake128_128`, `shake128_256`             |       [FIPS-202]       |
| SHAKE-256   | `Shake256`, `shake256`, `shake256_256`, `shake256_512`             |       [FIPS-202]       |
| Keccak      | `keccak224`, `keccak256`, `keccak384`, `keccak512`                 |     [Team Keccak]      |
| Blake2b     | `blake2b160`, `blake2b256`, `blake2b384`, `blake2b512`             |       [RFC-7693]       |
| Blake2s     | `blake2s128`, `blake2s160`, `blake2s224`, `blake2s256`             |       [RFC-7693]       |
| xxHash-32   | `XXHash32`, `xxh32`, `xxh32code`                                   |       [Cyan4973]       |
| xxHash-64   | `XXHash64`, `xxh64`, `xxh64code`                                   |       [Cyan4973]       |
| xxHash3-64  | `XXH3`, `xxh3`, `xxh3code`                                         |       [Cyan4973]       |
| xxHash3-128 | `XXH128`, `xxh128`, `xxh128code`                                   |       [Cyan4973]       |
| RIPEMD      | `ripemd128`, `ripemd256`, `ripemd160`, `ripemd320`                 | [ISO/IEC 10118-3:2018] |
| SM3         | `sm3`, `sm3sum`                                                    |   [GB/T 32905-2016]    |

> **Note**: `XXHash64`, `XXH3`, and `XXH128` are not supported on the web
> platform. They throw `UnimplementedError` when used there.

### Password / key derivation algorithms

| Algorithm | Available methods                                                | Source     |
| --------- | ---------------------------------------------------------------- | ---------- |
| Argon2    | `Argon2`, `argon2d`, `argon2i`, `argon2id`, `argon2Verify`       | [RFC-9106] |
| PBKDF2    | `PBKDF2`, `pbkdf2`, `#.pbkdf2`                                   | [RFC-8081] |
| scrypt    | `Scrypt`, `scrypt`                                               | [RFC-7914] |
| bcrypt    | `Bcrypt`, `bcrypt`, `bcryptSalt`, `bcryptVerify`, `bcryptDigest` |            |

### Message authentication codes (MAC)

| Algorithm | Available methods                      | Source     |
| --------- | -------------------------------------- | ---------- |
| HMAC      | `HMAC`, `#.hmac`                       | [RFC-2104] |
| Poly1305  | `Poly1305`, `poly1305`, `poly1305auth` | [RFC-8439] |

### One-time passwords (2FA)

| Algorithm | Available methods | Source     |
| --------- | ----------------- | ---------- |
| HOTP      | `HOTP`            | [RFC-4226] |
| TOTP      | `TOTP`            | [RFC-6238] |

### Checksums

| Algorithm | Available methods         | Source             |
| --------- | ------------------------- | ------------------ |
| CRC       | `crc16`, `crc32`, `crc64` | [Wikipedia][crc]   |
| Adler-32  | `adler32`                 | [Wikipedia][adler] |

### Random and UUID

The `random` library provides random number generators through `HashlibRandom`
(`secure`, `system`, `keccak`, `sha256`, `md5`, `xxh64`, `sm3`), plus helpers
like `randomBytes`, `randomNumbers`, and `randomString`. UUID versions v1, v3,
v4, v5, v6, v7, and v8 are available through `uuid`.

<!-- Sources referenced in the tables above -->

[RFC-1319]: https://datatracker.ietf.org/doc/html/rfc1319
[RFC-1320]: https://datatracker.ietf.org/doc/html/rfc1320
[RFC-1321]: https://datatracker.ietf.org/doc/html/rfc1321
[RFC-3174]: https://datatracker.ietf.org/doc/html/rfc3174
[RFC-6234]: https://datatracker.ietf.org/doc/html/rfc6234
[FIPS-202]: https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.202.pdf
[Team Keccak]: https://keccak.team/
[RFC-7693]: https://datatracker.ietf.org/doc/html/rfc7693
[Cyan4973]: https://github.com/Cyan4973/xxHash
[ISO/IEC 10118-3:2018]: https://www.iso.org/standard/67116.html
[GB/T 32905-2016]: https://www.codeofchina.com/standard/GBT32905-2016.html
[RFC-9106]: https://datatracker.ietf.org/doc/html/rfc9106
[RFC-8081]: https://datatracker.ietf.org/doc/html/rfc8081
[RFC-7914]: https://datatracker.ietf.org/doc/html/rfc7914
[RFC-2104]: https://datatracker.ietf.org/doc/html/rfc2104
[RFC-8439]: https://datatracker.ietf.org/doc/html/rfc8439
[RFC-4226]: https://datatracker.ietf.org/doc/html/rfc4226
[RFC-6238]: https://datatracker.ietf.org/doc/html/rfc6238
[crc]: https://en.wikipedia.org/wiki/Cyclic_redundancy_check
[adler]: https://en.wikipedia.org/wiki/Adler-32

## Security notes

- **Hash passwords with a KDF, not a bare hash.** Store `argon2id` (or `scrypt`
  / `bcrypt`) output with an appropriate `security` preset — never a plain
  `sha256` of a password — and check it with `argon2Verify` / `bcryptVerify`.
- **Compare digests in constant time.** Use `HashDigest.isEqual` when verifying
  MACs and digests instead of `==` or a manual byte loop, to avoid leaking
  information through timing.
- **Legacy algorithms are for compatibility only.** MD2, MD4, MD5, and SHA-1
  are cryptographically broken; use them only for interop or non-security
  checksums, and prefer SHA-256, SHA-3, or BLAKE2 for new work.
- **Non-cryptographic hashes.** CRC, Adler-32, and the xxHash family are fast
  integrity and lookup hashes, not secure against adversaries — do not use them
  where collision or preimage resistance matters.
- **Runtime timing.** Pure-Dart execution (JIT, AOT, dart2js) is not guaranteed
  to run in constant time; weigh the deployment environment before relying on it
  in side-channel-sensitive settings.

## Testing and reliability

Correctness is the first-order goal of this library, and the test suite is built
to enforce it. There are **700 test cases across 60+ files**` that runs after
every change and before each release across **three platforms: the Dart VM,
Node.js, and Chrome (WASM)**.

Every algorithm is checked in several independent ways:

- **Official known-answer vectors.** Digests are pinned against the published
  test vectors from the relevant standard — RFCs, FIPS/NIST publications, and
  each algorithm's reference implementation. Expected values are never invented;
  each vector cites its source in the test file.
- **Differential cross-validation.** For every algorithm that a mature,
  independent Dart package also implements, the output is compared byte-for-byte
  against [`crypto`][crypto] and [`pointycastle`][pointycastle] over hundreds
  of random inputs. This currently covers MD2, MD4, MD5, SHA-1,
  SHA-224/256/384/512, SHA-512/224, SHA-512/256, SHA3 (224–512), Keccak
  (224–512), RIPEMD-128/160/256/320, BLAKE2b, SM3, and HMAC. A subtle
  divergence in padding, endianness, or a block boundary would fail these tests
  even if it slipped past a fixed vector.
- **Boundary and edge coverage.** Inputs are exercised at the empty string,
  single bytes, and lengths straddling each algorithm's internal block/rate
  size (e.g. `block−1`, `block`, `block+1`, and multi-block messages) - the
  exact places where length-encoding and padding bugs hide.
- **Streaming equals one-shot.** Chunked/streamed input and the incremental
  `Sink` API (including `reset()`, double-`close()`, and use-after-close) are
  verified to produce identical digests to the one-shot path.
- **Argument validation.** Invalid key, salt, digest, and parameter lengths are
  asserted to throw typed errors rather than silently producing weak output.

The algorithms compute exactly what their standards define,
verified against official vectors and multiple independent
implementations.
Please still read the [Security notes](#security-notes) above:
choose the right primitive for your threat model (a KDF for passwords, a
cryptographic hash rather than a checksum where an adversary is involved),
and note that pure-Dart execution makes no hard constant-time guarantee.

You can reproduce all of this locally:

```sh
dart test              # vm, node, and chrome
dart test -p vm        # fast, VM-only iteration
```

[crypto]: https://pub.dev/packages/crypto
[pointycastle]: https://pub.dev/packages/pointycastle

## Recipes

Runnable programs for every snippet below live in the
[example](https://github.com/bitanon/hashlib/tree/master/example) folder.

### Hashing, checksums, MAC, and OTP

<!-- file: example/hashlib_example.dart -->

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
  print('Adler32 => ${adler32code(text)}');
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
  print('SM3 => ${sm3.string(text)}');
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

<!-- file: example/hashlib_example.dart -->

### Password and key derivation

<!-- file: example/keygen_example.dart -->

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

<!-- file: example/keygen_example.dart -->

### Secure random and UUID

<!-- file: example/random_example.dart -->

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

<!-- file: example/random_example.dart -->

## Benchmarks

### Libraries

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

### Hash Functions

<table>
<thead>
  <tr>
    <th>Algorithm</th>
    <th>Library</th>
    <th>5MB message</th>
    <th>1KB message</th>
    <th>10B message</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td rowspan="2">MD4</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.72 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>290 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>915 Mbps &#128315;1.88x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>864 Mbps &#128315;1.89x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>169 Mbps &#128315;1.72x</small></td>
  </tr>
  <tr>
    <td rowspan="4">MD5</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.45 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.35 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>236 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>1.36 Gbps &#128315;1.07x</small></td>
    <td><code>███████████████░</code> <br> <small>1.29 Gbps &#128315;1.05x</small></td>
    <td><code>███████████████░</code> <br> <small>228 Mbps &#128315;1.04x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>920 Mbps &#128315;1.58x</small></td>
    <td><code>███████████░░░░░</code> <br> <small>929 Mbps &#128315;1.45x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>78.66 Mbps &#128315;3x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████████░░░░░░░</code> <br> <small>775 Mbps &#128315;1.88x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>729 Mbps &#128315;1.85x</small></td>
    <td><code>██████████░░░░░░</code> <br> <small>141 Mbps &#128315;1.68x</small></td>
  </tr>
  <tr>
    <td rowspan="3">HMAC(MD5)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.45 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.1 Gbps</b> &#127775;</small></td>
    <td><code>████████████░░░░</code> <br> <small>44.14 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>1.34 Gbps &#128315;1.08x</small></td>
    <td><code>████████████████</code> <br> <small>1.1 Gbps &#128315;1x</small></td>
    <td><code>████████████████</code> <br> <small><b>58.31 Mbps</b> &#128314;1.32x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>913 Mbps &#128315;1.59x</small></td>
    <td><code>██████████░░░░░░</code> <br> <small>681 Mbps &#128315;1.61x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>20.71 Mbps &#128315;2.13x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-1</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.27 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.17 Gbps</b> &#127775;</small></td>
    <td><code>██████████████░░</code> <br> <small>155 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.12 Gbps &#128315;1.14x</small></td>
    <td><code>███████████████░</code> <br> <small>1.07 Gbps &#128315;1.08x</small></td>
    <td><code>████████████████</code> <br> <small><b>172 Mbps</b> &#128314;1.11x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>502 Mbps &#128315;2.53x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>472 Mbps &#128315;2.47x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>76.54 Mbps &#128315;2.03x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>544 Mbps &#128315;2.34x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>534 Mbps &#128315;2.18x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>56.57 Mbps &#128315;2.74x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-1)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.27 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>804 Mbps </small></td>
    <td><code>█████████████░░░</code> <br> <small>21.87 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.13 Gbps &#128315;1.13x</small></td>
    <td><code>████████████████</code> <br> <small><b>818 Mbps</b> &#128314;1.02x</small></td>
    <td><code>████████████████</code> <br> <small><b>26.98 Mbps</b> &#128314;1.23x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>934 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>126 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>932 Mbps &#128315;1.1x</small></td>
    <td><code>███████████████░</code> <br> <small>878 Mbps &#128315;1.06x</small></td>
    <td><code>████████████████</code> <br> <small><b>128 Mbps</b> &#128314;1.01x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>224 Mbps &#128315;4.57x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>231 Mbps &#128315;4.04x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>31.13 Mbps &#128315;4.05x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>233 Mbps &#128315;4.39x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>222 Mbps &#128315;4.2x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>37.18 Mbps &#128315;3.39x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>945 Mbps</b> &#127775;</small></td>
    <td><code>███████████████░</code> <br> <small>124 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>929 Mbps &#128315;1.1x</small></td>
    <td><code>███████████████░</code> <br> <small>891 Mbps &#128315;1.06x</small></td>
    <td><code>████████████████</code> <br> <small><b>129 Mbps</b> &#128314;1.04x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>239 Mbps &#128315;4.26x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>234 Mbps &#128315;4.04x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>30.82 Mbps &#128315;4.03x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>237 Mbps &#128315;4.31x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>220 Mbps &#128315;4.3x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>36.1 Mbps &#128315;3.44x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-256)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>652 Mbps</b> &#127775;</small></td>
    <td><code>██████████████░░</code> <br> <small>17.89 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>943 Mbps &#128315;1.09x</small></td>
    <td><code>████████████████</code> <br> <small>649 Mbps &#128315;1x</small></td>
    <td><code>████████████████</code> <br> <small><b>20.79 Mbps</b> &#128314;1.16x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.97 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>107 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>654 Mbps &#128315;3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>565 Mbps &#128315;2.9x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>48.35 Mbps &#128315;2.22x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>175 Mbps &#128315;11.26x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>166 Mbps &#128315;9.85x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>14.86 Mbps &#128315;7.23x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>51.87 Mbps &#128315;37.9x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>45.78 Mbps &#128315;35.79x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.98 Mbps &#128315;26.98x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.95 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>108 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>638 Mbps &#128315;3.06x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>561 Mbps &#128315;2.93x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>47.21 Mbps &#128315;2.29x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>168 Mbps &#128315;11.62x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>164 Mbps &#128315;10.02x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>15 Mbps &#128315;7.2x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>52.45 Mbps &#128315;37.17x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>46.35 Mbps &#128315;35.45x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.9 Mbps &#128315;27.68x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.01 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>948 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>126 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>33.09 Mbps &#128315;30.62x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>29.38 Mbps &#128315;32.26x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.25 Mbps &#128315;56.26x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>936 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>126 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>31.04 Mbps &#128315;33.01x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>29.19 Mbps &#128315;32.08x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.25 Mbps &#128315;55.97x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.96 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>109 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>23.66 Mbps &#128315;82.75x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>23.29 Mbps &#128315;69.91x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.25 Mbps &#128315;48.21x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.95 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>108 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>16.29 Mbps &#128315;119.52x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>15.27 Mbps &#128315;107.63x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.27 Mbps &#128315;47.74x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.38 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.29 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>203 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>478 Mbps &#128315;2.89x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>448 Mbps &#128315;2.87x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>80.7 Mbps &#128315;2.52x</small></td>
  </tr>
  <tr>
    <td rowspan="3">RIPEMD-160</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>734 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>700 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>110 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████████░░░░░░░░</code> <br> <small>366 Mbps &#128315;2.01x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>358 Mbps &#128315;1.96x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>45.18 Mbps &#128315;2.44x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>333 Mbps &#128315;2.2x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>316 Mbps &#128315;2.21x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>54.44 Mbps &#128315;2.03x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.56 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.44 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>217 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>471 Mbps &#128315;3.31x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>436 Mbps &#128315;3.3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>76.01 Mbps &#128315;2.86x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-320</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>708 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>679 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>107 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>337 Mbps &#128315;2.1x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>318 Mbps &#128315;2.14x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>52.8 Mbps &#128315;2.02x</small></td>
  </tr>
  <tr>
    <td>BLAKE-2s</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.67 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.65 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>208 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">BLAKE-2b</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>2.08 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>2.07 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>180 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>120 Mbps &#128315;17.33x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>119 Mbps &#128315;17.43x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>9.25 Mbps &#128315;19.5x</small></td>
  </tr>
  <tr>
    <td rowspan="2">Poly1305</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>4.61 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>4.48 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>680 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.29 Gbps &#128315;3.57x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.24 Gbps &#128315;3.62x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>349 Mbps &#128315;1.95x</small></td>
  </tr>
  <tr>
    <td>XXH32</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>6 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>5.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>855 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH64</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>3.53 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>3.05 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>699 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.44 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.23 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>77.31 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.43 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.24 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>76.51 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">SM3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>955 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>885 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>142 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>245 Mbps &#128315;3.89x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>228 Mbps &#128315;3.88x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>37.45 Mbps &#128315;3.8x</small></td>
  </tr>
</tbody>
</table>

### Key Derivators

<table>
<thead>
  <tr>
    <th>Algorithm</th>
    <th>little</th>
    <th>moderate</th>
    <th>good</th>
    <th>strong</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>scrypt</td>
    <td>1.02 ms</td>
    <td>11.11 ms</td>
    <td>61.04 ms</td>
    <td>2007.44 ms</td>
  </tr>
  <tr>
    <td>bcrypt</td>
    <td>2.63 ms</td>
    <td>20.57 ms</td>
    <td>328.42 ms</td>
    <td>2606.94 ms</td>
  </tr>
  <tr>
    <td>pbkdf2</td>
    <td>0.43 ms</td>
    <td>13.96 ms</td>
    <td>232.34 ms</td>
    <td>2809.76 ms</td>
  </tr>
  <tr>
    <td>argon2i</td>
    <td>2.13 ms</td>
    <td>14.69 ms</td>
    <td>193.6 ms</td>
    <td>2070.51 ms</td>
  </tr>
  <tr>
    <td>argon2d</td>
    <td>2.03 ms</td>
    <td>14.54 ms</td>
    <td>191.72 ms</td>
    <td>2069.29 ms</td>
  </tr>
  <tr>
    <td>argon2id</td>
    <td>2.05 ms</td>
    <td>14.52 ms</td>
    <td>191.36 ms</td>
    <td>2063.43 ms</td>
  </tr>
</tbody>
</table>

> All benchmarks are done on 36GB _Apple M3 Pro_ using compiled _exe_
>
> Dart SDK version: 3.12.2 (stable) (Tue Jun 9 01:11:39 2026 -0700) on "macos_arm64"

## License

BSD 3-Clause License. See the [LICENSE](LICENSE) file for details. Issues and
contributions are welcome at
[github.com/bitanon/hashlib](https://github.com/bitanon/hashlib).
