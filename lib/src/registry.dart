// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/block_hash.dart';
import 'package:hashlib/src/core/hash_base.dart';
import 'package:hashlib/src/core/utils.dart';

import 'alder32.dart';
import 'blake2b.dart';
import 'blake2s.dart';
import 'crc16.dart';
import 'crc32.dart';
import 'crc64.dart';
import 'keccak224.dart';
import 'keccak256.dart';
import 'keccak384.dart';
import 'keccak512.dart';
import 'md4.dart';
import 'md5.dart';
import 'sha1.dart';
import 'sha224.dart';
import 'sha256.dart';
import 'sha384.dart';
import 'sha3_224.dart';
import 'sha3_256.dart';
import 'sha3_384.dart';
import 'sha3_512.dart';
import 'sha512.dart';
import 'sha512t.dart';
import 'shake128.dart';
import 'shake256.dart';
import 'xxh128.dart';
import 'xxh3.dart';
import 'xxh32.dart';
import 'xxh64.dart';

final _hash = <String, HashBase>{};
final _blockHash = <String, BlockHashBase>{};

@pragma('vm:prefer-inline')
String _normalize(String name) => normalizeName(name);

void _buildRegistry() {
  if (_hash.isNotEmpty) return;

  _blockHash.addAll({
    _normalize('BLAKE2'): blake2b512,
    _normalize('BLAKE2b'): blake2b512,
    _normalize('BLAKE2s'): blake2s256,
    _normalize('SHA2'): sha256,
    _normalize('SHA3'): sha3_512,
    _normalize('SHAKE-128'): shake128_256,
    _normalize('SHAKE-512'): shake256_512,
    _normalize('XXH3-128'): xxh128,
    _normalize('XXH3-64'): xxh3,
    _normalize(blake2b160.name): blake2b160,
    _normalize(blake2b256.name): blake2b256,
    _normalize(blake2b384.name): blake2b384,
    _normalize(blake2b512.name): blake2b512,
    _normalize(blake2s128.name): blake2s128,
    _normalize(blake2s160.name): blake2s160,
    _normalize(blake2s224.name): blake2s224,
    _normalize(blake2s256.name): blake2s256,
    _normalize(keccak224.name): keccak224,
    _normalize(keccak256.name): keccak256,
    _normalize(keccak384.name): keccak384,
    _normalize(keccak512.name): keccak512,
    _normalize(md4.name): md4,
    _normalize(md5.name): md5,
    _normalize(sha1.name): sha1,
    _normalize(sha224.name): sha224,
    _normalize(sha256.name): sha256,
    _normalize(sha3_224.name): sha3_224,
    _normalize(sha3_256.name): sha3_256,
    _normalize(sha3_384.name): sha3_384,
    _normalize(sha3_512.name): sha3_512,
    _normalize(sha384.name): sha384,
    _normalize(sha512.name): sha512,
    _normalize(sha512t224.name): sha512t224,
    _normalize(sha512t256.name): sha512t256,
    _normalize(shake128_128.name): shake128_128,
    _normalize(shake128_160.name): shake128_160,
    _normalize(shake128_224.name): shake128_224,
    _normalize(shake128_256.name): shake128_256,
    _normalize(shake128_384.name): shake128_384,
    _normalize(shake128_512.name): shake128_512,
    _normalize(shake256_128.name): shake256_128,
    _normalize(shake256_160.name): shake256_160,
    _normalize(shake256_224.name): shake256_224,
    _normalize(shake256_256.name): shake256_256,
    _normalize(shake256_384.name): shake256_384,
    _normalize(shake256_512.name): shake256_512,
    _normalize(xxh128.name): xxh128,
    _normalize(xxh3.name): xxh3,
    _normalize(xxh32.name): xxh32,
    _normalize(xxh64.name): xxh64,
  });

  _hash.addAll(_blockHash);
  _hash.addAll({
    _normalize(alder32.name): alder32,
    _normalize(crc16.name): crc16,
    _normalize(crc32.name): crc32,
    _normalize(crc64.name): crc64,
  });
}

/// A registry to find a block hash algorithm by name
class BlockHashRegistry {
  /// Find a [BlockHashBase] algorithm given a string name
  static BlockHashBase? lookup(String name) {
    _buildRegistry();
    return _blockHash[_normalize(name)];
  }

  /// Register a new [BlockHashBase] algorithm on the fly given a string name
  static void register(BlockHashBase algo, [String? name]) {
    _buildRegistry();
    name = _normalize(name ?? algo.name);
    _blockHash[_normalize(name)] = algo;
  }
}

/// A registry to find a hash algorithm by name
class HashRegistry {
  /// Find a [HashBase] algorithm given a string name
  static HashBase? lookup(String name) {
    _buildRegistry();
    return _hash[_normalize(name)];
  }

  /// Register a new [HashBase] algorithm on the fly given a string name
  static void register(HashBase algo, [String? name]) {
    _buildRegistry();
    name = _normalize(name ?? algo.name);
    _hash[name] = algo;
    if (algo is BlockHashBase) {
      _blockHash[name] = algo;
    }
  }
}
