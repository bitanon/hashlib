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

  void measureRate() {
    var runtime = measure();
    var nbhps = 1e6 * iter / runtime;
    var rate = nbhps * size;
    var rtms = runtime.round() / 1000;
    var speed = '${formatSize(rate)}/s';
    print('$name ($size x $iter): $rtms ms => nb# ${nbhps.round()} @ $speed');
  }

  void showDiff([List<BenchmarkBase> others = const []]) {
    var diff = <String, double>{};
    var rate = <String, String>{};
    for (var benchmark in {this, ...others}) {
      var runtime = benchmark.measure();
      var hashRate = 1e6 * iter * size / runtime;
      diff[benchmark.name] = runtime;
      rate[benchmark.name] = '${formatSize(hashRate)}/s';
    }
    var mine = diff[name]!;
    var best = diff.values.fold(mine, min);
    for (var entry in diff.entries) {
      var message = "${entry.key} : ${rate[entry.key]}";
      var value = diff[entry.key]!;
      if (value == best) {
        message += ' [best]';
      }
      if (value > mine) {
        var p = (100 * (value - mine) / mine).round();
        message += ' ~ $p% slower';
      } else if (value < mine) {
        var p = (100 * (mine - value) / mine).round();
        message += ' ~ $p% faster';
      }
      print(message);
    }
  }
}

Map<String, int> measureDiff(Iterable<BenchmarkBase> benchmarks) {
  Map<String, int> data = {};
  for (BenchmarkBase benchmark in benchmarks) {
    data[benchmark.name] = benchmark.measure().round();
  }
  return data;
}

String formatDecimal(double value, [int precision = 2]) {
  var res = value.toStringAsFixed(precision);
  if (precision == 0) {
    return res;
  }
  int p = res.length - 1;
  while (res[p] == '0') {
    p--;
  }
  if (res[p] == '.') {
    p--;
  }
  return res.substring(0, p + 1);
}

String formatSize(num value) {
  int i;
  double size = value.toDouble();
  const suffix = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
  for (i = 0; size >= 1024; i++) {
    size /= 1024;
  }
  return '${formatDecimal(size)}${suffix[i]}';
}

String formatSpeed(num value) {
  int i;
  double size = (value * 8).toDouble();
  const suffix = ['', ' kbps', ' Mbps', ' Gbps', ' Tbps'];
  size /= 1000;
  for (i = 1; size >= 1000; i++) {
    size /= 1000;
  }
  if (size >= 100) {
    size = size.roundToDouble();
  }
  return '${formatDecimal(size)}${suffix[i]}';
}
