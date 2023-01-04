import 'dart:convert';
import 'dart:typed_data';

int _toHexCodeUnit(int digit) => digit + (digit < 10 ? 48 : 87);

// Get bytes from an string
List<int> toBytes(String value, [Encoding? encoding]) {
  if (encoding == null) {
    return value.codeUnits;
  } else {
    return encoding.encode(value);
  }
}

/// Converts a byte buffer to a hexadecimal buffer
Uint8List toHex(List<int> buffer) {
  final hex = Uint8List(buffer.length * 2);
  for (int i = 0; i < buffer.length; ++i) {
    hex[i << 1] = _toHexCodeUnit((buffer[i] >> 4) & 0xF);
    hex[(i << 1) + 1] = _toHexCodeUnit(buffer[i] & 0xF);
  }
  return hex;
}

/// Converts a byte buffer to a hexadecimal string
String toHexString(List<int> buffer) {
  return String.fromCharCodes(toHex(buffer));
}

/// Converts 8-bit [source] array to 32-bit [target] array
void convert8to32(
  final Uint8List source,
  final Uint32List target, [
  int sourceOffset = 0,
  int targetOffset = 0,
]) {
  for (int i = targetOffset, j = sourceOffset; j < source.length; i++, j += 4) {
    target[i] = (source[j]) |
        (source[j + 1] << 8) |
        (source[j + 2] << 16) |
        (source[j + 3] << 24);
  }
}

/// Converts 32-bit [source] array to 8-bit [target] array
void convert32to8(
  final Uint32List source,
  final Uint8List target, [
  int sourceOffset = 0,
  int targetOffset = 0,
]) {
  for (int i = sourceOffset, j = targetOffset; i < source.length; i++, j += 4) {
    target[j] = (source[i] & 0xff);
    target[j + 1] = (source[i] >> 8) & 0xff;
    target[j + 2] = (source[i] >> 16) & 0xff;
    target[j + 3] = (source[i] >> 24) & 0xff;
  }
}
