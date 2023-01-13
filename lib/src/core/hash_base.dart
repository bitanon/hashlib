// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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

  /// Converts the [input] string and returns a [HashDigest].
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

  /// Converts the [input] file and returns a [HashDigest].
  ///
  /// If [start] is present, the file will be read from byte-offset [start].
  /// Otherwise from the beginning (index 0).
  ///
  /// If [end] is present, only bytes up to byte-index [end] will be read.
  /// Otherwise, until end of file.
  HashDigest file(File input, [int? start, int? end]) {
    var sink = startChunkedConversion();
    var raf = input.openSync();
    var buffer = Uint8List(2048);
    int length = raf.lengthSync();
    for (int i = 0, l; i < length; i += l) {
      l = raf.readIntoSync(buffer);
      sink.addSlice(buffer, 0, l);
    }
    return sink.digest();
  }
}

abstract class HashDigestSink implements ByteConversionSink {
  /// The length of generated hash in bytes
  final int hashLength;

  const HashDigestSink({
    required this.hashLength,
  });

  /// Returns true if the sink is closed, false otherwise
  bool get closed;

  /// Adds [data] to the message-digest.
  ///
  /// The [addSlice] function is preferred over [add]
  ///
  /// Throws [StateError], if it is called after closing the digest.
  @override
  void add(List<int> data) => addSlice(data, 0, data.length);

  /// Adds [data] to the message-digest.
  ///
  /// Throws [StateError], if it is called after closing the digest.
  @override
  void addSlice(List<int> chunk, int start, int end, [bool isLast = false]);

  /// Finalizes the message-digest and returns a [HashDigest]
  HashDigest digest();

  @override
  void close() => digest();
}
