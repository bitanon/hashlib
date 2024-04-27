# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With 5MB message (10 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD4           | TODO           | TODO                          | ➖                           | ➖                           |
| MD5           | **170.44MB/s** | 82.22MB/s <br> `107% slower`  | 136.08MB/s <br> `25% slower` | 75.89MB/s <br> `125% slower` |
| HMAC(MD5)     | **162.81MB/s** | ➖                            | 134.81MB/s <br> `21% slower` | 77.15MB/s <br> `111% slower` |
| SHA-1         | **143.81MB/s** | 53.44MB/s <br> `169% slower`  | 102.45MB/s <br> `40% slower` | 43.15MB/s <br> `233% slower` |
| HMAC(SHA-1)   | **142.79MB/s** | ➖                            | 101.70MB/s <br> `40% slower` | ➖                           |
| SHA-224       | **95.77MB/s**  | 21.25MB/s <br> `351% slower`  | 87.43MB/s <br> `10% slower`  | 20.75MB/s <br> `362% slower` |
| SHA-256       | **96.17MB/s**  | 21.35MB/s <br> `350% slower`  | 87.87MB/s <br> `9% slower`   | 20.74MB/s <br> `364% slower` |
| HMAC(SHA-256) | **95.75MB/s**  | ➖                            | 87.79MB/s <br> `9% slower`   | ➖                           |
| SHA-384       | **152.55MB/s** | 4.98MB/s <br> `2961% slower`  | 52.92MB/s <br> `188% slower` | 17.86MB/s <br> `754% slower` |
| SHA-512       | **151.60MB/s** | 4.99MB/s <br> `2933% slower`  | 53.49MB/s <br> `183% slower` | 18.15MB/s <br> `735% slower` |
| SHA3-256      | **95.96MB/s**  | 3.20MB/s <br> `2891% slower`  | ➖                           | ➖                           |
| SHA3-512      | **152.55MB/s** | 1.70MB/s <br> `8863% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **210.70MB/s** | 43.34MB/s <br> `386% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **65.36MB/s**  | 28.21MB/s <br> `132% slower`  | ➖                           | 33.97MB/s <br> `92% slower`  |
| RIPEMD-256    | **224.89MB/s** | 43.59MB/s <br> `416% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **65.59MB/s**  | 27.69MB/s <br> `137% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **142.21MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **162.81MB/s** | 12.21MB/s <br> `1233% slower` | ➖                           | ➖                           |
| Poly1305      | **434.55MB/s** | 151.33MB/s <br> `187% slower` | ➖                           | ➖                           |
| XXH32         | **472.88MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **541.95MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **118.76MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **117.04MB/s** | ➖                            | ➖                           | ➖                           |

With 1KB message (5000 iterations):

| Algorithms    | `hashlib`      | `PointyCastle`                | `crypto`                     | `hash`                       |
| ------------- | -------------- | ----------------------------- | ---------------------------- | ---------------------------- |
| MD4           | TODO           | TODO                          | ➖                           | ➖                           |
| MD5           | **162.06MB/s** | 80.19MB/s <br> `102% slower`  | 127.99MB/s <br> `27% slower` | 97.19MB/s <br> `67% slower`  |
| HMAC(MD5)     | **129.87MB/s** | ➖                            | 105.50MB/s <br> `23% slower` | 74.01MB/s <br> `75% slower`  |
| SHA-1         | **134.21MB/s** | 50.28MB/s <br> `167% slower`  | 96.20MB/s <br> `40% slower`  | 47.46MB/s <br> `183% slower` |
| HMAC(SHA-1)   | **97.60MB/s**  | ➖                            | 69.13MB/s <br> `41% slower`  | ➖                           |
| SHA-224       | **88.96MB/s**  | 20.06MB/s <br> `343% slower`  | 81.63MB/s <br> `9% slower`   | 20.20MB/s <br> `340% slower` |
| SHA-256       | **89.97MB/s**  | 20.10MB/s <br> `348% slower`  | 81.54MB/s <br> `10% slower`  | 20.78MB/s <br> `333% slower` |
| HMAC(SHA-256) | **64.04MB/s**  | ➖                            | 59.15MB/s <br> `8% slower`   | ➖                           |
| SHA-384       | **131.17MB/s** | 4.50MB/s <br> `2814% slower`  | 47.02MB/s <br> `179% slower` | 19.76MB/s <br> `564% slower` |
| SHA-512       | **131.03MB/s** | 4.49MB/s <br> `2816% slower`  | 46.99MB/s <br> `179% slower` | 19.81MB/s <br> `561% slower` |
| SHA3-256      | **89.03MB/s**  | 3.02MB/s <br> `2846% slower`  | ➖                           | ➖                           |
| SHA3-512      | **133.31MB/s** | 1.61MB/s <br> `8148% slower`  | ➖                           | ➖                           |
| RIPEMD-128    | **191.28MB/s** | 41.19MB/s <br> `364% slower`  | ➖                           | ➖                           |
| RIPEMD-160    | **60.52MB/s**  | 26.51MB/s <br> `128% slower`  | ➖                           | 35.72MB/s <br> `69% slower`  |
| RIPEMD-256    | **208.94MB/s** | 40.97MB/s <br> `410% slower`  | ➖                           | ➖                           |
| RIPEMD-320    | **60.81MB/s**  | 25.87MB/s <br> `135% slower`  | ➖                           | ➖                           |
| BLAKE-2s      | **137.94MB/s** | ➖                            | ➖                           | ➖                           |
| BLAKE-2b      | **157.06MB/s** | 11.97MB/s <br> `1212% slower` | ➖                           | ➖                           |
| Poly1305      | **408.28MB/s** | 149.18MB/s <br> `174% slower` | ➖                           | ➖                           |
| XXH32         | **450.08MB/s** | ➖                            | ➖                           | ➖                           |
| XXH64         | **502.47MB/s** | ➖                            | ➖                           | ➖                           |
| XXH3          | **112.06MB/s** | ➖                            | ➖                           | ➖                           |
| XXH128        | **110.86MB/s** | ➖                            | ➖                           | ➖                           |

With 10B message (100000 iterations):

| Algorithms    | `hashlib`     | `PointyCastle`                 | `crypto`                    | `hash`                      |
| ------------- | ------------- | ------------------------------ | --------------------------- | --------------------------- |
| MD4           | TODO          | TODO                           | ➖                          | ➖                          |
| MD5           | **28.40MB/s** | 14.16MB/s <br> `101% slower`   | 14.65MB/s <br> `94% slower` | 8.04MB/s <br> `253% slower` |
| HMAC(MD5)     | **5.26MB/s**  | ➖                             | 4.46MB/s <br> `18% slower`  | 2.10MB/s <br> `150% slower` |
| SHA-1         | **16.24MB/s** | 7.46MB/s <br> `118% slower`    | 11.47MB/s <br> `42% slower` | 5.05MB/s <br> `222% slower` |
| HMAC(SHA-1)   | **2.64MB/s**  | ➖                             | 2.05MB/s <br> `28% slower`  | ➖                          |
| SHA-224       | **11.94MB/s** | 3.19MB/s <br> `273% slower`    | 9.43MB/s <br> `26% slower`  | 2.72MB/s <br> `338% slower` |
| SHA-256       | **12MB/s**    | 3.22MB/s <br> `273% slower`    | 9.61MB/s <br> `25% slower`  | 2.70MB/s <br> `343% slower` |
| HMAC(SHA-256) | **1.86MB/s**  | ➖                             | 1.74MB/s <br> `7% slower`   | ➖                          |
| SHA-384       | **9.29MB/s**  | 389.26KB/s <br> `2346% slower` | 3.54MB/s <br> `162% slower` | 1.41MB/s <br> `558% slower` |
| SHA-512       | **9.28MB/s**  | 388.67KB/s <br> `2345% slower` | 3.51MB/s <br> `164% slower` | 1.42MB/s <br> `550% slower` |
| SHA3-256      | **12MB/s**    | 229.72KB/s <br> `5251% slower` | ➖                          | ➖                          |
| SHA3-512      | **9.19MB/s**  | 230.15KB/s <br> `3990% slower` | ➖                          | ➖                          |
| RIPEMD-128    | **27.89MB/s** | 6.96MB/s <br> `300% slower`    | ➖                          | ➖                          |
| RIPEMD-160    | **9.43MB/s**  | 4.29MB/s <br> `120% slower`    | ➖                          | 4.29MB/s <br> `120% slower` |
| RIPEMD-256    | **28.34MB/s** | 6.76MB/s <br> `319% slower`    | ➖                          | ➖                          |
| RIPEMD-320    | **9.21MB/s**  | 4.04MB/s <br> `128% slower`    | ➖                          | ➖                          |
| BLAKE-2s      | **18.71MB/s** | ➖                             | ➖                          | ➖                          |
| BLAKE-2b      | **14.49MB/s** | 902.68KB/s <br> `1544% slower` | ➖                          | ➖                          |
| Poly1305      | **59.02MB/s** | 36.79MB/s <br> `60% slower`    | ➖                          | ➖                          |
| XXH32         | **99.65MB/s** | ➖                             | ➖                          | ➖                          |
| XXH64         | **76.38MB/s** | ➖                             | ➖                          | ➖                          |
| XXH3          | **10.37MB/s** | ➖                             | ➖                          | ➖                          |
| XXH128        | **9.54MB/s**  | ➖                             | ➖                          | ➖                          |

Argon2 and scrypt benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| scrypt     | 0.058 ms | 1.571 ms | 11.388 ms | 93.121 ms  | 1429.536 ms |
| argon2i    | 0.416 ms | 2.482 ms | 17.684 ms | 218.547 ms | 2524.993 ms |
| argon2d    | 0.274 ms | 2.369 ms | 16.477 ms | 205.339 ms | 2516.212 ms |
| argon2id   | 0.284 ms | 2.391 ms | 17.145 ms | 215.087 ms | 2531.751 ms |

> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_
>
> Dart SDK version: 3.3.3 (stable) (Tue Mar 26 14:21:33 2024 +0000) on "windows_x64"
