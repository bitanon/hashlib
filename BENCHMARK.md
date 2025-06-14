# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                 | `crypto`                    | `hash`                     |
| ------------- | ------------- | ------------------------------ | --------------------------- | -------------------------- |
| MD4           | **1.64 Gbps** | 352 Mbps <br> `4.66x slow`     |                             |                            |
| MD5           | **1.45 Gbps** | 347 Mbps <br> `4.18x slow`     | 1.01 Gbps <br> `1.44x slow` | 651 Mbps <br> `2.23x slow` |
| HMAC(MD5)     | **1.33 Gbps** |                                | 991 Mbps <br> `1.34x slow`  | 653 Mbps <br> `2.04x slow` |
| SHA-1         | **1.27 Gbps** | 248 Mbps <br> `5.13x slow`     | 794 Mbps <br> `1.61x slow`  | 388 Mbps <br> `3.28x slow` |
| HMAC(SHA-1)   | **1.28 Gbps** |                                | 793 Mbps <br> `1.61x slow`  |                            |
| SHA-224       | **856 Mbps**  | 152 Mbps <br> `5.65x slow`     | 685 Mbps <br> `1.25x slow`  | 198 Mbps <br> `4.32x slow` |
| SHA-256       | **859 Mbps**  | 151 Mbps <br> `5.67x slow`     | 686 Mbps <br> `1.25x slow`  | 198 Mbps <br> `4.35x slow` |
| HMAC(SHA-256) | **858 Mbps**  |                                | 688 Mbps <br> `1.25x slow`  |                            |
| SHA-384       | **1.36 Gbps** | 17.35 Mbps <br> `78.24x slow`  | 466 Mbps <br> `2.91x slow`  | 162 Mbps <br> `8.37x slow` |
| SHA-512       | **1.36 Gbps** | 17.59 Mbps <br> `77.15x slow`  | 470 Mbps <br> `2.89x slow`  | 160 Mbps <br> `8.46x slow` |
| SHA3-224      | **857 Mbps**  | 14.97 Mbps <br> `57.25x slow`  |                             |                            |
| SHA3-256      | **857 Mbps**  | 14.17 Mbps <br> `60.48x slow`  |                             |                            |
| SHA3-384      | **1.36 Gbps** | 10.85 Mbps <br> `125.22x slow` |                             |                            |
| SHA3-512      | **1.37 Gbps** | 7.49 Mbps <br> `182.3x slow`   |                             |                            |
| RIPEMD-128    | **1.79 Gbps** | 247 Mbps <br> `7.24x slow`     |                             |                            |
| RIPEMD-160    | **698 Mbps**  | 174 Mbps <br> `4x slow`        |                             | 290 Mbps <br> `2.41x slow` |
| RIPEMD-256    | **2 Gbps**    | 218 Mbps <br> `9.16x slow`     |                             |                            |
| RIPEMD-320    | **684 Mbps**  | 161 Mbps <br> `4.26x slow`     |                             |                            |
| BLAKE-2s      | **1.49 Gbps** |                                |                             |                            |
| BLAKE-2b      | **1.53 Gbps** | 71.06 Mbps <br> `21.6x slow`   |                             |                            |
| Poly1305      | **3.79 Gbps** | 362 Mbps <br> `10.48x slow`    |                             |                            |
| XXH32         | **4.5 Gbps**  |                                |                             |                            |
| XXH64         | **2.42 Gbps** |                                |                             |                            |
| XXH3          | **976 Mbps**  |                                |                             |                            |
| XXH128        | **1.03 Gbps** |                                |                             |                            |
| SM3           | **751 Mbps**  | 135 Mbps <br> `5.57x slow`     |                             |                            |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                 | `crypto`                   | `hash`                     |
| ------------- | ------------- | ------------------------------ | -------------------------- | -------------------------- |
| MD4           | **1.54 Gbps** | 576 Mbps <br> `2.67x slow`     |                            |                            |
| MD5           | **1.37 Gbps** | 514 Mbps <br> `2.66x slow`     | 916 Mbps <br> `1.49x slow` | 643 Mbps <br> `2.12x slow` |
| HMAC(MD5)     | **1 Gbps**    |                                | 735 Mbps <br> `1.36x slow` | 482 Mbps <br> `2.08x slow` |
| SHA-1         | **1.16 Gbps** | 348 Mbps <br> `3.33x slow`     | 714 Mbps <br> `1.62x slow` | 371 Mbps <br> `3.12x slow` |
| HMAC(SHA-1)   | **784 Mbps**  |                                | 505 Mbps <br> `1.55x slow` |                            |
| SHA-224       | **780 Mbps**  | 177 Mbps <br> `4.41x slow`     | 616 Mbps <br> `1.27x slow` | 187 Mbps <br> `4.18x slow` |
| SHA-256       | **784 Mbps**  | 175 Mbps <br> `4.48x slow`     | 615 Mbps <br> `1.27x slow` | 187 Mbps <br> `4.19x slow` |
| HMAC(SHA-256) | **549 Mbps**  |                                | 433 Mbps <br> `1.27x slow` |                            |
| SHA-384       | **1.13 Gbps** | 26.94 Mbps <br> `42.01x slow`  | 402 Mbps <br> `2.82x slow` | 169 Mbps <br> `6.71x slow` |
| SHA-512       | **1.13 Gbps** | 27.88 Mbps <br> `40.48x slow`  | 402 Mbps <br> `2.81x slow` | 170 Mbps <br> `6.64x slow` |
| SHA3-224      | **782 Mbps**  | 20.34 Mbps <br> `38.46x slow`  |                            |                            |
| SHA3-256      | **783 Mbps**  | 20.55 Mbps <br> `38.11x slow`  |                            |                            |
| SHA3-384      | **1.13 Gbps** | 16.25 Mbps <br> `69.21x slow`  |                            |                            |
| SHA3-512      | **1.13 Gbps** | 10.89 Mbps <br> `103.51x slow` |                            |                            |
| RIPEMD-128    | **1.62 Gbps** | 334 Mbps <br> `4.87x slow`     |                            |                            |
| RIPEMD-160    | **642 Mbps**  | 207 Mbps <br> `3.1x slow`      |                            | 280 Mbps <br> `2.29x slow` |
| RIPEMD-256    | **1.81 Gbps** | 339 Mbps <br> `5.34x slow`     |                            |                            |
| RIPEMD-320    | **636 Mbps**  | 198 Mbps <br> `3.22x slow`     |                            |                            |
| BLAKE-2s      | **1.43 Gbps** |                                |                            |                            |
| BLAKE-2b      | **1.47 Gbps** | 95.76 Mbps <br> `15.38x slow`  |                            |                            |
| Poly1305      | **3.33 Gbps** | 768 Mbps <br> `4.33x slow`     |                            |                            |
| XXH32         | **4.12 Gbps** |                                |                            |                            |
| XXH64         | **2.27 Gbps** |                                |                            |                            |
| XXH3          | **784 Mbps**  |                                |                            |                            |
| XXH128        | **825 Mbps**  |                                |                            |                            |
| SM3           | **698 Mbps**  | 163 Mbps <br> `4.28x slow`     |                            |                            |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                       |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **210 Mbps**   | 101 Mbps <br> `2.09x slow`   |                              |                              |
| MD5           | **177 Mbps**   | 89.19 Mbps <br> `1.98x slow` | 92.89 Mbps <br> `1.9x slow`  | 52.25 Mbps <br> `3.38x slow` |
| HMAC(MD5)     | **36.18 Mbps** |                              | 31.69 Mbps <br> `1.14x slow` | 14.23 Mbps <br> `2.54x slow` |
| SHA-1         | **120 Mbps**   | 49.47 Mbps <br> `2.42x slow` | 69.51 Mbps <br> `1.72x slow` | 34.29 Mbps <br> `3.49x slow` |
| HMAC(SHA-1)   | **19.64 Mbps** |                              | 14.71 Mbps <br> `1.34x slow` |                              |
| SHA-224       | **88.2 Mbps**  | 26.95 Mbps <br> `3.27x slow` | 58.57 Mbps <br> `1.51x slow` | 21.69 Mbps <br> `4.07x slow` |
| SHA-256       | **88.39 Mbps** | 27.12 Mbps <br> `3.26x slow` | 60.75 Mbps <br> `1.45x slow` | 22.48 Mbps <br> `3.93x slow` |
| HMAC(SHA-256) | **14.35 Mbps** |                              | 12.45 Mbps <br> `1.15x slow` |                              |
| SHA-384       | **65.18 Mbps** | 2.33 Mbps <br> `27.95x slow` | 26.99 Mbps <br> `2.42x slow` | 11.16 Mbps <br> `5.84x slow` |
| SHA-512       | **64.21 Mbps** | 2.35 Mbps <br> `27.3x slow`  | 26.59 Mbps <br> `2.41x slow` | 11.39 Mbps <br> `5.64x slow` |
| SHA3-224      | **88.02 Mbps** | 1.57 Mbps <br> `55.89x slow` |                              |                              |
| SHA3-256      | **89.16 Mbps** | 1.56 Mbps <br> `57.23x slow` |                              |                              |
| SHA3-384      | **64.5 Mbps**  | 1.57 Mbps <br> `41.07x slow` |                              |                              |
| SHA3-512      | **63.11 Mbps** | 1.57 Mbps <br> `40.2x slow`  |                              |                              |
| RIPEMD-128    | **177 Mbps**   | 58.35 Mbps <br> `3.03x slow` |                              |                              |
| RIPEMD-160    | **86.81 Mbps** | 33.18 Mbps <br> `2.62x slow` |                              | 32.16 Mbps <br> `2.7x slow`  |
| RIPEMD-256    | **180 Mbps**   | 53.17 Mbps <br> `3.39x slow` |                              |                              |
| RIPEMD-320    | **85.18 Mbps** | 30.48 Mbps <br> `2.79x slow` |                              |                              |
| BLAKE-2s      | **152 Mbps**   |                              |                              |                              |
| BLAKE-2b      | **120 Mbps**   | 6.89 Mbps <br> `17.44x slow` |                              |                              |
| Poly1305      | **269 Mbps**   | 167 Mbps <br> `1.61x slow`   |                              |                              |
| XXH32         | **413 Mbps**   |                              |                              |                              |
| XXH64         | **332 Mbps**   |                              |                              |                              |
| XXH3          | **32.94 Mbps** |                              |                              |                              |
| XXH128        | **33.16 Mbps** |                              |                              |                              |
| SM3           | **93.33 Mbps** | 24.81 Mbps <br> `3.76x slow` |                              |                              |

Key derivator algorithm benchmarks on different security parameters:

| Algorithms | little   | moderate  | good       | strong      |
| ---------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 1.092 ms | 11.899 ms | 69.138 ms  | 2100.983 ms |
| bcrypt     | 1.803 ms | 14.474 ms | 226.341 ms | 1811.425 ms |
| pbkdf2     | 0.668 ms | 16.363 ms | 267.526 ms | 3211.098 ms |
| argon2i    | 2.359 ms | 17.448 ms | 205.518 ms | 2375.301 ms |
| argon2d    | 2.272 ms | 16.064 ms | 201.827 ms | 2374.41 ms  |
| argon2id   | 2.306 ms | 16.38 ms  | 199.66 ms  | 2376.102 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.7.0 (stable) (Wed Feb 5 04:53:58 2025 -0800) on "windows_x64"
