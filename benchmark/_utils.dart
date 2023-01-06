import 'package:benchmark_harness/benchmark_harness.dart';

void showDiff(List<BenchmarkBase> benchmarks) {
  Map<String, double> data = {};
  for (BenchmarkBase benchmark in benchmarks) {
    data[benchmark.name] = benchmark.measure();
  }
  double first = data[benchmarks.first.name]!;
  for (MapEntry entry in data.entries) {
    print(
      "${entry.key} Runtime: ${entry.value}"
      " | "
      "Difference: ${entry.value - first}",
    );
  }
}
