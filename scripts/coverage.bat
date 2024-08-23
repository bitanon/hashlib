@echo off
rd /s /q "coverage" 2>nul
mkdir "coverage" || goto :error

call dart test -p vm --coverage="./coverage" || goto :error
call dart pub global run coverage:format_coverage --lcov --in="./coverage/test" --out="./coverage/lcov.info" --report-on="./lib" || goto :error
call dart pub global run cobertura convert
call dart test -p vm --reporter json | tojunit > "./coverage/junit.xml"
call dart pub global run cobertura show

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
