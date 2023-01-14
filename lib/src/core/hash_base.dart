// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

/// The base class used by the hash algorithm implementations
abstract class HashBase implements StreamTransformer<List<int>, HashDigest> {
  const HashBase();

  /// Create a [HashDigestSink] for generating message-digests
  HashDigestSink createSink();

  @override
  Stream<HashDigest> bind(Stream<List<int>> stream) {
    bool _paused = false;
    bool _cancelled = false;
    StreamSubscription<List<int>>? subscription;
    var controller = StreamController<HashDigest>(sync: false);
    controller.onCancel = () async {
      _cancelled = true;
      await subscription?.cancel();
    };
    controller.onPause = () {
      _paused = true;
      subscription?.pause();
    };
    controller.onResume = () {
      _paused = false;
      subscription?.resume();
    };
    controller.onListen = () {
      if (_cancelled) return;
      bool _hasError = false;
      var sink = createSink();
      subscription = stream.listen(
        (List<int> event) {
          try {
            sink.add(event);
          } catch (err, stack) {
            _hasError = true;
            subscription?.cancel();
            controller.addError(err, stack);
          }
        },
        cancelOnError: true,
        onError: (Object err, [StackTrace? stack]) {
          _hasError = true;
          controller.addError(err, stack);
        },
        onDone: () {
          try {
            if (!_hasError) {
              controller.add(sink.digest());
            }
          } catch (err, stack) {
            controller.addError(err, stack);
          } finally {
            controller.close();
          }
        },
      );
      if (_paused) {
        subscription?.pause();
      }
    };
    return controller.stream;
  }

  @override
  StreamTransformer<RS, RT> cast<RS, RT>() {
    throw UnimplementedError('This stream can not be cast');
  }

  /// Converts the byte array [input] and returns a [HashDigest].
  HashDigest convert(List<int> input) {
    var sink = createSink();
    sink.add(input);
    return sink.digest();
  }

  /// Converts the [input] string and returns a [HashDigest].
  ///
  /// If the [encoding] is not specified, `codeUnits` are used as input bytes.
  HashDigest string(String input, [Encoding? encoding]) {
    var sink = createSink();
    if (encoding != null) {
      var data = encoding.encode(input);
      sink.add(data);
    } else {
      sink.add(input.codeUnits);
    }
    return sink.digest();
  }

  /// Consume the entire [stream] of byte array and generate a HashDigest.
  Future<HashDigest> consume(Stream<List<int>> stream) {
    return bind(stream).first;
  }

  /// Consume the entire [stream] of string and generate a HashDigest.
  ///
  /// If the [encoding] is not specified, `codeUnits` are used as input bytes.
  Future<HashDigest> consumeAs(
    Stream<String> stream, [
    Encoding encoding = utf8,
  ]) {
    return bind(stream.transform(encoding.encoder)).first;
  }

  /// Converts the [input] file and returns a [HashDigest] asynchronously.
  ///
  /// If [start] is present, the file will be read from byte-offset [start].
  /// Otherwise from the beginning (index 0).
  ///
  /// If [end] is present, only bytes up to byte-index [end] will be read.
  /// Otherwise, until end of file.
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

abstract class HashDigestSink {
  const HashDigestSink();

  /// Returns true if the sink is closed, false otherwise
  bool get closed;

  /// The length of generated hash in bytes
  int get hashLength;

  /// Adds [data] to the message-digest.
  ///
  /// The [addSlice] function is preferred over [add]
  ///
  /// Throws [StateError], if it is called after closing the digest.
  void add(List<int> data, [int start = 0, int? end]);

  /// Finalizes the message-digest and returns a [HashDigest]
  HashDigest digest();
}
