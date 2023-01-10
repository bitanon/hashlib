## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                 | `hash`                   | `sha3`                   |
| ------------- | -------------- | ------------------------ | ------------------------ | ------------------------ |
| MD5           | **50.107 ms**  | 101.123 ms (102% slower) | 139.001 ms (177% slower) | ➖                       |
| SHA-1         | **55.785 ms**  | 116.463 ms (109% slower) | 208.638 ms (274% slower) | ➖                       |
| SHA-224       | **75.704 ms**  | 133.182 ms (76% slower)  | 387.721 ms (412% slower) | ➖                       |
| SHA-256       | **76.607 ms**  | 130.455 ms (70% slower)  | 381.222 ms (398% slower) | ➖                       |
| SHA-384       | **96.676 ms**  | 341.488 ms (253% slower) | 752.712 ms (679% slower) | ➖                       |
| SHA-512       | **97.046 ms**  | 342.706 ms (253% slower) | 719.218 ms (641% slower) | ➖                       |
| SHA-512/224   | **95.339 ms**  | 338.656 ms (255% slower) | ➖                       | ➖                       |
| SHA-512/256   | **95.722 ms**  | 338.353 ms (253% slower) | ➖                       | ➖                       |
| SHA3-256      | **75.395 ms**  | ➖                       | ➖                       | 411.966 ms (446% slower) |
| SHA3-512      | **96.882 ms**  | ➖                       | ➖                       | 411.606 ms (325% slower) |
| HMAC(MD5)     | **202.898 ms** | 261.717 ms (29% slower)  | 532.516 ms (162% slower) | ➖                       |
| HMAC(SHA-256) | **516.24 ms**  | 628.502 ms (22% slower)  | ➖                       | ➖                       |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   | `sha3`                   |
| ------------- | ------------- | ------------------------ | ------------------------ | ------------------------ |
| MD5           | **25.26 ms**  | 43.516 ms (72% slower)   | 56.735 ms (125% slower)  | ➖                       |
| SHA-1         | **34.681 ms** | 53.712 ms (55% slower)   | 107.652 ms (210% slower) | ➖                       |
| SHA-224       | **50.969 ms** | 63.217 ms (24% slower)   | 240.234 ms (371% slower) | ➖                       |
| SHA-256       | **51.111 ms** | 63.143 ms (24% slower)   | 242.054 ms (374% slower) | ➖                       |
| SHA-384       | **32.82 ms**  | 108.715 ms (231% slower) | 237.763 ms (624% slower) | ➖                       |
| SHA-512       | **32.79 ms**  | 108.357 ms (230% slower) | 243.2 ms (642% slower)   | ➖                       |
| SHA-512/224   | **32.647 ms** | 108.18 ms (231% slower)  | ➖                       | ➖                       |
| SHA-512/256   | **32.125 ms** | 107.816 ms (236% slower) | ➖                       | ➖                       |
| SHA3-256      | **50.881 ms** | ➖                       | ➖                       | 225.934 ms (344% slower) |
| SHA3-512      | **32.802 ms** | ➖                       | ➖                       | 337.521 ms (929% slower) |
| HMAC(MD5)     | **32.492 ms** | 52.861 ms (63% slower)   | 74.494 ms (129% slower)  | ➖                       |
| HMAC(SHA-256) | **72.161 ms** | 88.789 ms (23% slower)   | ➖                       | ➖                       |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                 | `hash`                   | `sha3`                    |
| ------------- | ------------- | ------------------------ | ------------------------ | ------------------------- |
| MD5           | **23.129 ms** | 40.817 ms (76% slower)   | 73.305 ms (217% slower)  | ➖                        |
| SHA-1         | **33.571 ms** | 51.972 ms (55% slower)   | 121.203 ms (261% slower) | ➖                        |
| SHA-224       | **48.692 ms** | 61.124 ms (26% slower)   | 251.237 ms (416% slower) | ➖                        |
| SHA-256       | **48.675 ms** | 61.115 ms (26% slower)   | 251.095 ms (416% slower) | ➖                        |
| SHA-384       | **29.876 ms** | 103.421 ms (246% slower) | 296.226 ms (892% slower) | ➖                        |
| SHA-512       | **29.865 ms** | 103.333 ms (246% slower) | 296.272 ms (892% slower) | ➖                        |
| SHA-512/224   | **29.926 ms** | 103.765 ms (247% slower) | ➖                       | ➖                        |
| SHA-512/256   | **29.923 ms** | 103.48 ms (246% slower)  | ➖                       | ➖                        |
| SHA3-256      | **48.624 ms** | ➖                       | ➖                       | 212.428 ms (337% slower)  |
| SHA3-512      | **30.132 ms** | ➖                       | ➖                       | 334.513 ms (1010% slower) |
| HMAC(MD5)     | **23.125 ms** | 40.56 ms (75% slower)    | 70.362 ms (204% slower)  | ➖                        |
| HMAC(SHA-256) | **48.835 ms** | 61.045 ms (25% slower)   | ➖                       | ➖                        |
