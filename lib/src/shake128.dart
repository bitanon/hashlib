// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:convert';

import 'package:hashlib/src/algorithms/shake.dart';
import 'package:hashlib/src/core/block_hash.dart';

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
const shake128 = _Shake128Builder();

/// [Shake128] instance to generate a 128-bit message digest.
const shake128_128 = Shake128(128 >>> 3);

/// [Shake128] instance to generate a 160-bit message digest.
const shake128_160 = Shake128(160 >>> 3);

/// [Shake128] instance to generate a 224-bit message digest.
const shake128_224 = Shake128(224 >>> 3);

/// [Shake128] instance to generate a 256-bit message digest.
const shake128_256 = Shake128(256 >>> 3);

/// [Shake128] instance to generate a 384-bit message digest.
const shake128_384 = Shake128(384 >>> 3);

/// [Shake128] instance to generate a 512-bit message digest.
const shake128_512 = Shake128(512 >>> 3);

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
class Shake128 extends BlockHashBase {
  final int outputSizeInBytes;

  /// Creates an instance to generate arbitrary size hash using SHAKE-128
  ///
  /// Parameters:
  /// - [outputSizeInBytes] is the length of the output digest in bytes.
  const Shake128(this.outputSizeInBytes);

  @override
  String get name => 'SHAKE-128/${outputSizeInBytes << 3}';

  @override
  Shake128Hash createSink() => Shake128Hash(outputSizeInBytes);
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
