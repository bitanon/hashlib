// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha3.dart';
import 'package:hashlib/src/core/block_hash.dart';

/// SHA3-256 is a member of SHA-3 family which uses 256-bit blocks to
/// generate a message digest of 256-bit long.
///
/// SHA-3 is a subset of Keccak cryptographic family, standardized by NIST
/// on 2015 to substitute SHA-2 if necessary. Since the algorithm uses the
/// [sponge construction][sponge], it can generate any arbitrary length of
/// message digest. This implementation generates a 256-bit output using
/// the [standard SHA-3 algorithm][fips202].
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
const BlockHashBase sha3_256 = _SHA3d256();

class _SHA3d256 extends BlockHashBase {
  const _SHA3d256();

  @override
  final String name = 'SHA3-256';

  @override
  SHA3d256Hash createSink() => SHA3d256Hash();
}

/// Generates a SHA3-256 checksum in hexadecimal
///
/// Parameters:
/// - [input] is the string to hash
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String sha3_256sum(
  String input, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return sha3_256.string(input, encoding).hex(uppercase);
}
