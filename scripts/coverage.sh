#!/bin/sh
set -ex
rm -rf coverage
dart test -p vm  --coverage="./coverage"
dart pub global activate coverage
dart pub global activate cobertura
dart pub global run coverage:format_coverage --lcov --in="./coverage/test" --out="./coverage/lcov.info" --report-on="./lib"
dart pub global run cobertura convert
dart pub global run cobertura show
