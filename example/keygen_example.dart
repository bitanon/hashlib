import 'package:hashlib/hashlib.dart';

void main() {
  final key = "password";
  final salt = "some salt";
  print("key => $key");
  print("salt => $salt");
  print('');

  final pw = key.codeUnits;
  final iv = salt.codeUnits;

  // Examples of Argon2 key derivation
  final argon2Test = Argon2Security.test;
  print("[Argon2i] => ${argon2i(pw, iv, security: argon2Test)}");
  print("[Argon2d] => ${argon2d(pw, iv, security: argon2Test)}");
  print("[Argon2id] => ${argon2id(pw, iv, security: argon2Test)}");

  // Examples of scrypt key derivation
  final scryptLittle = ScryptSecurity.little;
  print("[scrypt] => ${scrypt(pw, iv, security: scryptLittle, dklen: 24)}");
  print('');

  // Examples of bcrypt key derivation
  final bcryptLittle = BcryptSecurity.little;
  print("[bcrypt] => ${bcrypt(pw, bcryptSalt(security: bcryptLittle))}");
  print('');

  // Examples of PBKDF2 key derivation
  print("SHA256/HMAC/PBKDF2 => ${pbkdf2(pw, iv).hex()}");
  print("BLAKE2b-256/HMAC/PBKDF2 => ${blake2b256.pbkdf2(iv).hex(pw)}");
  print("BLAKE2b-256/MAC/PBKDF2 => ${blake2b256.mac.pbkdf2(iv).hex(pw)}");
  print("SHA1/HMAC/PBKDF2 => ${sha1.pbkdf2(iv, iterations: 100).hex(pw)}");
  print('');
}
