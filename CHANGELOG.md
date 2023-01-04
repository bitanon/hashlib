## 1.0.0-dev.5

- Adds `sha256` following [rfc6234](https://datatracker.ietf.org/doc/html/rfc6234)
- New functions available: `sha256`, `sha256sum`, `sha256stream`, `sha256buffer`
- New class available: `SHA256`

## 1.0.0-dev.4

- Rename `md5hash` to `md5buffer`
- Fix docs for the functions
- Change input type for `md5stream` to `Stream<List<int>>`
- Adds `sha1` following [rfc3174](https://datatracker.ietf.org/doc/html/rfc3174)
- New functions available: `sha1`, `sha1sum`, `sha1stream`, `sha1buffer`
- New class available: `SHA1`

## 1.0.0-dev.3

- Downgrade dart support to 2.12.0
- Add benchmarks
- Optimize `md5` for Dart
- Expose more function: `md5`, `md5sum`, `md5stream`, `md5hash`

## 1.0.0-dev.2

- Adds `md5` following [rfc1321](https://datatracker.ietf.org/doc/html/rfc1321) with `MD5` class.
- New class available: `MD5`
- New function available: `md5`

## 1.0.0-dev.1

- Initial version.
