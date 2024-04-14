#!/bin/sh
set -ex
dart test -p vm
mkdir -p build
dart compile exe ./benchmark/benchmark.dart -o ./build/benchmark
chmod +x ./build/benchmark
./build/benchmark BENCHMARK.md
echo ">" >> BENCHMARK.md
echo "> $(dart --version)" >> BENCHMARK.md
