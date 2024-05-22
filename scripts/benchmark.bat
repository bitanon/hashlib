@echo off

call dart test -p vm || goto :error
if not exist "build" mkdir build || goto :error
call dart compile exe .\benchmark\benchmark.dart -o .\build\benchmark.exe || goto :error
call .\build\benchmark.exe BENCHMARK.md || goto :error

call echo|set /p="> All benchmarks are done on _AMD Ryzen 7 5800X_ processor and _3200MHz_ RAM using compiled _exe_">> BENCHMARK.md
call echo.>> BENCHMARK.md
call echo|set /p=">">> BENCHMARK.md
call echo.>> BENCHMARK.md
call echo|set /p="> ">> BENCHMARK.md
call dart --version >> BENCHMARK.md

goto :EOF

:error
echo Failed with error #%errorlevel%.
exit /b %errorlevel%
