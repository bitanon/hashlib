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
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>285 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>888 Mbps &#128315;1.94x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>846 Mbps &#128315;1.94x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>163 Mbps &#128315;1.75x</small></td>
  </tr>
  <tr>
    <td rowspan="4">MD5</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.47 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.32 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>216 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>1.38 Gbps &#128315;1.06x</small></td>
    <td><code>████████████████</code> <br> <small>1.29 Gbps &#128315;1.03x</small></td>
    <td><code>███████████████░</code> <br> <small>205 Mbps &#128315;1.05x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>952 Mbps &#128315;1.55x</small></td>
    <td><code>███████████░░░░░</code> <br> <small>904 Mbps &#128315;1.47x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>69.73 Mbps &#128315;3.1x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████████░░░░░░░░</code> <br> <small>737 Mbps &#128315;2x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>705 Mbps &#128315;1.88x</small></td>
    <td><code>█████████░░░░░░░</code> <br> <small>125 Mbps &#128315;1.73x</small></td>
  </tr>
  <tr>
    <td rowspan="3">HMAC(MD5)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.4 Gbps</b> &#127775;</small></td>
    <td><code>██████████████░░</code> <br> <small>987 Mbps </small></td>
    <td><code>████████████░░░░</code> <br> <small>43.81 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>████████████████</code> <br> <small>1.37 Gbps &#128315;1.02x</small></td>
    <td><code>████████████████</code> <br> <small><b>1.1 Gbps</b> &#128314;1.12x</small></td>
    <td><code>████████████████</code> <br> <small><b>56.83 Mbps</b> &#128314;1.3x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>██████████░░░░░░</code> <br> <small>898 Mbps &#128315;1.56x</small></td>
    <td><code>██████████░░░░░░</code> <br> <small>666 Mbps &#128315;1.48x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>19.44 Mbps &#128315;2.25x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-1</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.26 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.16 Gbps</b> &#127775;</small></td>
    <td><code>███████████████░</code> <br> <small>153 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.11 Gbps &#128315;1.13x</small></td>
    <td><code>███████████████░</code> <br> <small>1.08 Gbps &#128315;1.07x</small></td>
    <td><code>████████████████</code> <br> <small><b>167 Mbps</b> &#128314;1.09x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>478 Mbps &#128315;2.64x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>464 Mbps &#128315;2.49x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>75.97 Mbps &#128315;2.01x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>533 Mbps &#128315;2.36x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>524 Mbps &#128315;2.21x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>54 Mbps &#128315;2.83x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-1)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.27 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>805 Mbps </small></td>
    <td><code>█████████████░░░</code> <br> <small>21.93 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>1.11 Gbps &#128315;1.15x</small></td>
    <td><code>████████████████</code> <br> <small><b>812 Mbps</b> &#128314;1.01x</small></td>
    <td><code>████████████████</code> <br> <small><b>26.82 Mbps</b> &#128314;1.22x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.02 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>868 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>120 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>██████████████░░</code> <br> <small>913 Mbps &#128315;1.12x</small></td>
    <td><code>███████████████░</code> <br> <small>838 Mbps &#128315;1.04x</small></td>
    <td><code>████████████████</code> <br> <small>118 Mbps &#128315;1.01x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>245 Mbps &#128315;4.19x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>228 Mbps &#128315;3.81x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>29.68 Mbps &#128315;4.05x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███░░░░░░░░░░░░░</code> <br> <small>219 Mbps &#128315;4.68x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>222 Mbps &#128315;3.91x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>36.69 Mbps &#128315;3.27x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>941 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>121 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>944 Mbps &#128315;1.09x</small></td>
    <td><code>███████████████░</code> <br> <small>864 Mbps &#128315;1.09x</small></td>
    <td><code>████████████████</code> <br> <small><b>123 Mbps</b> &#128314;1.02x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>243 Mbps &#128315;4.22x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>224 Mbps &#128315;4.21x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>30.65 Mbps &#128315;3.94x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>235 Mbps &#128315;4.36x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>220 Mbps &#128315;4.28x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>36.27 Mbps &#128315;3.33x</small></td>
  </tr>
  <tr>
    <td rowspan="2">HMAC(SHA-256)</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.04 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small>651 Mbps </small></td>
    <td><code>██████████████░░</code> <br> <small>17.88 Mbps </small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>███████████████░</code> <br> <small>942 Mbps &#128315;1.1x</small></td>
    <td><code>████████████████</code> <br> <small><b>651 Mbps</b> &#128314;1x</small></td>
    <td><code>████████████████</code> <br> <small><b>20.2 Mbps</b> &#128314;1.13x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.96 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.65 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>105 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>654 Mbps &#128315;3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>591 Mbps &#128315;2.8x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>51.35 Mbps &#128315;2.05x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>172 Mbps &#128315;11.43x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>161 Mbps &#128315;10.27x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>14.32 Mbps &#128315;7.36x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>50.49 Mbps &#128315;38.88x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>44.81 Mbps &#128315;36.9x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.86 Mbps &#128315;27.28x</small></td>
  </tr>
  <tr>
    <td rowspan="4">SHA-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.97 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.64 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>102 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>crypto</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>655 Mbps &#128315;3x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>590 Mbps &#128315;2.78x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>50.24 Mbps &#128315;2.04x</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>173 Mbps &#128315;11.36x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>160 Mbps &#128315;10.23x</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>14.37 Mbps &#128315;7.13x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>49.25 Mbps &#128315;39.91x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>43.61 Mbps &#128315;37.58x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>3.75 Mbps &#128315;27.33x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-224</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>913 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>116 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>31.33 Mbps &#128315;32.73x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>27.45 Mbps &#128315;33.25x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.13 Mbps &#128315;54.28x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.03 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>941 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>120 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>29.91 Mbps &#128315;34.28x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>27.96 Mbps &#128315;33.67x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.14 Mbps &#128315;56.1x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-384</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.94 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.65 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>104 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>22.7 Mbps &#128315;85.4x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>22.47 Mbps &#128315;73.34x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.16 Mbps &#128315;47.82x</small></td>
  </tr>
  <tr>
    <td rowspan="2">SHA3-512</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.91 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>101 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>15.8 Mbps &#128315;121.05x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.79 Mbps &#128315;110.1x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.14 Mbps &#128315;47.04x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.41 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.33 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>195 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>462 Mbps &#128315;3.05x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>438 Mbps &#128315;3.03x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>78.39 Mbps &#128315;2.48x</small></td>
  </tr>
  <tr>
    <td rowspan="3">RIPEMD-160</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>743 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>698 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>108 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>hash</td>
    <td><code>████████░░░░░░░░</code> <br> <small>373 Mbps &#128315;1.99x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>359 Mbps &#128315;1.95x</small></td>
    <td><code>██████░░░░░░░░░░</code> <br> <small>43.29 Mbps &#128315;2.48x</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>335 Mbps &#128315;2.22x</small></td>
    <td><code>███████░░░░░░░░░</code> <br> <small>317 Mbps &#128315;2.2x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>54.48 Mbps &#128315;1.97x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-256</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.56 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.44 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>220 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>468 Mbps &#128315;3.33x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>440 Mbps &#128315;3.29x</small></td>
    <td><code>█████░░░░░░░░░░░</code> <br> <small>74.18 Mbps &#128315;2.97x</small></td>
  </tr>
  <tr>
    <td rowspan="2">RIPEMD-320</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>713 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>669 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>105 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>███████░░░░░░░░░</code> <br> <small>331 Mbps &#128315;2.15x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>314 Mbps &#128315;2.13x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>51.56 Mbps &#128315;2.03x</small></td>
  </tr>
  <tr>
    <td>BLAKE-2s</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.69 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.67 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>203 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">BLAKE-2b</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>2.06 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>2.07 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>181 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>120 Mbps &#128315;17.09x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>119 Mbps &#128315;17.45x</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>9.26 Mbps &#128315;19.56x</small></td>
  </tr>
  <tr>
    <td rowspan="2">Poly1305</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>4.59 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>4.48 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>595 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.18 Gbps &#128315;3.88x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>1.16 Gbps &#128315;3.87x</small></td>
    <td><code>████████░░░░░░░░</code> <br> <small>310 Mbps &#128315;1.92x</small></td>
  </tr>
  <tr>
    <td>XXH32</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>5.9 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>5.6 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>789 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH64</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>3.63 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>3.3 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>639 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.46 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.23 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>70.49 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>XXH128</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>1.43 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>1.21 Gbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>68.5 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td rowspan="2">SM3</td>
    <td>hashlib</td>
    <td><code>████████████████</code> <br> <small><b>947 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>862 Mbps</b> &#127775;</small></td>
    <td><code>████████████████</code> <br> <small><b>136 Mbps</b> &#127775;</small></td>
  </tr>
  <tr>
    <td>PointyCastle</td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>241 Mbps &#128315;3.93x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>228 Mbps &#128315;3.78x</small></td>
    <td><code>████░░░░░░░░░░░░</code> <br> <small>37.31 Mbps &#128315;3.65x</small></td>
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
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>1.01 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>11.21 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>61.03 ms</small></td>
    <td><code>████████████████</code> <br> <small>2033.95 ms</small></td>
  </tr>
  <tr>
    <td>bcrypt</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.7 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>20.6 ms</small></td>
    <td><code>██░░░░░░░░░░░░░░</code> <br> <small>331.8 ms</small></td>
    <td><code>████████████████</code> <br> <small>2650.52 ms</small></td>
  </tr>
  <tr>
    <td>pbkdf2</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>0.42 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.05 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>232.89 ms</small></td>
    <td><code>████████████████</code> <br> <small>2777.65 ms</small></td>
  </tr>
  <tr>
    <td>argon2i</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.37 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.86 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>192.95 ms</small></td>
    <td><code>████████████████</code> <br> <small>2087.93 ms</small></td>
  </tr>
  <tr>
    <td>argon2d</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.14 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>15.01 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>191.21 ms</small></td>
    <td><code>████████████████</code> <br> <small>2094.69 ms</small></td>
  </tr>
  <tr>
    <td>argon2id</td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>2.11 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>14.68 ms</small></td>
    <td><code>█░░░░░░░░░░░░░░░</code> <br> <small>192.04 ms</small></td>
    <td><code>████████████████</code> <br> <small>2052.91 ms</small></td>
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
