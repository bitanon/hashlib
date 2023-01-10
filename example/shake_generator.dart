import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/utils.dart';

void main() {
  final seed = DateTime.now().microsecondsSinceEpoch.toRadixString(16);
  Stopwatch stopwatch = Stopwatch()..start();
  // ignore: deprecated_member_use_from_same_package
  final it = shake256generator(seed.codeUnits).iterator;
  it.moveNext();
  int i = 0;

  // take next 32 bytes at 0
  var first = "";
  for (; i < 32; ++i) {
    first += toHexSingle(it.current);
    it.moveNext();
  }
  print("      1: $first    [${stopwatch.elapsedMilliseconds} ms]");

  // skip to 1,000-th byte
  for (; i < 1000; ++i) {
    it.moveNext();
  }

  // take next 32 bytes at 1000
  var middle = "";
  for (; i < 1032; ++i) {
    middle += toHexSingle(it.current);
    it.moveNext();
  }
  print("  1,000: $middle    [${stopwatch.elapsedMilliseconds} ms]");

  // skip to 100,000-th byte
  for (; i < 100000; ++i) {
    it.moveNext();
  }

  // take next 32 bytes at 100,000
  var last = "";
  for (; i < 100032; ++i) {
    last += toHexSingle(it.current);
    it.moveNext();
  }
  print("100,000: $last    [${stopwatch.elapsedMilliseconds} ms]");
}
