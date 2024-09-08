// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/kdf_base.dart';
import 'package:hashlib_codecs/hashlib_codecs.dart';

import 'argon2_64bit.dart' if (dart.library.js) 'argon2_32bit.dart';
import 'common.dart';
import 'security.dart';

export 'common.dart';
export 'security.dart';

/// Creates a context for [Argon2][wiki] password hashing.
///
/// Argon2 is a key derivation algorithm that was selected as the winner of the
/// 2015 [Password Hashing Contest][phc], and the best password hashing / key
/// derivation algorithm known to date.
///
/// Example of password hashing using Argon2:
///
/// ```dart
/// final salt = utf.encode("some salt")
/// final password = utf8.encode('password');
/// final argon2 = Argon2(
///   version: Argon2Version.v13,
///   type: Argon2Type.argon2id,
///   hashLength: 32,
///   iterations: 2,
///   parallelism: 8,
///   memorySizeKB: 1 << 18,
///   salt: salt,
/// );
/// final digest = argon2.encode(password);
/// ```
///
/// [phc]: https://www.password-hashing.net/
/// [wiki]: https://en.wikipedia.org/wiki/Argon2
class Argon2 extends KeyDerivatorBase {
  final Argon2Context _ctx;

  @override
  String get name => _ctx.typeName;

  /// Argon2 Hash Type
  Argon2Type get type => _ctx.type;

  /// The current version is 0x13 (decimal: 19)
  Argon2Version get version => _ctx.version;

  /// Degree of parallelism (i.e. number of threads)
  int get parallelism => _ctx.lanes;

  /// Desired number of returned bytes
  int get hashLength => _ctx.hashLength;

  /// Amount of memory (in kibibytes) to use
  int get memorySizeKB => _ctx.memorySizeKB;

  /// Number of iterations to perform
  int get iterations => _ctx.passes;

  /// Salt (16 bytes recommended for password hashing)
  List<int> get salt => _ctx.salt;

  /// Optional key
  List<int>? get key => _ctx.key;

  /// Optional arbitrary additional data
  List<int>? get personalization => _ctx.personalization;

  @override
  int get derivedKeyLength => hashLength;

  /// Generate a derived key from a [password] using Argon2 algorithm
  @override
  Argon2HashDigest convert(List<int> password) {
    final result = Argon2Internal(_ctx).convert(password);
    return Argon2HashDigest(_ctx, result);
  }

  /// Generate an Argon2 encoded string from a [password]
  String encode(List<int> password) => convert(password).encoded();

  const Argon2._(this._ctx);

  factory Argon2({
    Argon2Type type = Argon2Type.argon2id,
    Argon2Version version = Argon2Version.v13,
    required int parallelism,
    required int memorySizeKB,
    required int iterations,
    int? hashLength,
    List<int>? salt,
    List<int>? key,
    List<int>? personalization,
  }) {
    var ctx = Argon2Context(
      salt: salt,
      version: version,
      type: type,
      hashLength: hashLength,
      iterations: iterations,
      parallelism: parallelism,
      memorySizeKB: memorySizeKB,
      key: key,
      personalization: personalization,
    );
    return Argon2._(ctx);
  }

  /// Creates an [Argon2] instance from [Argon2Security] parameter.
  factory Argon2.fromSecurity(
    Argon2Security security, {
    List<int>? salt,
    List<int>? key,
    int? hashLength,
    List<int>? personalization,
  }) {
    return Argon2(
      salt: salt,
      version: security.version,
      type: security.type,
      hashLength: hashLength,
      iterations: security.t,
      parallelism: security.p,
      memorySizeKB: security.m,
      key: key,
      personalization: personalization,
    );
  }

  /// Creates an [Argon2] instance from an encoded PHC-compliant string.
  ///
  /// The encoded string may look like this:
  /// `$argon2i$v=19$m=16,t=2,p=1$c29tZSBzYWx0$u1eU6mZFG4/OOoTdAtM5SQ`
  factory Argon2.fromEncoded(
    CryptData data, {
    List<int>? key,
    List<int>? personalization,
  }) {
    var ctx = Argon2Context.fromEncoded(
      data,
      key: key,
      personalization: personalization,
    );
    return Argon2._(ctx);
  }
}
