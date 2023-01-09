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
  i = j = 0;
  var hex = Uint8List(bytes.length << 1);
  while (i < bytes.length) {
    a = (bytes[i] >>> 4) & 0xF;
    b = bytes[i++] & 0xF;
    hex[j++] = a + (a < 10 ? 48 : (uppercase ? 55 : 87));
    hex[j++] = b + (b < 10 ? 48 : (uppercase ? 55 : 87));
  }
  return String.fromCharCodes(hex);
}

/// The message digest as a string of ASCII alphabets.
String toAscii(List<int> bytes) {
  int i, j, n, p;
  n = bytes.length + (bytes.length >>> 3);
  if (n & 7 != 0) n++;
  i = j = p = 0;
  var ascii = Uint8List(n);
  while (i < bytes.length) {
    p &= bytes[i] & 0x7F;
    ascii[j++] = p;
    p = (bytes[i++] >>> 7) & 1;
  }
  ascii[n - 1] = p;
  return String.fromCharCodes(ascii);
}

/// The message digest as a string of hexadecimal digits.
List<int> fromHex(String hex) {
  assert((hex.length & 1) == 0);
  int a, b, i, j;
  i = j = 0;
  var norm = Uint8List(hex.length >>> 1);
  while (i < hex.length) {
    a = hex.codeUnits[i++];
    b = hex.codeUnits[i++];
    a -= (a < 55 ? 48 : (a < 87 ? 55 : 87));
    b -= (b < 55 ? 48 : (b < 87 ? 55 : 87));
    norm[j++] = (a << 4) | b;
  }
  return norm;
}
