// Copyright (c) 2023, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'base.dart';

class ListBenchmark extends Benchmark {
  List<int> list = [];

  ListBenchmark(int size, int iter) : super('List<int>', size, iter);

  @override
  void setup() {
    list = List<int>.filled(size + 10, 0, growable: false);
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }

  @override
  void run() {
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
  }
}

class ListGrowingBenchmark extends Benchmark {
  List<int> list = [];

  ListGrowingBenchmark(int size, int iter)
      : super('Growing List<int>', size, iter);

  @override
  void setup() {
    list = [];
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
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
  }
}

class Uint8ListBenchmark extends Benchmark {
  Uint8List uint8list = Uint8List(0);

  Uint8ListBenchmark(int size, int iter) : super('Uint8List', size, iter);

  @override
  void setup() {
    uint8list = Uint8List(size + 10);
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }

  @override
  void run() {
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
  }
}

class ByteDataBenchmark extends Benchmark {
  ByteData byteData = ByteData(0);

  ByteDataBenchmark(int size, int iter) : super('ByteData', size, iter);

  @override
  void setup() {
    byteData = ByteData(size + 10);
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      byteData.setUint8(i, i);
    }
    for (int i = 0; i < size; ++i) {
      byteData.setUint32(i, byteData.getUint32(i) + i);
    }
    for (int i = 0; i < size; i += 4) {
      byteData.getUint32(i);
    }
  }
}

class ByteDataViewBenchmark extends Benchmark {
  Uint8List uint8list = Uint8List(0);
  ByteData byteData = ByteData(0);

  ByteDataViewBenchmark(int size, int iter) : super('ByteDataView', size, iter);

  @override
  void setup() {
    uint8list = Uint8List(size + 10);
    byteData = uint8list.buffer.asByteData();
  }

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }

  @override
  void run() {
    for (int i = 0; i < size; ++i) {
      uint8list[i] = i & 0xFF;
    }
    for (int i = 0; i < size; ++i) {
      byteData.setUint32(i, byteData.getUint32(i) + i);
    }
    for (int i = 0; i < size; i += 4) {
      byteData.getUint32(i);
    }
  }
}

void main() {
  print('-------- BUFFER ---------');
  ListBenchmark(1 << 7, 1 << 15).measureDiff([
    ListGrowingBenchmark(1 << 7, 1 << 15),
    ByteDataBenchmark(1 << 7, 1 << 15),
    ByteDataViewBenchmark(1 << 7, 1 << 15),
    Uint8ListBenchmark(1 << 7, 1 << 15),
  ]);
  print('');
  ListBenchmark(1 << 11, 1 << 11).measureDiff([
    ListGrowingBenchmark(1 << 11, 1 << 11),
    ByteDataBenchmark(1 << 11, 1 << 11),
    ByteDataViewBenchmark(1 << 11, 1 << 11),
    Uint8ListBenchmark(1 << 11, 1 << 11),
  ]);
  print('');
  ListBenchmark(1 << 18, 1 << 3).measureDiff([
    ListGrowingBenchmark(1 << 18, 1 << 3),
    ByteDataBenchmark(1 << 18, 1 << 3),
    ByteDataViewBenchmark(1 << 18, 1 << 3),
    Uint8ListBenchmark(1 << 18, 1 << 3),
  ]);
  print('');
}
