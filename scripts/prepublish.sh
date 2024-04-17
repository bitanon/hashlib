#!/bin/sh
set -ex
rm -rf "doc" "build"
dart format --fix .
dart analyze --fatal-infos
dart test
dart doc
