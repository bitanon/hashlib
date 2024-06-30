# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **2.07 Gbps** | 828 Mbps <br> `2.5x slow`     |                             |                            |
| MD5           | **1.41 Gbps** | 724 Mbps <br> `1.95x slow`    | 1.13 Gbps <br> `1.25x slow` | 627 Mbps <br> `2.26x slow` |
| HMAC(MD5)     | **1.3 Gbps**  |                               | 1.12 Gbps <br> `1.16x slow` | 625 Mbps <br> `2.08x slow` |
| SHA-1         | **1.21 Gbps** | 456 Mbps <br> `2.65x slow`    | 849 Mbps <br> `1.42x slow`  | 362 Mbps <br> `3.34x slow` |
| HMAC(SHA-1)   | **1.21 Gbps** |                               | 844 Mbps <br> `1.43x slow`  |                            |
| SHA-224       | **810 Mbps**  | 176 Mbps <br> `4.6x slow`     | 723 Mbps <br> `1.12x slow`  | 170 Mbps <br> `4.76x slow` |
| SHA-256       | **809 Mbps**  | 179 Mbps <br> `4.52x slow`    | 724 Mbps <br> `1.12x slow`  | 170 Mbps <br> `4.77x slow` |
| HMAC(SHA-256) | **813 Mbps**  |                               | 708 Mbps <br> `1.15x slow`  |                            |
| SHA-384       | **1.27 Gbps** | 44.66 Mbps <br> `28.36x slow` | 445 Mbps <br> `2.85x slow`  | 150 Mbps <br> `8.43x slow` |
| SHA-512       | **1.26 Gbps** | 45.17 Mbps <br> `27.94x slow` | 445 Mbps <br> `2.84x slow`  | 151 Mbps <br> `8.38x slow` |
| SHA3-256      | **812 Mbps**  | 26.32 Mbps <br> `30.86x slow` |                             |                            |
| SHA3-512      | **1.27 Gbps** | 13.91 Mbps <br> `91.63x slow` |                             |                            |
| RIPEMD-128    | **1.77 Gbps** | 368 Mbps <br> `4.8x slow`     |                             |                            |
| RIPEMD-160    | **551 Mbps**  | 234 Mbps <br> `2.35x slow`    |                             | 276 Mbps <br> `2x slow`    |
| RIPEMD-256    | **1.9 Gbps**  | 370 Mbps <br> `5.14x slow`    |                             |                            |
| RIPEMD-320    | **552 Mbps**  | 231 Mbps <br> `2.39x slow`    |                             |                            |
| BLAKE-2s      | **1.2 Gbps**  |                               |                             |                            |
| BLAKE-2b      | **1.37 Gbps** | 105 Mbps <br> `13.06x slow`   |                             |                            |
| Poly1305      | **3.83 Gbps** | 1.26 Gbps <br> `3.03x slow`   |                             |                            |
| XXH32         | **4.48 Gbps** |                               |                             |                            |
| XXH64         | **4.42 Gbps** |                               |                             |                            |
| XXH3          | **1.02 Gbps** |                               |                             |                            |
| XXH128        | **1.02 Gbps** |                               |                             |                            |
| SM3           | **706 Mbps**  | 188 Mbps <br> `3.76x slow`    |                             |                            |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                | `crypto`                    | `hash`                     |
| ------------- | ------------- | ----------------------------- | --------------------------- | -------------------------- |
| MD4           | **1.95 Gbps** | 794 Mbps <br> `2.45x slow`    |                             |                            |
| MD5           | **1.35 Gbps** | 691 Mbps <br> `1.95x slow`    | 1.04 Gbps <br> `1.29x slow` | 835 Mbps <br> `1.62x slow` |
| HMAC(MD5)     | **1.07 Gbps** |                               | 882 Mbps <br> `1.21x slow`  | 624 Mbps <br> `1.71x slow` |
| SHA-1         | **1.13 Gbps** | 429 Mbps <br> `2.62x slow`    | 790 Mbps <br> `1.43x slow`  | 407 Mbps <br> `2.76x slow` |
| HMAC(SHA-1)   | **830 Mbps**  |                               | 570 Mbps <br> `1.46x slow`  |                            |
| SHA-224       | **751 Mbps**  | 169 Mbps <br> `4.45x slow`    | 672 Mbps <br> `1.12x slow`  | 173 Mbps <br> `4.35x slow` |
| SHA-256       | **749 Mbps**  | 169 Mbps <br> `4.43x slow`    | 674 Mbps <br> `1.11x slow`  | 173 Mbps <br> `4.34x slow` |
| HMAC(SHA-256) | **541 Mbps**  |                               | 486 Mbps <br> `1.11x slow`  |                            |
| SHA-384       | **1.11 Gbps** | 41.31 Mbps <br> `26.78x slow` | 394 Mbps <br> `2.81x slow`  | 168 Mbps <br> `6.59x slow` |
| SHA-512       | **1.11 Gbps** | 40.96 Mbps <br> `27.07x slow` | 394 Mbps <br> `2.82x slow`  | 168 Mbps <br> `6.61x slow` |
| SHA3-256      | **752 Mbps**  | 24.86 Mbps <br> `30.26x slow` |                             |                            |
| SHA3-512      | **1.11 Gbps** | 13.32 Mbps <br> `83.25x slow` |                             |                            |
| RIPEMD-128    | **1.64 Gbps** | 350 Mbps <br> `4.68x slow`    |                             |                            |
| RIPEMD-160    | **516 Mbps**  | 220 Mbps <br> `2.34x slow`    |                             | 297 Mbps <br> `1.74x slow` |
| RIPEMD-256    | **1.75 Gbps** | 350 Mbps <br> `5x slow`       |                             |                            |
| RIPEMD-320    | **518 Mbps**  | 218 Mbps <br> `2.37x slow`    |                             |                            |
| BLAKE-2s      | **1.18 Gbps** |                               |                             |                            |
| BLAKE-2b      | **1.33 Gbps** | 103 Mbps <br> `12.9x slow`    |                             |                            |
| Poly1305      | **3.57 Gbps** | 1.26 Gbps <br> `2.84x slow`   |                             |                            |
| XXH32         | **4.23 Gbps** |                               |                             |                            |
| XXH64         | **4.19 Gbps** |                               |                             |                            |
| XXH3          | **956 Mbps**  |                               |                             |                            |
| XXH128        | **949 Mbps**  |                               |                             |                            |
| SM3           | **659 Mbps**  | 176 Mbps <br> `3.73x slow`    |                             |                            |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`               | `crypto`                     | `hash`                       |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **273 Mbps**   | 135 Mbps <br> `2.02x slow`   |                              |                              |
| MD5           | **246 Mbps**   | 118 Mbps <br> `2.08x slow`   | 125 Mbps <br> `1.97x slow`   | 69.2 Mbps <br> `3.55x slow`  |
| HMAC(MD5)     | **44.45 Mbps** |                              | 38.39 Mbps <br> `1.16x slow` | 18.19 Mbps <br> `2.44x slow` |
| SHA-1         | **144 Mbps**   | 66.9 Mbps <br> `2.15x slow`  | 98.88 Mbps <br> `1.45x slow` | 43.49 Mbps <br> `3.31x slow` |
| HMAC(SHA-1)   | **22.92 Mbps** |                              | 17.47 Mbps <br> `1.31x slow` |                              |
| SHA-224       | **103 Mbps**   | 27.22 Mbps <br> `3.8x slow`  | 80.2 Mbps <br> `1.29x slow`  | 22.93 Mbps <br> `4.51x slow` |
| SHA-256       | **103 Mbps**   | 27.14 Mbps <br> `3.79x slow` | 80.67 Mbps <br> `1.27x slow` | 23.12 Mbps <br> `4.45x slow` |
| HMAC(SHA-256) | **15.92 Mbps** |                              | 14.53 Mbps <br> `1.1x slow`  |                              |
| SHA-384       | **80.46 Mbps** | 3.5 Mbps <br> `23.01x slow`  | 30.22 Mbps <br> `2.66x slow` | 12.08 Mbps <br> `6.66x slow` |
| SHA-512       | **80.02 Mbps** | 3.48 Mbps <br> `22.98x slow` | 29.82 Mbps <br> `2.68x slow` | 12.12 Mbps <br> `6.6x slow`  |
| SHA3-256      | **103 Mbps**   | 1.88 Mbps <br> `54.75x slow` |                              |                              |
| SHA3-512      | **80.01 Mbps** | 1.88 Mbps <br> `42.63x slow` |                              |                              |
| RIPEMD-128    | **234 Mbps**   | 58.97 Mbps <br> `3.96x slow` |                              |                              |
| RIPEMD-160    | **80.04 Mbps** | 35.41 Mbps <br> `2.26x slow` |                              | 36.04 Mbps <br> `2.22x slow` |
| RIPEMD-256    | **243 Mbps**   | 57.34 Mbps <br> `4.23x slow` |                              |                              |
| RIPEMD-320    | **79.08 Mbps** | 33.59 Mbps <br> `2.35x slow` |                              |                              |
| BLAKE-2s      | **159 Mbps**   |                              |                              |                              |
| BLAKE-2b      | **125 Mbps**   | 7.61 Mbps <br> `16.38x slow` |                              |                              |
| Poly1305      | **508 Mbps**   | 318 Mbps <br> `1.6x slow`    |                              |                              |
| XXH32         | **837 Mbps**   |                              |                              |                              |
| XXH64         | **643 Mbps**   |                              |                              |                              |
| XXH3          | **87.49 Mbps** |                              |                              |                              |
| XXH128        | **83.2 Mbps**  |                              |                              |                              |
| SM3           | **98.76 Mbps** | 28.65 Mbps <br> `3.45x slow` |                              |                              |

Key derivator algorithm benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.056 ms | 1.564 ms | 11.017 ms | 92.747 ms  | 1375.198 ms |
| bcrypt     | 0.184 ms | 2.165 ms | 16.617 ms | 262.765 ms | 2101.005 ms |
| argon2i    | 0.333 ms | 3.034 ms | 16.871 ms | 205.397 ms | 2602.407 ms |
| argon2d    | 0.289 ms | 2.351 ms | 16.702 ms | 207.512 ms | 2650.916 ms |
| argon2id   | 0.284 ms | 2.354 ms | 16.642 ms | 209.787 ms | 2574.973 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
