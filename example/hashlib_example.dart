import 'package:hashlib/hashlib.dart';

void main() {
  // Examples of Hash generation
  var text = "Happy Hashing!";
  print('[CRC32] $text => ${crc32code(text)}');
  print('[CRC64] $text => ${crc64code(text)}');
  print('[MD5] $text => ${md5sum(text)}');
  print('[SHA-1] $text => ${sha1sum(text)}');
  print('[SHA-224] $text => ${sha224sum(text)}');
  print('[SHA-256] $text => ${sha256sum(text)}');
  print('[SHA-384] $text => ${sha384sum(text)}');
  print('[SHA-512] $text => ${sha512sum(text)}');
  print('[SHA-512/224] $text => ${sha512t224sum(text)}');
  print('[SHA-512/256] $text => ${sha512t256sum(text)}');
  print('[SHA3-224] $text => ${sha3_224sum(text)}');
  print('[SHA3-256] $text => ${sha3_256sum(text)}');
  print('[SHA3-384] $text => ${sha3_384sum(text)}');
  print('[SHA3-512] $text => ${sha3_512sum(text)}');
  print('[Keccak-224] $text => ${keccak224sum(text)}');
  print('[Keccak-256] $text => ${keccak256sum(text)}');
  print('[Keccak-384] $text => ${keccak384sum(text)}');
  print('[Keccak-512] $text => ${keccak512sum(text)}');
  print('[SHAKE-128] $text => ${shake128sum(text, 20)}');
  print('[SHAKE-256] $text => ${shake256sum(text, 20)}');
  print('[BLAKE-2s/256] $text => ${blake2s256.string(text)}');
  print('[BLAKE-2b/512] $text => ${blake2b512.string(text)}');
  print('');

  // Example of HMAC generation
  var key = "secret";
  print('HMAC[MD5] $text => ${md5.hmacBy(key).string(text)}');
  print('HMAC[SHA-1] $text => ${sha1.hmacBy(key).string(text)}');
  print('HMAC[SHA-256] $text => ${sha256.hmacBy(key).string(text)}');
  print('');

  // Example of Argon2 Password Hashing
  var argon2 = Argon2Context(
    version: Argon2Version.v13,
    hashType: Argon2Type.argon2id,
    hashLength: 32,
    iterations: 8,
    parallelism: 4,
    memorySizeKB: 8192,
    salt: "some salt".codeUnits,
  ).toInstance();
  var encoded = argon2.encode('password'.codeUnits).hex();
  print("Argon2id password: $encoded");
}

/*
Expected output:
-------------------------------------------------------------------------
[CRC32] Happy Hashing! => 3003384410
[CRC64] Happy Hashing! => -4095757041900067887
[MD5] Happy Hashing! => b69ec294812e3e6adcc36f44e82a4f42
[SHA-1] Happy Hashing! => 4d8ef3c1809ee3938323cb96d84c78b441df80ec
[SHA-224] Happy Hashing! => 0ca54016b13602d9426191228aec80934ecf348f8899145a065ed88e
[SHA-256] Happy Hashing! => d8d0b2ef14c59a9b51c7729e8cc80507eb3846e69f4f789b42da1d9aae3d5a04
[SHA-384] Happy Hashing! => d51cc00b9d9c21679bbdbfda278b4437072fe01029913543cd5bbdd35a794362fe922e7f41d8868098c36898a52f55b5
[SHA-512] Happy Hashing! => 74257021f2e3b2b6fa754086fa0cdc685e6d8d0ecd3b9dce64e4d77669deb4f0535e9ab04914695b98712134576b23df8800521a229474aa192fa7d5743f0e31
[SHA-512/224] Happy Hashing! => 4d61fe957865f36a0e89d3f92e4cd234ab3337c2a6b7d657fd9c7d2e
[SHA-512/256] Happy Hashing! => a5cb0eee89a29043496bd5fd05bc5a86d1e038fd52b0130535fb6e5073545f48
[SHA3-224] Happy Hashing! => 2c36d9720ef5e8cedb536e44e70113ff91c3ddaa5e527abdb0ccd343
[SHA3-256] Happy Hashing! => b588619d89c2e406445cc7d145c98e46dbf93b9352fd3d90057bcd726adca140
[SHA3-384] Happy Hashing! => 0824d49313092aa71092f9fb8904f2fdb0271ef457f65aab11caf8a006f45f97c21463ece01574261991be0412547ff6
[SHA3-512] Happy Hashing! => a0309d830780039b93a9516d92c41590695b8dcac779ca42e1e41ea87df8c6f5ec8c21db9906d7b5b2b218b410a6c85c4017333229cb1553e0ed0a6bd8a8cce1
[Keccak-224] Happy Hashing! => e26345c8fdb8f32e6d044088f41c2723513855ddb0593535c4a69d81
[Keccak-256] Happy Hashing! => aa9eaf07bf042bd695286834ae585003262cd2a9ec4d06fc8eaa2ec0fab9ea7c
[Keccak-384] Happy Hashing! => 8400959dff18d5a3b55e424eb47c615a02a1b2e6d5df97ab258351880efc365343940cc30eafcfcbf03b9377f554f08e
[Keccak-512] Happy Hashing! => beac6219513aa9b63e23105fbc1d181c2d27c37331315e03319a26652b086b765a3b22c04a797420595c061716c7c8d3f4d7b5456367c018eb2499bd6a560e9a
[SHAKE-128] Happy Hashing! => 229c29ab5aa24b21f6a30f740b859994b17cac4b
[SHAKE-256] Happy Hashing! => cb0ccda1d41965fd6e6487dabcb4a3bea5af68eb
[BLAKE-2s/256] Happy Hashing! => 466397aa28e5a121c818348ab8251f280d5188fbf67557b6385d8246915d90cc
[BLAKE-2b/512] Happy Hashing! => 09c0eaa605fb15f4887b5919a3bc93622af57b7574d55445cf2a89804551d30378e46b5f5bf2f0e041ad87c702f4da5512ff24e576593b94ca1dea013e9f8d1d

HMAC[MD5] Happy Hashing! => abc282ce2e47a4732da51288e5de0a64
HMAC[SHA-1] Happy Hashing! => a01c5a7e7a8a852ff806c6ede1398f9552a32e0f
HMAC[SHA-256] Happy Hashing! => bb1ad1e35898fb7ab888d65026fa29debc853ab754f3f82025cf9abe10d95b9f

Argon2id password: 7cfe6b4ffb846d67f1c5b5917d759ea75c1ac7b31a1e4200e9adf9f4b1c0523d
*/
