## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                 | `hash`                   |
| ------------- | -------------- | ------------------------ | ------------------------ |
| MD5           | **33.817 ms**  | 81.377 ms (141% slower)  | 93.012 ms (175% slower)  |
| SHA-1         | **48.042 ms**  | 97.887 ms (104% slower)  | 145.601 ms (203% slower) |
| SHA-224       | **75.26 ms**   | 122.895 ms (63% slower)  | 141.736 ms (88% slower)  |
| SHA-256       | **75.286 ms**  | 121.891 ms (62% slower)  | 139.003 ms (85% slower)  |
| SHA-384       | **76.275 ms**  | 170.599 ms (124% slower) | 367.84 ms (382% slower)  |
| SHA-512       | **77.796 ms**  | 176.0 ms (126% slower)   | 369.237 ms (375% slower) |
| SHA-512/224   | **76.038 ms**  | 171.777 ms (126% slower) | ➖                       |
| SHA-512/256   | **77.04 ms**   | 173.068 ms (125% slower) | ➖                       |
| HMAC(MD5)     | **169.861 ms** | 237.378 ms (40% slower)  | 314.386 ms (85% slower)  |
| HMAC(SHA-256) | **522.838 ms** | 599.62 ms (15% slower)   | ➖                       |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`               | `hash`                   |
| ------------- | ------------- | ---------------------- | ------------------------ |
| MD5           | **25.336 ms** | 32.298 ms (27% slower) | 43.648 ms (72% slower)   |
| SHA-1         | **30.674 ms** | 40.917 ms (33% slower) | 81.334 ms (165% slower)  |
| SHA-224       | **51.097 ms** | 55.512 ms (9% slower)  | 75.326 ms (47% slower)   |
| SHA-256       | **51.998 ms** | 60.757 ms (17% slower) | 75.418 ms (45% slower)   |
| SHA-384       | **24.014 ms** | 43.871 ms (83% slower) | 121.564 ms (406% slower) |
| SHA-512       | **24.237 ms** | 43.925 ms (81% slower) | 118.904 ms (391% slower) |
| SHA-512/224   | **24.174 ms** | 43.961 ms (82% slower) | ➖                       |
| SHA-512/256   | **23.917 ms** | 43.768 ms (83% slower) | ➖                       |
| HMAC(MD5)     | **34.247 ms** | 42.889 ms (25% slower) | 57.014 ms (66% slower)   |
| HMAC(SHA-256) | **76.335 ms** | 83.807 ms (10% slower) | ➖                       |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`               | `hash`                   |
| ------------- | ------------- | ---------------------- | ------------------------ |
| MD5           | **25.594 ms** | 31.597 ms (23% slower) | 67.266 ms (163% slower)  |
| SHA-1         | **29.977 ms** | 39.545 ms (32% slower) | 103.898 ms (247% slower) |
| SHA-224       | **49.716 ms** | 54.63 ms (10% slower)  | 95.404 ms (92% slower)   |
| SHA-256       | **48.967 ms** | 52.679 ms (8% slower)  | 98.221 ms (101% slower)  |
| SHA-384       | **22.043 ms** | 36.833 ms (67% slower) | 130.773 ms (493% slower) |
| SHA-512       | **21.78 ms**  | 37.093 ms (70% slower) | 135.342 ms (521% slower) |
| SHA-512/224   | **21.229 ms** | 37.259 ms (76% slower) | ➖                       |
| SHA-512/256   | **21.693 ms** | 37.189 ms (71% slower) | ➖                       |
| HMAC(MD5)     | **25.745 ms** | 31.544 ms (23% slower) | 67.113 ms (161% slower)  |
| HMAC(SHA-256) | **50.564 ms** | 54.578 ms (8% slower)  | ➖                       |
