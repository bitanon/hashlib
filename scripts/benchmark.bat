@echo off

call dart test -p vm || goto :error
if not exist "build" mkdir build || goto :error
call dart compile exe .\benchmark\benchmark.dart -o .\build\benchmark.exe || goto :error
call .\build\benchmark.exe > BENCHMARK.md || goto :error

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
