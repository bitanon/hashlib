// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/shake.dart';
import 'package:hashlib/src/core/block_hash.dart';

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
const shake256 = _Shake256Builder();

/// [Shake256] instance to generate a 128-bit message digest.
const shake256_128 = Shake256(128 >>> 3);

/// [Shake256] instance to generate a 160-bit message digest.
const shake256_160 = Shake256(160 >>> 3);

/// [Shake256] instance to generate a 224-bit message digest.
const shake256_224 = Shake256(224 >>> 3);

/// [Shake256] instance to generate a 256-bit message digest.
const shake256_256 = Shake256(256 >>> 3);

/// [Shake256] instance to generate a 384-bit message digest.
const shake256_384 = Shake256(384 >>> 3);

/// [Shake256] instance to generate a 512-bit message digest.
const shake256_512 = Shake256(512 >>> 3);

class _Shake256Builder {
  const _Shake256Builder();

  /// Returns a [Shake256] instance.
  ///
  /// Parameters:
  /// - [outputSizeInBytes] is the length of the output digest in bytes.
  Shake256 of(int outputSizeInBytes) => Shake256(outputSizeInBytes);
}

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
class Shake256 extends BlockHashBase {
  final int outputSizeInBytes;

  /// Creates an instance to generate arbitrary size hash using SHAKE-256
  ///
  /// Parameters:
  /// - [outputSizeInBytes] is the length of the output digest in bytes.
  const Shake256(this.outputSizeInBytes);

  @override
  String get name => 'SHAKE-256/${outputSizeInBytes << 3}';

  @override
  Shake256Hash createSink() => Shake256Hash(outputSizeInBytes);
}

/// Generates a SHAKE-256 checksum in hexadecimal of arbitrary length
///
/// Parameters:
/// - [input] is the string to hash
/// - [outputSize] is the length of the output digest in bytes. The
///   hexadecimal string output is twice as that. You can expect a string of
///   length `2 * outputSizeInBytes` from this function.
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String shake256sum(
  String input,
  int outputSize, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return Shake256(outputSize).string(input, encoding).hex(uppercase);
}

/// Creates a SHAKE-256 based **infinite** hash generator.
///
/// If [seed] is provided it will be used as an input to the algorithm.
/// With a proper seed, this can work as a random number generator.
///
/// **WARNING: Be careful to not go down the rabbit hole of infinite looping!**
Iterable<int> shake256generator([List<int>? seed]) {
  final hash = Shake256Hash(0);
  if (seed != null) {
    hash.add(seed, 0, seed.length);
  }
  return hash.generate();
}
