// Copyright (c) 2026, Sudipto Chandra
// All rights reserved. Check LICENSE file for details.

import 'dart:async';

/// Minimum number of milliseconds the probe runs to size a batch.
const int warmupDurationMillis = 100;

/// Minimum number of milliseconds the measured exercise runs.
const int exerciseDurationMillis = 2000;

/// Target wall-clock duration of a single measured batch, in microseconds.
///
/// Batches are sized so each one runs for roughly this long. Keeping a batch
/// well above the platform timer resolution (which is deliberately coarsened
/// to ~100us-1ms on the web) is what keeps per-batch samples meaningful.
const int batchTargetMicros = 25000;

/// Sink that consumes every [SyncBenchmark.run]/[AsyncBenchmark.run] result so
/// the optimizer cannot treat the benchmarked work as dead code and delete it.
///
/// It is written on every iteration and read once after measuring (see
/// [_keepAlive]); the store to this top-level therefore cannot be eliminated.
Object? _blackhole;

/// Reads [_blackhole] through a comparison the compiler cannot fold away,
/// forcing every `_blackhole = run()` store to be materialized.
void _keepAlive() {
  if (identical(_blackhole, _keepAlive)) {
    print(_blackhole); // observable use for optimizer; never fires at runtime
  }
}

// ------------ Interface Classes ------------
abstract class Benchmark {
  final int size;
  final String name;

  const Benchmark(this.name, this.size);

  /// Measures the score for the benchmark.
  Future<void> measureRate() async {
    await showRate(this);
  }

  /// Measures the difference between the benchmark and the others.
  Future<void> measureDiff([List<Benchmark> others = const []]) async {
    await showDiff([this, ...others]);
  }
}

class Measurement {
  Measurement(this._micros, this._iter, this._bytes, this._bestMicros);

  final int _iter;
  final int _bytes;
  final double _micros;
  final double _bestMicros;

  /// Total number of iterations measured.
  late final rounds = _iter;

  /// Representative (median) runtime of one iteration in microseconds.
  late final runtimeMicros = _micros;

  /// Representative (median) runtime of one iteration in milliseconds.
  late final runtimeMillis = runtimeMicros / 1000;

  /// Representative (median) runtime of one iteration in seconds.
  late final runtimeSeconds = runtimeMillis / 1000;

  /// Fastest observed runtime of one iteration in microseconds.
  late final bestMicros = _bestMicros;

  /// Number of iterations per second, derived from the median runtime.
  late final double rate = 1e6 / _micros;

  /// Throughput or bandwidth (bytes per second).
  late final double speed = _bytes * rate;

  /// Size in human readable string.
  late final String sizeString = formatSize(_bytes);

  /// Speed in human readable string.
  late final String speedString = formatSpeed(speed);
}

// ------------ Main Classes ------------

abstract class SyncBenchmark extends Benchmark {
  const SyncBenchmark(super.name, super.size);

  /// The benchmark code. Any returned value is fed to a sink that defeats
  /// dead-code elimination (see [_blackhole]); returning is optional.
  dynamic run();

  /// Not measured setup code executed prior to the benchmark runs.
  void setup() {}

  /// Not measured teardown code executed after the benchmark runs.
  void teardown() {}

  /// Measures the score for the benchmark and returns it.
  Measurement measure() {
    final watch = Stopwatch()..start();
    final warmupMicros = warmupDurationMillis * 1000;
    final exerciseMicros = exerciseDurationMillis * 1000;

    // warmup
    setup();
    _blackhole = run();

    // probe: measure how many iterations fit in the warmup window
    int iter = 0;
    int micros = 0;
    while (micros < warmupMicros) {
      watch.reset();
      _blackhole = run();
      _blackhole = run();
      micros += watch.elapsedMicroseconds;
      iter += 2;
    }

    // size a batch to ~batchTargetMicros of runtime (min 10 iterations)
    int batch = (batchTargetMicros * iter / micros).ceil();
    if (batch < 10) batch = 10;

    // exercise: collect a per-iteration time sample from each batch
    micros = 0;
    final samples = <double>[];
    while (micros < exerciseMicros) {
      watch.reset();
      for (int i = 0; i < batch; ++i) {
        _blackhole = run();
      }
      final dt = watch.elapsedMicroseconds;
      samples.add(dt / batch);
      micros += dt;
    }

    watch.stop();
    teardown();
    _keepAlive();
    return _summarize(samples, batch, size);
  }
}

abstract class AsyncBenchmark extends Benchmark {
  AsyncBenchmark(super.name, super.size);

  /// The benchmark code. Any returned value is fed to a sink that defeats
  /// dead-code elimination (see [_blackhole]); returning is optional.
  Future<dynamic> run();

  /// Not measured setup code executed prior to the benchmark runs.
  Future<void> setup() async {}

  /// Not measures teardown code executed after the benchmark runs.
  Future<void> teardown() async {}

  /// Measures the score for the benchmark and returns it.
  Future<Measurement> measure() async {
    final watch = Stopwatch()..start();
    final warmupMicros = warmupDurationMillis * 1000;
    final exerciseMicros = exerciseDurationMillis * 1000;

    // warmup
    await setup();
    _blackhole = await run();

    // probe: measure how many iterations fit in the warmup window
    int iter = 0;
    int micros = 0;
    while (micros < warmupMicros) {
      watch.reset();
      _blackhole = await run();
      _blackhole = await run();
      micros += watch.elapsedMicroseconds;
      iter += 2;
    }

    // size a batch to ~batchTargetMicros of runtime (min 10 iterations)
    int batch = (batchTargetMicros * iter / micros).ceil();
    if (batch < 10) batch = 10;

    // exercise: collect a per-iteration time sample from each batch
    micros = 0;
    final samples = <double>[];
    while (micros < exerciseMicros) {
      watch.reset();
      for (int i = 0; i < batch; ++i) {
        _blackhole = await run();
      }
      final dt = watch.elapsedMicroseconds;
      samples.add(dt / batch);
      micros += dt;
    }

    watch.stop();
    await teardown();
    _keepAlive();
    return _summarize(samples, batch, size);
  }
}

/// Reduces per-batch samples to a [Measurement] using the median per-iteration
/// time (robust against GC pauses and scheduler noise) and the fastest sample.
Measurement _summarize(List<double> samples, int batch, int size) {
  samples.sort();
  final n = samples.length;
  final m = n >>> 1;
  final median = n.isOdd ? samples[m] : (samples[m - 1] + samples[m]) / 2;
  final best = samples.first;
  return Measurement(median, n * batch, size, best);
}

/// ------------ Utility Functions ------------

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
  const suffix = [
    'B',
    'KB',
    'MB',
    'GB',
    'TB',
    'PB',
    'EB',
    'ZB',
    'YB',
  ];
  for (i = 0; size >= 1024; i++) {
    size /= 1024;
  }
  return '${formatDecimal(size)}${suffix[i]}';
}

String formatSpeed(num value) {
  int i;
  double size = (value * 8).toDouble();
  const suffix = [
    'bps',
    'Kbps',
    'Mbps',
    'Gbps',
    'Tbps',
    'Pbps',
    'Ebps',
    'Zbps',
    'Ybps',
  ];
  for (i = 0; size >= 1000; i++) {
    size /= 1000;
  }
  if (size >= 100) {
    size = size.roundToDouble();
  }
  return '${formatDecimal(size)} ${suffix[i]}';
}

Future<Measurement> measure(Benchmark benchmark) async {
  if (benchmark is SyncBenchmark) {
    return benchmark.measure();
  } else if (benchmark is AsyncBenchmark) {
    return await benchmark.measure();
  }
  throw UnimplementedError();
}

Future<void> showRate(Benchmark benchmark) async {
  final result = await measure(benchmark);
  var message = '${benchmark.name}(${result.sizeString}):';
  message += ' ${result.runtimeMillis} ms';
  message += ' => ${result.rate.round()} rounds';
  message += ' @ ${result.speedString}';
  print(message);
}

Future<void> showDiff(List<Benchmark> benchmarks) async {
  if (benchmarks.isEmpty) {
    return;
  }

  double best = 0;
  final diff = <String, Measurement>{};
  for (final benchmark in {...benchmarks}) {
    final result = await measure(benchmark);
    diff[benchmark.name] = result;
    if (result.speed > best) {
      best = result.speed;
    }
  }

  for (final name in diff.keys) {
    final result = diff[name]!;
    var message = "$name : ${result.speedString}";
    if (result.speed == best) {
      message += ' [best]';
    }
    if (best < result.speed) {
      var p = formatDecimal(result.speed / best);
      message += ' => ${p}x fast';
    } else if (best > result.speed) {
      var p = formatDecimal(best / result.speed);
      message += ' => ${p}x slow';
    }
    print(message);
  }
}
