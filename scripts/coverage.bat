@echo off
rd /s /q "coverage" 2>nul
mkdir "coverage" || goto :error

call dart test -p vm -x node --coverage-path="./coverage/lcov.info" || goto :error
call dart pub global run cobertura convert
call dart pub global run cobertura show
call dart test -p vm -x node --reporter json | tojunit > "./coverage/junit.xml"

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
