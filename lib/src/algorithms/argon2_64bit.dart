// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

import 'argon2.dart';
import 'blake2b.dart';

const int _mask32 = 0xFFFFFFFF;

const int _slices = 4;
const int _blockSize = 1024;

/// This implementation is derived from [RFC 9106][rfc]: Argon2 Memory-Hard
/// Function for Password Hashing and Proof-of-Work Applications.
///
/// The C++ implementation at [phc-winner-argon2][repo] was a great help.
///
/// [rfc]: https://rfc-editor.org/rfc/rfc9106.html
/// [repo]: https://github.com/P-H-C/phc-winner-argon2
class Argon2 {
  final Argon2Context ctx;

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
  late final _passes = ctx.iterations;
  late final _lanes = ctx.parallelism;
  late final _segments = ctx.memorySizeKB ~/ (_slices * ctx.parallelism);
  late final _blocks = _lanes * _slices * _segments;
  late final _columns = _slices * _segments;
  late final Uint8List _buffer = Uint8List(_blocks * _blockSize);

  Argon2(this.ctx) {
    ctx.validate();
  }

  HashDigest encode(List<int> password) {
    int i, j, k, p;
    int pass, slice, lane;
    var _hash0 = Uint8List(64 + 8);
    var result = Uint8List(ctx.hashLength);

    // H_0 Generation (64 + 8 = 72 bytes)
    _initialHash(_hash0, password);

    // Initial block generation
    _fillStartingBlocks(_hash0);

    // Further block generation
    for (pass = 0; pass < _passes; ++pass) {
      for (slice = 0; slice < _slices; ++slice) {
        for (lane = 0; lane < _lanes; ++lane) {
          _fillSegment(pass, slice, lane);
        }
      }
    }

    // Finalization
    /* XOR the blocks */
    j = _columns - 1;
    var block = _buffer.buffer.asUint8List(j << 10, _blockSize);
    for (k = 1; k < ctx.parallelism; ++k) {
      j += _columns;
      p = j << 10;
      for (i = 0; i < _blockSize; ++i, ++p) {
        block[i] ^= _buffer[p];
      }
    }

    /* Hash the result */
    _expandHash(ctx.hashLength, block, result, 0);
    return HashDigest(result);
  }

  void _initialHash(Uint8List _hash0, List<int> password) {
    // H_0 = H^(64)(LE32(p) || LE32(T) || LE32(m) || LE32(t) ||
    //         LE32(v) || LE32(y) || LE32(length(P)) || P ||
    //         LE32(length(S)) || S ||  LE32(length(K)) || K ||
    //         LE32(length(X)) || X)
    var blake2b = Blake2bHash(digestSize: 64);
    blake2b.addUint32(ctx.parallelism);
    blake2b.addUint32(ctx.hashLength);
    blake2b.addUint32(ctx.memorySizeKB);
    blake2b.addUint32(ctx.iterations);
    blake2b.addUint32(ctx.version.value);
    blake2b.addUint32(ctx.hashType.value);
    blake2b.addUint32(password.length);
    blake2b.add(password);
    blake2b.addUint32(ctx.salt.length);
    blake2b.add(ctx.salt);
    blake2b.addUint32(ctx.key?.length ?? 0);
    if (ctx.key != null) {
      blake2b.add(ctx.key!);
    }
    blake2b.addUint32(ctx.personalization?.length ?? 0);
    if (ctx.personalization != null) {
      blake2b.add(ctx.personalization!);
    }

    var hash = blake2b.digest().bytes;
    for (int i = 0; i < 64; ++i) {
      _hash0[i] = hash[i];
    }
  }

  void _fillStartingBlocks(Uint8List _hash0) {
    int i, k;

    // Lane Starting Blocks
    k = 0;
    _hash0.setUint32(64, 0);
    for (i = 0; i < _lanes; i++, k += _columns) {
      // B[i][0] = H'^(1024)(H_0 || LE32(0) || LE32(i))
      _hash0.setUint32(68, i);
      _expandHash(_blockSize, _hash0, _buffer, k << 10);
    }

    // Second Lane Blocks
    k = 1;
    _hash0.setUint32(64, 1);
    for (i = 0; i < _lanes; i++, k += _columns) {
      // B[i][1] = H'^(1024)(H_0 || LE32(1) || LE32(i))
      _hash0.setUint32(68, i);
      _expandHash(_blockSize, _hash0, _buffer, k << 10);
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
      var blake2b = Blake2bHash(digestSize: digestSize);
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

    var blake2b = Blake2bHash(digestSize: 64);
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
    int i, j, startIndex, rand0, rand1;
    const int zero = 0;
    const int input = zero + _blockSize;
    const int address = input + _blockSize;
    var temp = Uint8List(address + _blockSize);
    var input64 = temp.buffer.asUint64List(input);

    var dataIndependentAddressing = (ctx.hashType == Argon2Type.argon2i) ||
        (ctx.hashType == Argon2Type.argon2id &&
            (pass == 0) &&
            (slice < (_slices ~/ 2)));

    if (dataIndependentAddressing) {
      input64[0] = pass;
      input64[1] = lane;
      input64[2] = slice;
      input64[3] = _blocks;
      input64[4] = _passes;
      input64[5] = ctx.hashType.value;
    }

    startIndex = 0;
    if (pass == 0 && slice == 0) {
      startIndex = 2;
      if (dataIndependentAddressing) {
        input64[6]++;
        _fillBlock(temp, prev: zero, ref: input, next: address);
        _fillBlock(temp, prev: zero, ref: address, next: address);
      }
    }

    /* Offset of the current block */
    current = lane * _columns + slice * _segments + startIndex;

    if (current % _columns == 0) {
      /* Last block in this lane */
      previous = current + _columns - 1;
    } else {
      /* Previous block */
      previous = current - 1;
    }

    for (i = startIndex; i < _segments; ++i, ++current, ++previous) {
      /* 1.1 Rotating prev_offset if needed */
      if (current % _columns == 1) {
        previous = current - 1;
      }

      /* 1.2 Computing the index of the reference block */
      /* 1.2.1 Taking pseudo-random value from the previous block */
      if (dataIndependentAddressing) {
        j = i & 0x7F;
        if (j == 0) {
          input64[6]++;
          _fillBlock(temp, prev: zero, ref: input, next: address);
          _fillBlock(temp, prev: zero, ref: address, next: address);
        }
        rand0 = temp.getUint32(address + (j << 3));
        rand1 = temp.getUint32(4 + address + (j << 3));
      } else {
        rand0 = _buffer.getUint32(previous << 10);
        rand1 = _buffer.getUint32(4 + (previous << 10));
      }

      /* 1.2.2 Computing the lane of the reference block */
      refLane = rand1 % _lanes;

      if (pass == 0 && slice == 0) {
        /* Can not reference other lanes yet */
        refLane = lane;
      }

      /* 1.2.3 Computing the number of possible reference block within the lane */
      refIndex = _alphaIndex(
        pass: pass,
        slice: slice,
        lane: lane,
        index: i,
        columns: _columns,
        segments: _segments,
        random: rand0,
        sameLane: refLane == lane,
      );

      /* 2 Creating a new block */
      _fillBlock(
        _buffer,
        /* 1.2.1 v10 and earlier: overwrite, not XOR */
        xor: ctx.version != Argon2Version.v10 && pass > 0,
        next: current << 10,
        prev: previous << 10,
        ref: (refLane * _columns + refIndex) << 10,
      );
    }
  }

  // B[next] ^= G(B[prev], B[ref])
  /// Fills a new memory block and optionally XORs the old block over the new one.
  void _fillBlock(
    Uint8List buffer, {
    required int prev,
    required int ref,
    required int next,
    bool xor = false,
  }) {
    int i, j;
    var _blockR = Uint8List(_blockSize);
    var _blockT = Uint8List(_blockSize);
    var _blockR64 = _blockR.buffer.asUint64List();

    // T = R = ref ^ prev
    for (i = 0; i < _blockSize; ++i, ++ref, ++prev) {
      _blockT[i] = _blockR[i] = buffer[ref] ^ buffer[prev];
    }

    if (xor) {
      // T = ref ^ prev ^ next
      j = next;
      for (i = 0; i < _blockSize; ++i, ++j) {
        _blockT[i] ^= buffer[j];
      }
    }

    // Apply Blake2 on columns of 64-bit words: (0,1,...,15),
    // then (16,17,..31)... finally (112,113,...127)
    for (i = j = 0; i < 8; i++, j += 16) {
      _blake2bMixer(
        _blockR64,
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
    for (i = j = 0; i < 8; i++, j += 2) {
      _blake2bMixer(
        _blockR64,
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
    j = next;
    for (i = 0; i < _blockSize; ++i, ++j) {
      buffer[j] = _blockT[i] ^ _blockR[i];
    }
  }

  static int _alphaIndex({
    required int pass,
    required int slice,
    required int lane,
    required int index,
    required int random,
    required int segments,
    required int columns,
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
      } else {
        area = slice * segments + (index == 0 ? -1 : 0);
      }
    } else {
      // Other passes
      if (sameLane) {
        area = columns - segments + index - 1;
      } else {
        area = columns - segments + (index == 0 ? -1 : 0);
      }
    }

    // 1.2.4. Mapping pseudo_rand to 0..<reference_area_size-1>
    // and produce relative position
    pos = (random * random) >>> 32;
    pos = area - 1 - ((area * pos) >>> 32);

    /* 1.2.5 Computing starting position */
    start = 0;
    if (pass != 0) {
      start = slice == _slices - 1 ? 0 : (slice + 1) * segments;
    }

    /* 1.2.6. Computing absolute position */
    return (start + pos) % columns;
  }

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
    int v0, v1, v2, v3, v4, v5, v6, v7, v8, v9, v10, v11, v12, v13, v14, v15;

    v0 = v[_i0];
    v1 = v[_i1];
    v2 = v[_i2];
    v3 = v[_i3];
    v4 = v[_i4];
    v5 = v[_i5];
    v6 = v[_i6];
    v7 = v[_i7];
    v8 = v[_i8];
    v9 = v[_i9];
    v10 = v[_i10];
    v11 = v[_i11];
    v12 = v[_i12];
    v13 = v[_i13];
    v14 = v[_i14];
    v15 = v[_i15];

    // _mix(v, v0, v4, v8, v12);
    v0 += v4 + ((v0 & _mask32) * (v4 & _mask32) << 1);
    v12 ^= v0;
    v12 = (v12 >>> 32) ^ (v12 << (64 - 32));
    v8 += v12 + ((v8 & _mask32) * (v12 & _mask32) << 1);
    v4 ^= v8;
    v4 = (v4 >>> 24) ^ (v4 << (64 - 24));
    v0 += v4 + ((v0 & _mask32) * (v4 & _mask32) << 1);
    v12 ^= v0;
    v12 = (v12 >>> 16) ^ (v12 << (64 - 16));
    v8 += v12 + ((v8 & _mask32) * (v12 & _mask32) << 1);
    v4 ^= v8;
    v4 = (v4 >>> 63) ^ (v4 << (64 - 63));

    // _mix(v, v1, v5, v9, v13);
    v1 += v5 + ((v1 & _mask32) * (v5 & _mask32) << 1);
    v13 ^= v1;
    v13 = (v13 >>> 32) ^ (v13 << (64 - 32));
    v9 += v13 + ((v9 & _mask32) * (v13 & _mask32) << 1);
    v5 ^= v9;
    v5 = (v5 >>> 24) ^ (v5 << (64 - 24));
    v1 += v5 + ((v1 & _mask32) * (v5 & _mask32) << 1);
    v13 ^= v1;
    v13 = (v13 >>> 16) ^ (v13 << (64 - 16));
    v9 += v13 + ((v9 & _mask32) * (v13 & _mask32) << 1);
    v5 ^= v9;
    v5 = (v5 >>> 63) ^ (v5 << (64 - 63));

    // _mix(v, v2, v6, v10, v14);
    v2 += v6 + ((v2 & _mask32) * (v6 & _mask32) << 1);
    v14 ^= v2;
    v14 = (v14 >>> 32) ^ (v14 << (64 - 32));
    v10 += v14 + ((v10 & _mask32) * (v14 & _mask32) << 1);
    v6 ^= v10;
    v6 = (v6 >>> 24) ^ (v6 << (64 - 24));
    v2 += v6 + ((v2 & _mask32) * (v6 & _mask32) << 1);
    v14 ^= v2;
    v14 = (v14 >>> 16) ^ (v14 << (64 - 16));
    v10 += v14 + ((v10 & _mask32) * (v14 & _mask32) << 1);
    v6 ^= v10;
    v6 = (v6 >>> 63) ^ (v6 << (64 - 63));

    // _mix(v, v3, v7, v11, v15);
    v3 += v7 + ((v3 & _mask32) * (v7 & _mask32) << 1);
    v15 ^= v3;
    v15 = (v15 >>> 32) ^ (v15 << (64 - 32));
    v11 += v15 + ((v11 & _mask32) * (v15 & _mask32) << 1);
    v7 ^= v11;
    v7 = (v7 >>> 24) ^ (v7 << (64 - 24));
    v3 += v7 + ((v3 & _mask32) * (v7 & _mask32) << 1);
    v15 ^= v3;
    v15 = (v15 >>> 16) ^ (v15 << (64 - 16));
    v11 += v15 + ((v11 & _mask32) * (v15 & _mask32) << 1);
    v7 ^= v11;
    v7 = (v7 >>> 63) ^ (v7 << (64 - 63));

    // _mix(v, v0, v5, v10, v15);
    v0 += v5 + ((v0 & _mask32) * (v5 & _mask32) << 1);
    v15 ^= v0;
    v15 = (v15 >>> 32) ^ (v15 << (64 - 32));
    v10 += v15 + ((v10 & _mask32) * (v15 & _mask32) << 1);
    v5 ^= v10;
    v5 = (v5 >>> 24) ^ (v5 << (64 - 24));
    v0 += v5 + ((v0 & _mask32) * (v5 & _mask32) << 1);
    v15 ^= v0;
    v15 = (v15 >>> 16) ^ (v15 << (64 - 16));
    v10 += v15 + ((v10 & _mask32) * (v15 & _mask32) << 1);
    v5 ^= v10;
    v5 = (v5 >>> 63) ^ (v5 << (64 - 63));

    // _mix(v, v1, v6, v11, v12);
    v1 += v6 + ((v1 & _mask32) * (v6 & _mask32) << 1);
    v12 ^= v1;
    v12 = (v12 >>> 32) ^ (v12 << (64 - 32));
    v11 += v12 + ((v11 & _mask32) * (v12 & _mask32) << 1);
    v6 ^= v11;
    v6 = (v6 >>> 24) ^ (v6 << (64 - 24));
    v1 += v6 + ((v1 & _mask32) * (v6 & _mask32) << 1);
    v12 ^= v1;
    v12 = (v12 >>> 16) ^ (v12 << (64 - 16));
    v11 += v12 + ((v11 & _mask32) * (v12 & _mask32) << 1);
    v6 ^= v11;
    v6 = (v6 >>> 63) ^ (v6 << (64 - 63));

    // _mix(v, v2, v7, v8, v13);
    v2 += v7 + ((v2 & _mask32) * (v7 & _mask32) << 1);
    v13 ^= v2;
    v13 = (v13 >>> 32) ^ (v13 << (64 - 32));
    v8 += v13 + ((v8 & _mask32) * (v13 & _mask32) << 1);
    v7 ^= v8;
    v7 = (v7 >>> 24) ^ (v7 << (64 - 24));
    v2 += v7 + ((v2 & _mask32) * (v7 & _mask32) << 1);
    v13 ^= v2;
    v13 = (v13 >>> 16) ^ (v13 << (64 - 16));
    v8 += v13 + ((v8 & _mask32) * (v13 & _mask32) << 1);
    v7 ^= v8;
    v7 = (v7 >>> 63) ^ (v7 << (64 - 63));

    // _mix(v, v3, v4, v9, v14);
    v3 += v4 + ((v3 & _mask32) * (v4 & _mask32) << 1);
    v14 ^= v3;
    v14 = (v14 >>> 32) ^ (v14 << (64 - 32));
    v9 += v14 + ((v9 & _mask32) * (v14 & _mask32) << 1);
    v4 ^= v9;
    v4 = (v4 >>> 24) ^ (v4 << (64 - 24));
    v3 += v4 + ((v3 & _mask32) * (v4 & _mask32) << 1);
    v14 ^= v3;
    v14 = (v14 >>> 16) ^ (v14 << (64 - 16));
    v9 += v14 + ((v9 & _mask32) * (v14 & _mask32) << 1);
    v4 ^= v9;
    v4 = (v4 >>> 63) ^ (v4 << (64 - 63));

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

extension on Argon2Type {
  int get value {
    switch (this) {
      case Argon2Type.argon2d:
        return 0;
      case Argon2Type.argon2i:
        return 1;
      case Argon2Type.argon2id:
        return 2;
      default:
        throw ArgumentError('Invalid version');
    }
  }
}

extension on Argon2Version {
  int get value {
    switch (this) {
      case Argon2Version.v10:
        return 0x10;
      case Argon2Version.v13:
        return 0x13;
      default:
        throw ArgumentError('Invalid version');
    }
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

extension on Uint8List {
  void setUint32(int offset, int value) {
    this[offset++] = value;
    this[offset++] = value >>> 8;
    this[offset++] = value >>> 16;
    this[offset++] = value >>> 24;
  }

  int getUint32(int offset) {
    return (this[offset]) |
        (this[offset + 1] << 8) |
        (this[offset + 2] << 16) |
        (this[offset + 3] << 24);
  }
}
