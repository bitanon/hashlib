#!/bin/sh
set -ex
dart format --fix .
dart analyze --fatal-infos
dart test
dart doc
