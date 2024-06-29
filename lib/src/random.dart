// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';
import 'dart:typed_data';

export 'package:hashlib/src/algorithms/keccak_random.dart';

Random _defaultGenerator() {
  try {
    return Random.secure();
  } catch (err) {
    int micros = DateTime.now().millisecond;
    int millis = DateTime.now().microsecond;
    return Random((millis << 10) ^ micros);
  }
}

/// Generate a list of random 8-bit numbers of size [length]
Uint8List randomBytes(int length, [Random? random]) {
  random ??= _defaultGenerator();
  var data = Uint8List(length);
  for (int i = 0; i < data.length; i++) {
    data[i] = random.nextInt(256);
  }
  return data;
}

/// Generate a list of random 32-bit numbers of size [length]
Uint32List randomNumbers(int length, [Random? random]) {
  random ??= _defaultGenerator();
  var data = Uint32List(length);
  for (int i = 0; i < data.length; i++) {
    data[i] = random.nextInt(0x100000000);
  }
  return data;
}

/// Fill the [buffer] with random numbers.
///
/// Both the [start] and [length] are in bytes.
void fillRandom(
  ByteBuffer buffer, {
  int start = 0,
  int? length,
  Random? random,
}) {
  if (length == null) {
    length = buffer.lengthInBytes;
  } else {
    length = min(length + start, buffer.lengthInBytes);
  }
  random ??= _defaultGenerator();
  var data = Uint8List.view(buffer);
  for (int i = start; i < length; i++) {
    data[i] = random.nextInt(256);
  }
}
