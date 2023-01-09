## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                 | `hash`                   |
| ------------- | -------------- | ------------------------ | ------------------------ |
| MD5           | **34.55 ms**   | 83.386 ms (141% slower)  | 95.394 ms (176% slower)  |
| SHA-1         | **42.331 ms**  | 99.542 ms (135% slower)  | 145.904 ms (245% slower) |
| SHA-224       | **68.064 ms**  | 123.212 ms (81% slower)  | 139.145 ms (104% slower) |
| SHA-256       | **68.461 ms**  | 122.041 ms (78% slower)  | 137.47 ms (101% slower)  |
| SHA-384       | **68.317 ms**  | 173.358 ms (154% slower) | 364.279 ms (433% slower) |
| SHA-512       | **65.963 ms**  | 175.144 ms (166% slower) | 369.95 ms (461% slower)  |
| SHA-512/224   | **65.502 ms**  | 171.968 ms (163% slower) | ➖                       |
| SHA-512/256   | **65.801 ms**  | 172.064 ms (161% slower) | ➖                       |
| HMAC(MD5)     | **125.177 ms** | 237.121 ms (89% slower)  | 319.038 ms (155% slower) |
| HMAC(SHA-256) | **471.029 ms** | 600.542 ms (27% slower)  | ➖                       |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`               | `hash`                   |
| ------------- | ------------- | ---------------------- | ------------------------ |
| MD5           | **22.506 ms** | 33.438 ms (49% slower) | 44.499 ms (98% slower)   |
| SHA-1         | **30.322 ms** | 42.727 ms (41% slower) | 82.703 ms (173% slower)  |
| SHA-224       | **49.536 ms** | 56.77 ms (15% slower)  | 74.296 ms (50% slower)   |
| SHA-256       | **49.558 ms** | 56.566 ms (14% slower) | 74.013 ms (49% slower)   |
| SHA-384       | **25.064 ms** | 43.604 ms (74% slower) | 116.059 ms (363% slower) |
| SHA-512       | **24.691 ms** | 43.23 ms (75% slower)  | 115.27 ms (367% slower)  |
| SHA-512/224   | **24.688 ms** | 42.897 ms (74% slower) | ➖                       |
| SHA-512/256   | **24.563 ms** | 42.834 ms (74% slower) | ➖                       |
| HMAC(MD5)     | **27.88 ms**  | 42.56 ms (53% slower)  | 56.066 ms (101% slower)  |
| HMAC(SHA-256) | **69.575 ms** | 81.562 ms (17% slower) | ➖                       |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`               | `hash`                   |
| ------------- | ------------- | ---------------------- | ------------------------ |
| MD5           | **21.078 ms** | 31.651 ms (50% slower) | 65.45 ms (211% slower)   |
| SHA-1         | **28.687 ms** | 39.95 ms (39% slower)  | 98.414 ms (243% slower)  |
| SHA-224       | **47.879 ms** | 53.44 ms (12% slower)  | 91.338 ms (91% slower)   |
| SHA-256       | **47.623 ms** | 53.214 ms (12% slower) | 90.116 ms (89% slower)   |
| SHA-384       | **23.27 ms**  | 37.724 ms (62% slower) | 127.508 ms (448% slower) |
| SHA-512       | **23.086 ms** | 38.046 ms (65% slower) | 131.491 ms (470% slower) |
| SHA-512/224   | **23.177 ms** | 37.768 ms (63% slower) | ➖                       |
| SHA-512/256   | **23.289 ms** | 37.483 ms (61% slower) | ➖                       |
| HMAC(MD5)     | **21.15 ms**  | 31.393 ms (48% slower) | 63.543 ms (200% slower)  |
| HMAC(SHA-256) | **47.814 ms** | 53.223 ms (11% slower) | ➖                       |
