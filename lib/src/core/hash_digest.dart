// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' as cvt;
import 'dart:typed_data';

import 'package:hashlib/src/core/hash_algo.dart';
import 'package:hashlib/src/core/utils.dart';

class HashDigest<T extends HashAlgo> {
  final T algorithm;
  final Uint8List bytes;

  HashDigest({
    required this.algorithm,
    required Iterable<int> bytes,
  }) : bytes = Uint8List.fromList(bytes.toList());

  String hex([bool uppercase = false]) {
    return toHex(bytes, uppercase);
  }

  String base64() {
    return cvt.base64.encode(bytes);
  }

  String base64Url() {
    return cvt.base64Url.encode(bytes);
  }

  String latin1({bool? allowInvalid}) {
    return cvt.latin1.decode(bytes, allowInvalid: allowInvalid);
  }

  String ascii({bool? allowInvalid}) {
    return toAscii(bytes, allowInvalid: allowInvalid);
  }
}
