## 1.0.0-dev.4

- Rename `md5hash` to `md5buffer`
- Fix docs for the functions
- Change input type for `md5stream` to `Stream<List<int>>`
- Adds `sha1` following [RFC3174](https://datatracker.ietf.org/doc/html/rfc3174)
- New methods available: `sha1`, `sha1sum`, `sha1stream`, `sha1buffer`

## 1.0.0-dev.3

- Downgrade dart support to 2.12.0
- Add benchmarks
- Optimize `md5` for Dart
- Expose more function: `md5`, `md5sum`, `md5stream`, `md5hash`

## 1.0.0-dev.2

- Adds `md5` following [RFC1321](https://datatracker.ietf.org/doc/html/rfc1321) with `MD5` class.

## 1.0.0-dev.1

- Initial version.
