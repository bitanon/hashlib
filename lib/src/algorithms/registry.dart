// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:hashlib/src/core/block_hash.dart';

import '../blake2b.dart';
import '../blake2s.dart';
import '../keccak224.dart';
import '../keccak256.dart';
import '../keccak384.dart';
import '../keccak512.dart';
import '../md5.dart';
import '../sha1.dart';
import '../sha224.dart';
import '../sha256.dart';
import '../sha384.dart';
import '../sha3_224.dart';
import '../sha3_256.dart';
import '../sha3_384.dart';
import '../sha3_512.dart';
import '../sha512.dart';
import '../sha512t.dart';
import '../xxh128.dart';
import '../xxh3.dart';
import '../xxhash32.dart';
import '../xxhash64.dart';

final RegExp _alnumRe = RegExp(r'[0-9A-Za-z]+');

const Map<String, BlockHashBase> _blockHash = {
  'MD5': md5,
  'SHA1': sha1,
  'SHA224': sha224,
  'SHA256': sha256,
  'SHA384': sha384,
  'SHA512': sha512,
  'SHA3': sha3_512,
  'SHA3224': sha3_224,
  'SHA3256': sha3_256,
  'SHA3384': sha3_384,
  'SHA3512': sha3_512,
  'SHA512224': sha512t224,
  'SHA512256': sha512t256,
  'KECCAK224': keccak224,
  'KECCAK256': keccak256,
  'KECCAK384': keccak384,
  'KECCAK512': keccak512,
  'BLAKE2': blake2b512,
  'BLAKE2B': blake2b512,
  'BLAKE2S': blake2s256,
  'BLAKE2128': blake2s128,
  'BLAKE2160': blake2b160,
  'BLAKE2224': blake2s224,
  'BLAKE2384': blake2b384,
  'BLAKE2256': blake2b256,
  'BLAKE2512': blake2b512,
  'BLAKE2B160': blake2b160,
  'BLAKE2B256': blake2b256,
  'BLAKE2B384': blake2b384,
  'BLAKE2B512': blake2b512,
  'BLAKE2S128': blake2s128,
  'BLAKE2S160': blake2s160,
  'BLAKE2S224': blake2s224,
  'BLAKE2S256': blake2s256,
  'XXH3': xxh3,
  'XXH364': xxh3_64,
  'XXH3128': xxh3_128,
  'XXH128': xxh128,
  'XXH64': xxh64,
  'XXH32': xxh32,
};

BlockHashBase? findAlgorithm(String name) {
  name = _alnumRe.allMatches(name).map((m) => m.group(0)).join('');
  return _blockHash[name.toUpperCase()];
}
