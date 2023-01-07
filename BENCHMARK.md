## Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto

With string of length 17 (1000 times):

| Algorithms  |    Hashlib |  Crypto | Difference |
| ----------- | ---------: | ------: | :--------: |
| MD5         | **366 us** |  755 us |     ➖     |
| SHA-1       | **483 us** |  910 us |     ➖     |
| SHA-224     | **751 us** | 1192 us |     ➖     |
| SHA-256     | **757 us** | 1167 us |     ➖     |
| SHA-384     | **764 us** | 1697 us |     ➖     |
| SHA-512     | **759 us** | 1750 us |     ➖     |
| SHA-512/224 | **744 us** | 1699 us |     ➖     |
| SHA-512/256 | **763 us** | 1689 us |     ➖     |

With string of length 1777 (50 times):

| Algorithms  |    Hashlib |     Crypto | Difference |
| ----------- | ---------: | ---------: | :--------: |
| MD5         | **434 us** |     550 us |     ➖     |
| SHA-1       | **604 us** |     690 us |     ➖     |
| SHA-224     |     930 us | **923 us** |    7 us    |
| SHA-256     |     933 us | **925 us** |    8 us    |
| SHA-384     | **512 us** |     742 us |     ➖     |
| SHA-512     | **512 us** |     742 us |     ➖     |
| SHA-512/224 | **513 us** |     739 us |     ➖     |
| SHA-512/256 | **516 us** |     740 us |     ➖     |

With string of length 77000 (2 times):

| Algorithms  |     Hashlib |      Crypto | Difference |
| ----------- | ----------: | ----------: | :--------: |
| MD5         |  **733 us** |      910 us |     ➖     |
| SHA-1       | **1032 us** |     1130 us |     ➖     |
| SHA-224     |     1598 us | **1523 us** |   75 us    |
| SHA-256     |     1575 us | **1540 us** |   35 us    |
| SHA-384     |  **814 us** |     1097 us |     ➖     |
| SHA-512     |  **811 us** |     1132 us |     ➖     |
| SHA-512/224 |  **817 us** |     1118 us |     ➖     |
| SHA-512/256 |  **821 us** |     1102 us |     ➖     |
