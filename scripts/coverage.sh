#!/bin/sh
set -ex
rm -rf coverage || echo '' >/dev/null
mkdir -p coverage
dart test -p vm -x node --coverage-path="./coverage/lcov.info"
dart pub global run cobertura convert
dart pub global run cobertura show
dart test -p vm -x node --reporter json | tojunit > "./coverage/junit.xml"
