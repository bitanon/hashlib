## 1.0.0-dev.6

- Requires 2.14.0
- Using `>>>` operator for right shift

## 1.0.0-dev.5

- Adds SHA256 and SHA224 following [rfc6234](https://datatracker.ietf.org/doc/html/rfc6234)
- For SHA256: `sha256`, `sha256sum`, `sha256stream`, `sha256buffer`, `SHA256`
- For SHA224: `sha224`, `sha224sum`, `sha224stream`, `sha224buffer`, `SHA224`

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
