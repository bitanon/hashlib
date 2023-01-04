// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';
import 'dart:typed_data';

// Get bytes from an string
List<int> toBytes(String value, [Encoding? encoding]) {
  if (encoding == null) {
    return value.codeUnits;
  } else {
    return encoding.encode(value);
  }
}

int _toHexCodeUnit(int digit, [bool uppercase = false]) =>
    digit + (digit < 10 ? 48 : (uppercase ? 55 : 87));

/// Converts a byte buffer to a hexadecimal buffer
Uint8List toHex(List<int> buffer, [bool uppercase = false]) {
  final hex = Uint8List(buffer.length * 2);
  for (int i = 0; i < buffer.length; ++i) {
    hex[i << 1] = _toHexCodeUnit((buffer[i] >>> 4) & 0xF);
    hex[(i << 1) + 1] = _toHexCodeUnit(buffer[i] & 0xF);
  }
  return hex;
}

/// Converts a byte buffer to a hexadecimal string
String toHexString(List<int> buffer, [bool uppercase = false]) {
  return String.fromCharCodes(toHex(buffer));
}
