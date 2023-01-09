## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                 | `hash`                   |
| ------------- | -------------- | ------------------------ | ------------------------ |
| MD5           | **49.872 ms**  | 96.585 ms (94% slower)   | 133.627 ms (168% slower) |
| SHA-1         | **55.413 ms**  | 113.73 ms (105% slower)  | 208.398 ms (276% slower) |
| SHA-224       | **76.584 ms**  | 131.464 ms (72% slower)  | 383.59 ms (401% slower)  |
| SHA-256       | **76.331 ms**  | 130.14 ms (70% slower)   | 377.257 ms (394% slower) |
| SHA-384       | **96.624 ms**  | 337.329 ms (249% slower) | 712.231 ms (637% slower) |
| SHA-512       | **98.094 ms**  | 340.59 ms (247% slower)  | 711.801 ms (626% slower) |
| SHA-512/224   | **95.396 ms**  | 336.718 ms (253% slower) | ➖                       |
| SHA-512/256   | **95.147 ms**  | 336.471 ms (254% slower) | ➖                       |
| SHA3-256      | **76.245 ms**  | ➖                       | ➖                       |
| SHA3-512      | **97.575 ms**  | ➖                       | ➖                       |
| HMAC(MD5)     | **215.372 ms** | 262.821 ms (22% slower)  | 496.958 ms (131% slower) |
| HMAC(SHA-256) | **526.317 ms** | 615.802 ms (17% slower)  | ➖                       |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   |
| ------------- | ------------- | ------------------------ | ------------------------ |
| MD5           | **25.666 ms** | 41.487 ms (62% slower)   | 52.934 ms (106% slower)  |
| SHA-1         | **35.505 ms** | 53.241 ms (50% slower)   | 106.547 ms (200% slower) |
| SHA-224       | **51.645 ms** | 61.916 ms (20% slower)   | 246.322 ms (377% slower) |
| SHA-256       | **51.465 ms** | 61.645 ms (20% slower)   | 247.0 ms (380% slower)   |
| SHA-384       | **33.152 ms** | 107.364 ms (224% slower) | 244.713 ms (638% slower) |
| SHA-512       | **33.155 ms** | 108.873 ms (228% slower) | 243.685 ms (635% slower) |
| SHA-512/224   | **33.7 ms**   | 107.789 ms (220% slower) | ➖                       |
| SHA-512/256   | **33.279 ms** | 107.725 ms (224% slower) | ➖                       |
| SHA3-256      | **52.581 ms** | ➖                       | ➖                       |
| SHA3-512      | **33.386 ms** | ➖                       | ➖                       |
| HMAC(MD5)     | **33.959 ms** | 52.367 ms (54% slower)   | 72.017 ms (112% slower)  |
| HMAC(SHA-256) | **73.651 ms** | 88.246 ms (20% slower)   | ➖                       |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   |
| ------------- | ------------- | ------------------------ | ------------------------ |
| MD5           | **23.303 ms** | 40.572 ms (74% slower)   | 71.2 ms (206% slower)    |
| SHA-1         | **33.312 ms** | 52.087 ms (56% slower)   | 122.694 ms (268% slower) |
| SHA-224       | **49.265 ms** | 59.883 ms (22% slower)   | 258.147 ms (424% slower) |
| SHA-256       | **49.127 ms** | 60.73 ms (24% slower)    | 256.179 ms (421% slower) |
| SHA-384       | **30.112 ms** | 103.022 ms (242% slower) | 296.293 ms (884% slower) |
| SHA-512       | **30.251 ms** | 103.282 ms (241% slower) | 296.745 ms (881% slower) |
| SHA-512/224   | **30.178 ms** | 103.572 ms (243% slower) | ➖                       |
| SHA-512/256   | **30.104 ms** | 103.083 ms (242% slower) | ➖                       |
| SHA3-256      | **49.518 ms** | ➖                       | ➖                       |
| SHA3-512      | **30.412 ms** | ➖                       | ➖                       |
| HMAC(MD5)     | **23.756 ms** | 43.359 ms (83% slower)   | 68.846 ms (190% slower)  |
| HMAC(SHA-256) | **50.049 ms** | 60.212 ms (20% slower)   | ➖                       |
