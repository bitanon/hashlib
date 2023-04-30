// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

Random _generator() {
  try {
    return Random.secure();
  } catch (err) {
    return Random(DateTime.now().millisecondsSinceEpoch);
  }
}

/// Generate a list of random 8-bit numbers of size [length]
Uint8List randomBytes(int length) {
  var random = _generator();
  var data = Uint8List(length);
  for (int i = 0; i < data.length; i++) {
    data[i] = random.nextInt(256);
  }
  return data;
}

/// Fill the [buffer] with random numbers
void fillRandom(
  ByteBuffer buffer, [
  int offsetInBytes = 0,
  int? lengthInBytes,
]) {
  if (lengthInBytes == null) {
    lengthInBytes = buffer.lengthInBytes;
  } else {
    lengthInBytes = min(lengthInBytes + offsetInBytes, buffer.lengthInBytes);
  }
  var random = _generator();
  var data = buffer.asUint8List();
  for (int i = offsetInBytes; i < lengthInBytes; i++) {
    data[i] = random.nextInt(256);
  }
}
