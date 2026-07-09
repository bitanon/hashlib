// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import '_base.dart';

class ListBenchmark extends SyncBenchmark {
  List<int> list = [];

  ListBenchmark(int size) : super('List<int>', size);

  @override
  void setup() {
    list = List<int>.filled(size + 10, 0, growable: false);
  }

  @override
  dynamic run() {
    List<int> list = List.filled(size + 10, 0, growable: false);
    for (int i = 0; i < size; ++i) {
      list[i] = i & 0xFF;
    }
    for (int i = 0; i < size; ++i) {
      int value = (list[i] << 24) |
          (list[i + 1] << 16) |
          (list[i + 2] << 8) |
          (list[i + 3]) + 1;
      list[i] = value >>> 24;
      list[i + 1] = value >>> 24;
      list[i + 2] = value >>> 24;
      list[i + 3] = value >>> 24;
    }
    for (int i = 0; i < size; i += 4) {
      (list[i] << 24) |
          (list[i + 1] << 16) |
          (list[i + 2] << 8) |
          (list[i + 3]);
    }
    return list;
  }
}

class ListGrowingBenchmark extends SyncBenchmark {
  ListGrowingBenchmark(int size) : super('Growing List<int>', size);

  @override
  dynamic run() {
    List<int> list = [];
    for (int i = 0; i < size + 10; ++i) {
      list.add(i & 0xFF);
    }
    for (int i = 0; i < size; ++i) {
      int value = (list[i] << 24) |
          (list[i + 1] << 16) |
          (list[i + 2] << 8) |
          (list[i + 3]) + 1;
      list[i] = value >>> 24;
      list[i + 1] = value >>> 24;
      list[i + 2] = value >>> 24;
      list[i + 3] = value >>> 24;
    }
    for (int i = 0; i < size; i += 4) {
      (list[i] << 24) |
          (list[i + 1] << 16) |
          (list[i + 2] << 8) |
          (list[i + 3]);
    }
    return list;
  }
}

class Uint8ListBenchmark extends SyncBenchmark {
  Uint8List uint8list = Uint8List(0);

  Uint8ListBenchmark(int size) : super('Uint8List', size);

  @override
  void setup() {
    uint8list = Uint8List(size + 10);
  }

  @override
  dynamic run() {
    for (int i = 0; i < size; ++i) {
      uint8list[i] = i;
    }
    for (int i = 0; i < size; ++i) {
      int value = (uint8list[i] << 24) |
          (uint8list[i + 1] << 16) |
          (uint8list[i + 2] << 8) |
          (uint8list[i + 3]) + 1;
      uint8list[i] = value >>> 24;
      uint8list[i + 1] = value >>> 24;
      uint8list[i + 2] = value >>> 24;
      uint8list[i + 3] = value >>> 24;
    }
    for (int i = 0; i < size; i += 4) {
      (uint8list[i] << 24) |
          (uint8list[i + 1] << 16) |
          (uint8list[i + 2] << 8) |
          (uint8list[i + 3]);
    }
    return uint8list;
  }
}

class ByteDataBenchmark extends SyncBenchmark {
  ByteData byteData = ByteData(0);

  ByteDataBenchmark(int size) : super('ByteData', size);

  @override
  void setup() {
    byteData = ByteData(size + 10);
  }

  @override
  dynamic run() {
    for (int i = 0; i < size; ++i) {
      byteData.setUint8(i, i);
    }
    for (int i = 0; i < size; ++i) {
      byteData.setUint32(i, byteData.getUint32(i) + i);
    }
    for (int i = 0; i < size; i += 4) {
      byteData.getUint32(i);
    }
    return byteData;
  }
}

class ByteDataViewBenchmark extends SyncBenchmark {
  Uint8List uint8list = Uint8List(0);
  ByteData byteData = ByteData(0);

  ByteDataViewBenchmark(int size) : super('ByteDataView', size);

  @override
  void setup() {
    uint8list = Uint8List(size + 10);
    byteData = uint8list.buffer.asByteData();
  }

  @override
  dynamic run() {
    for (int i = 0; i < size; ++i) {
      uint8list[i] = i & 0xFF;
    }
    for (int i = 0; i < size; ++i) {
      byteData.setUint32(i, byteData.getUint32(i) + i);
    }
    for (int i = 0; i < size; i += 4) {
      byteData.getUint32(i);
    }
    return byteData;
  }
}

void main() async {
  print('-------- BUFFER ---------');
  for (int size in [1 << 7, 1 << 11, 1 << 18]) {
    print('---- size: ${formatSize(size)} ----');
    await ListBenchmark(size).measureDiff([
      ListGrowingBenchmark(size),
      ByteDataBenchmark(size),
      ByteDataViewBenchmark(size),
      Uint8ListBenchmark(size),
    ]);
    print('');
  }
}
