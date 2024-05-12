# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                      |
| ------------- | -------------- | ---------------------------- | ---------------------------- | --------------------------- |
| MD4           | **260.95MB/s** | 98.06MB/s <br> `2.66x slow`  |                              |                             |
| MD5           | **165.49MB/s** | 88.41MB/s <br> `1.87x slow`  | 137.71MB/s <br> `1.2x slow`  | 77.24MB/s <br> `2.14x slow` |
| HMAC(MD5)     | **159.15MB/s** |                              | 135.28MB/s <br> `1.18x slow` | 79.08MB/s <br> `2.01x slow` |
| SM3           | **84.25MB/s**  | 22.30MB/s <br> `3.78x slow`  |                              |                             |
| SHA-1         | **146.99MB/s** | 53.24MB/s <br> `2.76x slow`  | 102.99MB/s <br> `1.43x slow` | 44.74MB/s <br> `3.29x slow` |
| HMAC(SHA-1)   | **147.37MB/s** |                              | 102.43MB/s <br> `1.44x slow` |                             |
| SHA-224       | **98.53MB/s**  | 21.57MB/s <br> `4.57x slow`  | 89.08MB/s <br> `1.11x slow`  | 20.55MB/s <br> `4.79x slow` |
| SHA-256       | **98.58MB/s**  | 21.55MB/s <br> `4.57x slow`  | 89.21MB/s <br> `1.11x slow`  | 20.48MB/s <br> `4.81x slow` |
| HMAC(SHA-256) | **98.68MB/s**  |                              | 89.10MB/s <br> `1.11x slow`  |                             |
| SHA-384       | **156.57MB/s** | 5.48MB/s <br> `28.54x slow`  | 53.34MB/s <br> `2.94x slow`  | 18.15MB/s <br> `8.63x slow` |
| SHA-512       | **156.27MB/s** | 5.30MB/s <br> `29.45x slow`  | 53.25MB/s <br> `2.93x slow`  | 18.13MB/s <br> `8.62x slow` |
| SHA3-256      | **98.56MB/s**  | 3.24MB/s <br> `30.34x slow`  |                              |                             |
| SHA3-512      | **155.98MB/s** | 1.71MB/s <br> `91.08x slow`  |                              |                             |
| RIPEMD-128    | **207.04MB/s** | 45.51MB/s <br> `4.55x slow`  |                              |                             |
| RIPEMD-160    | **65.42MB/s**  | 27.69MB/s <br> `2.36x slow`  |                              | 33.79MB/s <br> `1.94x slow` |
| RIPEMD-256    | **223.38MB/s** | 45.38MB/s <br> `4.92x slow`  |                              |                             |
| RIPEMD-320    | **64.88MB/s**  | 27.04MB/s <br> `2.4x slow`   |                              |                             |
| BLAKE-2s      | **141.79MB/s** |                              |                              |                             |
| BLAKE-2b      | **163.03MB/s** | 12.21MB/s <br> `13.35x slow` |                              |                             |
| Poly1305      | **447.39MB/s** | 141.09MB/s <br> `3.17x slow` |                              |                             |
| XXH32         | **520.04MB/s** |                              |                              |                             |
| XXH64         | **539.56MB/s** |                              |                              |                             |
| XXH3          | **119.75MB/s** |                              |                              |                             |
| XXH128        | **119.03MB/s** |                              |                              |                             |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                      |
| ------------- | -------------- | ---------------------------- | ---------------------------- | --------------------------- |
| MD4           | **242.72MB/s** | 96.52MB/s <br> `2.51x slow`  |                              |                             |
| MD5           | **156.82MB/s** | 84.18MB/s <br> `1.86x slow`  | 129.30MB/s <br> `1.21x slow` | 99.80MB/s <br> `1.57x slow` |
| HMAC(MD5)     | **127.45MB/s** |                              | 107.01MB/s <br> `1.19x slow` | 74.70MB/s <br> `1.71x slow` |
| SM3           | **78.88MB/s**  | 20.90MB/s <br> `3.77x slow`  |                              |                             |
| SHA-1         | **137.49MB/s** | 50.40MB/s <br> `2.73x slow`  | 95.75MB/s <br> `1.44x slow`  | 48.46MB/s <br> `2.84x slow` |
| HMAC(SHA-1)   | **97.97MB/s**  |                              | 69.56MB/s <br> `1.41x slow`  |                             |
| SHA-224       | **91.17MB/s**  | 20.27MB/s <br> `4.5x slow`   | 83.17MB/s <br> `1.1x slow`   | 20.49MB/s <br> `4.45x slow` |
| SHA-256       | **91.06MB/s**  | 20.27MB/s <br> `4.49x slow`  | 83.12MB/s <br> `1.1x slow`   | 20.51MB/s <br> `4.44x slow` |
| HMAC(SHA-256) | **65.26MB/s**  |                              | 59.73MB/s <br> `1.09x slow`  |                             |
| SHA-384       | **135.47MB/s** | 4.91MB/s <br> `27.59x slow`  | 46.98MB/s <br> `2.88x slow`  | 19.74MB/s <br> `6.86x slow` |
| SHA-512       | **134.15MB/s** | 4.90MB/s <br> `27.32x slow`  | 46.75MB/s <br> `2.87x slow`  | 19.72MB/s <br> `6.8x slow`  |
| SHA3-256      | **89.06MB/s**  | 2.99MB/s <br> `29.73x slow`  |                              |                             |
| SHA3-512      | **134.18MB/s** | 1.60MB/s <br> `83.55x slow`  |                              |                             |
| RIPEMD-128    | **192.56MB/s** | 42.93MB/s <br> `4.49x slow`  |                              |                             |
| RIPEMD-160    | **60.60MB/s**  | 25.84MB/s <br> `2.34x slow`  |                              | 35.09MB/s <br> `1.73x slow` |
| RIPEMD-256    | **204MB/s**    | 42.50MB/s <br> `4.8x slow`   |                              |                             |
| RIPEMD-320    | **59.92MB/s**  | 25.14MB/s <br> `2.38x slow`  |                              |                             |
| BLAKE-2s      | **138.87MB/s** |                              |                              |                             |
| BLAKE-2b      | **158.64MB/s** | 12.01MB/s <br> `13.2x slow`  |                              |                             |
| Poly1305      | **425.11MB/s** | 140.06MB/s <br> `3.04x slow` |                              |                             |
| XXH32         | **494.65MB/s** |                              |                              |                             |
| XXH64         | **498.92MB/s** |                              |                              |                             |
| XXH3          | **111.20MB/s** |                              |                              |                             |
| XXH128        | **111.06MB/s** |                              |                              |                             |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | -------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **33.95MB/s**  | 16.83MB/s <br> `2.02x slow`   |                             |                            |
| MD5           | **29.82MB/s**  | 14.33MB/s <br> `2.08x slow`   | 14.92MB/s <br> `2x slow`    | 8.09MB/s <br> `3.69x slow` |
| HMAC(MD5)     | **5.41MB/s**   |                               | 4.58MB/s <br> `1.18x slow`  | 2.14MB/s <br> `2.52x slow` |
| SM3           | **12.11MB/s**  | 3.40MB/s <br> `3.56x slow`    |                             |                            |
| SHA-1         | **17.07MB/s**  | 7.71MB/s <br> `2.21x slow`    | 11.72MB/s <br> `1.46x slow` | 5.16MB/s <br> `3.31x slow` |
| HMAC(SHA-1)   | **2.68MB/s**   |                               | 2.10MB/s <br> `1.27x slow`  |                            |
| SHA-224       | **12.16MB/s**  | 3.23MB/s <br> `3.75x slow`    | 9.69MB/s <br> `1.25x slow`  | 2.68MB/s <br> `4.52x slow` |
| SHA-256       | **12.21MB/s**  | 3.24MB/s <br> `3.77x slow`    | 9.69MB/s <br> `1.26x slow`  | 2.72MB/s <br> `4.47x slow` |
| HMAC(SHA-256) | **1.87MB/s**   |                               | 1.76MB/s <br> `1.06x slow`  |                            |
| SHA-384       | **9.43MB/s**   | 430KB/s <br> `22.46x slow`    | 3.55MB/s <br> `2.65x slow`  | 1.41MB/s <br> `6.67x slow` |
| SHA-512       | **9.25MB/s**   | 429.68KB/s <br> `22.05x slow` | 3.53MB/s <br> `2.62x slow`  | 1.42MB/s <br> `6.49x slow` |
| SHA3-256      | **12.29MB/s**  | 233.73KB/s <br> `53.87x slow` |                             |                            |
| SHA3-512      | **9.35MB/s**   | 235.50KB/s <br> `40.66x slow` |                             |                            |
| RIPEMD-128    | **28.40MB/s**  | 7.29MB/s <br> `3.9x slow`     |                             |                            |
| RIPEMD-160    | **9.48MB/s**   | 4.16MB/s <br> `2.28x slow`    |                             | 4.21MB/s <br> `2.25x slow` |
| RIPEMD-256    | **28.74MB/s**  | 6.96MB/s <br> `4.13x slow`    |                             |                            |
| RIPEMD-320    | **9.29MB/s**   | 3.93MB/s <br> `2.36x slow`    |                             |                            |
| BLAKE-2s      | **18.71MB/s**  |                               |                             |                            |
| BLAKE-2b      | **15.09MB/s**  | 903.49KB/s <br> `17.11x slow` |                             |                            |
| Poly1305      | **64.56MB/s**  | 35.79MB/s <br> `1.8x slow`    |                             |                            |
| XXH32         | **100.48MB/s** |                               |                             |                            |
| XXH64         | **73.79MB/s**  |                               |                             |                            |
| XXH3          | **10.66MB/s**  |                               |                             |                            |
| XXH128        | **10.09MB/s**  |                               |                             |                            |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.057 ms | 1.507 ms | 10.907 ms | 87.509 ms  | 1412.755 ms |
| argon2i    | 0.395 ms | 2.761 ms | 17.238 ms | 200.692 ms | 2407.547 ms |
| argon2d    | 0.268 ms | 2.726 ms | 16.428 ms | 200.05 ms  | 2404.685 ms |
| argon2id   | 0.286 ms | 2.364 ms | 16.378 ms | 198.979 ms | 2433.166 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
