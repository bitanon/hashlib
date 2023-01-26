# Benchmarks

Libraries:

- **Hashlib** : https://pub.dev/packages/hashlib
- **Crypto** : https://pub.dev/packages/crypto
- **PointyCastle** : https://pub.dev/packages/pointycastle
- **Hash** : https://pub.dev/packages/hash

With string of length 10 (100000 iterations):

| Algorithms    | `hashlib`      | `crypto`                      | `hash`                        | `PointyCastle`                  |
| ------------- | -------------- | ----------------------------- | ----------------------------- | ------------------------------- |
| MD5           | **45.248 ms**  | 88.953 ms <br> `97% slower`   | 185.666 ms <br> `310% slower` | 128.899 ms <br> `185% slower`   |
| SHA-1         | **66.573 ms**  | 106.527 ms <br> `60% slower`  | 252.757 ms <br> `280% slower` | 144.162 ms <br> `117% slower`   |
| SHA-224       | **83.778 ms**  | 125.566 ms <br> `50% slower`  | 421.126 ms <br> `403% slower` | 333.455 ms <br> `298% slower`   |
| SHA-256       | **83.865 ms**  | 125.549 ms <br> `50% slower`  | 418.54 ms <br> `399% slower`  | 326.431 ms <br> `289% slower`   |
| SHA-384       | **96.596 ms**  | 274.969 ms <br> `185% slower` | 979.47 ms <br> `914% slower`  | 2218.299 ms <br> `2196% slower` |
| SHA-512       | **97.738 ms**  | 276.727 ms <br> `183% slower` | 982.465 ms <br> `905% slower` | 2215.304 ms <br> `2167% slower` |
| SHA-512/224   | **95.8 ms**    | 272.947 ms <br> `185% slower` | ➖                            | 4287.939 ms <br> `4376% slower` |
| SHA-512/256   | **95.99 ms**   | 273.518 ms <br> `185% slower` | ➖                            | 4307.934 ms <br> `4388% slower` |
| SHA3-256      | **83.846 ms**  | ➖                            | ➖                            | 4267.935 ms <br> `4990% slower` |
| SHA3-512      | **97.777 ms**  | ➖                            | ➖                            | 4271.159 ms <br> `4268% slower` |
| BLAKE-2s      | **66.163 ms**  | ➖                            | ➖                            | ➖                              |
| BLAKE-2b      | **76.357 ms**  | ➖                            | ➖                            | 1055.354 ms <br> `1282% slower` |
| HMAC(MD5)     | **209.623 ms** | 245.241 ms <br> `17% slower`  | 684.095 ms <br> `226% slower` | ➖                              |
| HMAC(SHA-256) | **540.564 ms** | 621.116 ms <br> `15% slower`  | ➖                            | ➖                              |

With string of length 1000 (5000 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                        | `PointyCastle`                  |
| ------------- | ------------- | ---------------------------- | ----------------------------- | ------------------------------- |
| MD5           | **34.652 ms** | 37.937 ms <br> `9% slower`   | 68.937 ms <br> `99% slower`   | 100.301 ms <br> `189% slower`   |
| SHA-1         | **41.762 ms** | 48.043 ms <br> `15% slower`  | 111.724 ms <br> `168% slower` | 102.005 ms <br> `144% slower`   |
| SHA-224       | **54.186 ms** | 61.737 ms <br> `14% slower`  | 249.364 ms <br> `360% slower` | 248.049 ms <br> `358% slower`   |
| SHA-256       | **54.368 ms** | 61.809 ms <br> `14% slower`  | 249.28 ms <br> `359% slower`  | 247.361 ms <br> `355% slower`   |
| SHA-384       | **30.814 ms** | 84.52 ms <br> `174% slower`  | 330.226 ms <br> `972% slower` | 850.038 ms <br> `2659% slower`  |
| SHA-512       | **30.87 ms**  | 84.512 ms <br> `174% slower` | 331.359 ms <br> `973% slower` | 850.103 ms <br> `2654% slower`  |
| SHA-512/224   | **30.98 ms**  | 84.447 ms <br> `173% slower` | ➖                            | 953.33 ms <br> `2977% slower`   |
| SHA-512/256   | **30.783 ms** | 84.611 ms <br> `175% slower` | ➖                            | 955.661 ms <br> `3005% slower`  |
| SHA3-256      | **54.289 ms** | ➖                           | ➖                            | 1649.036 ms <br> `2938% slower` |
| SHA3-512      | **30.96 ms**  | ➖                           | ➖                            | 2878.77 ms <br> `9198% slower`  |
| BLAKE-2s      | **36.558 ms** | ➖                           | ➖                            | ➖                              |
| BLAKE-2b      | **27.387 ms** | ➖                           | ➖                            | 360.981 ms <br> `1218% slower`  |
| HMAC(MD5)     | **42.721 ms** | 46.975 ms <br> `10% slower`  | 93.048 ms <br> `118% slower`  | ➖                              |
| HMAC(SHA-256) | **77.251 ms** | 87.738 ms <br> `14% slower`  | ➖                            | ➖                              |

With string of length 500000 (10 iterations):

| Algorithms    | `hashlib`     | `crypto`                     | `hash`                         | `PointyCastle`                   |
| ------------- | ------------- | ---------------------------- | ------------------------------ | -------------------------------- |
| MD5           | **33.291 ms** | 36.318 ms <br> `9% slower`   | 75.338 ms <br> `126% slower`   | 96.575 ms <br> `190% slower`     |
| SHA-1         | **39.199 ms** | 45.993 ms <br> `17% slower`  | 116.264 ms <br> `197% slower`  | 98.005 ms <br> `150% slower`     |
| SHA-224       | **51.594 ms** | 59.379 ms <br> `15% slower`  | 250.895 ms <br> `386% slower`  | 240.0 ms <br> `365% slower`      |
| SHA-256       | **51.655 ms** | 59.381 ms <br> `15% slower`  | 250.894 ms <br> `386% slower`  | 239.805 ms <br> `364% slower`    |
| SHA-384       | **27.624 ms** | 81.056 ms <br> `193% slower` | 334.933 ms <br> `1112% slower` | 820.631 ms <br> `2871% slower`   |
| SHA-512       | **27.609 ms** | 80.973 ms <br> `193% slower` | 334.375 ms <br> `1111% slower` | 820.707 ms <br> `2873% slower`   |
| SHA-512/224   | **27.639 ms** | 81.378 ms <br> `194% slower` | ➖                             | 820.373 ms <br> `2868% slower`   |
| SHA-512/256   | **27.621 ms** | 81.213 ms <br> `194% slower` | ➖                             | 820.862 ms <br> `2872% slower`   |
| SHA3-256      | **51.641 ms** | ➖                           | ➖                             | 1507.17 ms <br> `2819% slower`   |
| SHA3-512      | **27.602 ms** | ➖                           | ➖                             | 2856.679 ms <br> `10250% slower` |
| BLAKE-2s      | **34.406 ms** | ➖                           | ➖                             | ➖                               |
| BLAKE-2b      | **25.945 ms** | ➖                           | ➖                             | 349.653 ms <br> `1248% slower`   |
| HMAC(MD5)     | **33.266 ms** | 36.478 ms <br> `10% slower`  | 75.431 ms <br> `127% slower`   | ➖                               |
| HMAC(SHA-256) | **51.543 ms** | 59.543 ms <br> `16% slower`  | ➖                             | ➖                               |

Argon2 benchmarks on different security parameters:

| Algorithms | test     | little   | moderate  | good       | strong      |
| ---------- | -------- | -------- | --------- | ---------- | ----------- |
| argon2i    | 0.391 ms | 2.889 ms | 19.686 ms | 250.008 ms | 2718.1 ms   |
| argon2d    | 0.29 ms  | 3.207 ms | 19.368 ms | 245.818 ms | 2664.177 ms |
| argon2id   | 0.382 ms | 5.554 ms | 20.352 ms | 250.707 ms | 2683.672 ms |
