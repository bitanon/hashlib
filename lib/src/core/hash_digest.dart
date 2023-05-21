// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:hashlib_codecs/hashlib_codecs.dart';

class HashDigest extends Object {
  final Uint8List bytes;

  const HashDigest(this.bytes);

  /// Returns the byte buffer associated with this digest.
  ByteBuffer get buffer => bytes.buffer;

  /// The message digest as a string of hexadecimal digits.
  @override
  String toString() => hex();

  /// The message digest as a binary string with zero padding.
  String binary() => toBinary(bytes);

  /// The message digest as a hexadecimal string with zero padding.
  ///
  /// Parameters:
  /// - If [upper] is true, the string will be in uppercase alphabets.
  String hex([bool upper = false]) => toHex(bytes, upper: upper);

  /// The message digest as a Base-32 string with no padding.
  ///
  /// If [upper] is true, the output will have uppercase alphabets.
  /// If [padding] is true, the output will have `=` padding at the end.
  String base32({bool upper = true, bool padding = false}) =>
      toBase32(bytes, lower: !upper, padding: padding);

  /// The message digest as a Base-64 string with no padding.
  ///
  /// If [urlSafe] is true, the output will have URL-safe base64 alphabets.
  /// If [padding] is true, the output will have `=` padding at the end.
  String base64({bool urlSafe = false, bool padding = false}) =>
      toBase64(bytes, padding: padding, url: urlSafe);

  /// The message digest as a string of ASCII alphabets.
  String ascii() => cvt.ascii.decode(bytes);

  /// The message digest as a string of UTF-8 alphabets.
  String utf8() => cvt.utf8.decode(bytes);

  /// Returns the digest in the given [encoding]
  String to(cvt.Encoding encoding) => encoding.decode(bytes);

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

  @override
  int get hashCode => bytes.hashCode;

  @override
  bool operator ==(other) => isEqual(other);

  /// Checks if the message digest equals to [other].
  ///
  /// Here, the [other] can be a one of the following:
  /// - Another [HashDigest] object.
  /// - An [Iterable] containing an array of bytes
  /// - Any [ByteBuffer] or [TypedData] that will be converted to [Uint8List]
  /// - A [String], which will be treated as a hexadecimal encoded byte array
  ///
  /// This function will return True if all bytes in the [other] matches with
  /// the [bytes] of this object. If the length does not match, or the type of
  /// [other] is not supported, it returns False immediately.
  bool isEqual(other) {
    if (other is HashDigest) {
      return isEqual(other.bytes);
    } else if (other is ByteBuffer) {
      return isEqual(buffer.asUint8List());
    } else if (other is TypedData && other is! Uint8List) {
      return isEqual(other.buffer.asUint8List());
    } else if (other is String) {
      return isEqual(base16.decodeFromString(other));
    } else if (other is Iterable<int>) {
      if (other is List<int>) {
        if (other.length != bytes.length) {
          return false;
        }
      }
      int i = 0;
      for (int x in other) {
        if (i >= bytes.length || x != bytes[i++]) {
          return false;
        }
      }
      return true;
    }
    return false;
  }
}
