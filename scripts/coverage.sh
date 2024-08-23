#!/bin/sh
set -ex
rm -rf coverage || echo '' >/dev/null
mkdir -p coverage
dart test -p vm --coverage="./coverage"
dart pub global run coverage:format_coverage --lcov --in="./coverage/test" --out="./coverage/lcov.info" --report-on="./lib"
dart pub global run cobertura convert
dart test -p vm --reporter json | tojunit > "./coverage/junit.xml"
dart pub global run cobertura show
