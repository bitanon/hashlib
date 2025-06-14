// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';

import 'hash_base.dart';
import 'hash_digest.dart';

/// Stub for machines that does not have file IO support.
extension HashBaseFileSupport on HashBase {
  /// Converts the [input] file and returns a [HashDigest] asynchronously.
  ///
  /// If [start] is present, the file will be read from byte-offset [start].
  /// Otherwise from the beginning (index 0).
  ///
  /// If [end] is present, only bytes up to byte-index [end] will be read.
  /// Otherwise, until end of file.
  @pragma('vm:prefer-inline')
  Future<HashDigest> file(dynamic input, [int start = 0, int? end]) {
    throw UnsupportedError('Unavailable for this platform');
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
    dynamic input, {
    int start = 0,
    int? end,
    int bufferSize = 2048,
  }) {
    throw UnsupportedError('Unavailable for this platform');
  }
}
