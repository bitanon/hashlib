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

  final _hash0 = Uint8List(64 + 8);
  final _blockR = Uint8List(_blockSize);
  final _blockT = Uint8List(_blockSize);
  late final _blockR32 = _blockR.buffer.asUint32List();

  Argon2(this.ctx) {
    throw UnimplementedError('Argon2 is not yet available for Node VM');
    // ctx.validate();
  }

  HashDigest encode(List<int> password) {
    // H_0 Generation (64 + 8 = 72 bytes)
    _initialHash(password);

    // Initial block generation
    _fillStartingBlocks();

    // Further block generation
    int pass, slice, lane;
    for (pass = 0; pass < _passes; ++pass) {
      for (slice = 0; slice < _slices; ++slice) {
        for (lane = 0; lane < _lanes; ++lane) {
          _fillSegment(pass, slice, lane);
        }
      }
    }

    // Finalization
    /* XOR the blocks */
    int i, j, k, p;
    j = _columns - 1;
    p = j << 10;
    for (i = 0; i < _blockSize; ++i, ++p) {
      _blockR[i] = _buffer[p];
    }
    for (k = 1; k < ctx.parallelism; ++k) {
      j += _columns;
      p = j << 10;
      for (i = 0; i < _blockSize; ++i, ++p) {
        _blockR[i] ^= _buffer[p];
      }
    }

    /* Hash the result */
    var result = Uint8List(ctx.hashLength);
    _expandHash(ctx.hashLength, _blockR, result, 0);
    return HashDigest(result);
  }

  void _initialHash(List<int> password) {
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

  void _fillStartingBlocks() {
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
    int previous, current, reference;
    int i, startIndex;
    Uint32List rand;
    var zero = Uint8List(_blockSize);
    var input = Uint8List(_blockSize);
    var address = Uint8List(_blockSize);
    var input32 = input.buffer.asUint32List();

    var dataIndependentAddressing = (ctx.hashType == Argon2Type.argon2i) ||
        (ctx.hashType == Argon2Type.argon2id &&
            (pass == 0) &&
            (slice < (_slices ~/ 2)));

    if (dataIndependentAddressing) {
      input32[0] = pass;
      input32[1] = 0;
      input32[2] = lane;
      input32[3] = 0;
      input32[4] = slice;
      input32[5] = 0;
      input32[6] = _blocks;
      input32[7] = _blocks >>> 32;
      input32[8] = _passes;
      input32[9] = 0;
      input32[10] = ctx.hashType.value;
      input32[11] = 0;
    }

    startIndex = 0;
    if (pass == 0 && slice == 0) {
      startIndex = 2;
      if (dataIndependentAddressing) {
        _increment(input32, 12);
        _fillBlock(prev: zero, ref: input, next: address);
        _fillBlock(prev: zero, ref: address, next: address);
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
        if ((i & 0x7F) == 0) {
          _increment(input32, 12);
          _fillBlock(prev: zero, ref: input, next: address);
          _fillBlock(prev: zero, ref: address, next: address);
        }
        rand = address.buffer.asUint32List((i & 0x7F) << 3, 2);
      } else {
        rand = _buffer.buffer.asUint32List(previous << 10, 2);
      }

      /* 1.2.2 Computing the lane of the reference block */
      refLane = rand[1] % _lanes;

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
        random: rand[0],
        sameLane: refLane == lane,
      );

      /* 2 Creating a new block */
      reference = refLane * _columns + refIndex;
      _fillBlock(
        /* 1.2.1 v10 and earlier: overwrite, not XOR */
        xor: ctx.version != Argon2Version.v10 && pass > 0,
        next: _buffer.buffer.asUint8List(current << 10, _blockSize),
        prev: _buffer.buffer.asUint8List(previous << 10, _blockSize),
        ref: _buffer.buffer.asUint8List(reference << 10, _blockSize),
      );
    }
  }

  // B[next] ^= G(B[prev], B[ref])
  /// Fills a new memory block and optionally XORs the old block over the new one.
  void _fillBlock({
    required Uint8List prev,
    required Uint8List ref,
    required Uint8List next,
    bool xor = false,
  }) {
    int i, j;

    // T = R = ref ^ prev
    for (i = 0; i < _blockSize; ++i) {
      _blockT[i] = _blockR[i] = ref[i] ^ prev[i];
    }
    if (xor) {
      // T = ref ^ prev ^ next
      for (i = 0; i < _blockSize; ++i) {
        _blockT[i] ^= next[i];
      }
    }

    // Apply Blake2 on columns of 64-bit words: (0,1,...,15),
    // then (16,17,..31)... finally (112,113,...127)
    for (i = j = 0; i < 8; i++, j += 16) {
      _blake2b(
        _blockR32,
        ((j) << 1),
        ((j + 1) << 1),
        ((j + 2) << 1),
        ((j + 3) << 1),
        ((j + 4) << 1),
        ((j + 5) << 1),
        ((j + 6) << 1),
        ((j + 7) << 1),
        ((j + 8) << 1),
        ((j + 9) << 1),
        ((j + 10) << 1),
        ((j + 11) << 1),
        ((j + 12) << 1),
        ((j + 13) << 1),
        ((j + 14) << 1),
        ((j + 15) << 1),
      );
    }

    // Apply Blake2 on rows of 64-bit words: (0,1,16,17,...112,113),
    // then (2,3,18,19,...,114,115).. finally (14,15,30,31,...,126,127)
    for (i = j = 0; i < 8; i++, j += 2) {
      _blake2b(
        _blockR32,
        ((j) << 1),
        ((j + 1) << 1),
        ((j + 16) << 1),
        ((j + 17) << 1),
        ((j + 32) << 1),
        ((j + 33) << 1),
        ((j + 48) << 1),
        ((j + 49) << 1),
        ((j + 64) << 1),
        ((j + 65) << 1),
        ((j + 80) << 1),
        ((j + 81) << 1),
        ((j + 96) << 1),
        ((j + 97) << 1),
        ((j + 112) << 1),
        ((j + 113) << 1),
      );
    }

    // next = T ^ R
    for (i = 0; i < _blockSize; ++i) {
      next[i] = _blockT[i] ^ _blockR[i];
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
    int refArea, relPos, startPos;

    if (pass == 0) {
      // First pass
      if (slice == 0) {
        // First slice
        refArea = index - 1; // all but the previous
      } else if (sameLane) {
        // The same lane => add current segment
        refArea = slice * segments + index - 1;
      } else {
        refArea = slice * segments + (index == 0 ? -1 : 0);
      }
    } else {
      // Other passes
      if (sameLane) {
        refArea = columns - segments + index - 1;
      } else {
        refArea = columns - segments + (index == 0 ? -1 : 0);
      }
    }

    // 1.2.4. Mapping pseudo_rand to 0..<reference_area_size-1>
    // and produce relative position
    relPos = _multiplyAndGetMSB(random, random);
    relPos = refArea - 1 - _multiplyAndGetMSB(refArea, relPos);

    /* 1.2.5 Computing starting position */
    startPos = 0;
    if (pass != 0) {
      startPos = slice == _slices - 1 ? 0 : (slice + 1) * segments;
    }

    /* 1.2.6. Computing absolute position */
    return (startPos + relPos) % columns;
  }

  static int _multiplyAndGetMSB(int x, int y) {
    int x1 = x >>> 16;
    int x2 = x & 0xFFFF;
    int y1 = y >>> 16;
    int y2 = y & 0xFFFF;
    return ((x1 * y1) & _mask32) +
        (((x1 * y2 + x2 * y1) + ((x2 * y2) >>> 16)) >>> 16);
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

  static void _fBlaMka(Uint32List v, int x, int y) {
    var t = v[x] + v[y] + ((v[x] * v[y]) << 1);
    v[x] = t;
    v[x + 1] += v[y + 1] + (t >>> 32);
  }

  /// `v[i] = (v[i] << (64 - n)) | (v[i] >>> n)`
  static void _rotr(int n, Uint32List v, int i) {
    var a = v[i + 1];
    var b = v[i];
    if (n == 32) {
      v[i + 1] = b;
      v[i] = a;
    } else if (n < 32) {
      v[i + 1] = (b << (32 - n)) | (a >>> n);
      v[i] = (a << (32 - n)) | (b >>> n);
    } else {
      v[i + 1] = (a << (64 - n)) | (b >>> (n - 32));
      v[i] = (b << (64 - n)) | (a >>> (n - 32));
    }
  }

  /// `v[i] ^= v[j]`
  static void _xor(Uint32List v, int i, int j) {
    v[i] ^= v[j];
    v[i + 1] ^= v[j + 1];
  }

  static void _mix(Uint32List v, int a, int b, int c, int d) {
    _fBlaMka(v, a, b);
    _xor(v, d, a);
    _rotr(32, v, d);
    _fBlaMka(v, c, d);
    _xor(v, b, c);
    _rotr(24, v, b);
    _fBlaMka(v, a, b);
    _xor(v, d, a);
    _rotr(16, v, d);
    _fBlaMka(v, c, d);
    _xor(v, b, c);
    _rotr(63, v, b);
  }

  static void _blake2b(
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

extension on Uint8List {
  void setUint32(int offset, int value) {
    this[offset++] = value;
    this[offset++] = value >>> 8;
    this[offset++] = value >>> 16;
    this[offset++] = value >>> 24;
  }
}
