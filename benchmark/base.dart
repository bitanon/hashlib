// Copyright (c) 2021, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:math';

import 'package:benchmark_harness/benchmark_harness.dart';

Random random = Random();

abstract class Benchmark extends BenchmarkBase {
  final int size;
  final int iter;
  final List<int> input;

  Benchmark(String name, this.size, this.iter)
      : input = List.filled(size, 0x3f),
        super(name);

  @override
  void exercise() {
    for (int i = 0; i < iter; ++i) {
      run();
    }
  }

  void showDiff([List<BenchmarkBase> others = const []]) {
    var data = measureDiff({this, ...others});
    var mine = data[name]!;
    var best = data.values.fold(mine, min);
    for (var entry in data.entries) {
      var message = "${entry.key} Runtime: ${entry.value / 1000} ms";
      if (entry.value == best) {
        message += " [best]";
      }
      if (entry.key != name) {
        message += " ~ ${((entry.value - mine) / 1000)} ms";
      }
      print(message);
    }
  }

  void measureRate() {
    const suffix = ['B/s', 'KB/s', 'MB/s', 'GB/s', 'TB/s', 'PB/s'];

    Stopwatch watch = Stopwatch()..start();
    warmup();
    watch.reset();
    exercise();
    var runtime = watch.elapsedMicroseconds;

    var nbhps = 1e6 * iter / runtime;
    var rate = nbhps * size;
    int i = 0;
    for (; rate >= 1000; i++) {
      rate /= 1000;
    }

    var rtms = runtime.round() / 1000;
    var speed = '${rate.toStringAsFixed(2)} ${suffix[i]}';
    print('$name : $rtms ms => #${nbhps.round()} @ $speed ');
  }
}

Map<String, int> measureDiff(Iterable<BenchmarkBase> benchmarks) {
  Map<String, int> data = {};
  for (BenchmarkBase benchmark in benchmarks) {
    data[benchmark.name] = benchmark.measure().round();
  }
  return data;
}
