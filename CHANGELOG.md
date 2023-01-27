## 1.7.0

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
- Define `MACSinkBase` for Message Authentication Code generators.
- Reset features for `crc16`, `crc32`, `crc64`, `alder32`, and `hmac` internal sinks.

## 1.6.1

- Fixes enum name getter usage issue for Dart < 2.15.0

## 1.6.0

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

## 1.5.0

- Fixes issues with web platform
- Adds web support to `blake2b`
- Adds Argon2, the [Password Hashing Competition](https://www.password-hashing.net/) winner.

## 1.4.0

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

## 1.3.0

- Reduces memory overhead by utilizing the buffer in all `BlockHash`
- Fixes broken sha512 hash fo web VM
- New features:
  - `blake2s`
  - `blake2b`

## 1.2.0

- New features available:
  - `crc16`
  - `crc32`
  - `crc64`
  - `alder32`

## 1.1.0

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

## 1.0.0

- First release
