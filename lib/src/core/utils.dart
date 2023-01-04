import 'dart:convert';
import 'dart:typed_data';

int _toHexCodeUnit(int digit) => digit + (digit < 10 ? 48 : 87);

// Get bytes from an string
List<int> toBytes(String value, [Encoding? encoding]) {
  if (encoding != null) {
    return encoding.encode(value);
  } else {
    return value.codeUnits;
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
