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

HMAC[MD5] Happy Hashing! => abc282ce2e47a4732da51288e5de0a64
HMAC[SHA-1] Happy Hashing! => a01c5a7e7a8a852ff806c6ede1398f9552a32e0f
HMAC[SHA-224] Happy Hashing! => e15db85ded736ef7a1fe6be40dcfaa907da609790c5304cfc1f95b70
HMAC[SHA-256] Happy Hashing! => bb1ad1e35898fb7ab888d65026fa29debc853ab754f3f82025cf9abe10d95b9f
HMAC[SHA-384] Happy Hashing! => 1f3e75eba24e6fcd9035ef1f175aa89bc0bc323f8bd986cc3b481f7d2589029e437827b0794776acf434a688154ae679
HMAC[SHA-512] Happy Hashing! => 4faf4d044df59db198a76946ca430c5bbd2a1a604dcf0bc7fabdab87098aec06519e9e566df89361b76db4e88e45d702276caf6e24fad21dca3bc532f74ec905
HMAC[SHA-512/224] Happy Hashing! => 4053d63babafab9f0201afed79346597d17af65fb887a9facc7cdd6e
HMAC[SHA-512/256] Happy Hashing! => 98d6cc407c12ed1081306fa03ac1031b4cd3f7e82dfab0387292c7d4e5635839
*/
