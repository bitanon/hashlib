// Copyright (c) 2025, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:js_interop';

@JS()
@staticInterop
class Crypto {}

extension on Crypto {
  external int randomInt(final int max);
}

@JS('require')
external Crypto require(final String id);

/// For Node.js environment + dart2js compiler
abstract class CryptoRandom {
  Crypto? _crypto;

  int cryptoRandomInt(final int max) {
    _crypto ??= require('crypto');
    return _crypto!.randomInt(max);
  }
}
