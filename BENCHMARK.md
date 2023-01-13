# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                         | `PointyCastle`                  | `sha3`                        |
| ------------- | -------------- | ----------------------------- | ------------------------------ | ------------------------------- | ----------------------------- |
| MD5           | **42.276 ms**  | 93.323 ms <br> `121% slower`  | 196.541 ms <br> `365% slower`  | 134.664 ms <br> `219% slower`   | ➖                            |
| SHA-1         | **70.194 ms**  | 108.909 ms <br> `55% slower`  | 257.306 ms <br> `267% slower`  | 149.935 ms <br> `114% slower`   | ➖                            |
| SHA-224       | **89.61 ms**   | 131.638 ms <br> `47% slower`  | 444.125 ms <br> `396% slower`  | 342.773 ms <br> `283% slower`   | ➖                            |
| SHA-256       | **89.447 ms**  | 131.85 ms <br> `47% slower`   | 445.699 ms <br> `398% slower`  | 347.406 ms <br> `288% slower`   | ➖                            |
| SHA-384       | **103.699 ms** | 289.271 ms <br> `179% slower` | 1062.919 ms <br> `925% slower` | 2342.641 ms <br> `2159% slower` | ➖                            |
| SHA-512       | **103.754 ms** | 290.572 ms <br> `180% slower` | 1066.844 ms <br> `928% slower` | 2344.139 ms <br> `2159% slower` | ➖                            |
| SHA-512/224   | **101.674 ms** | 286.771 ms <br> `182% slower` | ➖                             | 4501.391 ms <br> `4327% slower` | ➖                            |
| SHA-512/256   | **102.228 ms** | 286.739 ms <br> `180% slower` | ➖                             | 4498.623 ms <br> `4301% slower` | ➖                            |
| SHA3-256      | **89.147 ms**  | ➖                            | ➖                             | 4535.083 ms <br> `4987% slower` | 400.67 ms <br> `349% slower`  |
| SHA3-512      | **103.919 ms** | ➖                            | ➖                             | 4512.838 ms <br> `4243% slower` | 399.102 ms <br> `284% slower` |
| BLAKE-2s      | **61.892 ms**  | ➖                            | ➖                             | ➖                              | ➖                            |
| BLAKE-2b      | **62.643 ms**  | ➖                            | ➖                             | 1086.441 ms <br> `1634% slower` | ➖                            |
| HMAC(MD5)     | **223.08 ms**  | 258.091 ms <br> `16% slower`  | 696.94 ms <br> `212% slower`   | ➖                              | ➖                            |
| HMAC(SHA-256) | **585.78 ms**  | 654.331 ms <br> `12% slower`  | ➖                             | ➖                              | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ---------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **36.01 ms**  | 39.858 ms <br> `11% slower`  | 72.474 ms <br> `101% slower`  | 104.904 ms <br> `191% slower`   | ➖                            |
| SHA-1         | **43.245 ms** | 50.977 ms <br> `18% slower`  | 117.81 ms <br> `172% slower`  | 109.037 ms <br> `152% slower`   | ➖                            |
| SHA-224       | **58.281 ms** | 65.112 ms <br> `12% slower`  | 261.982 ms <br> `350% slower` | 261.985 ms <br> `350% slower`   | ➖                            |
| SHA-256       | **57.941 ms** | 65.011 ms <br> `12% slower`  | 259.712 ms <br> `348% slower` | 259.007 ms <br> `347% slower`   | ➖                            |
| SHA-384       | **32.632 ms** | 88.778 ms <br> `172% slower` | 353.296 ms <br> `983% slower` | 885.859 ms <br> `2615% slower`  | ➖                            |
| SHA-512       | **32.491 ms** | 89.023 ms <br> `174% slower` | 353.802 ms <br> `989% slower` | 884.92 ms <br> `2624% slower`   | ➖                            |
| SHA-512/224   | **32.363 ms** | 88.61 ms <br> `174% slower`  | ➖                            | 991.488 ms <br> `2964% slower`  | ➖                            |
| SHA-512/256   | **32.361 ms** | 88.525 ms <br> `174% slower` | ➖                            | 989.959 ms <br> `2959% slower`  | ➖                            |
| SHA3-256      | **57.67 ms**  | ➖                           | ➖                            | 1743.355 ms <br> `2923% slower` | 226.167 ms <br> `292% slower` |
| SHA3-512      | **32.586 ms** | ➖                           | ➖                            | 3041.517 ms <br> `9234% slower` | 334.749 ms <br> `927% slower` |
| BLAKE-2s      | **42.142 ms** | ➖                           | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **23.465 ms** | ➖                           | ➖                            | 380.297 ms <br> `1521% slower`  | ➖                            |
| HMAC(MD5)     | **45.388 ms** | 49.641 ms <br> `9% slower`   | 98.273 ms <br> `117% slower`  | ➖                              | ➖                            |
| HMAC(SHA-256) | **81.632 ms** | 92.378 ms <br> `13% slower`  | ➖                            | ➖                              | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                         | `PointyCastle`                   | `sha3`                         |
| ------------- | ------------- | ---------------------------- | ------------------------------ | -------------------------------- | ------------------------------ |
| MD5           | **35.057 ms** | 38.494 ms <br> `10% slower`  | 79.518 ms <br> `127% slower`   | 101.072 ms <br> `188% slower`    | ➖                             |
| SHA-1         | **41.346 ms** | 48.679 ms <br> `18% slower`  | 124.539 ms <br> `201% slower`  | 103.355 ms <br> `150% slower`    | ➖                             |
| SHA-224       | **53.93 ms**  | 62.588 ms <br> `16% slower`  | 260.972 ms <br> `384% slower`  | 251.336 ms <br> `366% slower`    | ➖                             |
| SHA-256       | **54.4 ms**   | 62.699 ms <br> `15% slower`  | 260.605 ms <br> `379% slower`  | 250.739 ms <br> `361% slower`    | ➖                             |
| SHA-384       | **28.829 ms** | 85.269 ms <br> `196% slower` | 352.308 ms <br> `1122% slower` | 861.306 ms <br> `2888% slower`   | ➖                             |
| SHA-512       | **28.842 ms** | 84.94 ms <br> `195% slower`  | 351.892 ms <br> `1120% slower` | 854.374 ms <br> `2862% slower`   | ➖                             |
| SHA-512/224   | **28.983 ms** | 85.248 ms <br> `194% slower` | ➖                             | 861.93 ms <br> `2874% slower`    | ➖                             |
| SHA-512/256   | **28.919 ms** | 85.894 ms <br> `197% slower` | ➖                             | 857.679 ms <br> `2866% slower`   | ➖                             |
| SHA3-256      | **54.634 ms** | ➖                           | ➖                             | 1617.128 ms <br> `2860% slower`  | 213.12 ms <br> `290% slower`   |
| SHA3-512      | **28.755 ms** | ➖                           | ➖                             | 3026.285 ms <br> `10424% slower` | 333.488 ms <br> `1060% slower` |
| BLAKE-2s      | **40.092 ms** | ➖                           | ➖                             | ➖                               | ➖                             |
| BLAKE-2b      | **22.359 ms** | ➖                           | ➖                             | 363.314 ms <br> `1525% slower`   | ➖                             |
| HMAC(MD5)     | **35.489 ms** | 38.657 ms <br> `9% slower`   | 82.969 ms <br> `134% slower`   | ➖                               | ➖                             |
| HMAC(SHA-256) | **54.019 ms** | 62.991 ms <br> `17% slower`  | ➖                             | ➖                               | ➖                             |
