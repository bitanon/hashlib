## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **Hash** : https://pub.dev/packages/hash

With string of length 17 (1000 iterations):

| Algorithms  | `hashlib`  | `crypto`              | `hash`                |
| ----------- | ---------- | --------------------- | --------------------- |
| MD5         | **346 us** | 758 us (119% slower)  | 902 us (161% slower)  |
| SHA-1       | **497 us** | 912 us (84% slower)   | 1443 us (190% slower) |
| SHA-224     | **756 us** | 1178 us (56% slower)  | 1345 us (78% slower)  |
| SHA-256     | **757 us** | 1158 us (53% slower)  | 1370 us (81% slower)  |
| SHA-384     | **739 us** | 1701 us (130% slower) | 3613 us (389% slower) |
| SHA-512     | **749 us** | 1715 us (129% slower) | 3668 us (390% slower) |
| SHA-512/224 | **755 us** | 1681 us (123% slower) | ➖                    |
| SHA-512/256 | **782 us** | 1710 us (119% slower) | ➖                    |

With string of length 1777 (50 iterations):

| Algorithms  | `hashlib`  | `crypto`            | `hash`                |
| ----------- | ---------- | ------------------- | --------------------- |
| MD5         | **284 us** | 534 us (88% slower) | 752 us (165% slower)  |
| SHA-1       | **465 us** | 684 us (47% slower) | 1402 us (202% slower) |
| SHA-224     | **816 us** | 923 us (13% slower) | 1257 us (54% slower)  |
| SHA-256     | **816 us** | 923 us (13% slower) | 1254 us (54% slower)  |
| SHA-384     | **376 us** | 722 us (92% slower) | 2115 us (463% slower) |
| SHA-512     | **378 us** | 735 us (94% slower) | 2141 us (466% slower) |
| SHA-512/224 | **381 us** | 735 us (93% slower) | ➖                    |
| SHA-512/256 | **377 us** | 725 us (92% slower) | ➖                    |

With string of length 177000 (2 iterations):

| Algorithms  | `hashlib`   | `crypto`             | `hash`                |
| ----------- | ----------- | -------------------- | --------------------- |
| MD5         | **1104 us** | 2016 us (83% slower) | 4529 us (310% slower) |
| SHA-1       | **1830 us** | 2585 us (41% slower) | 6913 us (278% slower) |
| SHA-224     | **3206 us** | 3523 us (10% slower) | 6306 us (97% slower)  |
| SHA-256     | **3199 us** | 3524 us (10% slower) | 6324 us (98% slower)  |
| SHA-384     | **1290 us** | 2446 us (90% slower) | 9042 us (601% slower) |
| SHA-512     | **1289 us** | 2458 us (91% slower) | 9038 us (601% slower) |
| SHA-512/224 | **1288 us** | 2463 us (91% slower) | ➖                    |
| SHA-512/256 | **1289 us** | 2447 us (90% slower) | ➖                    |
