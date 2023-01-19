## 1.5.0

- Fixes issues with web platform
- Adds web support to `blake2b`
- Adds Argon2, the [Password Hashing Competition](https://www.password-hashing.net/) winner.
  - `argon2d`
  - `argon2i`
  - `argon2id`

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
