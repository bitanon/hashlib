# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash
- **Sha3** : https://pub.dev/packages/sha3

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | -------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **35.353 ms**  | 99.184 ms <br> `181% slower`  | 132.232 ms <br> `274% slower` | 84.348 ms <br> `139% slower`    | ➖                            |
| SHA-1         | **60.984 ms**  | 115.06 ms <br> `89% slower`   | 204.618 ms <br> `236% slower` | 132.707 ms <br> `118% slower`   | ➖                            |
| SHA-224       | **82.921 ms**  | 137.013 ms <br> `65% slower`  | 376.467 ms <br> `354% slower` | 317.903 ms <br> `283% slower`   | ➖                            |
| SHA-256       | **82.724 ms**  | 135.03 ms <br> `63% slower`   | 375.416 ms <br> `354% slower` | 318.855 ms <br> `285% slower`   | ➖                            |
| SHA-384       | **103.835 ms** | 344.046 ms <br> `231% slower` | 722.537 ms <br> `596% slower` | 2601.015 ms <br> `2405% slower` | ➖                            |
| SHA-512       | **103.755 ms** | 346.637 ms <br> `234% slower` | 713.643 ms <br> `588% slower` | 2627.374 ms <br> `2432% slower` | ➖                            |
| SHA-512/224   | **102.017 ms** | 342.321 ms <br> `236% slower` | ➖                            | 5106.248 ms <br> `4905% slower` | ➖                            |
| SHA-512/256   | **102.386 ms** | 341.22 ms <br> `233% slower`  | ➖                            | 5096.226 ms <br> `4877% slower` | ➖                            |
| SHA3-256      | **82.077 ms**  | ➖                            | ➖                            | 4472.259 ms <br> `5349% slower` | 408.232 ms <br> `397% slower` |
| SHA3-512      | **103.6 ms**   | ➖                            | ➖                            | 4481.2 ms <br> `4225% slower`   | 408.795 ms <br> `295% slower` |
| BLAKE-2s      | **62.667 ms**  | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **81.948 ms**  | ➖                            | ➖                            | 1144.464 ms <br> `1297% slower` | ➖                            |
| HMAC(MD5)     | **213.07 ms**  | 266.102 ms <br> `25% slower`  | 498.219 ms <br> `134% slower` | ➖                              | ➖                            |
| HMAC(SHA-256) | **535.764 ms** | 624.437 ms <br> `17% slower`  | ➖                            | ➖                              | ➖                            |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **31.268 ms** | 41.928 ms <br> `34% slower`   | 52.334 ms <br> `67% slower`   | 60.301 ms <br> `93% slower`     | ➖                            |
| SHA-1         | **36.819 ms** | 53.565 ms <br> `45% slower`   | 105.095 ms <br> `185% slower` | 89.969 ms <br> `144% slower`    | ➖                            |
| SHA-224       | **52.821 ms** | 63.124 ms <br> `20% slower`   | 238.791 ms <br> `352% slower` | 237.553 ms <br> `350% slower`   | ➖                            |
| SHA-256       | **52.85 ms**  | 62.812 ms <br> `19% slower`   | 238.127 ms <br> `351% slower` | 236.949 ms <br> `348% slower`   | ➖                            |
| SHA-384       | **34.541 ms** | 107.518 ms <br> `211% slower` | 257.815 ms <br> `646% slower` | 1000.244 ms <br> `2796% slower` | ➖                            |
| SHA-512       | **33.865 ms** | 107.616 ms <br> `218% slower` | 233.219 ms <br> `589% slower` | 999.335 ms <br> `2851% slower`  | ➖                            |
| SHA-512/224   | **33.684 ms** | 109.742 ms <br> `226% slower` | ➖                            | 1123.899 ms <br> `3237% slower` | ➖                            |
| SHA-512/256   | **34.84 ms**  | 109.424 ms <br> `214% slower` | ➖                            | 1143.562 ms <br> `3182% slower` | ➖                            |
| SHA3-256      | **54.081 ms** | ➖                            | ➖                            | 1721.936 ms <br> `3084% slower` | 230.092 ms <br> `325% slower` |
| SHA3-512      | **34.698 ms** | ➖                            | ➖                            | 3002.732 ms <br> `8554% slower` | 337.325 ms <br> `872% slower` |
| BLAKE-2s      | **36.763 ms** | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **25.799 ms** | ➖                            | ➖                            | 409.533 ms <br> `1487% slower`  | ➖                            |
| HMAC(MD5)     | **40.644 ms** | 53.016 ms <br> `30% slower`   | 70.384 ms <br> `73% slower`   | ➖                              | ➖                            |
| HMAC(SHA-256) | **74.654 ms** | 91.42 ms <br> `22% slower`    | ➖                            | ➖                              | ➖                            |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                      | `hash`                        | `PointyCastle`                  | `sha3`                        |
| ------------- | ------------- | ----------------------------- | ----------------------------- | ------------------------------- | ----------------------------- |
| MD5           | **30.376 ms** | 40.509 ms <br> `33% slower`   | 69.67 ms <br> `129% slower`   | 57.96 ms <br> `91% slower`      | ➖                            |
| SHA-1         | **33.523 ms** | 51.793 ms <br> `54% slower`   | 120.908 ms <br> `261% slower` | 86.113 ms <br> `157% slower`    | ➖                            |
| SHA-224       | **50.253 ms** | 60.678 ms <br> `21% slower`   | 249.619 ms <br> `397% slower` | 230.563 ms <br> `359% slower`   | ➖                            |
| SHA-256       | **50.344 ms** | 60.738 ms <br> `21% slower`   | 249.453 ms <br> `395% slower` | 229.371 ms <br> `356% slower`   | ➖                            |
| SHA-384       | **31.777 ms** | 103.155 ms <br> `225% slower` | 280.01 ms <br> `781% slower`  | 968.057 ms <br> `2946% slower`  | ➖                            |
| SHA-512       | **31.718 ms** | 103.332 ms <br> `226% slower` | 279.144 ms <br> `780% slower` | 969.389 ms <br> `2956% slower`  | ➖                            |
| SHA-512/224   | **31.656 ms** | 102.954 ms <br> `225% slower` | ➖                            | 970.759 ms <br> `2967% slower`  | ➖                            |
| SHA-512/256   | **32.011 ms** | 103.348 ms <br> `223% slower` | ➖                            | 968.022 ms <br> `2924% slower`  | ➖                            |
| SHA3-256      | **50.22 ms**  | ➖                            | ➖                            | 1560.669 ms <br> `3008% slower` | 212.792 ms <br> `324% slower` |
| SHA3-512      | **31.7 ms**   | ➖                            | ➖                            | 2932.904 ms <br> `9152% slower` | 334.856 ms <br> `956% slower` |
| BLAKE-2s      | **34.788 ms** | ➖                            | ➖                            | ➖                              | ➖                            |
| BLAKE-2b      | **23.761 ms** | ➖                            | ➖                            | 393.928 ms <br> `1558% slower`  | ➖                            |
| HMAC(MD5)     | **31.094 ms** | 42.317 ms <br> `36% slower`   | 69.942 ms <br> `125% slower`  | ➖                              | ➖                            |
| HMAC(SHA-256) | **50.258 ms** | 62.296 ms <br> `24% slower`   | ➖                            | ➖                              | ➖                            |
