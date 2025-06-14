// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/codecs.dart';
import 'package:hashlib/src/algorithms/bcrypt/bcrypt.dart';
import 'package:hashlib/src/core/hash_digest.dart';
import 'package:hashlib/src/random.dart';

/// The [Bcrypt] algorithm version
enum BcryptVersion {
  /// This is a revised version of original v2 with UTF-8 character support
  /// and inclusion of the null terminator with the password.
  $2a,

  /// This is the bug-fixed version of OpenBSD implementation of bcrypt, which
  /// fixes the support for password longer than 255 characters.
  $2b,

  /// This was introduced by PHP `crypt_blowfish` implementation to mark hashes
  /// generated with a bug in their implementation.
  $2x,

  /// This was introduced by PHP `crypt_blowfish` implementation to mark hashes
  /// generated after fixing the bug in their implementation.
  $2y,
}

extension BcryptVersionName on BcryptVersion {
  /// The name of this version
  String get name {
    switch (this) {
      case BcryptVersion.$2a:
        return '2a';
      case BcryptVersion.$2b:
        return '2b';
      case BcryptVersion.$2x:
        return '2x';
      case BcryptVersion.$2y:
        return '2y';
    }
  }
}

BcryptVersion _nameToVersion(String name) {
  switch (name) {
    case '2a':
      return BcryptVersion.$2a;
    case '2b':
      return BcryptVersion.$2b;
    case '2x':
      return BcryptVersion.$2x;
    case '2y':
      return BcryptVersion.$2y;
    default:
      throw FormatException('Invalid version');
  }
}

/// The HashDigest for Bcrypt with [BcryptContext]
class BcryptHashDigest extends HashDigest {
  final BcryptContext ctx;

  const BcryptHashDigest(this.ctx, Uint8List bytes) : super(bytes);

  @override
  String toString() => encoded();

  /// Gets a PHC-compliant encoded string
  String encoded() => ctx.toEncoded(bytes);
}

/// The configuration used by the [Bcrypt] algorithm
class BcryptContext {
  /// The BCrypt version
  final BcryptVersion version;

  /// Number of rounds in terms of power of 2
  final int cost;

  /// 16-byte salt
  final Uint8List salt;

  const BcryptContext._({
    required this.salt,
    required this.version,
    required this.cost,
  });

  /// Creates an [BcryptContext] instance from encoded string.
  ///
  /// Parameters:
  /// - [version] : The BcryptVersion to use. Default `BcryptVersion.$2b`.
  /// - [salt] : An uniquely and randomly generated string.
  /// - [cost] : Number of rounds in terms of power of 2. 0 < [cost] < 31.
  factory BcryptContext({
    required int cost,
    List<int>? salt,
    BcryptVersion version = BcryptVersion.$2b,
  }) {
    // validate parameters
    if (cost < 0) {
      throw ArgumentError('The cost must be at least 0');
    }
    if (cost > 31) {
      throw ArgumentError('The cost must be at most 31');
    }
    salt ??= randomBytes(16);
    if (salt.length != 16) {
      throw ArgumentError('The salt must be exactly 16-bytes');
    }
    return BcryptContext._(
      cost: cost,
      version: version,
      salt: salt is Uint8List ? salt : Uint8List.fromList(salt),
    );
  }

  /// Creates an [BcryptContext] instance from encoded string.
  ///
  /// The encoded string may look like this:
  /// `$2a$12$WApznUOJfkEGSmYRfnkrPOr466oFDCaj4b6HY3EXGvfxm43seyhgC`
  factory BcryptContext.fromEncoded(CryptData data) {
    var version = _nameToVersion(data.id);
    var cost = int.tryParse(data.salt ?? '0');
    if (cost == null) {
      throw FormatException('Invalid cost');
    }
    Uint8List? salt;
    var hash = data.hash;
    if (hash != null) {
      if (hash.length != 22 && hash.length != 53) {
        throw FormatException('Invalid hash');
      }
      salt = fromBase64(
        hash.substring(0, 22),
        codec: Base64Codec.bcrypt,
      );
    }
    return BcryptContext(
      salt: salt,
      cost: cost,
      version: version,
    );
  }

  /// Gets a PHC-compliant encoded string
  String toEncoded([Uint8List? hashBytes]) {
    var hash = toBase64(salt, codec: Base64Codec.bcrypt);
    if (hashBytes != null) {
      hash += toBase64(hashBytes, codec: Base64Codec.bcrypt);
    }
    return toCrypt(
      CryptDataBuilder(version.name)
          .salt('$cost'.padLeft(2, '0'))
          .hash(hash)
          .build(),
    );
  }

  /// Make the 72-byte long password using version-specific strategy.
  Uint32List makePassword(List<int> password) {
    int i, j;
    var long32 = Uint32List(18);
    var long = Uint8List.view(long32.buffer);
    var pass8 = Uint8List.fromList(password);
    for (i = 0; i < 72 && i < pass8.length; i++) {
      long[i] = pass8[i];
    }
    if (i < 72) {
      long[i++] = 0;
    }
    for (j = 0; i < 72; i++, j++) {
      long[i] = long[j];
    }
    for (i = 0; i < 18; ++i) {
      j = long32[i];
      j = ((j << 24) & 0xff000000) |
          ((j << 8) & 0x00ff0000) |
          ((j >>> 8) & 0x0000ff00) |
          ((j >>> 24) & 0x000000ff);
      long32[i] = j;
    }
    return long32;
  }
}
