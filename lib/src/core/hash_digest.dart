// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:hashlib/src/core/utils.dart' as utils;

class HashDigest {
  final Uint8List bytes;

  HashDigest(this.bytes);

  /// The message digest as a string of base64.
  String base64() {
    return cvt.base64.encoder.convert(bytes);
  }

  /// The message digest as a string of URL-safe base64.
  String base64Url() {
    return cvt.base64Url.encode(bytes);
  }

  /// The message digest as a string of extended Latin alphabets.
  String latin1({bool? allowInvalid}) {
    return cvt.latin1.decode(bytes, allowInvalid: allowInvalid);
  }

  /// The message digest as a string of hexadecimal digits.
  String hex([bool uppercase = false]) {
    return utils.toHex(bytes, uppercase);
  }

  /// The message digest as a string of ASCII alphabets.
  String toAscii() {
    return utils.toAscii(bytes);
  }

  /// The message digest as a string of hexadecimal digits.
  @override
  String toString() => utils.toHex(bytes);
}
