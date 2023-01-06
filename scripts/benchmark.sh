set -ex
dart test
dart run ./benchmark/benchmark.dart > BENCHMARK.md
