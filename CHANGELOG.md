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
