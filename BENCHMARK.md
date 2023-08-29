# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **158.25MB/s** | 120.80MB/s <br> `31% slower` | 69.00MB/s <br> `129% slower` | 79.41MB/s <br> `99% slower`   |
| HMAC(MD5)     | **159.98MB/s** | 121.65MB/s <br> `32% slower` | 69.45MB/s <br> `130% slower` | ➖                            |
| SHA-1         | **147.59MB/s** | 96.42MB/s <br> `53% slower`  | 41.19MB/s <br> `258% slower` | 53.58MB/s <br> `175% slower`  |
| HMAC(SHA-1)   | **149.01MB/s** | 96.20MB/s <br> `55% slower`  | ➖                           | ➖                            |
| SHA-224       | **98.60MB/s**  | 84.39MB/s <br> `17% slower`  | 20.12MB/s <br> `390% slower` | 21.03MB/s <br> `369% slower`  |
| SHA-256       | **97.51MB/s**  | 84.23MB/s <br> `16% slower`  | 20.22MB/s <br> `382% slower` | 20.77MB/s <br> `370% slower`  |
| HMAC(SHA-256) | **97.77MB/s**  | 83.36MB/s <br> `17% slower`  | ➖                           | ➖                            |
| SHA-384       | **156.34MB/s** | 49.44MB/s <br> `216% slower` | 17.51MB/s <br> `793% slower` | 5.12MB/s <br> `2955% slower`  |
| SHA-512       | **157.51MB/s** | 49.35MB/s <br> `219% slower` | 17.41MB/s <br> `805% slower` | 5.08MB/s <br> `2998% slower`  |
| SHA3-256      | **97.72MB/s**  | ➖                           | ➖                           | 3.13MB/s <br> `3019% slower`  |
| SHA3-512      | **153.92MB/s** | ➖                           | ➖                           | 1.66MB/s <br> `9174% slower`  |
| RIPEMD-128    | **200.03MB/s** | ➖                           | ➖                           | 45.51MB/s <br> `340% slower`  |
| RIPEMD-160    | **66.46MB/s**  | ➖                           | 31.73MB/s <br> `109% slower` | 26.87MB/s <br> `147% slower`  |
| RIPEMD-256    | **222.37MB/s** | ➖                           | ➖                           | 44.99MB/s <br> `394% slower`  |
| RIPEMD-320    | **66.47MB/s**  | ➖                           | ➖                           | 26.45MB/s <br> `151% slower`  |
| BLAKE-2s      | **142.38MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **163.08MB/s** | ➖                           | ➖                           | 12.02MB/s <br> `1256% slower` |
| Poly1305      | **354.80MB/s** | ➖                           | ➖                           | 152.52MB/s <br> `133% slower` |
| XXH32         | **493.59MB/s** | ➖                           | ➖                           | ➖                            |
| XXH64         | **501.26MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **102.48MB/s** | ➖                           | ➖                           | ➖                            |
| XXH128        | **103.29MB/s** | ➖                           | ➖                           | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| MD5           | **151.03MB/s** | 116.75MB/s <br> `29% slower` | 87.36MB/s <br> `73% slower`  | 76.49MB/s <br> `97% slower`   |
| HMAC(MD5)     | **115.39MB/s** | 93.47MB/s <br> `23% slower`  | 63.77MB/s <br> `81% slower`  | ➖                            |
| SHA-1         | **139.67MB/s** | 92.56MB/s <br> `51% slower`  | 45.23MB/s <br> `209% slower` | 50.75MB/s <br> `175% slower`  |
| HMAC(SHA-1)   | **92.06MB/s**  | 63.64MB/s <br> `45% slower`  | ➖                           | ➖                            |
| SHA-224       | **94.08MB/s**  | 79.64MB/s <br> `18% slower`  | 20.74MB/s <br> `354% slower` | 20.07MB/s <br> `369% slower`  |
| SHA-256       | **93.87MB/s**  | 79.67MB/s <br> `18% slower`  | 20.66MB/s <br> `354% slower` | 19.96MB/s <br> `370% slower`  |
| HMAC(SHA-256) | **61.69MB/s**  | 56.52MB/s <br> `9% slower`   | ➖                           | ➖                            |
| SHA-384       | **143.57MB/s** | 47.38MB/s <br> `203% slower` | 20.17MB/s <br> `612% slower` | 4.87MB/s <br> `2846% slower`  |
| SHA-512       | **144.20MB/s** | 46.81MB/s <br> `208% slower` | 20.64MB/s <br> `598% slower` | 4.87MB/s <br> `2860% slower`  |
| SHA3-256      | **92.60MB/s**  | ➖                           | ➖                           | 2.85MB/s <br> `3145% slower`  |
| SHA3-512      | **142.48MB/s** | ➖                           | ➖                           | 1.65MB/s <br> `8544% slower`  |
| RIPEMD-128    | **190.02MB/s** | ➖                           | ➖                           | 44.51MB/s <br> `327% slower`  |
| RIPEMD-160    | **65.02MB/s**  | ➖                           | 34.96MB/s <br> `86% slower`  | 26.57MB/s <br> `145% slower`  |
| RIPEMD-256    | **206.49MB/s** | ➖                           | ➖                           | 44.06MB/s <br> `369% slower`  |
| RIPEMD-320    | **64.46MB/s**  | ➖                           | ➖                           | 25.91MB/s <br> `149% slower`  |
| BLAKE-2s      | **136.29MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **150.38MB/s** | ➖                           | ➖                           | 11.48MB/s <br> `1209% slower` |
| Poly1305      | **279.10MB/s** | ➖                           | ➖                           | 149.49MB/s <br> `87% slower`  |
| XXH32         | **482.94MB/s** | ➖                           | ➖                           | ➖                            |
| XXH64         | **506.20MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **96.50MB/s**  | ➖                           | ➖                           | ➖                            |
| XXH128        | **96.85MB/s**  | ➖                           | ➖                           | ➖                            |

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`     | `crypto`                    | `hash`                      | `PointyCastle`                 |
| ------------- | ------------- | --------------------------- | --------------------------- | ------------------------------ |
| MD5           | **22.52MB/s** | 9.59MB/s <br> `135% slower` | 6.23MB/s <br> `262% slower` | 11.56MB/s <br> `95% slower`    |
| HMAC(MD5)     | **3.85MB/s**  | 3.66MB/s <br> `5% slower`   | 1.75MB/s <br> `121% slower` | ➖                             |
| SHA-1         | **16.94MB/s** | 8.34MB/s <br> `103% slower` | 4.23MB/s <br> `300% slower` | 7.39MB/s <br> `129% slower`    |
| HMAC(SHA-1)   | **2.43MB/s**  | 1.84MB/s <br> `32% slower`  | ➖                          | ➖                             |
| SHA-224       | **12.15MB/s** | 7.18MB/s <br> `69% slower`  | 2.36MB/s <br> `415% slower` | 3.10MB/s <br> `292% slower`    |
| SHA-256       | **12.09MB/s** | 7.17MB/s <br> `69% slower`  | 2.45MB/s <br> `393% slower` | 3.07MB/s <br> `295% slower`    |
| HMAC(SHA-256) | **1.60MB/s**  | 1.57MB/s <br> `2% slower`   | ➖                          | ➖                             |
| SHA-384       | **9.34MB/s**  | 2.90MB/s <br> `222% slower` | 1.27MB/s <br> `635% slower` | 380.63KB/s <br> `2355% slower` |
| SHA-512       | **9.36MB/s**  | 2.91MB/s <br> `221% slower` | 1.19MB/s <br> `686% slower` | 378.06KB/s <br> `2376% slower` |
| SHA3-256      | **11.95MB/s** | ➖                          | ➖                          | 219.64KB/s <br> `5343% slower` |
| SHA3-512      | **9.51MB/s**  | ➖                          | ➖                          | 219.20KB/s <br> `4238% slower` |
| RIPEMD-128    | **22.09MB/s** | ➖                          | ➖                          | 6.91MB/s <br> `220% slower`    |
| RIPEMD-160    | **8.67MB/s**  | ➖                          | 3.47MB/s <br> `150% slower` | 4.07MB/s <br> `113% slower`    |
| RIPEMD-256    | **23.23MB/s** | ➖                          | ➖                          | 6.71MB/s <br> `246% slower`    |
| RIPEMD-320    | **8.59MB/s**  | ➖                          | ➖                          | 3.88MB/s <br> `122% slower`    |
| BLAKE-2s      | **15.12MB/s** | ➖                          | ➖                          | ➖                             |
| BLAKE-2b      | **12.71MB/s** | ➖                          | ➖                          | 833.86KB/s <br> `1424% slower` |
| Poly1305      | **58.75MB/s** | ➖                          | ➖                          | 27.05MB/s <br> `117% slower`   |
| XXH32         | **87.41MB/s** | ➖                          | ➖                          | ➖                             |
| XXH64         | **67.40MB/s** | ➖                          | ➖                          | ➖                             |
| XXH3          | **8.56MB/s**  | ➖                          | ➖                          | ➖                             |
| XXH128        | **8.42MB/s**  | ➖                          | ➖                          | ➖                             |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.067 ms | 2.242 ms | 14.684 ms | 118.737 ms | 1849.659 ms |
| argon2i    | 0.374 ms | 2.517 ms | 16.873 ms | 203.907 ms | 2406.902 ms |
| argon2d    | 0.319 ms | 2.453 ms | 16.837 ms | 201.673 ms | 2394.64 ms  |
| argon2id   | 0.331 ms | 2.609 ms | 16.868 ms | 205.1 ms   | 2453.487 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
