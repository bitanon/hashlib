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
