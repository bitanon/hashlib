@echo off
rd /s /q "coverage"
call dart test -p vm  --coverage="./coverage"
call dart pub global activate coverage
call dart pub global activate cobertura
call dart pub global run coverage:format_coverage --lcov --in="./coverage/test" --out="./coverage/lcov.info" --report-on="./lib"
call dart pub global run cobertura convert
call dart pub global run cobertura show