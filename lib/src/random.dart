// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

final Random _secure = Random.secure();

/// Generate a list of random 8-bit numbers of size [length]
List<int> randomBytes(int length) {
  return List<int>.generate(length, (index) => _secure.nextInt(256));
}

/// Generate a [Uint8List] of size [length] with random 8-bit numbers
Uint8List randomBuffer(int length) {
  var data = Uint8List(length);
  for (int i = 0; i < data.length; i++) {
    data[i] = _secure.nextInt(256);
  }
  return data;
}

/// Fill the [buffer] with random numbers
void fillRandom(
  ByteBuffer buffer, [
  int offsetInBytes = 0,
  int? lengthInBytes,
]) {
  var data = buffer.asUint8List(offsetInBytes, lengthInBytes);
  for (int i = 0; i < data.length; i++) {
    data[i] = _secure.nextInt(256);
  }
}
