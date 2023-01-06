// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

class ListBenchmark extends BenchmarkBase {
  final int size;
  final int iter;
  List<int> list = [];

  ListBenchmark(this.size, this.iter) : super('List<int>');

  @override
  void setup() {
    list = List<int>.filled(size, 0, growable: false);
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
      list[i] = i & 0xFF;
    }
    for (int i = 0; i < size; ++i) {
      list[i] = (list[i] + i) & 0xFF;
    }
    for (int i = 0; i < size; i += 4) {
      (list[i] << 24) |
          (list[i + 1] << 16) |
          (list[i + 2] << 8) |
          (list[i + 3]);
    }
  }
}

class ListGrowingBenchmark extends BenchmarkBase {
  final int size;
  final int iter;
  List<int> list = [];

  ListGrowingBenchmark(this.size, this.iter) : super('Growing List<int>');

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
      list[i] = (list[i] + i) & 0xFF;
    }
    for (int i = 0; i < size; i += 4) {
      (list[i] << 24) |
          (list[i + 1] << 16) |
          (list[i + 2] << 8) |
          (list[i + 3]);
    }
  }
}

class Uint8ListBenchmark extends BenchmarkBase {
  final int size;
  final int iter;
  Uint8List uint8list = Uint8List(0);

  Uint8ListBenchmark(this.size, this.iter) : super('Uint8List');

  @override
  void setup() {
    uint8list = Uint8List(size);
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
      uint8list[i] += i;
    }
    for (int i = 0; i < size; i += 4) {
      (uint8list[i] << 24) |
          (uint8list[i + 1] << 16) |
          (uint8list[i + 2] << 8) |
          (uint8list[i + 3]);
    }
  }
}

class ByteDataBenchmark extends BenchmarkBase {
  final int size;
  final int iter;
  ByteData byteData = ByteData(0);

  ByteDataBenchmark(this.size, this.iter) : super('ByteData');

  @override
  void setup() {
    byteData = ByteData(size);
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
      byteData.setUint8(i, byteData.getUint8(i) + i);
    }
    for (int i = 0; i < size; i += 4) {
      byteData.getUint32(i);
    }
  }
}

class ByteDataViewBenchmark extends BenchmarkBase {
  final int size;
  final int iter;
  ByteData byteData = ByteData(0);

  ByteDataViewBenchmark(this.size, this.iter) : super('ByteDataView');

  @override
  void setup() {
    byteData = Uint8List(size).buffer.asByteData();
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
      byteData.setUint8(i, byteData.getUint8(i) + i);
    }
    for (int i = 0; i < size; i += 4) {
      byteData.getUint32(i);
    }
  }
}

void main() {
  print('-------- BUFFER ---------');
  ByteDataBenchmark(1 << 7, 1 << 15).report();
  ByteDataViewBenchmark(1 << 7, 1 << 15).report();
  ListBenchmark(1 << 7, 1 << 15).report();
  ListGrowingBenchmark(1 << 7, 1 << 15).report();
  Uint8ListBenchmark(1 << 7, 1 << 15).report();
  print('');
  ByteDataBenchmark(1 << 11, 1 << 11).report();
  ByteDataViewBenchmark(1 << 11, 1 << 11).report();
  ListBenchmark(1 << 11, 1 << 11).report();
  ListGrowingBenchmark(1 << 11, 1 << 11).report();
  Uint8ListBenchmark(1 << 11, 1 << 11).report();
  print('');
  ByteDataBenchmark(1 << 18, 1 << 3).report();
  ByteDataViewBenchmark(1 << 18, 1 << 3).report();
  ListBenchmark(1 << 18, 1 << 3).report();
  ListGrowingBenchmark(1 << 18, 1 << 3).report();
  Uint8ListBenchmark(1 << 18, 1 << 3).report();
  print('');
}
