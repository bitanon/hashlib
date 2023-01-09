@echo off
call dart test || exit 1
if not exist "build" mkdir build
call dart compile exe .\benchmark\benchmark.dart -o .\build\benchmark.exe
call .\build\benchmark.exe > BENCHMARK.md
