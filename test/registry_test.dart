// Copyright (c) 2024, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'package:test/test.dart';
import 'package:hashlib/hashlib.dart'; // Adjust the import path as needed

// Mock or custom implementations for testing purposes
class CustomHashBase extends HashBase {
  @override
  String get name => 'custom-hash';

  @override
  createSink() {
    throw UnimplementedError();
  }
}

class CustomBlockHashBase extends BlockHashBase {
  @override
  String get name => 'custom-block-hash';

  @override
  createSink() {
    throw UnimplementedError();
  }
}

void main() {
  group('HashRegistry', () {
    test('lookup should return the correct HashBase algorithm by name', () {
      expect(HashRegistry.lookup('SHA-256'), equals(sha256));
      expect(HashRegistry.lookup('sha256'), equals(sha256));
      expect(HashRegistry.lookup('SHA2'), equals(sha256));
      expect(HashRegistry.lookup('md5'), equals(md5));
      expect(HashRegistry.lookup('blake2b512'), equals(blake2b512));
    });

    test('lookup should return null for an unknown algorithm name', () {
      expect(HashRegistry.lookup('unknown-algo'), isNull);
    });

    test('register should add a new HashBase algorithm', () {
      final customHash = CustomHashBase();
      HashRegistry.register(customHash);
      expect(HashRegistry.lookup(customHash.name), equals(customHash));
    });

    test('register should override an existing HashBase algorithm', () {
      final customHash = CustomHashBase();
      HashRegistry.register(customHash, 'Sha-256');
      expect(HashRegistry.lookup('sha256'), equals(customHash));
    });

    test('register should add BlockHashBase algorithm', () {
      HashRegistry.register(md5, 'test-md5');
      expect(HashRegistry.lookup('test-md5'), equals(md5));
      expect(BlockHashRegistry.lookup('test-md5'), equals(md5));
    });
  });

  group('BlockHashRegistry', () {
    test('lookup should return the correct algorithm by name', () {
      expect(BlockHashRegistry.lookup('blake2b512'), equals(blake2b512));
      expect(BlockHashRegistry.lookup('BLAKE2'), equals(blake2b512));
      expect(BlockHashRegistry.lookup('sha3_512'), equals(sha3_512));
      expect(BlockHashRegistry.lookup('sha3-384'), equals(sha3_384));
      expect(BlockHashRegistry.lookup('sha3 256'), equals(sha3_256));
    });

    test('lookup should return null for an unknown algorithm', () {
      expect(BlockHashRegistry.lookup('unknown-algo'), isNull);
    });

    test('register should add a new BlockHashBase algorithm', () {
      final customBlockHash = CustomBlockHashBase();
      BlockHashRegistry.register(customBlockHash);
      expect(BlockHashRegistry.lookup(customBlockHash.name),
          equals(customBlockHash));
    });

    test('register should override an existing BlockHashBase algorithm', () {
      final customBlockHash = CustomBlockHashBase();
      BlockHashRegistry.register(customBlockHash, 'blake2b512');
      expect(BlockHashRegistry.lookup('blake2b512'), equals(customBlockHash));
    });
  });
}
