// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/hashlib.dart';

import 'utils.dart';

final _hash = <String, HashBase>{};
final _blockHash = <String, BlockHashBase>{};

@pragma('vm:prefer-inline')
String _norm(String name) =>
    // ignore: deprecated_member_use_from_same_package
    normalizeName(name);

void _buildRegistry() {
  if (_hash.isNotEmpty) return;

  _hash.addAll({
    _norm(alder32.name): alder32,
    _norm(crc16.name): crc16,
    _norm(crc32.name): crc32,
    _norm(crc64.name): crc64,
  });

  _blockHash.addAll({
    _norm(blake2b160.name): blake2b160,
    _norm(blake2b256.name): blake2b256,
    _norm(blake2b384.name): blake2b384,
    _norm(blake2b512.name): blake2b512,
    _norm('BLAKE2'): blake2b512,
    _norm('BLAKE2b'): blake2b512,
    _norm(blake2s128.name): blake2s128,
    _norm(blake2s160.name): blake2s160,
    _norm(blake2s224.name): blake2s224,
    _norm(blake2s256.name): blake2s256,
    _norm('BLAKE2s'): blake2s256,
    _norm(keccak224.name): keccak224,
    _norm(keccak256.name): keccak256,
    _norm(keccak384.name): keccak384,
    _norm(keccak512.name): keccak512,
    _norm(md4.name): md4,
    _norm(md5.name): md5,
    _norm(ripemd128.name): ripemd128,
    _norm(ripemd160.name): ripemd160,
    _norm(ripemd256.name): ripemd256,
    _norm(ripemd320.name): ripemd320,
    _norm(sha1.name): sha1,
    _norm(sha3_224.name): sha3_224,
    _norm(sha3_256.name): sha3_256,
    _norm(sha3_384.name): sha3_384,
    _norm(sha3_512.name): sha3_512,
    _norm('SHA3'): sha3_512,
    _norm(sha224.name): sha224,
    _norm(sha256.name): sha256,
    _norm('SHA2'): sha256,
    _norm(sha384.name): sha384,
    _norm(sha512.name): sha512,
    _norm(sha512t224.name): sha512t224,
    _norm(sha512t256.name): sha512t256,
    _norm(shake128_128.name): shake128_128,
    _norm(shake128_160.name): shake128_160,
    _norm(shake128_224.name): shake128_224,
    _norm(shake128_256.name): shake128_256,
    _norm('SHAKE-128'): shake128_256,
    _norm(shake128_384.name): shake128_384,
    _norm(shake128_512.name): shake128_512,
    _norm(shake256_128.name): shake256_128,
    _norm(shake256_160.name): shake256_160,
    _norm(shake256_224.name): shake256_224,
    _norm(shake256_256.name): shake256_256,
    _norm(shake256_384.name): shake256_384,
    _norm(shake256_512.name): shake256_512,
    _norm('SHAKE-512'): shake256_512,
    _norm(sm3.name): sm3,
    _norm(xxh3.name): xxh3,
    _norm('XXH3-64'): xxh3,
    _norm(xxh32.name): xxh32,
    _norm(xxh64.name): xxh64,
    _norm(xxh128.name): xxh128,
    _norm('XXH3-128'): xxh128,
  });
  _hash.addAll(_blockHash);
}

/// A registry to find a block hash algorithm by name
@Deprecated('It will be removed in 2.0.0')
class BlockHashRegistry {
  /// Find a [BlockHashBase] algorithm given a string name
  static BlockHashBase? lookup(String name) {
    _buildRegistry();
    return _blockHash[_norm(name)];
  }

  /// Register a new [BlockHashBase] algorithm on the fly given a string name
  static void register(BlockHashBase algo, [String? name]) {
    _buildRegistry();
    name = _norm(name ?? algo.name);
    _blockHash[name] = algo;
  }
}

/// A registry to find a hash algorithm by name
@Deprecated('It will be removed in 2.0.0')
class HashRegistry {
  /// Find a [HashBase] algorithm given a string name
  static HashBase? lookup(String name) {
    _buildRegistry();
    return _hash[_norm(name)];
  }

  /// Register a new [HashBase] algorithm on the fly given a string name
  static void register(HashBase algo, [String? name]) {
    _buildRegistry();
    name = _norm(name ?? algo.name);
    _hash[name] = algo;
    if (algo is BlockHashBase) {
      _blockHash[name] = algo;
    }
  }
}
