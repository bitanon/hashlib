# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **1.59 Gbps** | 836 Mbps <br> `1.9x slow`     |                             |                            |
| MD5           | **1.42 Gbps** | 728 Mbps <br> `1.95x slow`    | 1.15 Gbps <br> `1.23x slow` | 617 Mbps <br> `2.3x slow`  |
| HMAC(MD5)     | **1.37 Gbps** |                               | 1.13 Gbps <br> `1.21x slow` | 615 Mbps <br> `2.23x slow` |
| SHA-1         | **1.25 Gbps** | 439 Mbps <br> `2.84x slow`    | 861 Mbps <br> `1.45x slow`  | 351 Mbps <br> `3.55x slow` |
| HMAC(SHA-1)   | **1.25 Gbps** |                               | 858 Mbps <br> `1.46x slow`  |                            |
| SHA-224       | **823 Mbps**  | 179 Mbps <br> `4.59x slow`    | 744 Mbps <br> `1.11x slow`  | 172 Mbps <br> `4.78x slow` |
| SHA-256       | **827 Mbps**  | 181 Mbps <br> `4.57x slow`    | 746 Mbps <br> `1.11x slow`  | 172 Mbps <br> `4.79x slow` |
| HMAC(SHA-256) | **819 Mbps**  |                               | 740 Mbps <br> `1.11x slow`  |                            |
| SHA-384       | **1.32 Gbps** | 46.07 Mbps <br> `28.59x slow` | 445 Mbps <br> `2.96x slow`  | 151 Mbps <br> `8.74x slow` |
| SHA-512       | **1.32 Gbps** | 44.17 Mbps <br> `29.77x slow` | 443 Mbps <br> `2.97x slow`  | 150 Mbps <br> `8.74x slow` |
| SHA3-224      | **823 Mbps**  | 27.88 Mbps <br> `29.52x slow` |                             |                            |
| SHA3-256      | **826 Mbps**  | 26.6 Mbps <br> `31.06x slow`  |                             |                            |
| SHA3-384      | **1.31 Gbps** | 20.37 Mbps <br> `64.17x slow` |                             |                            |
| SHA3-512      | **1.31 Gbps** | 13.97 Mbps <br> `93.79x slow` |                             |                            |
| RIPEMD-128    | **1.77 Gbps** | 378 Mbps <br> `4.69x slow`    |                             |                            |
| RIPEMD-160    | **559 Mbps**  | 239 Mbps <br> `2.34x slow`    |                             | 281 Mbps <br> `1.99x slow` |
| RIPEMD-256    | **1.91 Gbps** | 373 Mbps <br> `5.11x slow`    |                             |                            |
| RIPEMD-320    | **543 Mbps**  | 237 Mbps <br> `2.29x slow`    |                             |                            |
| BLAKE-2s      | **1.2 Gbps**  |                               |                             |                            |
| BLAKE-2b      | **1.38 Gbps** | 105 Mbps <br> `13.12x slow`   |                             |                            |
| Poly1305      | **2.2 Gbps**  | 1.24 Gbps <br> `1.77x slow`   |                             |                            |
| XXH32         | **3.84 Gbps** |                               |                             |                            |
| XXH64         | **2.63 Gbps** |                               |                             |                            |
| XXH3          | **987 Mbps**  |                               |                             |                            |
| XXH128        | **985 Mbps**  |                               |                             |                            |
| SM3           | **637 Mbps**  | 185 Mbps <br> `3.44x slow`    |                             |                            |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **1.51 Gbps** | 795 Mbps <br> `1.9x slow`     |                             |                            |
| MD5           | **1.34 Gbps** | 684 Mbps <br> `1.96x slow`    | 1.08 Gbps <br> `1.24x slow` | 804 Mbps <br> `1.67x slow` |
| HMAC(MD5)     | **1.01 Gbps** |                               | 886 Mbps <br> `1.14x slow`  | 608 Mbps <br> `1.66x slow` |
| SHA-1         | **1.16 Gbps** | 416 Mbps <br> `2.79x slow`    | 809 Mbps <br> `1.44x slow`  | 395 Mbps <br> `2.93x slow` |
| HMAC(SHA-1)   | **773 Mbps**  |                               | 578 Mbps <br> `1.34x slow`  |                            |
| SHA-224       | **763 Mbps**  | 170 Mbps <br> `4.49x slow`    | 694 Mbps <br> `1.1x slow`   | 174 Mbps <br> `4.39x slow` |
| SHA-256       | **763 Mbps**  | 170 Mbps <br> `4.49x slow`    | 692 Mbps <br> `1.1x slow`   | 174 Mbps <br> `4.38x slow` |
| HMAC(SHA-256) | **519 Mbps**  |                               | 500 Mbps <br> `1.04x slow`  |                            |
| SHA-384       | **1.14 Gbps** | 40.79 Mbps <br> `27.98x slow` | 391 Mbps <br> `2.92x slow`  | 165 Mbps <br> `6.92x slow` |
| SHA-512       | **1.14 Gbps** | 40.88 Mbps <br> `27.87x slow` | 391 Mbps <br> `2.92x slow`  | 166 Mbps <br> `6.87x slow` |
| SHA3-224      | **767 Mbps**  | 25.06 Mbps <br> `30.59x slow` |                             |                            |
| SHA3-256      | **767 Mbps**  | 25.03 Mbps <br> `30.66x slow` |                             |                            |
| SHA3-384      | **1.14 Gbps** | 20.05 Mbps <br> `56.82x slow` |                             |                            |
| SHA3-512      | **1.14 Gbps** | 13.41 Mbps <br> `85.04x slow` |                             |                            |
| RIPEMD-128    | **1.63 Gbps** | 359 Mbps <br> `4.56x slow`    |                             |                            |
| RIPEMD-160    | **535 Mbps**  | 229 Mbps <br> `2.34x slow`    |                             | 286 Mbps <br> `1.87x slow` |
| RIPEMD-256    | **1.77 Gbps** | 356 Mbps <br> `4.96x slow`    |                             |                            |
| RIPEMD-320    | **509 Mbps**  | 224 Mbps <br> `2.28x slow`    |                             |                            |
| BLAKE-2s      | **1.18 Gbps** |                               |                             |                            |
| BLAKE-2b      | **1.34 Gbps** | 104 Mbps <br> `12.91x slow`   |                             |                            |
| Poly1305      | **2.12 Gbps** | 1.23 Gbps <br> `1.72x slow`   |                             |                            |
| XXH32         | **4.12 Gbps** |                               |                             |                            |
| XXH64         | **2.54 Gbps** |                               |                             |                            |
| XXH3          | **918 Mbps**  |                               |                             |                            |
| XXH128        | **925 Mbps**  |                               |                             |                            |
| SM3           | **599 Mbps**  | 174 Mbps <br> `3.43x slow`    |                             |                            |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                         | `hash`                       |
| ------------- | -------------- | ---------------------------- | -------------------------------- | ---------------------------- |
| MD4           | **261 Mbps**   | 138 Mbps <br> `1.89x slow`   |                                  |                              |
| MD5           | **242 Mbps**   | 118 Mbps <br> `2.05x slow`   | 125 Mbps <br> `1.94x slow`       | 66.64 Mbps <br> `3.63x slow` |
| HMAC(MD5)     | 35.22 Mbps     |                              | **38.21 Mbps** <br> `1.08x fast` | 17.63 Mbps <br> `2x slow`    |
| SHA-1         | **152 Mbps**   | 64.91 Mbps <br> `2.34x slow` | 97.82 Mbps <br> `1.55x slow`     | 42.4 Mbps <br> `3.58x slow`  |
| HMAC(SHA-1)   | **19.18 Mbps** |                              | 17.66 Mbps <br> `1.09x slow`     |                              |
| SHA-224       | **107 Mbps**   | 27.04 Mbps <br> `3.97x slow` | 81.07 Mbps <br> `1.32x slow`     | 22.87 Mbps <br> `4.7x slow`  |
| SHA-256       | **107 Mbps**   | 26.91 Mbps <br> `3.98x slow` | 82.72 Mbps <br> `1.3x slow`      | 23.14 Mbps <br> `4.63x slow` |
| HMAC(SHA-256) | 13.54 Mbps     |                              | **14.94 Mbps** <br> `1.1x fast`  |                              |
| SHA-384       | **81.51 Mbps** | 3.49 Mbps <br> `23.36x slow` | 29.83 Mbps <br> `2.73x slow`     | 11.84 Mbps <br> `6.89x slow` |
| SHA-512       | **81 Mbps**    | 3.52 Mbps <br> `23.02x slow` | 29.68 Mbps <br> `2.73x slow`     | 11.94 Mbps <br> `6.78x slow` |
| SHA3-224      | **107 Mbps**   | 1.9 Mbps <br> `56.53x slow`  |                                  |                              |
| SHA3-256      | **107 Mbps**   | 1.9 Mbps <br> `56.4x slow`   |                                  |                              |
| SHA3-384      | **80.78 Mbps** | 1.9 Mbps <br> `42.47x slow`  |                                  |                              |
| SHA3-512      | **81.33 Mbps** | 1.9 Mbps <br> `42.87x slow`  |                                  |                              |
| RIPEMD-128    | **233 Mbps**   | 60.55 Mbps <br> `3.85x slow` |                                  |                              |
| RIPEMD-160    | **80.32 Mbps** | 36.69 Mbps <br> `2.19x slow` |                                  | 34.53 Mbps <br> `2.33x slow` |
| RIPEMD-256    | **238 Mbps**   | 58.04 Mbps <br> `4.1x slow`  |                                  |                              |
| RIPEMD-320    | **76.66 Mbps** | 34.48 Mbps <br> `2.22x slow` |                                  |                              |
| BLAKE-2s      | **168 Mbps**   |                              |                                  |                              |
| BLAKE-2b      | **140 Mbps**   | 7.71 Mbps <br> `18.21x slow` |                                  |                              |
| Poly1305      | **572 Mbps**   | 308 Mbps <br> `1.86x slow`   |                                  |                              |
| XXH32         | **840 Mbps**   |                              |                                  |                              |
| XXH64         | **656 Mbps**   |                              |                                  |                              |
| XXH3          | **82.46 Mbps** |                              |                                  |                              |
| XXH128        | **83.76 Mbps** |                              |                                  |                              |
| SM3           | **101 Mbps**   | 28.19 Mbps <br> `3.57x slow` |                                  |                              |

Key derivator algorithm benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.056 ms | 1.495 ms | 27.024 ms | 88.235 ms  | 2945.416 ms |
| bcrypt     | 0.226 ms | 2.124 ms | 17.19 ms  | 270.562 ms | 2159.172 ms |
| argon2i    | 0.334 ms | 2.548 ms | 16.994 ms | 213.406 ms | 2556.027 ms |
| argon2d    | 0.265 ms | 2.475 ms | 17.222 ms | 211.376 ms | 2528.972 ms |
| argon2id   | 0.276 ms | 2.549 ms | 19.534 ms | 213.577 ms | 2547.892 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
