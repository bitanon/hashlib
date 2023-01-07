// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';

import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/core/hash_sink.dart';

/// The base class used by the hash algorithm implementations
abstract class HashBase extends HashConverterBase {
  const HashBase();

  @override
  HashSink create();
}

abstract class HashConverterBase
    extends StreamTransformerBase<List<int>, HashDigest> {
  const HashConverterBase();

  @override
  Stream<HashDigest> bind(Stream<List<int>> stream) {
    return stream.map(convert);
  }

  /// Create a [HashDigestSink] for generating message-digests
  HashDigestSink create();

  /// Converts the byte array [input] and returns a [HashDigest].
  HashDigest convert(final List<int> input) {
    var sink = create();
    sink.add(input);
    return sink.digest();
  }

  /// Converts [input] string and returns a [HashDigest].
  ///
  /// If the [encoding] is not specified, `codeUnits` are used as input bytes.
  HashDigest string(final String input, [Encoding? encoding]) {
    var sink = create();
    if (encoding != null) {
      sink.add(encoding.encode(input));
    } else {
      sink.add(input.codeUnits);
    }
    return sink.digest();
  }

  /// Consume the entire [stream] of byte array and generate a HashDigest.
  Future<HashDigest> stream(final Stream<List<int>> stream) async {
    var sink = create();
    await stream.forEach(sink.add);
    return sink.digest();
  }

  /// Consume the entire [stream] of string and generate a HashDigest.
  ///
  /// If the [encoding] is not specified, `codeUnits` are used as input bytes.
  Future<HashDigest> stringStream(
    final Stream<String> stream, [
    Encoding? encoding,
  ]) async {
    var sink = create();
    if (encoding != null) {
      await stream.transform(encoding.encoder).forEach(sink.add);
    } else {
      await stream.forEach((input) => sink.add(input.codeUnits));
    }
    return sink.digest();
  }
}
