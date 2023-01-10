// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// The base class used by the hash algorithm implementations
abstract class HashBase extends Converter<List<int>, HashDigest> {
  const HashBase();

  /// Create a [HashDigestSink] for generating message-digests
  @override
  HashDigestSink startChunkedConversion([Sink<HashDigest>? sink]);

  /// Converts the byte array [input] and returns a [HashDigest].
  @override
  HashDigest convert(List<int> input) {
    var sink = startChunkedConversion();
    sink.addSlice(input, 0, input.length, true);
    return sink.digest();
  }

  /// Converts [input] string and returns a [HashDigest].
  ///
  /// If the [encoding] is not specified, `codeUnits` are used as input bytes.
  HashDigest string(String input, [Encoding? encoding]) {
    var sink = startChunkedConversion();
    if (encoding != null) {
      var data = encoding.encode(input);
      sink.addSlice(data, 0, data.length, true);
    } else {
      sink.addSlice(input.codeUnits, 0, input.length, true);
    }
    return sink.digest();
  }

  /// Consume the entire [stream] of byte array and generate a HashDigest.
  Future<HashDigest> consume(Stream<List<int>> stream) async {
    var sink = startChunkedConversion();
    await stream.forEach((chunk) => sink.addSlice(chunk, 0, chunk.length));
    return sink.digest();
  }

  /// Consume the entire [stream] of string and generate a HashDigest.
  ///
  /// If the [encoding] is not specified, `codeUnits` are used as input bytes.
  Future<HashDigest> consumeAs(Stream<String> stream,
      [Encoding? encoding]) async {
    var sink = startChunkedConversion();
    if (encoding != null) {
      await stream
          .transform(encoding.encoder)
          .forEach((chunk) => sink.addSlice(chunk, 0, chunk.length));
    } else {
      await stream
          .forEach((input) => sink.addSlice(input.codeUnits, 0, input.length));
    }
    return sink.digest();
  }
}
