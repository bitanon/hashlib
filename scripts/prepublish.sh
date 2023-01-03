set -ex
dart format --fix .
dart analyze
dart test
