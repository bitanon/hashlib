# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                        | `PointyCastle`                  |
| ------------- | -------------- | ----------------------------- | ----------------------------- | ------------------------------- |
| MD5           | **41.692 ms**  | 95.221 ms <br> `128% slower`  | 134.052 ms <br> `222% slower` | 89.152 ms <br> `114% slower`    |
| SHA-1         | **56.435 ms**  | 111.341 ms <br> `97% slower`  | 201.275 ms <br> `257% slower` | 137.573 ms <br> `144% slower`   |
| SHA-224       | **78.717 ms**  | 131.809 ms <br> `67% slower`  | 376.419 ms <br> `378% slower` | 305.068 ms <br> `288% slower`   |
| SHA-256       | **79.399 ms**  | 129.791 ms <br> `63% slower`  | 370.477 ms <br> `367% slower` | 313.473 ms <br> `295% slower`   |
| SHA-384       | **107.96 ms**  | 327.97 ms <br> `204% slower`  | 693.93 ms <br> `543% slower`  | 2499.461 ms <br> `2215% slower` |
| SHA-512       | **110.558 ms** | 350.128 ms <br> `217% slower` | 757.788 ms <br> `585% slower` | 2607.935 ms <br> `2259% slower` |
| SHA-512/224   | **101.562 ms** | 335.791 ms <br> `231% slower` | ➖                            | 5199.95 ms <br> `5020% slower`  |
| SHA-512/256   | **102.39 ms**  | 346.79 ms <br> `239% slower`  | ➖                            | 5197.253 ms <br> `4976% slower` |
| SHA3-256      | **86.194 ms**  | ➖                            | ➖                            | 4708.547 ms <br> `5363% slower` |
| SHA3-512      | **104.087 ms** | ➖                            | ➖                            | 4656.558 ms <br> `4374% slower` |
| BLAKE-2s      | **68.387 ms**  | ➖                            | ➖                            | ➖                              |
| BLAKE-2b      | **78.953 ms**  | ➖                            | ➖                            | 1185.177 ms <br> `1401% slower` |
| HMAC(MD5)     | **210.551 ms** | 267.079 ms <br> `27% slower`  | 509.217 ms <br> `142% slower` | ➖                              |
| HMAC(SHA-256) | **535.035 ms** | 627.013 ms <br> `17% slower`  | ➖                            | ➖                              |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- |
| MD5           | **32.59 ms**  | 44.881 ms <br> `38% slower`   | 54.503 ms <br> `67% slower`   | 64.161 ms <br> `97% slower`     |
| SHA-1         | **35.483 ms** | 56.267 ms <br> `59% slower`   | 106.92 ms <br> `201% slower`  | 94.902 ms <br> `167% slower`    |
| SHA-224       | **53.58 ms**  | 62.405 ms <br> `16% slower`   | 244.268 ms <br> `356% slower` | 240.907 ms <br> `350% slower`   |
| SHA-256       | **53.265 ms** | 62.558 ms <br> `17% slower`   | 239.206 ms <br> `349% slower` | 244.007 ms <br> `358% slower`   |
| SHA-384       | **33.707 ms** | 105.849 ms <br> `214% slower` | 228.567 ms <br> `578% slower` | 973.041 ms <br> `2787% slower`  |
| SHA-512       | **35.993 ms** | 106.572 ms <br> `196% slower` | 228.51 ms <br> `535% slower`  | 976.31 ms <br> `2612% slower`   |
| SHA-512/224   | **34.435 ms** | 107.02 ms <br> `211% slower`  | ➖                            | 1094.58 ms <br> `3079% slower`  |
| SHA-512/256   | **32.853 ms** | 106.725 ms <br> `225% slower` | ➖                            | 1117.826 ms <br> `3303% slower` |
| SHA3-256      | **52.189 ms** | ➖                            | ➖                            | 1741.637 ms <br> `3237% slower` |
| SHA3-512      | **34.525 ms** | ➖                            | ➖                            | 3069.689 ms <br> `8791% slower` |
| BLAKE-2s      | **36.971 ms** | ➖                            | ➖                            | ➖                              |
| BLAKE-2b      | **32.177 ms** | ➖                            | ➖                            | 422.508 ms <br> `1213% slower`  |
| HMAC(MD5)     | **40.505 ms** | 54.056 ms <br> `33% slower`   | 72.781 ms <br> `80% slower`   | ➖                              |
| HMAC(SHA-256) | **74.055 ms** | 87.972 ms <br> `19% slower`   | ➖                            | ➖                              |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- |
| MD5           | **30.431 ms** | 41.434 ms <br> `36% slower`   | 70.148 ms <br> `131% slower`  | 60.985 ms <br> `100% slower`    |
| SHA-1         | **33.091 ms** | 52.698 ms <br> `59% slower`   | 119.594 ms <br> `261% slower` | 89.967 ms <br> `172% slower`    |
| SHA-224       | **49.212 ms** | 59.472 ms <br> `21% slower`   | 251.832 ms <br> `412% slower` | 226.4 ms <br> `360% slower`     |
| SHA-256       | **48.925 ms** | 59.422 ms <br> `21% slower`   | 251.279 ms <br> `414% slower` | 231.274 ms <br> `373% slower`   |
| SHA-384       | **31.045 ms** | 102.704 ms <br> `231% slower` | 276.02 ms <br> `789% slower`  | 963.767 ms <br> `3004% slower`  |
| SHA-512       | **31.293 ms** | 103.984 ms <br> `232% slower` | 276.662 ms <br> `784% slower` | 960.876 ms <br> `2971% slower`  |
| SHA-512/224   | **31.069 ms** | 102.965 ms <br> `231% slower` | ➖                            | 960.332 ms <br> `2991% slower`  |
| SHA-512/256   | **31.017 ms** | 102.891 ms <br> `232% slower` | ➖                            | 960.388 ms <br> `2996% slower`  |
| SHA3-256      | **49.684 ms** | ➖                            | ➖                            | 1616.637 ms <br> `3154% slower` |
| SHA3-512      | **30.837 ms** | ➖                            | ➖                            | 2996.342 ms <br> `9617% slower` |
| BLAKE-2s      | **34.493 ms** | ➖                            | ➖                            | ➖                              |
| BLAKE-2b      | **30.35 ms**  | ➖                            | ➖                            | 409.216 ms <br> `1248% slower`  |
| HMAC(MD5)     | **30.467 ms** | 42.669 ms <br> `40% slower`   | 69.979 ms <br> `130% slower`  | ➖                              |
| HMAC(SHA-256) | **49.111 ms** | 60.201 ms <br> `23% slower`   | ➖                            | ➖                              |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.368 ms | 2.5 ms   | 16.591 ms | 206.684 ms | 2482.889 ms |
| argon2d    | 0.319 ms | 2.491 ms | 16.899 ms | 207.753 ms | 2490.568 ms |
| argon2id   | 0.354 ms | 2.93 ms  | 17.636 ms | 218.687 ms | 2613.261 ms |
