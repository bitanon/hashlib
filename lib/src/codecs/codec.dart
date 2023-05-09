// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert' show Codec;
import 'dart:typed_data';

import 'package:hashlib/src/codecs/converter.dart';

abstract class Uint8Codec extends Codec<Iterable<int>, Iterable<int>> {
  const Uint8Codec();

  @override
  Uint8Encoder get encoder;

  @override
  Uint8Decoder get decoder;

  /// Encode an input string using this codec and returns a string
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String encodeString(String input) {
    return String.fromCharCodes(encoder.convert(input.codeUnits));
  }

  /// Decode an input string using this codec and returns a string
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String decodeString(String input) {
    return String.fromCharCodes(decoder.convert(input.codeUnits));
  }

  /// Encode an array of bytes using this codec and returns a string
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String encodeToString(Iterable<int> input) {
    return String.fromCharCodes(encoder.convert(input));
  }

  /// Decode an array of bytes using this codec and returns a string
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String decodeToString(Iterable<int> input) {
    return String.fromCharCodes(decoder.convert(input));
  }

  /// Encode an string using this codec and returns an array of bytes
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  Iterable<int> encodeFromString(String input) {
    return encoder.convert(input.codeUnits);
  }

  /// Decode an string using this codec and returns an array of bytes
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  Iterable<int> decodeFromString(String input) {
    return decoder.convert(input.codeUnits);
  }

  /// Encode an input buffer using this codec
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  Iterable<int> encodeBuffer(ByteBuffer buffer) {
    return encoder.convert(buffer.asUint8List());
  }

  /// Encode an input buffer using this codec and returns a string
  @pragma('vm:prefer-inline')
  @pragma('dart2js:tryInline')
  String encodeBufferToString(ByteBuffer buffer) {
    return String.fromCharCodes(encoder.convert(buffer.asUint8List()));
  }
}
