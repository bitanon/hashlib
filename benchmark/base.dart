// Copyright (c) 2023, Sudipto Chandra
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
    var data = <String, int>{};
    var rate = <String, String>{};
    for (var benchmark in {this, ...others}) {
      var runtime = benchmark.measure();
      var hashRate = 1e6 * iter * size / runtime;
      data[benchmark.name] = runtime.round();
      rate[benchmark.name] = formatSize(hashRate) + '/s';
    }
    var mine = data[name]!;
    var best = data.values.fold(mine, min);
    for (var entry in data.entries) {
      var message = "${entry.key} : ${rate[entry.key]}";
      if (entry.value == best) {
        message += " [best]";
      }
      if (entry.key != name) {
        message += " ~ ${rate[entry.key]}";
      }
      print(message);
    }
  }

  void measureRate() {
    var runtime = measure();
    var nbhps = 1e6 * iter / runtime;
    var rate = nbhps * size;
    var rtms = runtime.round() / 1000;
    var speed = formatSize(rate) + '/s';
    print('$name ($size x $iter): $rtms ms => nb# ${nbhps.round()} @ $speed');
  }
}

Map<String, int> measureDiff(Iterable<BenchmarkBase> benchmarks) {
  Map<String, int> data = {};
  for (BenchmarkBase benchmark in benchmarks) {
    data[benchmark.name] = benchmark.measure().round();
  }
  return data;
}

String formatSize(double size) {
  const suffix = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  int i;
  for (i = 0; size >= 1000; i++) {
    size /= 1000;
  }
  return '${size.toStringAsFixed(2)}${suffix[i]}';
}
