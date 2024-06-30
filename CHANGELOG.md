# 1.18.0

- Implement BCrypt algorithm.
  - New class: `Bcrypt`
  - New methods: `bcrypt`, `bcryptSalt`, `bcryptVerify`, `bcryptDigest`
- Convert all asUint...List to Uint...List.view
- Refactor: `Argon2.fromEncoded` will now accept `CryptData` only.
- New method: `Argon2Context.fromEncoded` accepting `CryptData`.

# 1.17.0

- Update **Argon2** interface:
  - Paramters `salt` and `hashLength` are now optional.
  - If absent, `salt` is generated using default random generator.
  - Default hash length is now 32 instead of 24.
  - Extracts method `Argon2Security.optimize` -> `tuneArgon2Security`
- Put deprecation message on string extensions
- Update benchmarks

# 1.16.0

- Implement SM3 algorithm.
  - New constant: `sm3`
  - New method: `sm3sum`

# 1.15.0

- Expose `currentTime` in `TOTP`
- Implement MD4 algorithm.
  - New constant: `md4`
  - New method: `md4sum`

# 1.14.0

- Accept random number generator input in the following method parameters:
  - `randomBytes`
  - `fillRandom`
- Adds new method to generate 32-bit random numbers: `randomNumbers`
- Adds `KeccakRandom` as proof of concept random number generator.

# 1.13.1

- Expose `Poly1305Sink` to public.

# 1.13.0

- **Breaking** changes on public methods:
  - renames `poly1305` -> `poly1305pair`
  - renames `poly1305auth` -> `poly1305`
  - accepts 16 bytes key for `poly1305`
- Refactor `Poly1305` class structure.
  **Breaking** changes:
  - renames `Poly1305.auth` -> `Poly1305.pair`
  - removes getter `secret` (`key` contains both keypair).
- Refactor benchmark calculation.

# 1.12.1

- Optimize `HMAC` runtime.
- Refactor `Argon2` class structure.
  **Breaking** changes:
  - renames variable: `lanes` to `parallelism`
  - renames variable: `passes` to `iterations`
- Bump version of the [hashlib_codecs](https://pub.dev/packages/hashlib_codecs)

# 1.12.0

- **Breaking**: The `HashDigest.base32` and `HashDigest.base64` will have padding by default.
- Bump version of the [hashlib_codecs](https://pub.dev/packages/hashlib_codecs)

# 1.11.4

- Move codecs to separate package: [hashlib_codecs](https://github.com/bitanon/hashlib_codecs)
- Support BigInt conversion in `HashDigest`
  - Renames `remainder` -> `number`
  - Adds `bigInt` method to get `BigInt` from bytes

# 1.11.3

- Throws `FormatException` for invalid characters in codecs
- Adds `base2` codes. New methods:
  - `fromBinary`
  - `toBinary`

# 1.11.2

- Export codecs
- Update documentation
- Truncate seed to 32-bit integer for xxh32

# 1.11.1

- Export a few additional clases
  - `BlockHashBase`
  - `BlockHashSink`
  - `HashBase`
  - `HashDigestSink`
  - `HashDigest`
  - `Argon2HashDigest`
  - `BlockHashRegistry`
  - `HashRegistry`
  - `Uint8Codec`

# 1.11.0

- Optimize Poly1305 implementation (30x improvement in hashrate)
- Optimize scrypt implementation (10x improvement in runtime)
- RIPEMD algorithm series. New hash functions:
  - `ripemd128`, `ripemd128sum`
  - `ripemd160`, `ripemd160sum`
  - `ripemd256`, `ripemd256sum`
  - `ripemd320`, `ripemd320sum`
- Codecs are now able to handle padding characters

# 1.10.0

- Adds support for `Poly1305` MAC generation: [#5](https://github.com/bitanon/hashlib/issues/5)
  - New class: `Poly1305`
  - New methods: `poly1305`, `poly1305auth`
- Adds support for OTP generation:
  - `HOTP` - Hash-based OTP generation [#8](https://github.com/bitanon/hashlib/issues/8)
  - `TOTP` - Time-based OTP generation [#9](https://github.com/bitanon/hashlib/issues/9)
- Name all hash algorithms and a registry to loopup algorithms by name.
  - `BlockHashRegistry` - for block hash algorithms
  - `HashRegistry` - for all hash algorithms
- Adds random byte generator:
  - `randomBytes` method returns a `List<int>`
  - `fillRandom` method fills a `ByteBuffer` with random values
- New default instances for `Shake128`:
  - `shake128_128`
  - `shake128_160`
  - `shake128_224`
  - `shake128_256`
  - `shake128_384`
  - `shake128_512`
- New default instances for `Shake256`:
  - `shake256_128`
  - `shake256_160`
  - `shake256_224`
  - `shake256_256`
  - `shake256_384`
  - `shake256_512`
- Adds two new methods to `MACHashBase`:
  - `sign`: generates a tag from a message
  - `verify`: verifies if a message and tag matches
- Updates `HashDigest`
  - Adds `isEqual` to match it with other `HashDigest`, `String`, `TypedData`, `ByteBuffer`, `List<int>`, `Iterable<int>`
  - Use custom equality check
- Extracts few methods from utils and create codecs:
  - Available:
    - `ASCIICodec`
    - `B16Codec`
    - `B32Codec`
    - `B64Codec`
    - `B64URLCodec`
  - New or transferred methods:
    - `toAscii`
    - `fromAscii`
    - `toHex`
    - `fromHex`
    - `toBase32`
    - `fromBase32`
    - `toBase64`
    - `fromBase64`
    - `toBase64Url`
    - `fromBase64Url`
  - New constants:
    - `ascii`
    - `base16`
    - `base16lower`
    - `base32`
    - `base32lower`
    - `base64`
    - `base64url`
- New example: `otpauth_parser.dart`. It can decode migration string from Google Authenticator and parse any valid otpauth string.
- Updates benchmarks

# 1.9.0

- Adds SCRYPT:
  - New class: `Scrypt`
  - New method: `scrypt`
- Changes in `PBKDF2` and extensions:
  - parameter type of `keyLength`
  - use default iterations = 1000
  - adds validation in the constructor
  - adds global `pbkdf2` function

# 1.8.1

- Improves `dart run` using `@pragma('vm:prefer-inline')`
- Adds new methods:
  - `crc64sum`
  - `xxh64sum`
  - `xxh3sum`
  - `xxh128sum`
- Removes methods:
  - `xxh128code`

# 1.8.0

- Adds xxHash64
  - New class: `XXHash64`
  - New constants: `xxh64`, `xxh64code`
  - String extension: `xxh64code`
- Adds xxHash32
  - New class: `XXHash32`
  - New constants: `xxh32`, `xxh32code`
  - String extension: `xxh32code`
- Adds XXH3-64
  - New class: `XXH3`
  - New constants: `xxh3`, `xxh3code`
  - String extension: `xxh3code`
- Adds XXH3-128
  - New class: `XXH128`
  - New constants: `xxh128`, `xxh128code`
  - String extension: `xxh128code`
- Internal changes:
  - Removes the parameters from `$finalize` method in `BlockHash`
  - Uses `>>>` instead of `>>`
- Uses Hash Rate instead of Runtime for benchmarks

# 1.7.0

- Renames `Argon2Security.small` -> `Argon2Security.little`
- Adds `Argon2Security.optimize` method to find optimal parameters for a desired runtime.
- Define `KeyDerivator` and extend it for `Argon2`
- Modify internal structure of `Argon2` to make it faster.
- Implement `reset` functionality for all hash sinks.
- Define and use `BlockHashBase` for some algorithms.
- Renames `BlockHash` -> `BlockHashSink`
- Replaces the RFC links to ietf domain.
- Adds `PBKDF2` key derivator.
- Adds extension to `HMAC` to create `PBKDF2` instance.
- Define `MACHashBase` and `MACSinkBase` for Message Authentication Code generators.
- Reset features for `crc16`, `crc32`, `crc64`, `alder32`, and `hmac` internal sinks.
- Enhance `blake2b` and `blake2s` for MAC generation
- **Breaking change**:
  - Accept number of bytes instead of bits for `Blake2b` and `Blake2s`
  - Removes all `Blake2b.of##` and `Blake2s.of##` methods

# 1.6.1

- Fixes enum name getter usage issue for Dart < 2.15.0

# 1.6.0

- Optimize Argon2 (Now it is 6 times faster than 1.5.0)
- Support for Argon2 in Node platform (TODO: requires optimization)
- Renames `Argon2Context` -> `Argon2` with the following change:
  - `convert()` will generate password hash and return an `Argon2HashDigest`
  - `encode()` will generate password hash and return argon2 encoded string.
  - `toInstance()` is renamed to `instance` to get a singleton instance.
  - The method `encode()` is renamed to `convert()` inside the `instance`.
- Adds `Argon2Security` exposing some default parameter choices which can be used with these quick access functions:
  - `argon2d`
  - `argon2i`
  - `argon2id`
- Argon2 will now return the `Argon2HashDigest`, containing a few changes over `HashDigest`:
  - `encoded()` will return the argon2 hash as encoded format.
  - `toString()` will return the encoded hash instead of the password hash.
- Implement custom `toBase64` and `fromBase64` in utils for faster conversion without padding.
- Changes to `HashDigest`:
  - merge `base64` and `base64url` methods into one.
  - uses custom base64 conversion that does not include `=` padding.
  - removes `lantin1`

# 1.5.0

- Fixes issues with web platform
- Adds web support to `blake2b`
- Adds Argon2, the [Password Hashing Competition](https://www.password-hashing.net/) winner.

# 1.4.0

- Modifies the internal structure for better accessibility
- Fixes stream binding issue in `HashBase`
- Removes a lot of string extensions. Remaining ones are:
  - `sha512digest`
  - `sha256digest`
  - `sha224digest`
  - `sha3_512digest`
  - `sha3_384digest`
  - `sha3_256digest`
  - `sha3_224digest`
  - `sha1digest`
  - `md5digest`
  - `crc32code`
- Accepts file input in `HashBase`
- Accepts `salt` and `personalization` values with `Blake2s` and `Blake2b`

# 1.3.0

- Reduces memory overhead by utilizing the buffer in all `BlockHash`
- Fixes broken sha512 hash fo web VM
- New features:
  - `blake2s`
  - `blake2b`

# 1.2.0

- New features available:
  - `crc16`
  - `crc32`
  - `crc64`
  - `alder32`

# 1.1.0

- Adds `String` extensions for convenient use all algorithms.
- Renames functions:
  - `sha512sum224` -> `sha512t224sum`
  - `sha512sum256` -> `sha512t256sum`
- Renames function for `HashBase`:
  - `HashBase.stream` -> `HashBase.consume`
  - `HashBase.stringString` -> `HashBase.consumeAs`
- Modifies the internal `HashDigestSink`:
  - Implements `ByteConversionSink` instead of extending `Sink<List<int>>`
  - Use `addSlice` instead of `add`
- Improves performance of some algorithms

# 1.0.0

- First release
