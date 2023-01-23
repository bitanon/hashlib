// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/utils.dart' as utils;

class HashDigest {
  final Uint8List bytes;

  const HashDigest(this.bytes);

  /// The message digest as a string of hexadecimal digits.
  @override
  String toString() => utils.toHex(bytes);

  /// Returns the byte buffer associated with this digest.
  ByteBuffer get buffer => bytes.buffer;

  /// The message digest as a string of hexadecimal digits.
  ///
  /// If [uppercase] is true, the output will have uppercase alphabets.
  String hex([bool uppercase = false]) => utils.toHex(bytes, uppercase);

  /// The message digest as a string of base64.
  ///
  /// If [urlSafe] is true, the output will have URL-safe base64 alphabets.
  String base64([bool urlSafe = false]) => utils.toBase64(bytes, urlSafe);

  /// The message digest as a string of ASCII alphabets.
  String toAscii() => utils.toAscii(bytes);

  /// Returns the least significant bytes as a number.
  ///
  /// If [endian] is big, it will return the last few bytes as a number;
  /// Otherwise, if [endian] is little, it will return the first few bytes
  /// as a number.
  int remainder([Endian endian = Endian.big]) {
    int result = 0;
    if (endian == Endian.big) {
      for (int i = bytes.length - 1, p = 0; i >= 0; --i, p += 8) {
        result |= bytes[i] << p;
      }
    } else {
      for (int i = 0, p = 0; i < 8 && i < bytes.length; ++i, p += 8) {
        result |= bytes[i] << p;
      }
    }
    return result;
  }
}
