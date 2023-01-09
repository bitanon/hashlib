// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha3.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHAKE-256 is a member of SHA-3 family which uses 256-bit blocks to
/// generate a message digest of arbitrary length.
///
/// SHA-3 is a subset of Keccak cryptographic family, standardized by NIST
/// on 2015 to substitute SHA-2 if necessary. Since the algorithm uses the
/// [sponge construction][sponge], it can generate any arbitrary length of
/// message digest. This implementation generates a arbitrary length output
/// using the [standard SHA-3 algorithm][fips202].
///
/// [sponge]: https://en.wikipedia.org/wiki/Sponge_function
/// [fips202]: https://csrc.nist.gov/publications/detail/fips/202/final
///
/// **WARNING**: Not supported in Web
class Shake256 extends HashBase {
  final int outputSizeInBytes;

  const Shake256([this.outputSizeInBytes = 32]);

  @override
  Shake256Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      Shake256Hash(outputSizeInBytes);
}

/// Generates a SHAKE-256 checksum of arbitrary length
String shake256sum(
  String input,
  int outputSizeInBytes, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return Shake256(outputSizeInBytes).string(input, encoding).hex(uppercase);
}

/// Creates a SHAKE-256 based **infinite** hash generator.
///
/// If [seed] is provided it will be used as an input to the algorithm.
/// With a proper seed, this can work as a random number generator.
///
/// **WARNING: Do not go down the rabbit hole of infinite looping!**
Iterable<int> shake256generator([List<int>? seed]) {
  final hash = Shake256Hash(0);
  hash.add(seed ?? []);
  return hash.generate();
}
