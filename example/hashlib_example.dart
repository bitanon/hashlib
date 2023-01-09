import 'package:hashlib/hashlib.dart';

void main() {
  // Examples of Hash generation
  final text = "Happy Hashing!";
  print('[MD5] $text => ${md5sum(text)}');
  print('[SHA-1] $text => ${sha1sum(text)}');
  print('[SHA-224] $text => ${sha224sum(text)}');
  print('[SHA-256] $text => ${sha256sum(text)}');
  print('[SHA-384] $text => ${sha384sum(text)}');
  print('[SHA-512] $text => ${sha512sum(text)}');
  print('[SHA-512/224] $text => ${sha512sum224(text)}');
  print('[SHA-512/256] $text => ${sha512sum256(text)}');
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
  print('');

  // Example of HMAC generation
  final key = "secret";
  print('HMAC[MD5] $text => ${md5.hmacBy(key).string(text)}');
  print('HMAC[SHA-1] $text => ${sha1.hmacBy(key).string(text)}');
  print('HMAC[SHA-224] $text => ${sha224.hmacBy(key).string(text)}');
  print('HMAC[SHA-256] $text => ${sha256.hmacBy(key).string(text)}');
  print('HMAC[SHA-384] $text => ${sha384.hmacBy(key).string(text)}');
  print('HMAC[SHA-512] $text => ${sha512.hmacBy(key).string(text)}');
  print('HMAC[SHA-512/224] $text => ${sha512t224.hmacBy(key).string(text)}');
  print('HMAC[SHA-512/256] $text => ${sha512t256.hmacBy(key).string(text)}');
  print('HMAC[SHA3-224] $text => ${sha3_224.hmacBy(key).string(text)}');
  print('HMAC[SHA3-256] $text => ${sha3_256.hmacBy(key).string(text)}');
  print('HMAC[SHA3-384] $text => ${sha3_384.hmacBy(key).string(text)}');
  print('HMAC[SHA3-512] $text => ${sha3_512.hmacBy(key).string(text)}');
  print('HMAC[Keccak-224] $text => ${keccak224.hmacBy(key).string(text)}');
  print('HMAC[Keccak-256] $text => ${keccak256.hmacBy(key).string(text)}');
  print('HMAC[Keccak-384] $text => ${keccak384.hmacBy(key).string(text)}');
  print('HMAC[Keccak-512] $text => ${keccak512.hmacBy(key).string(text)}');
  print('HMAC[SHAKE-128] $text => ${Shake128(20).hmacBy(key).string(text)}');
  print('HMAC[SHAKE-256] $text => ${Shake256(20).hmacBy(key).string(text)}');
  print('');
}

/*
Expected output:
-------------------------------------------------------------------------
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

HMAC[MD5] Happy Hashing! => abc282ce2e47a4732da51288e5de0a64
HMAC[SHA-1] Happy Hashing! => a01c5a7e7a8a852ff806c6ede1398f9552a32e0f
HMAC[SHA-224] Happy Hashing! => e15db85ded736ef7a1fe6be40dcfaa907da609790c5304cfc1f95b70
HMAC[SHA-256] Happy Hashing! => bb1ad1e35898fb7ab888d65026fa29debc853ab754f3f82025cf9abe10d95b9f
HMAC[SHA-384] Happy Hashing! => 1f3e75eba24e6fcd9035ef1f175aa89bc0bc323f8bd986cc3b481f7d2589029e437827b0794776acf434a688154ae679
HMAC[SHA-512] Happy Hashing! => 4faf4d044df59db198a76946ca430c5bbd2a1a604dcf0bc7fabdab87098aec06519e9e566df89361b76db4e88e45d702276caf6e24fad21dca3bc532f74ec905
HMAC[SHA-512/224] Happy Hashing! => 4053d63babafab9f0201afed79346597d17af65fb887a9facc7cdd6e
HMAC[SHA-512/256] Happy Hashing! => 98d6cc407c12ed1081306fa03ac1031b4cd3f7e82dfab0387292c7d4e5635839
HMAC[SHA3-224] Happy Hashing! => 184619bfef37a44c21e7e4fbdee7a6661aaabe1c4ac575eb0577ad92
HMAC[SHA3-256] Happy Hashing! => d7b1d8bd3de74af58cc696b833df060359f812e9513d70490bbf5334fa3e2e23
HMAC[SHA3-384] Happy Hashing! => 3e4995efb84c49a6f9bb7cd4f0f1471ce86c1d157f136c2a2db87b93e7f4dcf8bd7f0c01db8ce2279b7710af2e236a9f
HMAC[SHA3-512] Happy Hashing! => d3d4dc913605db749d9f39a01dc319c6ac23d0fa9428070ef47ab56db2cd2f782468f6c5a1f39d3b2cf65ba0189429d759ac31bad4938a085f9ffa6f8a787e33
HMAC[Keccak-224] Happy Hashing! => 62747c9a880c40d83ccaa46cf12f603ec4e8ca4f08c589ee5899c33d
HMAC[Keccak-256] Happy Hashing! => b529f039dbd42881155cc104b05b566c78e5590e4d7c964d3d0f9e332abcd6fd
HMAC[Keccak-384] Happy Hashing! => 03a02180e8d3c8de05b701c0fe1cae5507f4971da72b05e839000135c1ae7fadc8d74f72a1f7a7d7b8b47e306f34e190
HMAC[Keccak-512] Happy Hashing! => c4f9ba1020b430a82261f341126ce183d6eef44420d44df786f4941bc7cf0d41fdb9c631ba680ed1347a6a64ad6b80a89e1a96d5b64329ce53a09361c9ebd74f
HMAC[SHAKE-128] Happy Hashing! => df786117e71d27a855c104ed201afabdcf0bb9de
HMAC[SHAKE-256] Happy Hashing! => 384ef058b61490aaa6fb7c458353179b8401bda1
*/
