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

/// The message digest as a string of hexadecimal digits.
String toHex(List<int> bytes, [bool uppercase = false]) {
  int a, b, i, j;
  final hex = ByteData(bytes.length << 1);
  i = j = 0;
  while (i < bytes.length) {
    a = (bytes[i] >>> 4) & 0xF;
    b = bytes[i++] & 0xF;
    hex.setUint8(j++, a + (a < 10 ? 48 : (uppercase ? 55 : 87)));
    hex.setUint8(j++, b + (b < 10 ? 48 : (uppercase ? 55 : 87)));
  }
  return String.fromCharCodes(hex.buffer.asUint8List());
}

/// The message digest as a string of ASCII alphabets.
String toAscii(List<int> bytes) {
  int i, j, n, p;
  n = bytes.length + (bytes.length >>> 3);
  if (n & 7 != 0) n++;
  final ascii = ByteData(n);
  i = j = p = 0;
  while (i < bytes.length) {
    p &= bytes[i] & 0x7F;
    ascii.setUint8(j++, p);
    p = (bytes[i++] >>> 7) & 1;
  }
  ascii.setUint8(n - 1, p);
  return String.fromCharCodes(ascii.buffer.asUint8List());
}
