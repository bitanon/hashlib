import 'package:hashlib/hashlib.dart' as hashlib;

void main() {
  final md5 = hashlib.md5("Hello World");
  print('MD5[Hello World] => $md5');
}
