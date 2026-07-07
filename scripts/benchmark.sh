#!/bin/sh
set -ex

dart test -p vm
mkdir -p build
dart compile exe ./benchmark/benchmark.dart -o ./build/benchmark
chmod +x ./build/benchmark
./build/benchmark BENCHMARK.md

printf "> All benchmarks are done on 36GB _Apple M3 Pro_ using compiled _exe_\n" >> BENCHMARK.md
printf ">\n" >> BENCHMARK.md
printf "> $(dart --version)\n" >> BENCHMARK.md
