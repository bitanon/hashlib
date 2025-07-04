// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:hashlib/codecs.dart';

/// This holds generated hash digest and provides utilities to extract it in
/// multiple formats.
class HashDigest extends Object {
  final Uint8List bytes;

  const HashDigest(this.bytes);

  /// Returns the length of this digest in bytes.
  int get length => bytes.length;

  /// Returns the byte buffer associated with this digest.
  ByteBuffer get buffer => bytes.buffer;

  /// The message digest as a string of hexadecimal digits.
  @override
  String toString() => hex();

  /// The message digest as a binary string.
  String binary() => toBinary(bytes);

  /// The message digest as a octal string.
  String octal() => toOctal(bytes);

  /// The message digest as a hexadecimal string.
  ///
  /// Parameters:
  /// - If [upper] is true, the string will be in uppercase alphabets.
  String hex([bool upper = false]) => toHex(bytes, upper: upper);

  /// The message digest as a Base-32 string.
  ///
  /// If [upper] is true, the output will have uppercase alphabets.
  /// If [padding] is true, the output will have `=` padding at the end.
  String base32({bool upper = true, bool padding = true}) =>
      toBase32(bytes, lower: !upper, padding: padding);

  /// The message digest as a Base-64 string with no padding.
  ///
  /// If [urlSafe] is true, the output will have URL-safe base64 alphabets.
  /// If [padding] is true, the output will have `=` padding at the end.
  String base64({bool urlSafe = false, bool padding = true}) =>
      toBase64(bytes, padding: padding, url: urlSafe);

  /// The message digest as a BigInt.
  ///
  /// If [endian] is [Endian.little], it will treat the digest bytes as a little
  /// endian number; Otherwise, if [endian] is [Endian.big], it will treat the
  /// digest bytes as a big endian number.
  BigInt bigInt({Endian endian = Endian.little}) =>
      toBigInt(bytes, msbFirst: endian == Endian.big);

  /// Gets unsiged integer of [bitLength]-bit from the message digest.
  ///
  /// If [endian] is [Endian.little], it will treat the digest bytes as a little
  /// endian number; Otherwise, if [endian] is [Endian.big], it will treat the
  /// digest bytes as a big endian number.
  int number([int bitLength = 64, Endian endian = Endian.big]) {
    if (bitLength < 8 || bitLength > 64 || (bitLength & 7) > 0) {
      throw ArgumentError(
        'Invalid bit length. '
        'It must be a number between 8 to 64 and a multiple of 8.',
      );
    } else {
      bitLength >>>= 3;
    }
    int result = 0;
    int n = bytes.length;
    if (endian == Endian.little) {
      for (int i = (n > bitLength ? bitLength : n) - 1; i >= 0; i--) {
        result <<= 8;
        result |= bytes[i];
      }
    } else {
      for (int i = n > bitLength ? n - bitLength : 0; i < n; i++) {
        result <<= 8;
        result |= bytes[i];
      }
    }
    return result;
  }

  /// The message digest as a string of ASCII alphabets.
  String ascii() => cvt.ascii.decode(bytes);

  /// The message digest as a string of UTF-8 alphabets.
  String utf8() => cvt.utf8.decode(bytes);

  /// Returns the digest in the given [encoding]
  String to(cvt.Encoding encoding) => encoding.decode(bytes);

  @override
  int get hashCode => bytes.hashCode;

  @override
  bool operator ==(Object other) => other is HashDigest && bytes == other.bytes;

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
  bool isEqual(dynamic other) {
    if (other is HashDigest) {
      return isEqual(other.bytes);
    } else if (other is ByteBuffer) {
      return isEqual(Uint8List.view(buffer));
    } else if (other is TypedData && other is! Uint8List) {
      return isEqual(Uint8List.view(other.buffer));
    } else if (other is String) {
      return isEqual(fromHex(other));
    } else if (other is List<int>) {
      if (other.length != bytes.length) {
        return false;
      }
      for (int i = 0; i < bytes.length; ++i) {
        if (other[i] != bytes[i++]) {
          return false;
        }
      }
      return true;
    } else if (other is Iterable<int>) {
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
