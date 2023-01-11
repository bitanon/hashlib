import 'package:hashlib/hashlib.dart';
import 'package:test/test.dart';

void main() {
  group('Alder-32 test', () {
    test('with empty string', () {
      expect(alder32code(""), 1);
    });
    test('with a string', () {
      expect(alder32code("Wikipedia"), 300286872);
    });
  });
}
