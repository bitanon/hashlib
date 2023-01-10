## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                 | `hash`                   | `PointyCastle`             | `sha3`                   |
| ------------- | -------------- | ------------------------ | ------------------------ | -------------------------- | ------------------------ |
| MD5           | **50.931 ms**  | 101.212 ms (99% slower)  | 133.758 ms (163% slower) | 88.288 ms (73% slower)     | ➖                       |
| SHA-1         | **53.747 ms**  | 115.271 ms (114% slower) | 211.951 ms (294% slower) | 137.231 ms (155% slower)   | ➖                       |
| SHA-224       | **76.389 ms**  | 134.22 ms (76% slower)   | 387.053 ms (407% slower) | 321.229 ms (321% slower)   | ➖                       |
| SHA-256       | **76.828 ms**  | 135.425 ms (76% slower)  | 379.707 ms (394% slower) | 319.343 ms (316% slower)   | ➖                       |
| SHA-384       | **96.529 ms**  | 334.873 ms (247% slower) | 718.278 ms (644% slower) | 2597.044 ms (2590% slower) | ➖                       |
| SHA-512       | **98.675 ms**  | 338.345 ms (243% slower) | 726.788 ms (637% slower) | 2618.119 ms (2553% slower) | ➖                       |
| SHA-512/224   | **97.361 ms**  | 329.735 ms (239% slower) | ➖                       | 5096.644 ms (5135% slower) | ➖                       |
| SHA-512/256   | **96.537 ms**  | 334.794 ms (247% slower) | ➖                       | 5038.997 ms (5120% slower) | ➖                       |
| SHA3-256      | **77.401 ms**  | ➖                       | ➖                       | 4452.906 ms (5653% slower) | 434.21 ms (461% slower)  |
| SHA3-512      | **97.807 ms**  | ➖                       | ➖                       | 4492.233 ms (4493% slower) | 429.818 ms (339% slower) |
| HMAC(MD5)     | **206.854 ms** | 263.488 ms (27% slower)  | 508.613 ms (146% slower) | ➖                         | ➖                       |
| HMAC(SHA-256) | **515.705 ms** | 632.506 ms (23% slower)  | ➖                       | ➖                         | ➖                       |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   | `PointyCastle`             | `sha3`                   |
| ------------- | ------------- | ------------------------ | ------------------------ | -------------------------- | ------------------------ |
| MD5           | **26.035 ms** | 42.218 ms (62% slower)   | 54.553 ms (110% slower)  | 60.076 ms (131% slower)    | ➖                       |
| SHA-1         | **35.23 ms**  | 52.975 ms (50% slower)   | 105.127 ms (198% slower) | 91.053 ms (158% slower)    | ➖                       |
| SHA-224       | **53.851 ms** | 64.94 ms (21% slower)    | 249.092 ms (363% slower) | 243.794 ms (353% slower)   | ➖                       |
| SHA-256       | **53.426 ms** | 63.715 ms (19% slower)   | 248.188 ms (365% slower) | 242.431 ms (354% slower)   | ➖                       |
| SHA-384       | **35.019 ms** | 106.083 ms (203% slower) | 239.521 ms (584% slower) | 990.296 ms (2728% slower)  | ➖                       |
| SHA-512       | **34.532 ms** | 105.82 ms (206% slower)  | 236.418 ms (585% slower) | 993.274 ms (2776% slower)  | ➖                       |
| SHA-512/224   | **34.895 ms** | 105.861 ms (203% slower) | ➖                       | 1108.072 ms (3075% slower) | ➖                       |
| SHA-512/256   | **34.694 ms** | 106.124 ms (206% slower) | ➖                       | 1111.653 ms (3104% slower) | ➖                       |
| SHA3-256      | **53.227 ms** | ➖                       | ➖                       | 1724.218 ms (3139% slower) | 232.79 ms (337% slower)  |
| SHA3-512      | **35.456 ms** | ➖                       | ➖                       | 2980.181 ms (8305% slower) | 350.984 ms (890% slower) |
| HMAC(MD5)     | **32.946 ms** | 54.731 ms (66% slower)   | 73.506 ms (123% slower)  | ➖                         | ➖                       |
| HMAC(SHA-256) | **75.485 ms** | 91.716 ms (22% slower)   | ➖                       | ➖                         | ➖                       |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   | `PointyCastle`             | `sha3`                   |
| ------------- | ------------- | ------------------------ | ------------------------ | -------------------------- | ------------------------ |
| MD5           | **24.426 ms** | 41.096 ms (68% slower)   | 69.952 ms (186% slower)  | 57.881 ms (137% slower)    | ➖                       |
| SHA-1         | **33.924 ms** | 52.011 ms (53% slower)   | 120.991 ms (257% slower) | 87.333 ms (157% slower)    | ➖                       |
| SHA-224       | **50.227 ms** | 61.098 ms (22% slower)   | 260.411 ms (418% slower) | 234.297 ms (366% slower)   | ➖                       |
| SHA-256       | **50.354 ms** | 61.608 ms (22% slower)   | 254.885 ms (406% slower) | 233.129 ms (363% slower)   | ➖                       |
| SHA-384       | **31.181 ms** | 101.861 ms (227% slower) | 280.735 ms (800% slower) | 972.907 ms (3020% slower)  | ➖                       |
| SHA-512       | **31.34 ms**  | 103.349 ms (230% slower) | 279.512 ms (792% slower) | 949.03 ms (2928% slower)   | ➖                       |
| SHA-512/224   | **31.817 ms** | 102.973 ms (224% slower) | ➖                       | 954.928 ms (2901% slower)  | ➖                       |
| SHA-512/256   | **31.462 ms** | 103.699 ms (230% slower) | ➖                       | 970.079 ms (2983% slower)  | ➖                       |
| SHA3-256      | **50.011 ms** | ➖                       | ➖                       | 1554.648 ms (3009% slower) | 216.966 ms (334% slower) |
| SHA3-512      | **31.264 ms** | ➖                       | ➖                       | 2939.351 ms (9302% slower) | 343.434 ms (998% slower) |
| HMAC(MD5)     | **24.111 ms** | 42.385 ms (76% slower)   | 70.695 ms (193% slower)  | ➖                         | ➖                       |
| HMAC(SHA-256) | **50.42 ms**  | 62.647 ms (24% slower)   | ➖                       | ➖                         | ➖                       |
