#!/bin/sh
set -ex
rm -rf coverage
mkdir -p coverage
dart test -p vm --coverage="./coverage" --reporter json | tojunit > "./coverage/junit.xml"
dart pub global run coverage:format_coverage --lcov --in="./coverage/test" --out="./coverage/lcov.info" --report-on="./lib"
dart pub global run cobertura convert
dart pub global run cobertura show
