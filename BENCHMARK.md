# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **259.72MB/s** | 99.56MB/s <br> `161% slower`  | ➖                           | ➖                           |
| MD5           | **168.39MB/s** | 87.81MB/s <br> `92% slower`   | 131.96MB/s <br> `28% slower` | 76.41MB/s <br> `120% slower` |
| HMAC(MD5)     | **156.45MB/s** | ➖                            | 129.58MB/s <br> `21% slower` | 75.25MB/s <br> `108% slower` |
| SHA-1         | **139.41MB/s** | 53.93MB/s <br> `158% slower`  | 100.08MB/s <br> `39% slower` | 42.84MB/s <br> `225% slower` |
| HMAC(SHA-1)   | **139.88MB/s** | ➖                            | 101.45MB/s <br> `38% slower` | ➖                           |
| SHA-224       | **95.23MB/s**  | 20.65MB/s <br> `361% slower`  | 86.13MB/s <br> `11% slower`  | 20.32MB/s <br> `369% slower` |
| SHA-256       | **95.18MB/s**  | 20.83MB/s <br> `357% slower`  | 86.50MB/s <br> `10% slower`  | 20.45MB/s <br> `365% slower` |
| HMAC(SHA-256) | **94.70MB/s**  | ➖                            | 85.48MB/s <br> `11% slower`  | ➖                           |
| SHA-384       | **151.46MB/s** | 5.41MB/s <br> `2698% slower`  | 53.04MB/s <br> `186% slower` | 17.97MB/s <br> `743% slower` |
| SHA-512       | **150.59MB/s** | 5.39MB/s <br> `2693% slower`  | 52.88MB/s <br> `185% slower` | 17.94MB/s <br> `739% slower` |
| SHA3-256      | **95.12MB/s**  | 3.21MB/s <br> `2855% slower`  | ➖                           | ➖                           |
| SHA3-512      | **150.90MB/s** | 1.70MB/s <br> `8754% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **204.31MB/s** | 43.18MB/s <br> `373% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **65.84MB/s**  | 28.14MB/s <br> `134% slower`  | ➖                           | 33.66MB/s <br> `96% slower`  |
| RIPEMD-256    | **223.50MB/s** | 41.98MB/s <br> `432% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **65.74MB/s**  | 27.95MB/s <br> `135% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **143.56MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **158.93MB/s** | 12.08MB/s <br> `1215% slower` | ➖                           | ➖                           |
| Poly1305      | **448.23MB/s** | 147.96MB/s <br> `203% slower` | ➖                           | ➖                           |
| XXH32         | **518.68MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **527.12MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **120.16MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **119.32MB/s** | ➖                            | ➖                           | ➖                           |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD4           | **243.89MB/s** | 95.49MB/s <br> `155% slower`  | ➖                           | ➖                           |
| MD5           | **161.42MB/s** | 83.58MB/s <br> `93% slower`   | 127.65MB/s <br> `26% slower` | 96.58MB/s <br> `67% slower`  |
| HMAC(MD5)     | **128.92MB/s** | ➖                            | 106.10MB/s <br> `22% slower` | 73.12MB/s <br> `76% slower`  |
| SHA-1         | **131.39MB/s** | 51.14MB/s <br> `157% slower`  | 95.65MB/s <br> `37% slower`  | 46.99MB/s <br> `180% slower` |
| HMAC(SHA-1)   | **96.57MB/s**  | ➖                            | 69.18MB/s <br> `40% slower`  | ➖                           |
| SHA-224       | **88.92MB/s**  | 19.92MB/s <br> `346% slower`  | 81.37MB/s <br> `9% slower`   | 20.68MB/s <br> `330% slower` |
| SHA-256       | **88.71MB/s**  | 19.87MB/s <br> `346% slower`  | 81.34MB/s <br> `9% slower`   | 20.71MB/s <br> `328% slower` |
| HMAC(SHA-256) | **64.20MB/s**  | ➖                            | 58.76MB/s <br> `9% slower`   | ➖                           |
| SHA-384       | **131.39MB/s** | 4.91MB/s <br> `2571% slower`  | 46.20MB/s <br> `184% slower` | 19.43MB/s <br> `576% slower` |
| SHA-512       | **131.90MB/s** | 4.89MB/s <br> `2593% slower`  | 46.37MB/s <br> `184% slower` | 19.53MB/s <br> `575% slower` |
| SHA3-256      | **89.05MB/s**  | 3.08MB/s <br> `2790% slower`  | ➖                           | ➖                           |
| SHA3-512      | **132.36MB/s** | 1.65MB/s <br> `7918% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **195.96MB/s** | 41.61MB/s <br> `371% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **61.78MB/s**  | 26.49MB/s <br> `133% slower`  | ➖                           | 35.84MB/s <br> `72% slower`  |
| RIPEMD-256    | **207.92MB/s** | 39.87MB/s <br> `421% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **61.66MB/s**  | 26.29MB/s <br> `134% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **141.49MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **152.02MB/s** | 11.96MB/s <br> `1170% slower` | ➖                           | ➖                           |
| Poly1305      | **423.75MB/s** | 146.63MB/s <br> `189% slower` | ➖                           | ➖                           |
| XXH32         | **494.25MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **501.45MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **113.33MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **112.55MB/s** | ➖                            | ➖                           | ➖                           |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                 | `crypto`                     | `hash`                      |
| ------------- | -------------- | ------------------------------ | ---------------------------- | --------------------------- |
| MD4           | **35.37MB/s**  | 16.32MB/s <br> `117% slower`   | ➖                           | ➖                          |
| MD5           | **29.80MB/s**  | 14.07MB/s <br> `112% slower`   | 14.82MB/s <br> `101% slower` | 8.03MB/s <br> `271% slower` |
| HMAC(MD5)     | **5.20MB/s**   | ➖                             | 4.53MB/s <br> `15% slower`   | 2.15MB/s <br> `142% slower` |
| SHA-1         | **16.91MB/s**  | 7.78MB/s <br> `117% slower`    | 11.61MB/s <br> `46% slower`  | 5.08MB/s <br> `233% slower` |
| HMAC(SHA-1)   | **2.68MB/s**   | ➖                             | 2.08MB/s <br> `29% slower`   | ➖                          |
| SHA-224       | **12.24MB/s**  | 3.23MB/s <br> `278% slower`    | 9.75MB/s <br> `26% slower`   | 2.74MB/s <br> `346% slower` |
| SHA-256       | **12.24MB/s**  | 3.21MB/s <br> `281% slower`    | 9.83MB/s <br> `25% slower`   | 2.76MB/s <br> `342% slower` |
| HMAC(SHA-256) | **1.89MB/s**   | ➖                             | 1.76MB/s <br> `7% slower`    | ➖                          |
| SHA-384       | **9.41MB/s**   | 432.14KB/s <br> `2131% slower` | 3.56MB/s <br> `164% slower`  | 1.40MB/s <br> `568% slower` |
| SHA-512       | **9.36MB/s**   | 432.57KB/s <br> `2118% slower` | 3.55MB/s <br> `164% slower`  | 1.42MB/s <br> `560% slower` |
| SHA3-256      | **12.24MB/s**  | 239.44KB/s <br> `5137% slower` | ➖                           | ➖                          |
| SHA3-512      | **9.31MB/s**   | 239.06KB/s <br> `3889% slower` | ➖                           | ➖                          |
| RIPEMD-128    | **28.70MB/s**  | 6.79MB/s <br> `322% slower`    | ➖                           | ➖                          |
| RIPEMD-160    | **9.48MB/s**   | 4.26MB/s <br> `123% slower`    | ➖                           | 4.32MB/s <br> `120% slower` |
| RIPEMD-256    | **28.97MB/s**  | 6.44MB/s <br> `350% slower`    | ➖                           | ➖                          |
| RIPEMD-320    | **9.42MB/s**   | 4.03MB/s <br> `134% slower`    | ➖                           | ➖                          |
| BLAKE-2s      | **19.13MB/s**  | ➖                             | ➖                           | ➖                          |
| BLAKE-2b      | **15.15MB/s**  | 903.43KB/s <br> `1618% slower` | ➖                           | ➖                          |
| Poly1305      | **62.02MB/s**  | 36.58MB/s <br> `70% slower`    | ➖                           | ➖                          |
| XXH32         | **101.78MB/s** | ➖                             | ➖                           | ➖                          |
| XXH64         | **76.44MB/s**  | ➖                             | ➖                           | ➖                          |
| XXH3          | **10.43MB/s**  | ➖                             | ➖                           | ➖                          |
| XXH128        | **10.01MB/s**  | ➖                             | ➖                           | ➖                          |

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
