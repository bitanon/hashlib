## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto

With string of length 17 (1000 times):

| Algorithms  |  `hashlib` | `crypto` |  Comment   |
| ----------- | ---------: | -------: | :--------: |
| MD5         | **369 us** |   764 us | 52% faster |
| SHA-1       | **489 us** |   915 us | 47% faster |
| SHA-224     | **764 us** |  1167 us | 35% faster |
| SHA-256     | **786 us** |  1155 us | 32% faster |
| SHA-384     | **758 us** |  1719 us | 56% faster |
| SHA-512     | **765 us** |  1710 us | 55% faster |
| SHA-512/224 | **741 us** |  1685 us | 56% faster |
| SHA-512/256 | **756 us** |  1690 us | 55% faster |

With string of length 1777 (50 times):

| Algorithms  |  `hashlib` |   `crypto` |  Comment   |
| ----------- | ---------: | ---------: | :--------: |
| MD5         | **428 us** |     541 us | 21% faster |
| SHA-1       | **594 us** |     686 us | 13% faster |
| SHA-224     |     965 us | **923 us** | 5% slower  |
| SHA-256     |     965 us | **922 us** | 5% slower  |
| SHA-384     | **505 us** |     727 us | 31% faster |
| SHA-512     | **505 us** |     732 us | 31% faster |
| SHA-512/224 | **516 us** |     737 us | 30% faster |
| SHA-512/256 | **516 us** |     741 us | 30% faster |

With string of length 177000 (1 times):

| Algorithms  |   `hashlib` |    `crypto` |  Comment   |
| ----------- | ----------: | ----------: | :--------: |
| MD5         |  **840 us** |     1010 us | 17% faster |
| SHA-1       | **1177 us** |     1320 us | 11% faster |
| SHA-224     |     1914 us | **1826 us** | 5% slower  |
| SHA-256     |     1909 us | **1773 us** | 8% slower  |
| SHA-384     |  **929 us** |     1278 us | 27% faster |
| SHA-512     |  **942 us** |     1234 us | 24% faster |
| SHA-512/224 |  **933 us** |     1237 us | 25% faster |
| SHA-512/256 |  **947 us** |     1236 us | 23% faster |
