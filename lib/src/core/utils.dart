// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' as cvt;
import 'dart:typed_data';

const int _zero = 48;
const int _smallA = 97;
const int _bigA = 65;

// The RFC 4648 base64 encoding alphabet.
// "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
const _base64Alphabet = [
  65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, //
  84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106,
  107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121,
  122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 43, 47
];
const _base64Reverse = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 0, 63, 52,
  53, 54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5,
  6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
  0, 0, 0, 0, 0, 0, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
];

// The RFC 4648 base64url encoding alphabet.
// "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
const _base64UrlAlphabet = [
  65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, //
  84, 85, 86, 87, 88, 89, 90, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106,
  107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121,
  122, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 45, 95
];
const _base64UrlReverse = [
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, //
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 62, 0, 0, 52,
  53, 54, 55, 56, 57, 58, 59, 60, 61, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 3, 4, 5,
  6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
  0, 0, 0, 0, 63, 0, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
  41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51
];

// Get bytes from an string
List<int> toBytes(String value, [cvt.Encoding? encoding]) {
  if (encoding == null) {
    return value.codeUnits;
  } else {
    return encoding.encode(value);
  }
}

/// The message digest as a string of hexadecimal digits.
String toHexSingle(int byte, [bool uppercase = false]) {
  int a, b;
  a = (byte >>> 4) & 0xF;
  b = byte & 0xF;
  a += a < 10 ? _zero : ((uppercase ? _bigA : _smallA) - 10);
  b += b < 10 ? _zero : ((uppercase ? _bigA : _smallA) - 10);
  return String.fromCharCodes([a, b]);
}

/// The message digest as a string of hexadecimal digits.
String toHex(List<int> bytes, [bool uppercase = false]) {
  int a, b, i, j;
  i = j = 0;
  var hex = Uint8List(bytes.length << 1);
  while (i < bytes.length) {
    a = (bytes[i] >>> 4) & 0xF;
    b = bytes[i++] & 0xF;
    a += a < 10 ? _zero : ((uppercase ? _bigA : _smallA) - 10);
    b += b < 10 ? _zero : ((uppercase ? _bigA : _smallA) - 10);
    hex[j++] = a;
    hex[j++] = b;
  }
  return String.fromCharCodes(hex);
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
    a -= a < _bigA ? _zero : ((a < _smallA ? _bigA : _smallA) - 10);
    b -= b < _bigA ? _zero : ((b < _smallA ? _bigA : _smallA) - 10);
    norm[j++] = (a << 4) | b;
  }
  return norm;
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

String toBase64(Iterable<int> bytes, [bool urlSafe = false]) {
  int p = 0, n = 0;
  var result = <int>[];
  var alpha = urlSafe ? _base64UrlAlphabet : _base64Alphabet;
  for (int x in bytes) {
    p = (p << 8) | x;
    for (n += 8; n >= 6; n -= 6, p &= (1 << n) - 1) {
      result.add(alpha[p >> (n - 6)]);
    }
  }
  if (n > 0) {
    result.add(alpha[p << (6 - n)]);
  }
  return String.fromCharCodes(result);
}

Uint8List fromBase64(String data, [bool urlSafe = false]) {
  int p = 0, n = 0, i = 0;
  var map = urlSafe ? _base64UrlReverse : _base64Reverse;
  var result = Uint8List((data.length * 6) ~/ 8);
  for (int x in data.codeUnits) {
    p = (p << 6) | map[x];
    for (n += 6; n >= 8; n -= 8, p &= (1 << n) - 1) {
      result[i++] = p >> (n - 8);
    }
  }
  if (p > 0) {
    result[i++] = p;
  }
  return result;
}
