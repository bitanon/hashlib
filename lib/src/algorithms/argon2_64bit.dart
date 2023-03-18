// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'argon2.dart';
import 'blake2b.dart';

const int _mask32 = 0xFFFFFFFF;

const int _blockSize = 1024;
const int _blockSize64 = 128;

//     slice 0      slice 1      slice 2      slice 3
//   ____/\____   ____/\____   ____/\____   ____/\____
//  /          \ /          \ /          \ /          \
// +------------+------------+------------+------------+
// | segment 0  | segment 1  | segment 2  | segment 3  | -> lane 0
// +------------+------------+------------+-----------+
// | segment 4  | segment 5  | segment 6  | segment 7  | -> lane 1
// +------------+------------+------------+------------+
// | segment 8  | segment 9  | segment 10 | segment 11 | -> lane 2
// +------------+------------+------------+------------+
// |           ...          ...          ...           | ...
// +------------+------------+------------+------------+
// |            |            |            |            | -> lane p - 1
// +------------+------------+------------+------------+

class Argon2Internal extends Argon2 {
  final _hash0 = Uint8List(64 + 8);
  final _blockR = Uint64List(_blockSize64);
  final _blockT = Uint64List(_blockSize64);
  final _input = Uint64List(_blockSize64);
  final _address = Uint64List(_blockSize64);

  late final _digest = Uint8List(hashLength);
  late final _memory = Uint64List(blocks << 7);

  Argon2Internal({
    required List<int> salt,
    required int hashLength,
    required int passes,
    required int memorySizeKB,
    required int lanes,
    required int segments,
    required int columns,
    required int blocks,
    required int slices,
    required List<int>? key,
    required List<int>? personalization,
    required Argon2Type type,
    required Argon2Version version,
  }) : super.internal(
          salt: salt,
          slices: slices,
          version: version,
          type: type,
          hashLength: hashLength,
          passes: passes,
          lanes: lanes,
          memorySizeKB: memorySizeKB,
          segments: segments,
          columns: columns,
          blocks: blocks,
          key: key,
          personalization: personalization,
        );

  @override
  Argon2HashDigest convert(List<int> password) {
    int i, j, k, cols;
    int pass, slice, lane;
    var hash0_32 = _hash0.buffer.asUint32List();
    var memoryBytes = _memory.buffer.asUint8List();

    // H_0 Generation (64 + 8 = 72 bytes)
    _initialHash(_hash0, password);

    // Initial block generation: First Lane Blocks
    k = 0;
    hash0_32[16] = 0;
    cols = columns << 10;
    for (i = 0; i < lanes; i++, k += cols) {
      // B[i][0] = H'^(1024)(H_0 || LE32(0) || LE32(i))
      hash0_32[17] = i;
      _expandHash(_blockSize, _hash0, memoryBytes, k);
    }

    // Initial block generation: Second Lane Blocks
    k = _blockSize;
    hash0_32[16] = 1;
    for (i = 0; i < lanes; i++, k += cols) {
      // B[i][1] = H'^(1024)(H_0 || LE32(1) || LE32(i))
      hash0_32[17] = i;
      _expandHash(_blockSize, _hash0, memoryBytes, k);
    }

    // Further block generation
    for (pass = 0; pass < passes; ++pass) {
      for (slice = 0; slice < slices; ++slice) {
        for (lane = 0; lane < lanes; ++lane) {
          _fillSegment(pass, slice, lane);
        }
      }
    }

    // Finalization : XOR the last column blocks
    j = cols - _blockSize;
    var block = memoryBytes.buffer.asUint8List(j, _blockSize);
    for (k = 1; k < lanes; ++k) {
      j += cols;
      for (i = 0; i < _blockSize; ++i) {
        block[i] ^= memoryBytes[j + i];
      }
    }

    // Extend the block to make final result
    _expandHash(hashLength, block, _digest, 0);
    return Argon2HashDigest(this, _digest);
  }

  void _initialHash(Uint8List hash0, List<int> password) {
    // H_0 = H^(64)(LE32(p) || LE32(T) || LE32(m) || LE32(t) ||
    //         LE32(v) || LE32(y) || LE32(length(P)) || P ||
    //         LE32(length(S)) || S ||  LE32(length(K)) || K ||
    //         LE32(length(X)) || X)
    var blake2b = Blake2bHash(64);
    blake2b.addUint32(lanes);
    blake2b.addUint32(hashLength);
    blake2b.addUint32(memorySizeKB);
    blake2b.addUint32(passes);
    blake2b.addUint32(version.value);
    blake2b.addUint32(type.index);
    blake2b.addUint32(password.length);
    blake2b.add(password);
    blake2b.addUint32(salt.length);
    blake2b.add(salt);
    blake2b.addUint32(key?.length ?? 0);
    if (key != null) {
      blake2b.add(key!);
    }
    blake2b.addUint32(personalization?.length ?? 0);
    if (personalization != null) {
      blake2b.add(personalization!);
    }

    var hash = blake2b.digest().bytes;
    for (int i = 0; i < 64; ++i) {
      hash0[i] = hash[i];
    }
  }

  static void _expandHash(
    int digestSize,
    Uint8List message,
    Uint8List output,
    int offset,
  ) {
    int i, j;

    // Take smaller hash unchanged
    if (digestSize <= 64) {
      var blake2b = Blake2bHash(digestSize);
      blake2b.addUint32(digestSize);
      blake2b.add(message);
      var hash = blake2b.digest().bytes;
      for (i = 0; i < digestSize; ++i, offset++) {
        output[offset] = hash[i];
      }
      return;
    }

    // Otherwise, expand to digestSize by repeatedly hashing
    // and taking the first 32-bytes from the each hash

    var blake2b = Blake2bHash(64);
    blake2b.addUint32(digestSize);
    blake2b.add(message);
    var hash = blake2b.digest().bytes;

    // first block
    for (i = 0; i < 32; ++i, ++offset) {
      output[offset] = hash[i];
    }

    // subsequent blocks
    for (j = digestSize - 32; j > 64; j -= 32) {
      blake2b.reset();
      blake2b.add(hash);
      hash = blake2b.digest().bytes;
      for (i = 0; i < 32; ++i, ++offset) {
        output[offset] = hash[i];
      }
    }

    // final block
    blake2b.reset();
    blake2b.add(hash);
    hash = blake2b.digest().bytes;
    for (i = 0; i < j; ++i, ++offset) {
      output[offset] = hash[i];
    }
  }

  void _fillSegment(int pass, int slice, int lane) {
    int refLane, refIndex; // l, z
    int previous, current;
    int i, startIndex, random;

    bool xor = version != Argon2Version.v10 && pass > 0;
    bool useAddress = (type == Argon2Type.argon2i);
    if (type == Argon2Type.argon2id) {
      useAddress = (pass == 0) && (slice < midSlice);
    }

    if (useAddress) {
      _input[0] = pass;
      _input[1] = lane;
      _input[2] = slice;
      _input[3] = blocks;
      _input[4] = passes;
      _input[5] = type.index;
      _input[6] = 0;
    }

    startIndex = 0;
    if (pass == 0 && slice == 0) {
      startIndex = 2;
      if (useAddress) {
        _input[6]++;
        _nextAddress(_input, _address);
      }
    }

    /* Offset of the current block */
    current = lane * columns + slice * segments + startIndex;

    for (i = startIndex; i < segments; ++i, ++current) {
      if (current % columns == 0) {
        /* Last block in this lane */
        previous = current + columns - 1;
      } else {
        /* Previous block */
        previous = current - 1;
      }

      /* 1.2 Computing the index of the reference block */
      /* 1.2.1 Taking pseudo-random value from the previous block */
      if (useAddress) {
        if (i & 0x7F == 0) {
          _input[6]++;
          _nextAddress(_input, _address);
        }
        random = _address[i & 0x7F];
      } else {
        random = _memory[previous << 7];
      }

      /* 1.2.2 Computing the lane of the reference block */
      refLane = (random >>> 32) % lanes;

      if (pass == 0 && slice == 0) {
        /* Can not reference other lanes yet */
        refLane = lane;
      }

      /* 1.2.3 Computing the number of possible reference block within the lane */
      refIndex = _alphaIndex(
        random: random & _mask32,
        index: i,
        slice: slice,
        lane: lane,
        pass: pass,
        sameLane: refLane == lane,
      );

      /* 2 Creating a new block */
      _fillBlock(
        _memory,
        xor: xor,
        next: current << 7,
        prev: previous << 7,
        ref: (refLane * columns + refIndex) << 7,
      );
    }
  }

  int _alphaIndex({
    required int pass,
    required int slice,
    required int lane,
    required int index,
    required int random,
    required bool sameLane,
  }) {
    int area, pos, start;

    if (pass == 0) {
      // First pass
      if (slice == 0) {
        // First slice
        area = index - 1; // all but the previous
      } else if (sameLane) {
        // The same lane => add current segment
        area = slice * segments + index - 1;
      } else if (index == 0) {
        area = slice * segments - 1;
      } else {
        area = slice * segments;
      }
    } else {
      // Other passes
      if (sameLane) {
        area = columns - segments + index - 1;
      } else if (index == 0) {
        area = columns - segments - 1;
      } else {
        area = columns - segments;
      }
    }

    // 1.2.4. Mapping pseudo_rand to 0..<reference_area_size-1>
    // and produce relative position
    pos = (random * random) >>> 32;
    pos = area - 1 - ((area * pos) >>> 32);

    /* 1.2.5 Computing starting position */
    start = 0;
    if (pass != 0 && slice != slices - 1) {
      start = (slice + 1) * segments;
    }

    /* 1.2.6. Computing absolute position */
    return (start + pos) % columns;
  }

  /// Fills a memory block and optionally XORs the old block over it.
  void _nextAddress(Uint64List input, Uint64List address) {
    for (int i = 0; i < _blockSize64; ++i) {
      _blockR[i] = address[i] = input[i];
    }

    for (int k = 0; k < 2; ++k) {
      // Apply Blake2 on columns of 64-bit words: (0,1,...,15),
      // then (16,17,..31)... finally (112,113,...127)
      for (int j = 0; j < 128; j += 16) {
        _blake2bMixer(
          _blockR,
          j,
          j + 1,
          j + 2,
          j + 3,
          j + 4,
          j + 5,
          j + 6,
          j + 7,
          j + 8,
          j + 9,
          j + 10,
          j + 11,
          j + 12,
          j + 13,
          j + 14,
          j + 15,
        );
      }

      // Apply Blake2 on rows of 64-bit words: (0,1,16,17,...112,113),
      // then (2,3,18,19,...,114,115).. finally (14,15,30,31,...,126,127)
      for (int j = 0; j < 16; j += 2) {
        _blake2bMixer(
          _blockR,
          j,
          j + 1,
          j + 16,
          j + 17,
          j + 32,
          j + 33,
          j + 48,
          j + 49,
          j + 64,
          j + 65,
          j + 80,
          j + 81,
          j + 96,
          j + 97,
          j + 112,
          j + 113,
        );
      }

      for (int i = 0; i < _blockSize64; ++i) {
        address[i] = _blockR[i] ^= address[i];
      }
    }
  }

  /// Fills a memory block and optionally XORs the old block over it.
  void _fillBlock(
    Uint64List memory, {
    required int prev,
    required int ref,
    required int next,
    bool xor = false,
  }) {
    // R = ref ^ prev
    for (int i = 0; i < _blockSize64; ++i) {
      _blockT[i] = _blockR[i] = memory[ref + i] ^ memory[prev + i];
    }

    if (xor) {
      // T ^= next
      for (int i = 0; i < _blockSize64; ++i) {
        _blockT[i] ^= memory[next + i];
      }
    }

    // Apply Blake2 on columns of 64-bit words: (0,1,...,15),
    // then (16,17,..31)... finally (112,113,...127)
    for (int j = 0; j < 128; j += 16) {
      _blake2bMixer(
        _blockR,
        j,
        j + 1,
        j + 2,
        j + 3,
        j + 4,
        j + 5,
        j + 6,
        j + 7,
        j + 8,
        j + 9,
        j + 10,
        j + 11,
        j + 12,
        j + 13,
        j + 14,
        j + 15,
      );
    }

    // Apply Blake2 on rows of 64-bit words: (0,1,16,17,...112,113),
    // then (2,3,18,19,...,114,115).. finally (14,15,30,31,...,126,127)
    for (int j = 0; j < 16; j += 2) {
      _blake2bMixer(
        _blockR,
        j,
        j + 1,
        j + 16,
        j + 17,
        j + 32,
        j + 33,
        j + 48,
        j + 49,
        j + 64,
        j + 65,
        j + 80,
        j + 81,
        j + 96,
        j + 97,
        j + 112,
        j + 113,
      );
    }

    // next = T ^ R
    for (int i = 0; i < _blockSize64; ++i) {
      memory[next + i] = _blockR[i] ^ _blockT[i];
    }
  }

  @pragma('vm:always-consider-inlining')
  static int _mul32(int a, int b) => (a & _mask32) * (b & _mask32);

  @pragma('vm:always-consider-inlining')
  static int _rotr(int x, int n) => (x >>> n) ^ (x << (64 - n));

  @pragma('vm:prefer-inline')
  static void _blake2bMixer(
    Uint64List v,
    int _i0,
    int _i1,
    int _i2,
    int _i3,
    int _i4,
    int _i5,
    int _i6,
    int _i7,
    int _i8,
    int _i9,
    int _i10,
    int _i11,
    int _i12,
    int _i13,
    int _i14,
    int _i15,
  ) {
    int v0 = v[_i0];
    int v1 = v[_i1];
    int v2 = v[_i2];
    int v3 = v[_i3];
    int v4 = v[_i4];
    int v5 = v[_i5];
    int v6 = v[_i6];
    int v7 = v[_i7];
    int v8 = v[_i8];
    int v9 = v[_i9];
    int v10 = v[_i10];
    int v11 = v[_i11];
    int v12 = v[_i12];
    int v13 = v[_i13];
    int v14 = v[_i14];
    int v15 = v[_i15];

    // _mix(v, v0, v4, v8, v12);
    v0 += v4 + (_mul32(v0, v4) << 1);
    v12 ^= v0;
    v12 = _rotr(v12, 32);
    v8 += v12 + (_mul32(v8, v12) << 1);
    v4 ^= v8;
    v4 = _rotr(v4, 24);
    v0 += v4 + (_mul32(v0, v4) << 1);
    v12 ^= v0;
    v12 = _rotr(v12, 16);
    v8 += v12 + (_mul32(v8, v12) << 1);
    v4 ^= v8;
    v4 = _rotr(v4, 63);

    // _mix(v, v1, v5, v9, v13);
    v1 += v5 + (_mul32(v1, v5) << 1);
    v13 ^= v1;
    v13 = _rotr(v13, 32);
    v9 += v13 + (_mul32(v9, v13) << 1);
    v5 ^= v9;
    v5 = _rotr(v5, 24);
    v1 += v5 + (_mul32(v1, v5) << 1);
    v13 ^= v1;
    v13 = _rotr(v13, 16);
    v9 += v13 + (_mul32(v9, v13) << 1);
    v5 ^= v9;
    v5 = _rotr(v5, 63);

    // _mix(v, v2, v6, v10, v14);
    v2 += v6 + (_mul32(v2, v6) << 1);
    v14 ^= v2;
    v14 = _rotr(v14, 32);
    v10 += v14 + (_mul32(v10, v14) << 1);
    v6 ^= v10;
    v6 = _rotr(v6, 24);
    v2 += v6 + (_mul32(v2, v6) << 1);
    v14 ^= v2;
    v14 = _rotr(v14, 16);
    v10 += v14 + (_mul32(v10, v14) << 1);
    v6 ^= v10;
    v6 = _rotr(v6, 63);

    // _mix(v, v3, v7, v11, v15);
    v3 += v7 + (_mul32(v3, v7) << 1);
    v15 ^= v3;
    v15 = _rotr(v15, 32);
    v11 += v15 + (_mul32(v11, v15) << 1);
    v7 ^= v11;
    v7 = _rotr(v7, 24);
    v3 += v7 + (_mul32(v3, v7) << 1);
    v15 ^= v3;
    v15 = _rotr(v15, 16);
    v11 += v15 + (_mul32(v11, v15) << 1);
    v7 ^= v11;
    v7 = _rotr(v7, 63);

    // _mix(v, v0, v5, v10, v15);
    v0 += v5 + (_mul32(v0, v5) << 1);
    v15 ^= v0;
    v15 = _rotr(v15, 32);
    v10 += v15 + (_mul32(v10, v15) << 1);
    v5 ^= v10;
    v5 = _rotr(v5, 24);
    v0 += v5 + (_mul32(v0, v5) << 1);
    v15 ^= v0;
    v15 = _rotr(v15, 16);
    v10 += v15 + (_mul32(v10, v15) << 1);
    v5 ^= v10;
    v5 = _rotr(v5, 63);

    // _mix(v, v1, v6, v11, v12);
    v1 += v6 + (_mul32(v1, v6) << 1);
    v12 ^= v1;
    v12 = _rotr(v12, 32);
    v11 += v12 + (_mul32(v11, v12) << 1);
    v6 ^= v11;
    v6 = _rotr(v6, 24);
    v1 += v6 + (_mul32(v1, v6) << 1);
    v12 ^= v1;
    v12 = _rotr(v12, 16);
    v11 += v12 + (_mul32(v11, v12) << 1);
    v6 ^= v11;
    v6 = _rotr(v6, 63);

    // _mix(v, v2, v7, v8, v13);
    v2 += v7 + (_mul32(v2, v7) << 1);
    v13 ^= v2;
    v13 = _rotr(v13, 32);
    v8 += v13 + (_mul32(v8, v13) << 1);
    v7 ^= v8;
    v7 = _rotr(v7, 24);
    v2 += v7 + (_mul32(v2, v7) << 1);
    v13 ^= v2;
    v13 = _rotr(v13, 16);
    v8 += v13 + (_mul32(v8, v13) << 1);
    v7 ^= v8;
    v7 = _rotr(v7, 63);

    // _mix(v, v3, v4, v9, v14);
    v3 += v4 + (_mul32(v3, v4) << 1);
    v14 ^= v3;
    v14 = _rotr(v14, 32);
    v9 += v14 + (_mul32(v9, v14) << 1);
    v4 ^= v9;
    v4 = _rotr(v4, 24);
    v3 += v4 + (_mul32(v3, v4) << 1);
    v14 ^= v3;
    v14 = _rotr(v14, 16);
    v9 += v14 + (_mul32(v9, v14) << 1);
    v4 ^= v9;
    v4 = _rotr(v4, 63);

    v[_i0] = v0;
    v[_i1] = v1;
    v[_i2] = v2;
    v[_i3] = v3;
    v[_i4] = v4;
    v[_i5] = v5;
    v[_i6] = v6;
    v[_i7] = v7;
    v[_i8] = v8;
    v[_i9] = v9;
    v[_i10] = v10;
    v[_i11] = v11;
    v[_i12] = v12;
    v[_i13] = v13;
    v[_i14] = v14;
    v[_i15] = v15;
  }
}

extension on Blake2bHash {
  void addUint32(int value) {
    add([
      value,
      value >>> 8,
      value >>> 16,
      value >>> 24,
    ]);
  }
}
