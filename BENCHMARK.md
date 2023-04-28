# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **503.64MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **105.12MB/s** | ➖                           | ➖                           | ➖                            |
| MD5           | **161.28MB/s** | 121.66MB/s <br> `33% slower` | 69.32MB/s <br> `133% slower` | 81.18MB/s <br> `99% slower`   |
| SHA-1         | **148.14MB/s** | 96.11MB/s <br> `54% slower`  | 37.83MB/s <br> `292% slower` | 55.12MB/s <br> `169% slower`  |
| SHA-224       | **100.14MB/s** | 84.14MB/s <br> `19% slower`  | 19.79MB/s <br> `406% slower` | 21.66MB/s <br> `362% slower`  |
| SHA-256       | **100.55MB/s** | 84.38MB/s <br> `19% slower`  | 19.83MB/s <br> `407% slower` | 21.79MB/s <br> `361% slower`  |
| SHA-384       | **157.21MB/s** | 48.19MB/s <br> `226% slower` | 17.82MB/s <br> `782% slower` | 5.19MB/s <br> `2927% slower`  |
| SHA-512       | **157.13MB/s** | 48.30MB/s <br> `225% slower` | 17.93MB/s <br> `776% slower` | 5.19MB/s <br> `2929% slower`  |
| SHA-512/224   | **156.70MB/s** | 48.46MB/s <br> `223% slower` | ➖                           | 5.20MB/s <br> `2913% slower`  |
| SHA-512/256   | **156.94MB/s** | 48.24MB/s <br> `225% slower` | ➖                           | 5.08MB/s <br> `2991% slower`  |
| SHA3-256      | **99.89MB/s**  | ➖                           | ➖                           | 3.18MB/s <br> `3044% slower`  |
| SHA3-512      | **157.45MB/s** | ➖                           | ➖                           | 1.71MB/s <br> `9127% slower`  |
| BLAKE-2s      | **144.42MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **164.61MB/s** | ➖                           | ➖                           | 12.62MB/s <br> `1204% slower` |
| HMAC(MD5)     | **161.72MB/s** | 120.11MB/s <br> `35% slower` | 70.40MB/s <br> `130% slower` | ➖                            |
| HMAC(SHA-256) | **100.12MB/s** | 83.03MB/s <br> `21% slower`  | ➖                           | ➖                            |
| Poly1305      | **10.73MB/s**  | ➖                           | ➖                           | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`      | `crypto`                     | `hash`                       | `PointyCastle`                |
| ------------- | -------------- | ---------------------------- | ---------------------------- | ----------------------------- |
| XXH64         | **454.17MB/s** | ➖                           | ➖                           | ➖                            |
| XXH3          | **97.26MB/s**  | ➖                           | ➖                           | ➖                            |
| MD5           | **155.91MB/s** | 119.53MB/s <br> `30% slower` | 91.58MB/s <br> `70% slower`  | 79.03MB/s <br> `97% slower`   |
| SHA-1         | **140.87MB/s** | 93.64MB/s <br> `50% slower`  | 46.09MB/s <br> `206% slower` | 54.30MB/s <br> `159% slower`  |
| SHA-224       | **96.18MB/s**  | 81.33MB/s <br> `18% slower`  | 20.67MB/s <br> `365% slower` | 20.86MB/s <br> `361% slower`  |
| SHA-256       | **96.18MB/s**  | 81.39MB/s <br> `18% slower`  | 20.67MB/s <br> `365% slower` | 21.26MB/s <br> `352% slower`  |
| SHA-384       | **145.70MB/s** | 46.59MB/s <br> `213% slower` | 21.52MB/s <br> `577% slower` | 5.09MB/s <br> `2762% slower`  |
| SHA-512       | **143.40MB/s** | 46.40MB/s <br> `209% slower` | 21.62MB/s <br> `563% slower` | 5.07MB/s <br> `2729% slower`  |
| SHA-512/224   | **143.47MB/s** | 46.50MB/s <br> `209% slower` | ➖                           | 4.50MB/s <br> `3090% slower`  |
| SHA-512/256   | **145.55MB/s** | 46.73MB/s <br> `211% slower` | ➖                           | 4.49MB/s <br> `3145% slower`  |
| SHA3-256      | **96.15MB/s**  | ➖                           | ➖                           | 2.97MB/s <br> `3136% slower`  |
| SHA3-512      | **143.89MB/s** | ➖                           | ➖                           | 1.70MB/s <br> `8346% slower`  |
| BLAKE-2s      | **136.61MB/s** | ➖                           | ➖                           | ➖                            |
| BLAKE-2b      | **154.86MB/s** | ➖                           | ➖                           | 12.28MB/s <br> `1161% slower` |
| HMAC(MD5)     | **123.84MB/s** | 94.08MB/s <br> `32% slower`  | 68.14MB/s <br> `82% slower`  | ➖                            |
| HMAC(SHA-256) | **67.95MB/s**  | 56.12MB/s <br> `21% slower`  | ➖                           | ➖                            |
| Poly1305      | **10.06MB/s**  | ➖                           | ➖                           | ➖                            |

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                      | `PointyCastle`                 |
| ------------- | ------------- | ---------------------------- | --------------------------- | ------------------------------ |
| XXH64         | **67.44MB/s** | ➖                           | ➖                          | ➖                             |
| XXH3          | **8.53MB/s**  | ➖                           | ➖                          | ➖                             |
| MD5           | **23.28MB/s** | 10.14MB/s <br> `130% slower` | 7.36MB/s <br> `216% slower` | 11.44MB/s <br> `103% slower`   |
| SHA-1         | **16.89MB/s** | 8.59MB/s <br> `97% slower`   | 4.77MB/s <br> `254% slower` | 7.43MB/s <br> `127% slower`    |
| SHA-224       | **12.21MB/s** | 7.32MB/s <br> `67% slower`   | 2.61MB/s <br> `367% slower` | 3.11MB/s <br> `292% slower`    |
| SHA-256       | **12.27MB/s** | 7.21MB/s <br> `70% slower`   | 2.62MB/s <br> `368% slower` | 3.13MB/s <br> `292% slower`    |
| SHA-384       | **9.48MB/s**  | 2.90MB/s <br> `227% slower`  | 1.34MB/s <br> `610% slower` | 386.20KB/s <br> `2355% slower` |
| SHA-512       | **9.49MB/s**  | 2.89MB/s <br> `228% slower`  | 1.35MB/s <br> `601% slower` | 384.32KB/s <br> `2370% slower` |
| SHA-512/224   | **9.62MB/s**  | 2.95MB/s <br> `226% slower`  | ➖                          | 197.75KB/s <br> `4765% slower` |
| SHA-512/256   | **9.67MB/s**  | 2.95MB/s <br> `227% slower`  | ➖                          | 197.90KB/s <br> `4784% slower` |
| SHA3-256      | **12.35MB/s** | ➖                           | ➖                          | 228.76KB/s <br> `5301% slower` |
| SHA3-512      | **9.50MB/s**  | ➖                           | ➖                          | 228.29KB/s <br> `4061% slower` |
| BLAKE-2s      | **15.14MB/s** | ➖                           | ➖                          | ➖                             |
| BLAKE-2b      | **13.05MB/s** | ➖                           | ➖                          | 884.35KB/s <br> `1376% slower` |
| HMAC(MD5)     | **4.77MB/s**  | 3.75MB/s <br> `27% slower`   | 1.95MB/s <br> `144% slower` | ➖                             |
| HMAC(SHA-256) | **1.93MB/s**  | 1.60MB/s <br> `21% slower`   | ➖                          | ➖                             |
| Poly1305      | **1.41MB/s**  | ➖                           | ➖                          | ➖                             |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.365 ms | 2.501 ms | 16.835 ms | 209.94 ms  | 2435.554 ms |
| argon2d    | 0.303 ms | 2.412 ms | 16.17 ms  | 207.963 ms | 2505.426 ms |
| argon2id   | 0.313 ms | 2.424 ms | 16.386 ms | 202.846 ms | 2471.51 ms  |
