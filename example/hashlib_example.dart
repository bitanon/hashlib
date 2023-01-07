import 'package:hashlib/hashlib.dart' as hashlib;

void main() {
  final text = "Happy Hashing!";
  print('[MD5] $text => ${hashlib.md5sum(text)}');
  print('[SHA-1] $text => ${hashlib.sha1sum(text)}');
  print('[SHA-224] $text => ${hashlib.sha224sum(text)}');
  print('[SHA-256] $text => ${hashlib.sha256sum(text)}');
  print('[SHA-384] $text => ${hashlib.sha384sum(text)}');
  print('[SHA-512] $text => ${hashlib.sha512sum(text)}');
  print('[SHA-512/224] $text => ${hashlib.sha512224sum(text)}');
  print('[SHA-512/256] $text => ${hashlib.sha512256sum(text)}');
}
