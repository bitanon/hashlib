@echo off
rd /s /q "coverage" || goto :error
mkdir "coverage" || goto :error

call dart test -p vm --coverage="./coverage" --reporter json | tojunit > "./coverage/junit.xml"
call dart pub global run coverage:format_coverage --lcov --in="./coverage/test" --out="./coverage/lcov.info" --report-on="./lib" || goto :error
call dart pub global run cobertura convert
call dart pub global run cobertura show

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
