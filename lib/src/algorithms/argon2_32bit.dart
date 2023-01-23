// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:hashlib/src/core/hash_digest.dart';

import 'argon2.dart';
import 'blake2b.dart';

const int _mask32 = 0xFFFFFFFF;

const int _slices = 4;
const int _blockSize = 1024;
const int _blockSize32 = 256;

const int _zero = 0;
const int _input = _zero + _blockSize32;
const int _address = _input + _blockSize32;

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

  final _blockR = Uint32List(_blockSize32);
  final _blockT = Uint32List(_blockSize32);
  final _temp = Uint32List(_address + _blockSize32);

  Argon2(this.ctx) {
    ctx.validate();
  }

  HashDigest encode(List<int> password) {
    int i, j, k, p;
    int pass, slice, lane;
    var hash0 = Uint8List(64 + 8);
    var hash0as32 = hash0.buffer.asUint32List();
    var buffer32 = Uint32List(_blocks * _blockSize32);
    var buffer = buffer32.buffer.asUint8List();
    var result = Uint8List(ctx.hashLength);

    // H_0 Generation (64 + 8 = 72 bytes)
    _initialHash(hash0, ctx, password);

    // Initial block generation
    // Lane Starting Blocks
    k = 0;
    hash0as32[16] = 0;
    for (i = 0; i < _lanes; i++, k += _columns) {
      // B[i][0] = H'^(1024)(H_0 || LE32(0) || LE32(i))
      hash0as32[17] = i;
      _expandHash(_blockSize, hash0, buffer, k << 10);
    }

    // Second Lane Blocks
    k = 1;
    hash0as32[16] = 1;
    for (i = 0; i < _lanes; i++, k += _columns) {
      // B[i][1] = H'^(1024)(H_0 || LE32(1) || LE32(i))
      hash0as32[17] = i;
      _expandHash(_blockSize, hash0, buffer, k << 10);
    }

    // Further block generation
    for (pass = 0; pass < _passes; ++pass) {
      for (slice = 0; slice < _slices; ++slice) {
        for (lane = 0; lane < _lanes; ++lane) {
          _fillSegment(buffer32, pass, slice, lane);
        }
      }
    }

    // Finalization
    /* XOR the blocks */
    j = _columns - 1;
    var block = buffer.buffer.asUint8List(j << 10, _blockSize);
    for (k = 1; k < ctx.parallelism; ++k) {
      j += _columns;
      p = j << 10;
      for (i = 0; i < _blockSize; ++i, ++p) {
        block[i] ^= buffer[p];
      }
    }

    /* Hash the result */
    _expandHash(ctx.hashLength, block, result, 0);
    return HashDigest(result);
  }

  static void _initialHash(
    Uint8List _hash0,
    Argon2Context ctx,
    List<int> password,
  ) {
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

  void _fillSegment(Uint32List buffer, int pass, int slice, int lane) {
    int refLane, refIndex; // l, z
    int previous, current;
    int i, j, startIndex, rand0, rand1;

    bool dataIndependentAddressing = (ctx.hashType == Argon2Type.argon2i);
    if (ctx.hashType == Argon2Type.argon2id) {
      dataIndependentAddressing = (pass == 0) && (slice < (_slices ~/ 2));
    }

    if (dataIndependentAddressing) {
      _temp[_input + 0] = pass;
      _temp[_input + 1] = 0;
      _temp[_input + 2] = lane;
      _temp[_input + 3] = 0;
      _temp[_input + 4] = slice;
      _temp[_input + 5] = 0;
      _temp[_input + 6] = _blocks;
      _temp[_input + 7] = _blocks >>> 32;
      _temp[_input + 8] = _passes;
      _temp[_input + 9] = 0;
      _temp[_input + 10] = ctx.hashType.value;
      _temp[_input + 11] = 0;
      _temp[_input + 12] = 0;
      _temp[_input + 13] = 0;
    }

    startIndex = 0;
    if (pass == 0 && slice == 0) {
      startIndex = 2;
      if (dataIndependentAddressing) {
        _increment(_temp, _input + 12);
        _fillBlock(_temp, prev: _zero, ref: _input, next: _address);
        _fillBlock(_temp, prev: _zero, ref: _address, next: _address);
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
          _increment(_temp, _input + 12);
          _fillBlock(_temp, prev: _zero, ref: _input, next: _address);
          _fillBlock(_temp, prev: _zero, ref: _address, next: _address);
        }
        rand0 = _temp[_address + (j << 1)];
        rand1 = _temp[_address + (j << 1) + 1];
      } else {
        rand0 = buffer[previous << 8];
        rand1 = buffer[(previous << 8) + 1];
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
        buffer,
        next: current << 8,
        prev: previous << 8,
        ref: (refLane * _columns + refIndex) << 8,
        /* 1.2.1 v10 and earlier: overwrite, not XOR */
        xor: ctx.version != Argon2Version.v10 && pass > 0,
      );
    }
  }

  // B[next] ^= G(B[prev], B[ref])
  /// Fills a new memory block and optionally XORs the old block over the new one.
  void _fillBlock(
    Uint32List buffer, {
    required int prev,
    required int ref,
    required int next,
    bool xor = false,
  }) {
    int i, j;

    // T = R = ref ^ prev
    for (i = 0; i < _blockSize32; ++i) {
      _blockT[i] = _blockR[i] = buffer[ref + i] ^ buffer[prev + i];
    }

    if (xor) {
      // T = ref ^ prev ^ next
      for (i = 0; i < _blockSize32; ++i) {
        _blockT[i] ^= buffer[next + i];
      }
    }

    // Apply Blake2 on columns of 64-bit words: (0,1,...,15),
    // then (16,17,..31)... finally (112,113,...127)
    for (i = j = 0; i < 8; i++, j += 16) {
      _blake2bMixer(
        _blockR,
        (j) << 1,
        (j + 1) << 1,
        (j + 2) << 1,
        (j + 3) << 1,
        (j + 4) << 1,
        (j + 5) << 1,
        (j + 6) << 1,
        (j + 7) << 1,
        (j + 8) << 1,
        (j + 9) << 1,
        (j + 10) << 1,
        (j + 11) << 1,
        (j + 12) << 1,
        (j + 13) << 1,
        (j + 14) << 1,
        (j + 15) << 1,
      );
    }

    // Apply Blake2 on rows of 64-bit words: (0,1,16,17,...112,113),
    // then (2,3,18,19,...,114,115).. finally (14,15,30,31,...,126,127)
    for (i = j = 0; i < 8; i++, j += 2) {
      _blake2bMixer(
        _blockR,
        (j) << 1,
        (j + 1) << 1,
        (j + 16) << 1,
        (j + 17) << 1,
        (j + 32) << 1,
        (j + 33) << 1,
        (j + 48) << 1,
        (j + 49) << 1,
        (j + 64) << 1,
        (j + 65) << 1,
        (j + 80) << 1,
        (j + 81) << 1,
        (j + 96) << 1,
        (j + 97) << 1,
        (j + 112) << 1,
        (j + 113) << 1,
      );
    }

    // next = T ^ R
    for (i = 0; i < _blockSize32; ++i) {
      buffer[next + i] = _blockT[i] ^ _blockR[i];
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
    pos = _multiplyAndGetMSB(random, random);
    pos = area - 1 - _multiplyAndGetMSB(area, pos);

    /* 1.2.5 Computing starting position */
    start = 0;
    if (pass != 0 && slice != _slices - 1) {
      start = (slice + 1) * segments;
    }

    /* 1.2.6. Computing absolute position */
    return (start + pos) % columns;
  }

  /// `v[i]++`
  static void _increment(Uint32List v, int i) {
    if (v[i] == _mask32) {
      v[i] = 0;
      v[i + 1]++;
    } else {
      v[i]++;
    }
  }

  /// `((x * y) mod 2^64) >> 32`
  static int _multiplyAndGetMSB(int x, int y) {
    return ((BigInt.from(x) * BigInt.from(y)) >> 32).toUnsigned(32).toInt();
  }

  /// `v[x] += v[y] + ((v[x] & _mask32) * (v[y] & _mask32) << 1)`
  static void _fBlaMka(Uint32List v, int x, int y) {
    var t = BigInt.two * BigInt.from(v[x]) * BigInt.from(v[y]);
    t += (BigInt.from(v[x + 1]) << 32) + BigInt.from(v[x]);
    t += (BigInt.from(v[y + 1]) << 32) + BigInt.from(v[y]);
    v[x] = t.toUnsigned(32).toInt();
    v[x + 1] = (t >> 32).toUnsigned(32).toInt();
  }

  // v[k] = (v[i] << (64 - n)) | (v[i] >>> n)
  static void _rotr(int n, List<int> v, int i, int k) {
    var a = v[i + 1];
    var b = v[i];
    if (n == 32) {
      v[k + 1] = b;
      v[k] = a;
    } else if (n < 32) {
      v[k + 1] = (b << (32 - n)) | (a >>> n);
      v[k] = (a << (32 - n)) | (b >>> n);
    } else {
      v[k + 1] = (a << (64 - n)) | (b >>> (n - 32));
      v[k] = (b << (64 - n)) | (a >>> (n - 32));
    }
  }

  /// `v[k] = v[i] ^ v[j]`
  static void _xor(List<int> v, int i, int j, int k) {
    v[k] = v[i] ^ v[j];
    v[k + 1] = v[i + 1] ^ v[j + 1];
  }

  static void _mix(Uint32List v, int a, int b, int c, int d) {
    _fBlaMka(v, a, b);
    // v[d] = _rotr(v[d] ^ v[a], 32);
    _xor(v, d, a, d);
    _rotr(32, v, d, d);

    _fBlaMka(v, c, d);
    // v[b] = _rotr(v[b] ^ v[c], 24);
    _xor(v, b, c, b);
    _rotr(24, v, b, b);

    _fBlaMka(v, a, b);
    // v[d] = _rotr(v[d] ^ v[a], 16);
    _xor(v, d, a, d);
    _rotr(16, v, d, d);

    _fBlaMka(v, c, d);
    // v[b] = _rotr(v[b] ^ v[c], 63);
    _xor(v, b, c, b);
    _rotr(63, v, b, b);
  }

  static void _blake2bMixer(
    Uint32List v,
    int v0,
    int v1,
    int v2,
    int v3,
    int v4,
    int v5,
    int v6,
    int v7,
    int v8,
    int v9,
    int v10,
    int v11,
    int v12,
    int v13,
    int v14,
    int v15,
  ) {
    _mix(v, v0, v4, v8, v12);
    _mix(v, v1, v5, v9, v13);
    _mix(v, v2, v6, v10, v14);
    _mix(v, v3, v7, v11, v15);
    _mix(v, v0, v5, v10, v15);
    _mix(v, v1, v6, v11, v12);
    _mix(v, v2, v7, v8, v13);
    _mix(v, v3, v4, v9, v14);
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
