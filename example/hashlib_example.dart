import 'dart:convert';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';

void main() {
  var text = "Happy Hashing!";
  var key = "password";
  var pw = key.codeUnits;
  var salt = "some salt".codeUnits;
  print("text => $text");
  print("key => $key");
  print("salt => ${toHex(salt)}");
  print('');

  // Examples of Hash generation
  print('[MD5] => ${md5.string(text)}');
  print('[SHA-1] => ${sha1.string(text)}');
  print('[SHA-224] => ${sha224.string(text)}');
  print('[SHA-256] => ${sha256.string(text)}');
  print('[SHA-384] => ${sha384.string(text)}');
  print('[SHA-512] => ${sha512.string(text)}');
  print('[SHA-512/224] => ${sha512t224.string(text)}');
  print('[SHA-512/256] => ${sha512t256.string(text)}');
  print('[SHA3-224] => ${sha3_224.string(text)}');
  print('[SHA3-256] => ${sha3_256.string(text)}');
  print('[SHA3-384] => ${sha3_384.string(text)}');
  print('[SHA3-512] => ${sha3_512.string(text)}');
  print('[Keccak-224] => ${keccak224.string(text)}');
  print('[Keccak-256] => ${keccak256.string(text)}');
  print('[Keccak-384] => ${keccak384.string(text)}');
  print('[Keccak-512] => ${keccak512.string(text)}');
  print('[SHAKE-128] => ${shake128.of(20).string(text)}');
  print('[SHAKE-256] => ${shake256.of(20).string(text)}');
  print('[BLAKE-2s/256] => ${blake2s256.string(text)}');
  print('[BLAKE-2b/512] => ${blake2b512.string(text)}');
  print('');

  // Examples of MAC generations
  print('HMAC[MD5] => ${md5.hmac(pw).string(text)}');
  print('HMAC[MD5] => ${md5.hmacBy(key, utf8).string(text)}');
  print('HMAC[MD5] => ${md5.hmacBy(key).string(text)}');
  print('HMAC[MD5] => ${HMAC(md5, pw).string(text)}');
  print("[BLAKE-2b/256] => ${blake2b256.mac(pw).string(text)}");
  print("[BLAKE-2b/256] => ${Blake2bMAC(32, pw).string(text)}");
  print('');

  // Examples of PBKDF2 key derivation
  print("PBKDF2[HMAC[SHA-256]] => ${sha256.pbkdf2(pw, salt, 100)}");
  print("PBKDF2[HMAC[SHA-256]] => ${sha256.hmac(pw).pbkdf2(salt, 100)}");
  print("PBKDF2[BLAKE-2b-MAC] => ${blake2b256.mac(pw).pbkdf2(salt, 100)}");
  print("PBKDF2[HMAC[BLAKE-2b]] => ${blake2b256.pbkdf2(pw, salt, 100)}");
  print("PBKDF2[HMAC[BLAKE-2b]] => ${blake2b256.hmac(pw).pbkdf2(salt, 100)}");
  print('');

  // Examples of Argon2 key derivation
  var security = Argon2Security.test;
  print("[Argon2i] => ${argon2i(pw, salt, security: security)}");
  print("[Argon2d] => ${argon2d(pw, salt, security: security)}");
  print("[Argon2id] => ${argon2id(pw, salt, security: security)}");
  print('');

  // Example of checksum code generators
  print('[CRC16] => ${crc16code(text)}');
  print('[CRC32] => ${crc32code(text)}');
  print('[CRC64] => ${crc64code(text)}');
  print('[Alder32] => ${alder32code(text)}');
}
