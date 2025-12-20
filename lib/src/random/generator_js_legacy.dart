// Copyright (c) 2025, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

// Dart v2.19 compatible version
// Works with dart2js in a Node.js runtime (where `require` exists).

// ignore_for_file: deprecated_member_use, depend_on_referenced_packages

import 'dart:js' as js;

js.JsObject _require(String id) {
  final r = js.context['require'];
  if (r == null) {
    throw StateError("`require` is not available.");
  }
  return (r as js.JsFunction).apply([id]) as js.JsObject;
}

/// For Node.js environment + dart2js compiler
abstract class CryptoRandom {
  js.JsObject? _crypto;
  js.JsFunction? _randomInt;

  int cryptoRandomInt(final int max) {
    _crypto ??= _require('crypto');
    _randomInt ??= _crypto!['randomInt'] as js.JsFunction;
    return (_randomInt!.apply([max]) as num).toInt();
  }
}
