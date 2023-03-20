# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                      | `PointyCastle`                 |
| ------------- | ------------- | ---------------------------- | --------------------------- | ------------------------------ |
| XXH64         | **67.24MB/s** | ➖                           | ➖                          | ➖                             |
| XXH3          | **8.56MB/s**  | ➖                           | ➖                          | ➖                             |
| MD5           | **22.80MB/s** | 10.23MB/s <br> `123% slower` | 7.47MB/s <br> `205% slower` | 11.39MB/s <br> `100% slower`   |
| SHA-1         | **17.38MB/s** | 8.74MB/s <br> `99% slower`   | 4.76MB/s <br> `265% slower` | 7.37MB/s <br> `136% slower`    |
| SHA-224       | **12.30MB/s** | 7.24MB/s <br> `70% slower`   | 2.49MB/s <br> `395% slower` | 3.16MB/s <br> `289% slower`    |
| SHA-256       | **12.28MB/s** | 7.29MB/s <br> `68% slower`   | 2.62MB/s <br> `368% slower` | 3.18MB/s <br> `286% slower`    |
| SHA-384       | **9.44MB/s**  | 2.98MB/s <br> `216% slower`  | 1.28MB/s <br> `639% slower` | 397.37KB/s <br> `2276% slower` |
| SHA-512       | **9.36MB/s**  | 2.98MB/s <br> `214% slower`  | 1.34MB/s <br> `597% slower` | 396.35KB/s <br> `2262% slower` |
| SHA-512/224   | **9.57MB/s**  | 3.02MB/s <br> `217% slower`  | ➖                          | 201.40KB/s <br> `4652% slower` |
| SHA-512/256   | **9.54MB/s**  | 3.00MB/s <br> `218% slower`  | ➖                          | 201.98KB/s <br> `4623% slower` |
| SHA3-256      | **12.33MB/s** | ➖                           | ➖                          | 219.98KB/s <br> `5505% slower` |
| SHA3-512      | **9.36MB/s**  | ➖                           | ➖                          | 219.72KB/s <br> `4162% slower` |
| BLAKE-2s      | **14.83MB/s** | ➖                           | ➖                          | ➖                             |
| BLAKE-2b      | **12.63MB/s** | ➖                           | ➖                          | 813.14KB/s <br> `1453% slower` |
| HMAC(MD5)     | **4.67MB/s**  | 3.75MB/s <br> `24% slower`   | 1.95MB/s <br> `140% slower` | ➖                             |
| HMAC(SHA-256) | **1.89MB/s**  | 1.57MB/s <br> `20% slower`   | ➖                          | ➖                             |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **454.17MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **105.77MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **155.56MB/s** | 116.70MB/s <br> `33% slower` | 89.72MB/s <br> `73% slower`  | 79.40MB/s <br> `96% slower`   |
| SHA-1         | **146.49MB/s** | 94.75MB/s <br> `55% slower`  | 46.52MB/s <br> `215% slower` | 54.18MB/s <br> `170% slower`  |
| SHA-224       | **97.16MB/s**  | 78.68MB/s <br> `23% slower`  | 20.99MB/s <br> `363% slower` | 20.98MB/s <br> `363% slower`  |
| SHA-256       | **97.22MB/s**  | 78.19MB/s <br> `24% slower`  | 20.95MB/s <br> `364% slower` | 20.97MB/s <br> `364% slower`  |
| SHA-384       | **143.92MB/s** | 46.98MB/s <br> `206% slower` | 21.39MB/s <br> `573% slower` | 5.21MB/s <br> `2665% slower`  |
| SHA-512       | **148.22MB/s** | 47.41MB/s <br> `213% slower` | 21.50MB/s <br> `589% slower` | 5.21MB/s <br> `2745% slower`  |
| SHA-512/224   | **145.98MB/s** | 47.04MB/s <br> `210% slower` | ➖                           | 4.61MB/s <br> `3068% slower`  |
| SHA-512/256   | **144.80MB/s** | 47.35MB/s <br> `206% slower` | ➖                           | 4.61MB/s <br> `3042% slower`  |
| SHA3-256      | **96.78MB/s**  | ➖                           | ➖                           | 2.88MB/s <br> `3266% slower`  |
| SHA3-512      | **145.49MB/s** | ➖                           | ➖                           | 1.66MB/s <br> `8685% slower`  |
| BLAKE-2s      | **133.86MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **153.35MB/s** | ➖                           | ➖                           | 11.53MB/s <br> `1231% slower` |
| HMAC(MD5)     | **122.39MB/s** | 94.73MB/s <br> `29% slower`  | 67.13MB/s <br> `82% slower`  | ➖                            |
| HMAC(SHA-256) | **67.48MB/s**  | 55.64MB/s <br> `21% slower`  | ➖                           | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **484.62MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **116.98MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **161.57MB/s** | 123.35MB/s <br> `31% slower` | 69.18MB/s <br> `134% slower` | 83.05MB/s <br> `95% slower`   |
| SHA-1         | **153.49MB/s** | 97.47MB/s <br> `57% slower`  | 40.97MB/s <br> `275% slower` | 56.68MB/s <br> `171% slower`  |
| SHA-224       | **101.25MB/s** | 82.35MB/s <br> `23% slower`  | 20.11MB/s <br> `404% slower` | 21.55MB/s <br> `370% slower`  |
| SHA-256       | **101.56MB/s** | 82.32MB/s <br> `23% slower`  | 20.02MB/s <br> `407% slower` | 21.69MB/s <br> `368% slower`  |
| SHA-384       | **160.98MB/s** | 49.18MB/s <br> `227% slower` | 17.69MB/s <br> `810% slower` | 5.34MB/s <br> `2913% slower`  |
| SHA-512       | **162.20MB/s** | 49.22MB/s <br> `230% slower` | 17.68MB/s <br> `817% slower` | 5.34MB/s <br> `2938% slower`  |
| SHA-512/224   | **161.66MB/s** | 49.25MB/s <br> `228% slower` | ➖                           | 5.34MB/s <br> `2930% slower`  |
| SHA-512/256   | **161.52MB/s** | 49.16MB/s <br> `229% slower` | ➖                           | 5.35MB/s <br> `2921% slower`  |
| SHA3-256      | **101.83MB/s** | ➖                           | ➖                           | 3.15MB/s <br> `3129% slower`  |
| SHA3-512      | **160.89MB/s** | ➖                           | ➖                           | 1.67MB/s <br> `9543% slower`  |
| BLAKE-2s      | **141.52MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **162.45MB/s** | ➖                           | ➖                           | 12.14MB/s <br> `1238% slower` |
| HMAC(MD5)     | **162.09MB/s** | 123.68MB/s <br> `31% slower` | 69.42MB/s <br> `133% slower` | ➖                            |
| HMAC(SHA-256) | **101.54MB/s** | 82.08MB/s <br> `24% slower`  | ➖                           | ➖                            |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.378 ms | 2.62 ms  | 17.917 ms | 219.696 ms | 2504.115 ms |
| argon2d    | 0.334 ms | 2.747 ms | 19.035 ms | 239.565 ms | 2508.532 ms |
| argon2id   | 0.323 ms | 2.631 ms | 17.18 ms  | 214.449 ms | 2538.26 ms  |
