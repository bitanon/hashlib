#!/bin/sh
set -ex

dart pub global activate pana
dart pub global activate coverage
dart pub global activate cobertura
dart pub global activate junitreport