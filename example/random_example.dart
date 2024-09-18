import 'package:hashlib/codecs.dart';
import 'package:hashlib/random.dart';

void main() {
  print('UUID Generation:');
  print('UUIDv1: ${uuid.v1()}');
  print('UUIDv3: ${uuid.v3()}');
  print('UUIDv4: ${uuid.v4()}');
  print('UUIDv5: ${uuid.v5()}');
  print('UUIDv6: ${uuid.v6()}');
  print('UUIDv7: ${uuid.v7()}');
  print('UUIDv8: ${uuid.v8()}');
  print('');

  print('Random Generation:');
  print(randomNumbers(4));
  print(toHex(randomBytes(16)));
  print(randomString(32, lower: true, whitelist: '_'.codeUnits));
  print('');
}
