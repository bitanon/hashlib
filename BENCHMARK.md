# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD5           | **170.53MB/s** | 81.35MB/s <br> `110% slower`  | 136.30MB/s <br> `25% slower` | 76.73MB/s <br> `122% slower` |
| HMAC(MD5)     | **159.58MB/s** | ➖                            | 136.15MB/s <br> `17% slower` | 76.89MB/s <br> `108% slower` |
| SHA-1         | **142.59MB/s** | 53.02MB/s <br> `169% slower`  | 102.50MB/s <br> `39% slower` | 43.61MB/s <br> `227% slower` |
| HMAC(SHA-1)   | **141.53MB/s** | ➖                            | 101.98MB/s <br> `39% slower` | ➖                           |
| SHA-224       | **95.10MB/s**  | 21.01MB/s <br> `352% slower`  | 87.38MB/s <br> `9% slower`   | 20.61MB/s <br> `361% slower` |
| SHA-256       | **94.87MB/s**  | 21.24MB/s <br> `346% slower`  | 87.11MB/s <br> `9% slower`   | 20.53MB/s <br> `362% slower` |
| HMAC(SHA-256) | **95.04MB/s**  | ➖                            | 87.26MB/s <br> `9% slower`   | ➖                           |
| SHA-384       | **151.95MB/s** | 4.94MB/s <br> `2974% slower`  | 53.19MB/s <br> `186% slower` | 17.97MB/s <br> `745% slower` |
| SHA-512       | **151.55MB/s** | 4.97MB/s <br> `2946% slower`  | 53.18MB/s <br> `185% slower` | 18.19MB/s <br> `733% slower` |
| SHA3-256      | **94.98MB/s**  | 3.21MB/s <br> `2859% slower`  | ➖                           | ➖                           |
| SHA3-512      | **151.83MB/s** | 1.70MB/s <br> `8831% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **209.75MB/s** | 43.57MB/s <br> `381% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **65.42MB/s**  | 28.20MB/s <br> `132% slower`  | ➖                           | 34.23MB/s <br> `91% slower`  |
| RIPEMD-256    | **224.79MB/s** | 43.14MB/s <br> `421% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **66.21MB/s**  | 27.56MB/s <br> `140% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **142.40MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **163.02MB/s** | 12.12MB/s <br> `1244% slower` | ➖                           | ➖                           |
| Poly1305      | **432.83MB/s** | 152.54MB/s <br> `184% slower` | ➖                           | ➖                           |
| XXH32         | **471.74MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **534.63MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **118.42MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **119.06MB/s** | ➖                            | ➖                           | ➖                           |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD5           | **161.58MB/s** | 80.23MB/s <br> `101% slower`  | 127.70MB/s <br> `27% slower` | 98.07MB/s <br> `65% slower`  |
| HMAC(MD5)     | **129.45MB/s** | ➖                            | 106.28MB/s <br> `22% slower` | 72.41MB/s <br> `79% slower`  |
| SHA-1         | **131.47MB/s** | 50.05MB/s <br> `163% slower`  | 96.13MB/s <br> `37% slower`  | 47.31MB/s <br> `178% slower` |
| HMAC(SHA-1)   | **98.25MB/s**  | ➖                            | 69.93MB/s <br> `40% slower`  | ➖                           |
| SHA-224       | **88.27MB/s**  | 19.99MB/s <br> `341% slower`  | 81.18MB/s <br> `9% slower`   | 20.52MB/s <br> `330% slower` |
| SHA-256       | **88.17MB/s**  | 19.93MB/s <br> `342% slower`  | 81.11MB/s <br> `9% slower`   | 20.62MB/s <br> `327% slower` |
| HMAC(SHA-256) | **63.57MB/s**  | ➖                            | 58.88MB/s <br> `8% slower`   | ➖                           |
| SHA-384       | **130.47MB/s** | 4.46MB/s <br> `2825% slower`  | 46.76MB/s <br> `179% slower` | 19.61MB/s <br> `565% slower` |
| SHA-512       | **130.27MB/s** | 4.44MB/s <br> `2834% slower`  | 46.79MB/s <br> `178% slower` | 19.69MB/s <br> `562% slower` |
| SHA3-256      | **88.18MB/s**  | 3MB/s <br> `2835% slower`     | ➖                           | ➖                           |
| SHA3-512      | **129.73MB/s** | 1.59MB/s <br> `8028% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **191.74MB/s** | 41.07MB/s <br> `367% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **60.40MB/s**  | 26.46MB/s <br> `128% slower`  | ➖                           | 35.69MB/s <br> `69% slower`  |
| RIPEMD-256    | **208.81MB/s** | 40.60MB/s <br> `414% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **60.47MB/s**  | 25.77MB/s <br> `135% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **138.66MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **157.75MB/s** | 11.89MB/s <br> `1227% slower` | ➖                           | ➖                           |
| Poly1305      | **407.20MB/s** | 148.72MB/s <br> `174% slower` | ➖                           | ➖                           |
| XXH32         | **449.71MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **484.08MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **111.51MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **111.04MB/s** | ➖                            | ➖                           | ➖                           |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                 | `crypto`                    | `hash`                      |
| ------------- | -------------- | ------------------------------ | --------------------------- | --------------------------- |
| MD5           | **28.34MB/s**  | 14.11MB/s <br> `101% slower`   | 14.84MB/s <br> `91% slower` | 8.08MB/s <br> `251% slower` |
| HMAC(MD5)     | **5.23MB/s**   | ➖                             | 4.47MB/s <br> `17% slower`  | 2.12MB/s <br> `146% slower` |
| SHA-1         | **16.28MB/s**  | 7.77MB/s <br> `110% slower`    | 11.52MB/s <br> `41% slower` | 5.03MB/s <br> `224% slower` |
| HMAC(SHA-1)   | **2.66MB/s**   | ➖                             | 2.05MB/s <br> `30% slower`  | ➖                          |
| SHA-224       | **11.98MB/s**  | 3.22MB/s <br> `272% slower`    | 9.58MB/s <br> `25% slower`  | 2.73MB/s <br> `339% slower` |
| SHA-256       | **11.94MB/s**  | 3.18MB/s <br> `275% slower`    | 9.65MB/s <br> `24% slower`  | 2.75MB/s <br> `334% slower` |
| HMAC(SHA-256) | **1.87MB/s**   | ➖                             | 1.72MB/s <br> `8% slower`   | ➖                          |
| SHA-384       | **9.34MB/s**   | 387.94KB/s <br> `2366% slower` | 3.53MB/s <br> `164% slower` | 1.41MB/s <br> `563% slower` |
| SHA-512       | **9.24MB/s**   | 387.41KB/s <br> `2345% slower` | 3.52MB/s <br> `162% slower` | 1.42MB/s <br> `550% slower` |
| SHA3-256      | **11.89MB/s**  | 228.04KB/s <br> `5241% slower` | ➖                          | ➖                          |
| SHA3-512      | **9.23MB/s**   | 228.99KB/s <br> `4029% slower` | ➖                          | ➖                          |
| RIPEMD-128    | **27.95MB/s**  | 7MB/s <br> `299% slower`       | ➖                          | ➖                          |
| RIPEMD-160    | **9.38MB/s**   | 4.28MB/s <br> `119% slower`    | ➖                          | 4.29MB/s <br> `118% slower` |
| RIPEMD-256    | **28.46MB/s**  | 6.73MB/s <br> `322% slower`    | ➖                          | ➖                          |
| RIPEMD-320    | **9.23MB/s**   | 4.06MB/s <br> `127% slower`    | ➖                          | ➖                          |
| BLAKE-2s      | **18.85MB/s**  | ➖                             | ➖                          | ➖                          |
| BLAKE-2b      | **14.82MB/s**  | 904.52KB/s <br> `1578% slower` | ➖                          | ➖                          |
| Poly1305      | **59.63MB/s**  | 36.50MB/s <br> `63% slower`    | ➖                          | ➖                          |
| XXH32         | **100.03MB/s** | ➖                             | ➖                          | ➖                          |
| XXH64         | **76.53MB/s**  | ➖                             | ➖                          | ➖                          |
| XXH3          | **10.48MB/s**  | ➖                             | ➖                          | ➖                          |
| XXH128        | **9.86MB/s**   | ➖                             | ➖                          | ➖                          |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.058 ms | 1.464 ms | 11.0 ms   | 90.375 ms  | 1410.816 ms |
| argon2i    | 0.385 ms | 2.473 ms | 17.017 ms | 208.533 ms | 2481.148 ms |
| argon2d    | 0.281 ms | 2.416 ms | 17.501 ms | 206.161 ms | 2454.029 ms |
| argon2id   | 0.285 ms | 2.442 ms | 17.356 ms | 205.749 ms | 2512.451 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
