set -ex
dart test
mkdir -p build
dart compile exe ./benchmark/benchmark.dart -o ./build/benchmark
chmod +x ./build/benchmark
./build/benchmark > BENCHMARK.md
