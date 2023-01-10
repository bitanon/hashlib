// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/sha3.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/hash_digest.dart';

/// SHAKE-128 is a member of SHA-3 family which uses 128-bit blocks to
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
const shake128 = _Shake128Builder();

class _Shake128Builder {
  const _Shake128Builder();

  /// Returns a [Shake128] instance.
  ///
  /// Parameters:
  /// - [outputSizeInBytes] is the length of the output digest in bytes.
  Shake128 of(int outputSizeInBytes) => Shake128(outputSizeInBytes);
}

/// SHAKE-128 is a member of SHA-3 family which uses 128-bit blocks to
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
class Shake128 extends HashBase {
  final int outputSizeInBytes;

  /// Creates an instance to generate arbitrary size hash using SHAKE-128
  ///
  /// Parameters:
  /// - [outputSizeInBytes] is the length of the output digest in bytes.
  const Shake128(this.outputSizeInBytes);

  @override
  Shake128Hash startChunkedConversion([Sink<HashDigest>? sink]) =>
      Shake128Hash(outputSizeInBytes);
}

/// Generates a SHAKE-128 checksum in hexadecimal of arbitrary length
///
/// Parameters:
/// - [input] is the string to hash
/// - [outputSize] is the length of the output digest in bytes. The
///   hexadecimal string output is twice as that. You can expect a string of
///   length `2 * outputSizeInBytes` from this function.
/// - The [encoding] is the encoding to use. Default is `input.codeUnits`
/// - [uppercase] defines if the hexadecimal output should be in uppercase
String shake128sum(
  String input,
  int outputSize, [
  Encoding? encoding,
  bool uppercase = false,
]) {
  return Shake128(outputSize).string(input, encoding).hex(uppercase);
}

/// Extension to [String] to generate [shake128] hash
extension Shake128StringExtension on String {
  /// Generates a SHAKE-128 digest of this string
  ///
  /// Parameters:
  /// - The [encoding] is the encoding to use. Default is `input.codeUnits`
  HashDigest shake128digest(int outputSize, [Encoding? encoding]) {
    return Shake128(outputSize).string(this, encoding);
  }
}

/// Creates a SHAKE-128 based **infinite** hash generator.
///
/// If [seed] is provided it will be used as an input to the algorithm.
/// With a proper seed, this can work as a random number generator.
///
/// **WARNING: Do not go down the rabbit hole of infinite looping!**
@Deprecated("Experimental feature. Can be removed or changed in the future.")
Iterable<int> shake128generator([List<int>? seed]) {
  final hash = Shake128Hash(0);
  if (seed != null) {
    hash.addSlice(seed, 0, seed.length);
  }
  return hash.generate();
}
