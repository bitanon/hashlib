// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'hash_base.dart';
import 'hash_digest.dart';

extension HashBaseFileSupport on HashBase {
  /// Converts the [input] file and returns a [HashDigest] asynchronously.
  ///
  /// If [start] is present, the file will be read from byte-offset [start].
  /// Otherwise from the beginning (index 0).
  ///
  /// If [end] is present, only bytes up to byte-index [end] will be read.
  /// Otherwise, until end of file.
  @pragma('vm:prefer-inline')
  Future<HashDigest> file(File input, [int start = 0, int? end]) {
    return bind(input.openRead(start, end)).first;
  }

  /// Converts the [input] file and returns a [HashDigest] synchronously.
  ///
  /// If [start] is present, the file will be read from byte-offset [start].
  /// Otherwise from the beginning (index 0).
  ///
  /// If [end] is present, only bytes up to byte-index [end] will be read.
  /// Otherwise, until end of file.
  ///
  /// If [bufferSize] is present, the file will be read in chunks of this size.
  /// By default the [bufferSize] is `2048`.
  HashDigest fileSync(
    File input, {
    int start = 0,
    int? end,
    int bufferSize = 2048,
  }) {
    var raf = input.openSync();
    try {
      var sink = createSink();
      var buffer = Uint8List(bufferSize);
      int length = end ?? raf.lengthSync();
      for (int i = start, l; i < length; i += l) {
        l = raf.readIntoSync(buffer);
        sink.add(buffer, 0, l);
      }
      return sink.digest();
    } finally {
      raf.closeSync();
    }
  }
}
