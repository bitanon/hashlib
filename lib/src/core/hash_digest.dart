// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';

/// This holds generated hash digest and provides utilities to extract it in
/// multiple formats.
class HashDigest extends ByteCollector {
  @override
  final Uint8List bytes;

  /// Creates a new [HashDigest].
  const HashDigest(this.bytes);
}
