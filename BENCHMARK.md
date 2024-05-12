# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **2.22 Gbps** | 864 Mbps <br> `2.57x slow`    |                             |                            |
| MD5           | **1.43 Gbps** | 756 Mbps <br> `1.89x slow`    | 1.14 Gbps <br> `1.25x slow` | 638 Mbps <br> `2.24x slow` |
| HMAC(MD5)     | **1.36 Gbps** |                               | 1.09 Gbps <br> `1.25x slow` | 652 Mbps <br> `2.09x slow` |
| SHA-1         | **1.21 Gbps** | 452 Mbps <br> `2.67x slow`    | 845 Mbps <br> `1.43x slow`  | 370 Mbps <br> `3.27x slow` |
| HMAC(SHA-1)   | **1.21 Gbps** |                               | 834 Mbps <br> `1.45x slow`  |                            |
| SHA-224       | **805 Mbps**  | 181 Mbps <br> `4.45x slow`    | 739 Mbps <br> `1.09x slow`  | 173 Mbps <br> `4.65x slow` |
| SHA-256       | **807 Mbps**  | 183 Mbps <br> `4.41x slow`    | 739 Mbps <br> `1.09x slow`  | 173 Mbps <br> `4.66x slow` |
| HMAC(SHA-256) | **804 Mbps**  |                               | 739 Mbps <br> `1.09x slow`  |                            |
| SHA-384       | **1.26 Gbps** | 44.04 Mbps <br> `28.53x slow` | 452 Mbps <br> `2.78x slow`  | 152 Mbps <br> `8.25x slow` |
| SHA-512       | **1.27 Gbps** | 45.79 Mbps <br> `27.65x slow` | 451 Mbps <br> `2.81x slow`  | 153 Mbps <br> `8.3x slow`  |
| SHA3-256      | **803 Mbps**  | 26.94 Mbps <br> `29.83x slow` |                             |                            |
| SHA3-512      | **1.26 Gbps** | 14.31 Mbps <br> `88.28x slow` |                             |                            |
| RIPEMD-128    | **1.76 Gbps** | 376 Mbps <br> `4.7x slow`     |                             |                            |
| RIPEMD-160    | **553 Mbps**  | 232 Mbps <br> `2.39x slow`    |                             | 279 Mbps <br> `1.98x slow` |
| RIPEMD-256    | **1.91 Gbps** | 376 Mbps <br> `5.09x slow`    |                             |                            |
| RIPEMD-320    | **550 Mbps**  | 230 Mbps <br> `2.39x slow`    |                             |                            |
| BLAKE-2s      | **1.2 Gbps**  |                               |                             |                            |
| BLAKE-2b      | **1.37 Gbps** | 102 Mbps <br> `13.34x slow`   |                             |                            |
| Poly1305      | **3.67 Gbps** | 1.28 Gbps <br> `2.87x slow`   |                             |                            |
| XXH32         | **4.35 Gbps** |                               |                             |                            |
| XXH64         | **4.39 Gbps** |                               |                             |                            |
| XXH3          | **1.01 Gbps** |                               |                             |                            |
| XXH128        | **1.01 Gbps** |                               |                             |                            |
| SM3           | **667 Mbps**  | 188 Mbps <br> `3.55x slow`    |                             |                            |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **1.99 Gbps** | 806 Mbps <br> `2.47x slow`    |                             |                            |
| MD5           | **1.34 Gbps** | 692 Mbps <br> `1.94x slow`    | 1.06 Gbps <br> `1.26x slow` | 801 Mbps <br> `1.67x slow` |
| HMAC(MD5)     | **1.07 Gbps** |                               | 881 Mbps <br> `1.22x slow`  | 611 Mbps <br> `1.75x slow` |
| SHA-1         | **1.11 Gbps** | 425 Mbps <br> `2.6x slow`     | 797 Mbps <br> `1.39x slow`  | 401 Mbps <br> `2.75x slow` |
| HMAC(SHA-1)   | **808 Mbps**  |                               | 579 Mbps <br> `1.4x slow`   |                            |
| SHA-224       | **742 Mbps**  | 172 Mbps <br> `4.3x slow`     | 691 Mbps <br> `1.07x slow`  | 172 Mbps <br> `4.32x slow` |
| SHA-256       | **741 Mbps**  | 173 Mbps <br> `4.29x slow`    | 680 Mbps <br> `1.09x slow`  | 172 Mbps <br> `4.3x slow`  |
| HMAC(SHA-256) | **530 Mbps**  |                               | 498 Mbps <br> `1.06x slow`  |                            |
| SHA-384       | **1.08 Gbps** | 40.49 Mbps <br> `26.75x slow` | 398 Mbps <br> `2.72x slow`  | 165 Mbps <br> `6.56x slow` |
| SHA-512       | **1.09 Gbps** | 40.88 Mbps <br> `26.65x slow` | 397 Mbps <br> `2.75x slow`  | 165 Mbps <br> `6.61x slow` |
| SHA3-256      | **744 Mbps**  | 25.43 Mbps <br> `29.26x slow` |                             |                            |
| SHA3-512      | **1.1 Gbps**  | 13.6 Mbps <br> `80.78x slow`  |                             |                            |
| RIPEMD-128    | **1.64 Gbps** | 355 Mbps <br> `4.61x slow`    |                             |                            |
| RIPEMD-160    | **518 Mbps**  | 218 Mbps <br> `2.37x slow`    |                             | 292 Mbps <br> `1.77x slow` |
| RIPEMD-256    | **1.77 Gbps** | 354 Mbps <br> `5.01x slow`    |                             |                            |
| RIPEMD-320    | **516 Mbps**  | 216 Mbps <br> `2.39x slow`    |                             |                            |
| BLAKE-2s      | **1.17 Gbps** |                               |                             |                            |
| BLAKE-2b      | **1.32 Gbps** | 101 Mbps <br> `13.07x slow`   |                             |                            |
| Poly1305      | **3.45 Gbps** | 1.26 Gbps <br> `2.73x slow`   |                             |                            |
| XXH32         | **4.15 Gbps** |                               |                             |                            |
| XXH64         | **4.1 Gbps**  |                               |                             |                            |
| XXH3          | **951 Mbps**  |                               |                             |                            |
| XXH128        | **943 Mbps**  |                               |                             |                            |
| SM3           | **658 Mbps**  | 177 Mbps <br> `3.71x slow`    |                             |                            |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                       |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **286 Mbps**   | 142 Mbps <br> `2.02x slow`   |                              |                              |
| MD5           | **252 Mbps**   | 121 Mbps <br> `2.08x slow`   | 125 Mbps <br> `2.01x slow`   | 67.68 Mbps <br> `3.72x slow` |
| HMAC(MD5)     | **44.8 Mbps**  |                              | 38.62 Mbps <br> `1.16x slow` | 17.96 Mbps <br> `2.49x slow` |
| SHA-1         | **143 Mbps**   | 65.93 Mbps <br> `2.17x slow` | 98.48 Mbps <br> `1.45x slow` | 42.65 Mbps <br> `3.35x slow` |
| HMAC(SHA-1)   | **22.88 Mbps** |                              | 17.64 Mbps <br> `1.3x slow`  |                              |
| SHA-224       | **101 Mbps**   | 27.37 Mbps <br> `3.7x slow`  | 82.92 Mbps <br> `1.22x slow` | 22.88 Mbps <br> `4.43x slow` |
| SHA-256       | **99.94 Mbps** | 27.66 Mbps <br> `3.61x slow` | 83.27 Mbps <br> `1.2x slow`  | 23.09 Mbps <br> `4.33x slow` |
| HMAC(SHA-256) | **15.5 Mbps**  |                              | 15.17 Mbps <br> `1.02x slow` |                              |
| SHA-384       | **77.33 Mbps** | 3.48 Mbps <br> `22.23x slow` | 30.53 Mbps <br> `2.53x slow` | 11.94 Mbps <br> `6.48x slow` |
| SHA-512       | **77.58 Mbps** | 3.48 Mbps <br> `22.3x slow`  | 30.5 Mbps <br> `2.54x slow`  | 12.03 Mbps <br> `6.45x slow` |
| SHA3-256      | **101 Mbps**   | 1.91 Mbps <br> `52.53x slow` |                              |                              |
| SHA3-512      | **77.68 Mbps** | 1.91 Mbps <br> `40.58x slow` |                              |                              |
| RIPEMD-128    | **238 Mbps**   | 57.95 Mbps <br> `4.1x slow`  |                              |                              |
| RIPEMD-160    | **79.49 Mbps** | 34.7 Mbps <br> `2.29x slow`  |                              | 35.43 Mbps <br> `2.24x slow` |
| RIPEMD-256    | **243 Mbps**   | 57.48 Mbps <br> `4.22x slow` |                              |                              |
| RIPEMD-320    | **78.84 Mbps** | 33.2 Mbps <br> `2.37x slow`  |                              |                              |
| BLAKE-2s      | **156 Mbps**   |                              |                              |                              |
| BLAKE-2b      | **128 Mbps**   | 7.45 Mbps <br> `17.19x slow` |                              |                              |
| Poly1305      | **538 Mbps**   | 312 Mbps <br> `1.72x slow`   |                              |                              |
| XXH32         | **858 Mbps**   |                              |                              |                              |
| XXH64         | **646 Mbps**   |                              |                              |                              |
| XXH3          | **88.11 Mbps** |                              |                              |                              |
| XXH128        | **83.12 Mbps** |                              |                              |                              |
| SM3           | **98.72 Mbps** | 28.64 Mbps <br> `3.45x slow` |                              |                              |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.057 ms | 1.518 ms | 11.05 ms  | 87.86 ms   | 1440.171 ms |
| argon2i    | 0.348 ms | 2.539 ms | 16.816 ms | 202.203 ms | 2414.167 ms |
| argon2d    | 0.312 ms | 2.46 ms  | 17.917 ms | 205.445 ms | 2394.531 ms |
| argon2id   | 0.311 ms | 2.332 ms | 16.581 ms | 200.097 ms | 2420.071 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
