// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:hashlib/hashlib.dart';
import 'package:hashlib/src/core/hash_digest.dart';

export 'hash_base_stub.dart' if (dart.library.io) 'hash_base_io.dart';

/// This sink allows adding arbitrary length byte arrays
/// and produces a [HashDigest] on [close].
abstract class HashDigestSink implements Sink<List<int>> {
  const HashDigestSink();

  /// Returns true if the sink is closed, false otherwise
  bool get closed;

  /// The length of generated hash in bytes
  int get hashLength;

  /// Adds [data] to the message-digest.
  ///
  /// Throws [StateError], if it is called after closing the digest.
  @override
  void add(List<int> data, [int start = 0, int? end]);

  /// Finalizes the message-digest. It calls [digest] method internally.
  @override
  @pragma('vm:prefer-inline')
  void close() => digest();

  /// Finalizes the message-digest and returns a [HashDigest]
  HashDigest digest();

  /// Resets the current state to start from fresh state
  void reset();
}

/// The base class used by the hash algorithm implementations. It implements
/// the [StreamTransformer] and exposes few convenient methods to handle any
/// types of data source.
abstract class HashBase implements StreamTransformer<List<int>, HashDigest> {
  const HashBase();

  /// The name of this algorithm
  String get name;

  /// Create a [HashDigestSink] for generating message-digests
  @pragma('vm:prefer-inline')
  HashDigestSink createSink();

  /// Process the byte array [input] and returns a [HashDigest].
  @pragma('vm:prefer-inline')
  HashDigest convert(List<int> input) {
    var sink = createSink();
    sink.add(input);
    return sink.digest();
  }

  /// Process the [input] string and returns a [HashDigest].
  ///
  /// If the [encoding] is not specified, `codeUnits` are used as input bytes.
  HashDigest string(String input, [Encoding? encoding]) {
    var sink = createSink();
    if (encoding != null) {
      sink.add(encoding.encode(input));
    } else {
      sink.add(input.codeUnits);
    }
    return sink.digest();
  }

  /// Consumes the entire [stream] of byte array and generates a [HashDigest].
  Future<HashDigest> byteStream(
    Stream<int> stream, [
    int bufferSize = 1024,
  ]) async {
    var sink = createSink();
    var buffer = Uint8List(bufferSize);
    int p = 0;
    await for (var x in stream) {
      buffer[p++] = x;
      if (p == bufferSize) {
        sink.add(buffer);
        p = 0;
      }
    }
    if (p > 0) {
      sink.add(buffer, 0, p);
    }
    return sink.digest();
  }

  /// Transforms the byte array input stream to generate a new stream
  /// which contains a single [HashDigest]
  ///
  /// The expected behavior of this method is described below:
  ///
  /// - When the returned stream has a subscriber (calling [Stream.listen]),
  ///   the message-digest generation begins from the input [stream].
  /// - If the returned stream is paused, the processing of the input [stream]
  ///   is also paused, and on resume, it continue processing from where it was
  ///   left off.
  /// - If the returned stream is cancelled, the subscription to the input
  ///   [stream] is also cancelled.
  /// - When the input [stream] is closed, the returned stream also gets closed
  ///   with a [HashDigest] data. The returned stream may produce only one
  ///   such data event in its life-time.
  /// - On error reading the input [stream], or while processing the message
  ///   digest, the subscription to input [stream] cancels immediately and the
  ///   returned stream closes with an error event.
  @override
  Stream<HashDigest> bind(Stream<List<int>> stream) async* {
    var sink = createSink();
    await for (var x in stream) {
      sink.add(x);
    }
    yield sink.digest();
  }

  /// Consumes the entire [stream] of string and generates a [HashDigest].
  ///
  /// Default [encoding] scheme to get the input bytes is [latin1].
  Future<HashDigest> stringStraem(
    Stream<String> stream, [
    Encoding? encoding,
  ]) {
    if (encoding == null) {
      return bind(stream.map((s) => s.codeUnits)).first;
    } else {
      return bind(stream.transform(encoding.encoder)).first;
    }
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() =>
      StreamTransformer.castFrom<List<int>, HashDigest, RS, RT>(this);
}
