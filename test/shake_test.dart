import 'package:hashlib/src/algorithms/shake.dart';
import 'package:test/test.dart';

void main() {
  group('SHAKE test', () {
    test('SHAKE128 with empty message', () {
      final hash = Shake128Hash(512);
      expect(hash.digest().hex().substring((512 - 32) * 2),
          "43e41b45a653f2a5c4492c1add544512dda2529833462b71a41a45be97290b6f");
    });

    test('SHAKE128 with 1600-bit message', () {
      final hash = Shake128Hash(512);
      final buf = List.filled(20, 0xA3);
      for (int i = 0; i < 200; i += 20) {
        hash.addSlice(buf, 0, buf.length);
      }
      expect(hash.digest().hex().substring((512 - 32) * 2),
          "44c9fb359fd56ac0a9a75a743cff6862f17d7259ab075216c0699511643b6439");
    });

    test('SHAKE256 with empty message', () {
      final hash = Shake256Hash(512);
      expect(hash.digest().hex().substring((512 - 32) * 2),
          "ab0bae316339894304e35877b0c28a9b1fd166c796b9cc258a064a8f57e27f2a");
    });

    test('SHAKE256 with 1600-bit message', () {
      final hash = Shake256Hash(512);
      final buf = List.filled(20, 0xA3);
      for (int i = 0; i < 200; i += 20) {
        hash.addSlice(buf, 0, buf.length);
      }
      expect(hash.digest().hex().substring((512 - 32) * 2),
          "6a1a9d7846436e4dca5728b6f760eef0ca92bf0be5615e96959d767197a0beeb");
    });
  });
}