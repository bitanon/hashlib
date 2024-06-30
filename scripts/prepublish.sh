#!/bin/sh
set -ex
rm -rf "doc" "build"
dart format --fix .
dart analyze --fatal-infos
dart doc --validate-links
dart test
