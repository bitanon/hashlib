#!/bin/sh
set -ex
rm -rf "doc" "build"
dart format .
dart analyze --fatal-infos
dart doc --validate-links
dart test
pana --exit-code-threshold 0
