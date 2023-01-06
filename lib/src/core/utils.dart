// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' as cvt;
import 'dart:typed_data';

// Get bytes from an string
List<int> toBytes(String value, [cvt.Encoding? encoding]) {
  if (encoding == null) {
    return value.codeUnits;
  } else {
    return encoding.encode(value);
  }
}

int _hexCodeUnit(int digit, [bool uppercase = false]) =>
    digit + (digit < 10 ? 48 : (uppercase ? 55 : 87));

/// Converts a byte buffer to a hexadecimal string
String toHex(List<int> buffer, [bool uppercase = false]) {
  final hex = ByteData(buffer.length * 2);
  for (int i = 0, p = 0; i < buffer.length; ++i) {
    hex.setUint8(p++, _hexCodeUnit((buffer[i] >>> 4) & 0xF));
    hex.setUint8(p++, _hexCodeUnit(buffer[i] & 0xF));
  }
  return String.fromCharCodes(hex.buffer.asUint8List());
}

/// Converts a byte buffer to a hexadecimal buffer
String toAscii(List<int> buffer, {bool? allowInvalid}) {
  int n = buffer.length + (buffer.length >>> 3);
  if (n & 7 != 0) n++;
  final ascii = List<int>.filled(n, 0);
  for (int i = 0, p = 0; i < buffer.length; ++i) {
    ascii[p] &= buffer[i] & 0x7F;
    ascii[p] = buffer[i] >>> 7;
  }
  return cvt.ascii.decode(ascii, allowInvalid: allowInvalid);
}
